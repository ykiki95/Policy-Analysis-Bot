import { eq } from "drizzle-orm";
import {
  db,
  regionsTable,
  demographicMarginsTable,
  surveysTable,
  type Region,
} from "@workspace/db";
import { computeSurveyAdjustments } from "./surveyWeighting";
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

  const surveys = await db.select().from(surveysTable);
  const adjustments = computeSurveyAdjustments(surveys);

  return {
    inputs: {
      count,
      seed,
      regions: regionMeta,
      regionMarginals: scopedRegionMarginals,
      ageMarginals,
      genderMarginals,
      adjustments,
    },
    scopeName,
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
