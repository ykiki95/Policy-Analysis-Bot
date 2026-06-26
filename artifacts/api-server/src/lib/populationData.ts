import { desc, eq } from "drizzle-orm";
import {
  db,
  regionsTable,
  demographicMarginsTable,
  surveysTable,
  calibrationsTable,
  calibrationSettingsTable,
  accuracySnapshotsTable,
  type Region,
} from "@workspace/db";
import { GLOBAL_LEARNING_USER_ID } from "./tenant";
import { computeSurveyAdjustments } from "./surveyWeighting";
import { computeConsumerAdjustments } from "./consumerWeighting";
import { computePolicyAdjustments } from "./policyWeighting";
import { computeCalibrationOffsets } from "./calibrationWeighting";
import type { GenerationInputs, RegionMeta } from "./agentGenerator";
import type { Marginal } from "./raking";

export const NATIONAL_SCOPE = "NATIONAL";

export type LoadedMargins = {
  regions: Region[];
  regionMarginals: Marginal[];
  ageMarginals: { bracket: string; population: number }[];
  genderMarginals: Marginal[];
};

/** Load region metadata + official marginals from the database. */
export async function loadMargins(): Promise<LoadedMargins> {
  const [regions, margins] = await Promise.all([
    db.select().from(regionsTable).orderBy(regionsTable.displayOrder),
    db.select().from(demographicMarginsTable),
  ]);

  const regionMarginals: Marginal[] = margins
    .filter((m) => m.dimension === "region")
    .map((m) => ({ key: m.key, population: m.population }));
  const ageMarginals = margins
    .filter((m) => m.dimension === "age")
    .map((m) => ({ bracket: m.key, population: m.population }));
  const genderMarginals: Marginal[] = margins
    .filter((m) => m.dimension === "gender")
    .map((m) => ({ key: m.key, population: m.population }));

  return { regions, regionMarginals, ageMarginals, genderMarginals };
}

/**
 * Build deterministic generation inputs for a given count + region scope.
 * When `regionScope` is a specific region code, the region marginal collapses to
 * that single region so all agents are generated there (age/gender marginals are
 * preserved). Survey adjustments are applied from applied-to-population surveys.
 */
export async function buildGenerationInputs(
  count: number,
  seed: number | undefined,
  regionScope: string,
  userId: number,
): Promise<{ inputs: GenerationInputs; scopeName: string }> {
  const { regions, regionMarginals, ageMarginals, genderMarginals } =
    await loadMargins();

  const regionMeta: RegionMeta[] = regions.map((r) => ({
    code: r.code,
    name: r.name,
    lat: r.lat,
    lng: r.lng,
    leaningBias: r.leaningBias,
  }));

  let scopedRegionMarginals = regionMarginals;
  let scopeName = "전국";
  if (regionScope && regionScope !== NATIONAL_SCOPE) {
    scopedRegionMarginals = regionMarginals.filter((m) => m.key === regionScope);
    const r = regions.find((x) => x.code === regionScope);
    scopeName = r?.name ?? regionScope;
  }

  const surveys = await db
    .select()
    .from(surveysTable)
    .where(eq(surveysTable.userId, userId));
  const adjustments = computeSurveyAdjustments(surveys);
  const consumerAdjustments = computeConsumerAdjustments(surveys);
  const policyAdjustments = computePolicyAdjustments(surveys);

  // 입력 보정(Lever 1): 토글이 켜져 있으면 검증 이벤트 편향을 페르소나
  // 기준선 이동량으로 환산해 주입한다. 꺼져 있으면 모두 0. (테넌트 스코프)
  const [calibrationEvents, [settings]] = await Promise.all([
    db
      .select()
      .from(calibrationsTable)
      .where(eq(calibrationsTable.userId, userId)),
    db
      .select()
      .from(calibrationSettingsTable)
      .where(eq(calibrationSettingsTable.userId, userId))
      .limit(1),
  ]);
  const calibrationOffsets = computeCalibrationOffsets(
    calibrationEvents,
    settings?.shrinkageFactor ?? 0.4,
    settings?.applyToPopulation ?? false,
  );

  // 자동 자가학습 누적 offset(전역 인구에만 적용). 검증 게이트를 통과해 승격된
  // 학습이 누적된 기준선 이동량으로, 전역(0) 인구 재생성 시 수동 보정 레버와 합산된다.
  // 두 레버 합이 과도하지 않게 최종 clamp.
  if (userId === GLOBAL_LEARNING_USER_ID) {
    const auto = await loadAutoLearnedOffsets();
    const clamp = (v: number, lim: number) => Math.max(-lim, Math.min(lim, v));
    calibrationOffsets.political = clamp(
      calibrationOffsets.political + auto.political,
      35,
    );
    calibrationOffsets.consumer = clamp(
      calibrationOffsets.consumer + auto.consumer,
      20,
    );
    calibrationOffsets.policy = clamp(
      calibrationOffsets.policy + auto.policy,
      20,
    );
  }

  return {
    inputs: {
      count,
      seed,
      userId,
      regions: regionMeta,
      regionMarginals: scopedRegionMarginals,
      ageMarginals,
      genderMarginals,
      adjustments,
      consumerAdjustments,
      policyAdjustments,
      calibrationOffsets,
    },
    scopeName,
  };
}

/**
 * 가장 최근 정확도 스냅샷에 저장된 누적 auto offset. 스냅샷이 없으면 0.
 * 자가학습이 승격할 때마다 새 스냅샷에 누적 offset이 기록되며, 전역 인구 재생성이
 * 이 값을 읽어 기준선을 이동한다.
 */
export async function loadAutoLearnedOffsets(): Promise<{
  political: number;
  consumer: number;
  policy: number;
}> {
  const [latest] = await db
    .select()
    .from(accuracySnapshotsTable)
    .orderBy(desc(accuracySnapshotsTable.cycle))
    .limit(1);
  if (!latest) return { political: 0, consumer: 0, policy: 0 };
  return {
    political: latest.offsetPolitical,
    consumer: latest.offsetConsumer,
    policy: latest.offsetPolicy,
  };
}

/** Resolve a region row by code (or null). */
export async function getRegion(code: string): Promise<Region | null> {
  const [row] = await db
    .select()
    .from(regionsTable)
    .where(eq(regionsTable.code, code))
    .limit(1);
  return row ?? null;
}
