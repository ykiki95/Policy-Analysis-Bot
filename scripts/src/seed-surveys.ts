/**
 * Idempotent seed for the REAL published Korean survey aggregates used as the
 * synthetic population's attitude raking targets, plus their matching data-source
 * rows for the 데이터 출처 tab.
 *
 * Idempotent: only manages canonical rows — surveys with `isReal=true` and
 * data sources in the "여론조사" category are deleted then re-inserted. Any
 * user-created surveys (isReal=false) and other data-source categories are left
 * untouched. Safe to run repeatedly (e.g. from the post-merge setup script).
 */
import { db, surveysTable, dataSourcesTable, type InsertSurvey } from "@workspace/db";
import { eq } from "drizzle-orm";

const surveys: InsertSurvey[] = [
  {
    title: "한국갤럽 데일리 오피니언 — 향후 1년 경기 전망",
    description:
      "전국 만 18세 이상 1,000명 대상 전화면접(CATI) 조사. 향후 1년 경기 전망에서 '나빠질 것' 47% vs '좋아질 것' 24%로 비관론 우세 → 정부의 경제 역할 확대 선호로 해석.",
    methodology: "전화면접조사(CATI), 무선 가상번호 무작위 추출",
    sampleSize: 1000,
    fieldedDate: "2025-04-17",
    status: "active",
    reliability: 95,
    appliedToPopulation: true,
    isReal: true,
    sourceAgency: "한국갤럽",
    sourceTitle: "데일리 오피니언 제634호 — 향후 1년 경기 전망",
    fieldPeriod: "2025-04-15 ~ 2025-04-17",
    sourceUrl: "https://www.gallup.co.kr/gallupdb/report.asp",
    drivers: [
      {
        factor: "경기 전망",
        issue: "경제",
        weight: 0.4,
        direction: "경기 비관론 우세(나빠질 47% vs 좋아질 24%) → 정부 경제 역할 확대 선호",
        targetStance: -20,
      },
    ],
  },
  {
    title: "통계청 2023년 사회조사 — 복지 부문",
    description:
      "전국 만 13세 이상 약 36,000명(약 19,000가구) 대상 면접조사. 늘려야 할 복지서비스로 고용(취업)지원 1위·보건의료 2위, 노후 준비 필요 인식이 높게 나타남 → 복지 확대 지지.",
    methodology: "가구방문 면접조사 (국가지정통계)",
    sampleSize: 36000,
    fieldedDate: "2023-05-31",
    status: "active",
    reliability: 95,
    appliedToPopulation: true,
    isReal: true,
    sourceAgency: "통계청",
    sourceTitle: "2023년 사회조사 결과 (복지·사회참여·여가·소득과 소비·노동)",
    fieldPeriod: "2023-05 (16일간)",
    sourceUrl:
      "https://kostat.go.kr/board.es?mid=a10301010000&bid=219&act=view&list_no=427913",
    drivers: [
      {
        factor: "복지 수요",
        issue: "복지",
        weight: 0.55,
        direction: "늘려야 할 복지 1위 고용지원·2위 보건의료 → 복지 확대 지지",
        targetStance: 35,
      },
    ],
  },
  {
    title: "서울대 통일평화연구원 2024 통일의식조사 — 대북·안보 인식",
    description:
      "전국 17개 시·도 만 19세 이상 1,200명 대상 1:1 면접조사(표본오차 ±2.8%, 95% 신뢰수준). 대북 적대의식이 22.3%로 역대 최고(3년 연속 상승), 통일 불필요 여론도 역대 최고 → 안보 강화 기조 강화.",
    methodology: "1:1 대면 면접조사 (한국갤럽 수행)",
    sampleSize: 1200,
    fieldedDate: "2024-07-23",
    status: "active",
    reliability: 95,
    appliedToPopulation: true,
    isReal: true,
    sourceAgency: "서울대학교 통일평화연구원",
    sourceTitle: "2024 통일의식조사",
    fieldPeriod: "2024-07-01 ~ 2024-07-23",
    sourceUrl: "https://ipus.snu.ac.kr/blog/archives/news/9627",
    drivers: [
      {
        factor: "대북 인식",
        issue: "안보",
        weight: 0.45,
        direction: "대북 적대의식 22.3% 역대 최고 → 안보 강화 기조 강화",
        targetStance: 18,
      },
    ],
  },
  {
    title: "한국환경연구원(KEI) 2024 국민환경의식조사 — 기후변화 인식",
    description:
      "전국 성인 3,040명 대상 웹조사(지역·성·연령 비례 할당). 기후변화를 가장 중요한 환경문제로 꼽은 응답이 68.2%로 2021년 39.8%에서 급증, 불안감 75.7% → 환경 보호 우선 강하게 지지.",
    methodology: "웹조사 (온라인 패널, 비례 할당 추출)",
    sampleSize: 3040,
    fieldedDate: "2024-12-31",
    status: "active",
    reliability: 95,
    appliedToPopulation: true,
    isReal: true,
    sourceAgency: "한국환경연구원(KEI)",
    sourceTitle: "2024 국민환경의식조사",
    fieldPeriod: "2024 (연간 조사)",
    sourceUrl:
      "https://www.kei.re.kr/elibList.es?mid=a10101010000&elibName=researchreport&act=view&c_id=766481",
    drivers: [
      {
        factor: "기후변화 심각성",
        issue: "환경",
        weight: 0.68,
        direction: "기후변화를 최우선 환경문제로 꼽은 응답 68.2% → 환경 보호 우선",
        targetStance: 45,
      },
    ],
  },
  {
    title: "국토교통부 2023년 주거실태조사 — 주거 인식",
    description:
      "전국 약 6.1만 가구 대상 1:1 개별 면접조사(국토연구원·한국리서치 수행). 내 집 보유 의사 87.3%인 반면 자가점유율은 57.4%에 그쳐 미충족 주거 수요가 큼 → 주거 지원·공급 확대 지지.",
    methodology: "1:1 개별 면접조사 (국토연구원·한국리서치)",
    sampleSize: 61000,
    fieldedDate: "2023-12-31",
    status: "active",
    reliability: 95,
    appliedToPopulation: true,
    isReal: true,
    sourceAgency: "국토교통부",
    sourceTitle: "2023년도 주거실태조사",
    fieldPeriod: "2023 (연간 조사)",
    sourceUrl:
      "https://www.molit.go.kr/USR/NEWS/m_71/dtl.jsp?lcmspage=1&id=95090538",
    drivers: [
      {
        factor: "주거 보유의사",
        issue: "주거",
        weight: 0.6,
        direction: "내 집 보유의사 87.3% vs 자가점유율 57.4% → 주거 지원·공급 확대 지지",
        targetStance: 42,
      },
    ],
  },
];

const dataSources = [
  {
    name: "한국갤럽 데일리 오피니언 (경기 전망)",
    agency: "한국갤럽",
    category: "여론조사",
    contributesTo: "경제 태도(시장·정부 역할)",
    recordCount: 1000,
    coverage: "전국 만 18세 이상",
    referenceYear: "2025",
    sourceUrl: "https://www.gallup.co.kr/gallupdb/report.asp",
  },
  {
    name: "통계청 2023년 사회조사 (복지)",
    agency: "통계청",
    category: "여론조사",
    contributesTo: "복지 태도(복지 확대)",
    recordCount: 36000,
    coverage: "전국 만 13세 이상",
    referenceYear: "2023",
    sourceUrl:
      "https://kostat.go.kr/board.es?mid=a10301010000&bid=219&act=view&list_no=427913",
  },
  {
    name: "서울대 통일평화연구원 통일의식조사",
    agency: "서울대학교 통일평화연구원",
    category: "여론조사",
    contributesTo: "안보 태도(대북 인식)",
    recordCount: 1200,
    coverage: "전국 17개 시·도 만 19세 이상",
    referenceYear: "2024",
    sourceUrl: "https://ipus.snu.ac.kr/blog/archives/news/9627",
  },
  {
    name: "KEI 2024 국민환경의식조사",
    agency: "한국환경연구원(KEI)",
    category: "여론조사",
    contributesTo: "환경 태도(기후변화 인식)",
    recordCount: 3040,
    coverage: "전국 성인 (웹조사)",
    referenceYear: "2024",
    sourceUrl:
      "https://www.kei.re.kr/elibList.es?mid=a10101010000&elibName=researchreport&act=view&c_id=766481",
  },
  {
    name: "국토교통부 2023년 주거실태조사",
    agency: "국토교통부",
    category: "여론조사",
    contributesTo: "주거 태도(보유의사·지원)",
    recordCount: 61000,
    coverage: "전국 약 6.1만 가구",
    referenceYear: "2023",
    sourceUrl:
      "https://www.molit.go.kr/USR/NEWS/m_71/dtl.jsp?lcmspage=1&id=95090538",
  },
];

async function main(): Promise<void> {
  await db.transaction(async (tx) => {
    await tx.delete(surveysTable).where(eq(surveysTable.isReal, true));
    await tx.insert(surveysTable).values(surveys);

    await tx.delete(dataSourcesTable).where(eq(dataSourcesTable.category, "여론조사"));
    await tx.insert(dataSourcesTable).values(dataSources);
  });
  console.log(
    `Seeded ${surveys.length} real surveys + ${dataSources.length} 여론조사 data sources.`,
  );
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
