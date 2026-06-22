import { describe, it, expect, beforeAll } from "vitest";
import request from "supertest";
import app from "../app";

/**
 * 통합 테스트: 인증 강제 / 테넌시 격리 / 예산 / 에러 응답 일관성을 검증한다.
 * 시드된 계정(test, admin — 비밀번호 1111)을 사용하며 라이브 DB에 붙는다.
 * 읽기 위주로 작성해 데이터를 변형하지 않는다.
 */
describe("API 통합 — 인증/테넌시/예산", () => {
  const testAgent = request.agent(app);
  const adminAgent = request.agent(app);

  beforeAll(async () => {
    const a = await testAgent
      .post("/api/auth/login")
      .send({ username: "test", password: "1111" });
    expect(a.status).toBe(200);
    const b = await adminAgent
      .post("/api/auth/login")
      .send({ username: "admin", password: "1111" });
    expect(b.status).toBe(200);
  });

  it("미로그인 데이터 접근은 401", async () => {
    const res = await request(app).get("/api/agents/summary");
    expect(res.status).toBe(401);
    expect(res.body).toHaveProperty("error");
  });

  it("잘못된 비밀번호 로그인은 401", async () => {
    const res = await request(app)
      .post("/api/auth/login")
      .send({ username: "test", password: "wrong" });
    expect(res.status).toBe(401);
  });

  it("테넌시 격리: test 는 자신의 인구를, admin 은 비어있는 자신의 인구를 본다", async () => {
    const testSummary = await testAgent.get("/api/agents/summary");
    expect(testSummary.status).toBe(200);
    expect(testSummary.body.total).toBeGreaterThan(0);

    const adminOwn = await adminAgent.get("/api/agents/summary");
    expect(adminOwn.status).toBe(200);
    expect(adminOwn.body.total).toBe(0);
  });

  it("admin 계정 스위처(?accountId)로 타 계정 데이터를 조회할 수 있다", async () => {
    const switched = await adminAgent.get("/api/agents/summary?accountId=1");
    expect(switched.status).toBe(200);
    expect(switched.body.total).toBeGreaterThan(0);
  });

  it("일반 사용자는 ?accountId 를 무시하고 자신의 데이터만 본다", async () => {
    const own = await testAgent.get("/api/agents/summary");
    const tryingSwitch = await testAgent.get("/api/agents/summary?accountId=2");
    expect(tryingSwitch.status).toBe(200);
    expect(tryingSwitch.body.total).toBe(own.body.total);
  });

  it("일반 사용자는 admin 라우트 접근이 차단된다", async () => {
    const res = await testAgent.get("/api/admin/accounts");
    expect(res.status).toBe(403);
  });

  it("admin 은 전체 계정 목록을 예산과 함께 조회한다(실비 USD)", async () => {
    const res = await adminAgent.get("/api/admin/accounts");
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
    expect(res.body.length).toBeGreaterThanOrEqual(2);
    for (const acc of res.body) {
      expect(acc).toHaveProperty("budgetLimitUsd");
      expect(acc).toHaveProperty("spentUsd");
      expect(acc).toHaveProperty("remainingUsd");
    }
  });

  it("예산 현황은 실비(USD)로 반환한다", async () => {
    const res = await testAgent.get("/api/budget");
    expect(res.status).toBe(200);
    expect(res.body).not.toHaveProperty("multiplier");
    expect(res.body).toHaveProperty("limitUsd");
    expect(res.body).toHaveProperty("spentUsd");
    expect(res.body).toHaveProperty("remainingUsd");
  });

  it("예산 초과 시 실행(enqueue)은 402로 차단되고 예산 상세는 실비(USD)다", async () => {
    // test 계정은 이미 누적 지출이 한도($1 실비)에 근접해 있어, gpt-5(≈$1.44 실비)
    // 한 건만으로도 한도를 초과한다. 시뮬레이션은 생성되지만 run 은 402여야 한다.
    const created = await testAgent.post("/api/simulations").send({
      title: "예산 초과 회귀 테스트",
      audience: "비즈니스",
      product: "Lumen",
      policyText: "테스트",
      model: "gpt-5",
    });
    expect(created.status).toBe(201);
    const run = await testAgent.post(`/api/simulations/${created.body.id}/run`);
    expect(run.status).toBe(402);
    expect(run.body.budget).not.toHaveProperty("multiplier");
    expect(run.body.budget.estimateUsd).toBeGreaterThan(run.body.budget.remainingUsd);
  });

  it("미등록 경로는 일관된 404 JSON 을 반환한다", async () => {
    const res = await testAgent.get("/api/this-route-does-not-exist");
    expect(res.status).toBe(404);
    expect(res.body).toHaveProperty("error");
  });
});
