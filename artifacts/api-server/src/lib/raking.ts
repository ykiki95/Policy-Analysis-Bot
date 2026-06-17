/**
 * Iterative Proportional Fitting (raking) for synthetic-population generation.
 *
 * Given target marginal distributions over region, age bracket and gender, we
 * fit a (region × age × gender) joint table that simultaneously matches all
 * three marginals, starting from a uniform (maximum-entropy) seed. The fitted
 * joint is then allocated to a fixed agent count with deterministic
 * largest-remainder rounding, so the generated population's region/age/gender
 * marginals match the official statistics exactly (up to integer rounding).
 *
 * Everything here is pure and deterministic — no RNG, no IO.
 */

export type Marginal = { key: string; population: number };

export type JointCell = {
  region: string;
  age: string;
  gender: string;
  /** Fitted joint probability (sums to 1 across all cells). */
  prob: number;
};

export type AllocatedCell = JointCell & {
  /** Integer agent count for this cell (sums to the requested total). */
  count: number;
};

function normalize(marginals: Marginal[]): Map<string, number> {
  const total = marginals.reduce((s, m) => s + Math.max(0, m.population), 0);
  const out = new Map<string, number>();
  if (total <= 0) {
    const share = marginals.length > 0 ? 1 / marginals.length : 0;
    for (const m of marginals) out.set(m.key, share);
    return out;
  }
  for (const m of marginals) out.set(m.key, Math.max(0, m.population) / total);
  return out;
}

/**
 * Fit the joint distribution from the three marginals via IPF.
 * Returns cells in a stable sorted order (region, age, gender).
 */
export function fitJoint(
  regionMarginals: Marginal[],
  ageMarginals: Marginal[],
  genderMarginals: Marginal[],
  iterations = 30,
): JointCell[] {
  const regions = [...regionMarginals]
    .filter((m) => m.population > 0)
    .map((m) => m.key)
    .sort();
  const ages = [...ageMarginals].map((m) => m.key);
  const genders = [...genderMarginals].map((m) => m.key).sort();

  const regionTarget = normalize(regionMarginals);
  const ageTarget = normalize(ageMarginals);
  const genderTarget = normalize(genderMarginals);

  if (regions.length === 0 || ages.length === 0 || genders.length === 0) {
    return [];
  }

  // Seed: uniform over all present cells.
  const nCells = regions.length * ages.length * genders.length;
  const cellKey = (r: string, a: string, g: string) => `${r}|${a}|${g}`;
  const cells = new Map<string, number>();
  for (const r of regions) {
    for (const a of ages) {
      for (const g of genders) cells.set(cellKey(r, a, g), 1 / nCells);
    }
  }

  for (let iter = 0; iter < iterations; iter++) {
    // Fit region marginal.
    for (const r of regions) {
      let sum = 0;
      for (const a of ages)
        for (const g of genders) sum += cells.get(cellKey(r, a, g))!;
      const target = regionTarget.get(r) ?? 0;
      const factor = sum > 0 ? target / sum : 0;
      for (const a of ages)
        for (const g of genders) {
          const k = cellKey(r, a, g);
          cells.set(k, cells.get(k)! * factor);
        }
    }
    // Fit age marginal.
    for (const a of ages) {
      let sum = 0;
      for (const r of regions)
        for (const g of genders) sum += cells.get(cellKey(r, a, g))!;
      const target = ageTarget.get(a) ?? 0;
      const factor = sum > 0 ? target / sum : 0;
      for (const r of regions)
        for (const g of genders) {
          const k = cellKey(r, a, g);
          cells.set(k, cells.get(k)! * factor);
        }
    }
    // Fit gender marginal.
    for (const g of genders) {
      let sum = 0;
      for (const r of regions)
        for (const a of ages) sum += cells.get(cellKey(r, a, g))!;
      const target = genderTarget.get(g) ?? 0;
      const factor = sum > 0 ? target / sum : 0;
      for (const r of regions)
        for (const a of ages) {
          const k = cellKey(r, a, g);
          cells.set(k, cells.get(k)! * factor);
        }
    }
  }

  const out: JointCell[] = [];
  for (const r of regions)
    for (const a of ages)
      for (const g of genders)
        out.push({
          region: r,
          age: a,
          gender: g,
          prob: cells.get(cellKey(r, a, g))!,
        });
  return out;
}

/**
 * Allocate `total` agents across joint cells using largest-remainder rounding,
 * so the integer counts sum exactly to `total` and best approximate the fitted
 * proportions. Deterministic given identical input ordering.
 */
export function allocate(cells: JointCell[], total: number): AllocatedCell[] {
  const probSum = cells.reduce((s, c) => s + c.prob, 0);
  if (probSum <= 0 || cells.length === 0) {
    return cells.map((c) => ({ ...c, count: 0 }));
  }
  const exact = cells.map((c) => (c.prob / probSum) * total);
  const floors = exact.map((e) => Math.floor(e));
  let assigned = floors.reduce((s, f) => s + f, 0);
  let remainder = total - assigned;

  const order = cells
    .map((c, i) => ({ i, frac: exact[i] - floors[i] }))
    .sort((a, b) => b.frac - a.frac || a.i - b.i);

  const counts = [...floors];
  for (let k = 0; k < order.length && remainder > 0; k++) {
    counts[order[k].i] += 1;
    remainder -= 1;
  }

  return cells.map((c, i) => ({ ...c, count: counts[i] }));
}
