import type { Agent, Simulation } from "@workspace/db";

/**
 * Lumen simulations probe consumer reception, so they use the consumer-attitude
 * persona rather than the political or policy one. Decided strictly by product —
 * Seraph runs on the policy track and Dynamo on the political track even if
 * audience is mis-set, so audience is descriptive only and never switches the
 * track.
 */
export function isCommercialSim(sim: Pick<Simulation, "product">): boolean {
  return sim.product?.toLowerCase() === "lumen";
}

/**
 * Seraph simulations probe policy/government reception, so they use the policy-
 * attitude persona rather than the political or consumer one. Decided strictly
 * by product — Lumen·Dynamo stay on their own tracks even if audience is
 * mis-set, so audience is descriptive only and never switches the track.
 */
export function isPolicySim(sim: Pick<Simulation, "product">): boolean {
  return sim.product?.toLowerCase() === "seraph";
}

export function buildCommercialPrompt(agent: Agent, sim: Simulation): string {
  const c = agent.consumerStances;
  return [
    `당신은 대한민국에 거주하는 소비자 페르소나입니다. 아래 인물의 입장에서 제품/브랜드/마케팅 메시지에 대한 반응을 평가하세요.`,
    `이름: ${agent.name}`,
    `나이: ${agent.age} (${agent.ageBracket}), 성별: ${agent.gender}`,
    `거주 지역(시·도): ${agent.district}`,
    `학력: ${agent.education}, 소득: ${agent.incomeBracket}, 직업: ${agent.occupation}, 가구형태: ${agent.householdType}`,
    `소비 성향(0~100): 가격민감도 ${c.priceSensitivity}, 브랜드충성도 ${c.brandLoyalty}, 신제품수용 ${c.noveltySeeking}, 친환경소비 ${c.ecoConsciousness}, 디지털소비 ${c.digitalConsumption}`,
    `미디어 소비: ${agent.mediaDiet}`,
    `핵심 가치: ${agent.values.join(", ")}`,
    `요약: ${agent.personaSummary}`,
    ``,
    `평가 대상 (${sim.audience} / ${sim.product}):`,
    sim.policyText,
    ``,
    `이 소비자가 위 제품/메시지에 어떻게 반응할지(구매·수용 의향) JSON으로만 답하세요. 형식:`,
    `{"stance":"support|oppose|neutral","score":0-100,"confidence":0-100,"reasoning":"한국어 1-2문장"}`,
    `score는 수용/구매 의향(0=전혀 구매 안 함, 100=적극 구매). stance는 support=수용/구매, oppose=거부, neutral=중립. 이 소비자의 소비 성향과 가치에 충실하게 답하세요.`,
  ].join("\n");
}

export function buildPolicyPrompt(agent: Agent, sim: Simulation): string {
  const p = agent.policyStances;
  return [
    `당신은 대한민국에 거주하는 시민 페르소나입니다. 아래 인물의 입장에서 정부 정책/제도/행정 서비스에 대한 반응을 평가하세요.`,
    `이름: ${agent.name}`,
    `나이: ${agent.age} (${agent.ageBracket}), 성별: ${agent.gender}`,
    `거주 지역(시·도): ${agent.district}`,
    `학력: ${agent.education}, 소득: ${agent.incomeBracket}, 직업: ${agent.occupation}, 가구형태: ${agent.householdType}`,
    `정책 성향(0~100): 정부신뢰 ${p.governmentTrust}, 정책수용성 ${p.policyAcceptance}, 증세수용 ${p.taxTolerance}, 규제선호 ${p.regulationPreference}, 공공서비스만족 ${p.publicServiceSatisfaction}`,
    `미디어 소비: ${agent.mediaDiet}`,
    `핵심 가치: ${agent.values.join(", ")}`,
    `요약: ${agent.personaSummary}`,
    ``,
    `평가 대상 (${sim.audience} / ${sim.product}):`,
    sim.policyText,
    ``,
    `이 시민이 위 정책/제도에 어떻게 반응할지(수용·순응 의향) JSON으로만 답하세요. 형식:`,
    `{"stance":"support|oppose|neutral","score":0-100,"confidence":0-100,"reasoning":"한국어 1-2문장"}`,
    `score는 수용/순응 의향(0=전혀 수용 안 함, 100=적극 수용). stance는 support=수용, oppose=거부, neutral=중립. 이 시민의 정책 성향(정부신뢰·증세수용·규제선호 등)과 가치에 충실하게 답하세요.`,
  ].join("\n");
}

export function buildPoliticalPrompt(agent: Agent, sim: Simulation): string {
  const stances = agent.issueStances;
  return [
    `당신은 대한민국에 거주하는 시민 페르소나입니다. 아래 인물의 입장에서 정책/메시지에 대한 반응을 평가하세요.`,
    `이름: ${agent.name}`,
    `나이: ${agent.age} (${agent.ageBracket}), 성별: ${agent.gender}`,
    `거주 지역(시·도): ${agent.district}`,
    `학력: ${agent.education}, 소득: ${agent.incomeBracket}, 직업: ${agent.occupation}, 가구형태: ${agent.householdType}`,
    `정치성향(-100 진보 ~ +100 보수): ${agent.politicalLeaning}, 지지정당 성향: ${agent.partyAffinity}, 투표 성향(0~100): ${agent.turnoutPropensity}`,
    `이슈별 입장(0~100): 경제 ${stances.economy}, 복지 ${stances.welfare}, 안보 ${stances.security}, 환경 ${stances.environment}, 주거 ${stances.housing}`,
    `미디어 소비: ${agent.mediaDiet}`,
    `핵심 가치: ${agent.values.join(", ")}`,
    `요약: ${agent.personaSummary}`,
    ``,
    `평가 대상 (${sim.audience} / ${sim.product}):`,
    sim.policyText,
    ``,
    `이 인물이 위 내용에 어떻게 반응할지 JSON으로만 답하세요. 형식:`,
    `{"stance":"support|oppose|neutral","score":0-100,"confidence":0-100,"reasoning":"한국어 1-2문장"}`,
    `score는 지지 강도(0=강한 반대, 100=강한 지지). 이 인물의 성향과 가치에 충실하게 답하세요.`,
  ].join("\n");
}

export function buildPrompt(agent: Agent, sim: Simulation): string {
  if (isCommercialSim(sim)) return buildCommercialPrompt(agent, sim);
  if (isPolicySim(sim)) return buildPolicyPrompt(agent, sim);
  return buildPoliticalPrompt(agent, sim);
}
