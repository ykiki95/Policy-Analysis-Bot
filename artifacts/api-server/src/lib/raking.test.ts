import { describe, it, expect } from "vitest";
import {
  fitJoint,
  allocate,
  type Marginal,
  type JointCell,
} from "./raking";

/** Sum every cell's probability. */
function probSum(cells: JointCell[]): number {
  return cells.reduce((s, c) => s + c.prob, 0);
}

/** Marginal of a fitted joint along one dimension, keyed by that dimension. */
function marginalOf(
  cells: JointCell[],
  dim: (c: JointCell) => string,
): Map<string, number> {
  const out = new Map<string, number>();
  for (const c of cells) out.set(dim(c), (out.get(dim(c)) ?? 0) + c.prob);
  return out;
}

/** Expected target share of one entry within its own marginal dimension. */
function targetShare(marginals: Marginal[]): Map<string, number> {
  const total = marginals.reduce((s, m) => s + Math.max(0, m.population), 0);
  const out = new Map<string, number>();
  for (const m of marginals)
    out.set(m.key, total > 0 ? Math.max(0, m.population) / total : 0);
  return out;
}

const REGIONS: Marginal[] = [
  { key: "11", population: 950 },
  { key: "26", population: 330 },
  { key: "41", population: 1350 },
];
const AGES: Marginal[] = [
  { key: "18-29", population: 600 },
  { key: "30-39", population: 500 },
  { key: "40-49", population: 520 },
  { key: "50-59", population: 480 },
  { key: "60-69", population: 320 },
  { key: "70+", population: 210 },
];
const GENDERS: Marginal[] = [
  { key: "남성", population: 1300 },
  { key: "여성", population: 1330 },
];

/** Assert each dimension marginal of the fitted joint matches its targets. */
function expectMarginalsConverge(
  cells: JointCell[],
  regions: Marginal[],
  ages: Marginal[],
  genders: Marginal[],
  tol = 1e-9,
) {
  const fittedRegion = marginalOf(cells, (c) => c.region);
  const fittedAge = marginalOf(cells, (c) => c.age);
  const fittedGender = marginalOf(cells, (c) => c.gender);

  const wantRegion = targetShare(regions.filter((m) => m.population > 0));
  for (const [k, want] of wantRegion)
    expect(fittedRegion.get(k) ?? 0).toBeCloseTo(want, 8);

  const wantAge = targetShare(ages);
  for (const [k, want] of wantAge)
    expect(fittedAge.get(k) ?? 0).toBeCloseTo(want, 8);

  const wantGender = targetShare(genders);
  for (const [k, want] of wantGender)
    expect(fittedGender.get(k) ?? 0).toBeCloseTo(want, 8);

  void tol;
}

describe("fitJoint", () => {
  it("produces a joint that normalizes to 1 with all marginals converged", () => {
    const cells = fitJoint(REGIONS, AGES, GENDERS);
    expect(cells.length).toBe(3 * 6 * 2);
    expect(probSum(cells)).toBeCloseTo(1, 9);
    for (const c of cells) {
      expect(Number.isFinite(c.prob)).toBe(true);
      expect(c.prob).toBeGreaterThan(0);
    }
    expectMarginalsConverge(cells, REGIONS, AGES, GENDERS);
  });

  it("returns cells in a stable sorted order (region, age, gender)", () => {
    const a = fitJoint(REGIONS, AGES, GENDERS);
    const b = fitJoint(REGIONS, AGES, GENDERS);
    expect(b).toEqual(a);
    // Regions and genders are sorted; ages keep their input order.
    const regionOrder = [...new Set(a.map((c) => c.region))];
    expect(regionOrder).toEqual([...regionOrder].sort());
  });

  it("excludes region marginal entries with zero population", () => {
    const regions: Marginal[] = [
      { key: "11", population: 0 },
      { key: "26", population: 330 },
      { key: "41", population: 1350 },
    ];
    const cells = fitJoint(regions, AGES, GENDERS);
    const presentRegions = new Set(cells.map((c) => c.region));
    expect(presentRegions.has("11")).toBe(false);
    expect(presentRegions.has("26")).toBe(true);
    expect(presentRegions.has("41")).toBe(true);
    expect(probSum(cells)).toBeCloseTo(1, 9);
    expectMarginalsConverge(cells, regions, AGES, GENDERS);
  });

  it("handles a single region collapse", () => {
    const single: Marginal[] = [{ key: "41", population: 1350 }];
    const cells = fitJoint(single, AGES, GENDERS);
    expect(new Set(cells.map((c) => c.region))).toEqual(new Set(["41"]));
    expect(probSum(cells)).toBeCloseTo(1, 9);
    // The whole region marginal mass sits on the single region.
    const region = marginalOf(cells, (c) => c.region);
    expect(region.get("41")).toBeCloseTo(1, 9);
    expectMarginalsConverge(cells, single, AGES, GENDERS);
  });

  it("handles a single age dimension", () => {
    const oneAge: Marginal[] = [{ key: "전연령", population: 100 }];
    const cells = fitJoint(REGIONS, oneAge, GENDERS);
    expect(new Set(cells.map((c) => c.age))).toEqual(new Set(["전연령"]));
    expect(probSum(cells)).toBeCloseTo(1, 9);
    const age = marginalOf(cells, (c) => c.age);
    expect(age.get("전연령")).toBeCloseTo(1, 9);
    expectMarginalsConverge(cells, REGIONS, oneAge, GENDERS);
  });

  it("handles a single gender dimension", () => {
    const oneGender: Marginal[] = [{ key: "여성", population: 500 }];
    const cells = fitJoint(REGIONS, AGES, oneGender);
    expect(new Set(cells.map((c) => c.gender))).toEqual(new Set(["여성"]));
    expect(probSum(cells)).toBeCloseTo(1, 9);
    expectMarginalsConverge(cells, REGIONS, AGES, oneGender);
  });

  it("handles a fully collapsed 1x1x1 joint", () => {
    const cells = fitJoint(
      [{ key: "41", population: 10 }],
      [{ key: "전연령", population: 10 }],
      [{ key: "여성", population: 10 }],
    );
    expect(cells.length).toBe(1);
    expect(cells[0].prob).toBeCloseTo(1, 9);
  });

  it("falls back to a uniform marginal when a whole dimension has zero population", () => {
    // Age marginal all-zero: normalize() falls back to uniform shares, so the
    // joint must still be finite and normalized (no NaN from 0/0).
    const zeroAges: Marginal[] = AGES.map((m) => ({ ...m, population: 0 }));
    const cells = fitJoint(REGIONS, zeroAges, GENDERS);
    expect(cells.length).toBe(3 * 6 * 2);
    expect(probSum(cells)).toBeCloseTo(1, 9);
    for (const c of cells) expect(Number.isFinite(c.prob)).toBe(true);
    // Uniform age fallback => each age bracket gets an equal 1/6 share.
    const age = marginalOf(cells, (c) => c.age);
    for (const m of zeroAges) expect(age.get(m.key)).toBeCloseTo(1 / 6, 8);
  });

  it("returns an empty joint when any dimension is empty", () => {
    expect(fitJoint([], AGES, GENDERS)).toEqual([]);
    expect(fitJoint(REGIONS, [], GENDERS)).toEqual([]);
    expect(fitJoint(REGIONS, AGES, [])).toEqual([]);
    // All region entries filtered out (zero population) => empty too.
    expect(
      fitJoint([{ key: "11", population: 0 }], AGES, GENDERS),
    ).toEqual([]);
  });

  it("never emits NaN even with mixed zero/positive populations", () => {
    const regions: Marginal[] = [
      { key: "11", population: 0 },
      { key: "26", population: 1 },
    ];
    const ages: Marginal[] = [
      { key: "18-29", population: 0 },
      { key: "30-39", population: 7 },
    ];
    const genders: Marginal[] = [
      { key: "남성", population: 3 },
      { key: "여성", population: 0 },
    ];
    const cells = fitJoint(regions, ages, genders);
    for (const c of cells) expect(Number.isFinite(c.prob)).toBe(true);
    expect(probSum(cells)).toBeCloseTo(1, 9);
  });
});

describe("allocate", () => {
  /** Build a uniform joint over n cells for allocation-focused tests. */
  function uniformCells(n: number): JointCell[] {
    return Array.from({ length: n }, (_, i) => ({
      region: `r${i}`,
      age: "a",
      gender: "g",
      prob: 1 / n,
    }));
  }

  it("sums exactly to total for a range of totals", () => {
    const cells = fitJoint(REGIONS, AGES, GENDERS);
    for (const total of [0, 1, 2, 7, 50, 240, 1000, 5000, 99999]) {
      const allocated = allocate(cells, total);
      const sum = allocated.reduce((s, c) => s + c.count, 0);
      expect(sum).toBe(total);
      for (const c of allocated) {
        expect(Number.isInteger(c.count)).toBe(true);
        expect(c.count).toBeGreaterThanOrEqual(0);
      }
    }
  });

  it("allocates zero everywhere when total is 0", () => {
    const allocated = allocate(fitJoint(REGIONS, AGES, GENDERS), 0);
    expect(allocated.every((c) => c.count === 0)).toBe(true);
    expect(allocated.reduce((s, c) => s + c.count, 0)).toBe(0);
  });

  it("puts the single agent in exactly one cell when total is 1", () => {
    const allocated = allocate(fitJoint(REGIONS, AGES, GENDERS), 1);
    expect(allocated.reduce((s, c) => s + c.count, 0)).toBe(1);
    expect(allocated.filter((c) => c.count === 1).length).toBe(1);
  });

  it("matches total even when count is far smaller than the cell count", () => {
    // 36 cells, only 5 agents => most cells get 0 but the sum is exact.
    const cells = fitJoint(REGIONS, AGES, GENDERS);
    expect(cells.length).toBe(36);
    const allocated = allocate(cells, 5);
    expect(allocated.reduce((s, c) => s + c.count, 0)).toBe(5);
    expect(allocated.filter((c) => c.count > 0).length).toBeLessThanOrEqual(5);
  });

  it("returns zero counts for an empty cell list", () => {
    expect(allocate([], 100)).toEqual([]);
    expect(allocate([], 0)).toEqual([]);
  });

  it("returns zero counts when probabilities sum to zero", () => {
    const cells: JointCell[] = [
      { region: "11", age: "a", gender: "g", prob: 0 },
      { region: "26", age: "a", gender: "g", prob: 0 },
    ];
    const allocated = allocate(cells, 100);
    expect(allocated.every((c) => c.count === 0)).toBe(true);
  });

  it("distributes a uniform joint as evenly as largest-remainder allows", () => {
    const allocated = allocate(uniformCells(4), 10);
    expect(allocated.reduce((s, c) => s + c.count, 0)).toBe(10);
    const counts = allocated.map((c) => c.count).sort((a, b) => a - b);
    // 10 over 4 even cells => two 2s and two 3s.
    expect(counts).toEqual([2, 2, 3, 3]);
  });

  it("is deterministic for identical input ordering", () => {
    const cells = fitJoint(REGIONS, AGES, GENDERS);
    expect(allocate(cells, 777)).toEqual(allocate(cells, 777));
  });
});
