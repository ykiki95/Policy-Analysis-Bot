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
import { eq, inArray } from "drizzle-orm";

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
  // ── 상업(소비) 도메인: Lumen 제품 라인용 소비자 태도 ─────────────────────────
  {
    title: "방송통신위원회 2024 방송매체 이용행태조사 — 디지털·OTT 소비",
    description:
      "전국 17개 시·도 13세 이상 8,316명 대상 방문면접(국가승인통계). 전체 OTT 이용률 79.2%, 주5일 이상 스마트폰 이용 92.2%로 디지털 매체 소비가 일상화 → 합성 인구의 디지털소비 성향을 높게 보정.",
    methodology: "가구방문 면접조사 (국가승인통계 제164002호)",
    sampleSize: 8316,
    fieldedDate: "2024-12-30",
    status: "active",
    reliability: 95,
    appliedToPopulation: true,
    domain: "commercial",
    isReal: true,
    sourceAgency: "방송통신위원회",
    sourceTitle: "2024 방송매체 이용행태조사",
    fieldPeriod: "2024 (연간 조사)",
    sourceUrl:
      "https://www.kcc.go.kr/user.do?mode=view&page=A05030000&dc=K05030000&boardId=1113&boardSeq=64951",
    drivers: [
      {
        factor: "OTT·디지털 매체 이용",
        issue: "디지털소비",
        weight: 0.7,
        direction: "OTT 79.2%·스마트폰 92.2% → 디지털 채널 소비 성향 높음",
        targetStance: 72,
      },
    ],
  },
  {
    title: "과학기술정보통신부 2024 인터넷이용실태조사 — 신기술 수용",
    description:
      "전국 25,509가구·만 3세 이상 60,229명 대상 면접조사. AI 서비스 경험률 60.3%, 생성형 AI 경험률 33.3%(전년 17.6% 대비 약 2배)로 신기술 수용이 빠르게 확산 → 신제품수용 성향을 중상위로 보정.",
    methodology: "가구방문 면접조사 (국가승인통계)",
    sampleSize: 60229,
    fieldedDate: "2025-03-31",
    status: "active",
    reliability: 95,
    appliedToPopulation: true,
    domain: "commercial",
    isReal: true,
    sourceAgency: "과학기술정보통신부",
    sourceTitle: "2024 인터넷이용실태조사",
    fieldPeriod: "2024 (연간 조사)",
    sourceUrl: "https://www.korea.kr/briefing/pressReleaseView.do?newsId=156681493",
    drivers: [
      {
        factor: "AI·신기술 수용",
        issue: "신제품수용",
        weight: 0.6,
        direction: "AI 경험 60.3%·생성형 AI 33.3%(2배↑) → 신제품 수용 성향 중상위",
        targetStance: 58,
      },
    ],
  },
  {
    title: "한국소비자원 2025 친환경 소비 제도 이용 실태조사 — 친환경 소비",
    description:
      "전국 성인 소비자 3,200명 대상 조사. 친환경 제도 이용 66.4%, 구매 의향 82.2%로 인식은 높으나 실제 친환경 제품 구매 노력은 25.5%에 그쳐 인식–실천 괴리가 큼 → 친환경소비 성향을 중간 수준으로 보정.",
    methodology: "소비자 대상 설문조사",
    sampleSize: 3200,
    fieldedDate: "2025-05-13",
    status: "active",
    reliability: 95,
    appliedToPopulation: true,
    domain: "commercial",
    isReal: true,
    sourceAgency: "한국소비자원",
    sourceTitle: "친환경 제도 소비자 이용 실태조사",
    fieldPeriod: "2025",
    sourceUrl:
      "https://www.kca.go.kr/home/board/download.do?menukey=4002&fno=10046976&bid=00000013&did=1003867815",
    drivers: [
      {
        factor: "친환경 인식–실천 괴리",
        issue: "친환경소비",
        weight: 0.55,
        direction: "제도 이용 66.4%·의향 82.2% vs 실천 25.5% → 친환경소비 중간 수준",
        targetStance: 50,
      },
    ],
  },
  {
    title: "한국은행 2025 소비자동향조사 — 물가·가격 민감도",
    description:
      "전국 약 2,500가구 대상 월간 소비자동향조사. 물가수준전망 CSI 148, 기대인플레이션율 2.6%로 향후 물가 상승 부담 인식이 높아 가격에 민감한 소비 태도가 우세 → 가격민감도 성향을 높게 보정.",
    methodology: "가구 대상 월간 설문조사 (한국은행 통계)",
    sampleSize: 2500,
    fieldedDate: "2025-12-23",
    status: "active",
    reliability: 95,
    appliedToPopulation: true,
    domain: "commercial",
    isReal: true,
    sourceAgency: "한국은행",
    sourceTitle: "소비자동향조사(소비자심리지수)",
    fieldPeriod: "2025-12",
    sourceUrl:
      "https://www.bok.or.kr/portal/bbs/B0000501/view.do?nttId=10095310&menuNo=201264",
    drivers: [
      {
        factor: "물가 상승 부담",
        issue: "가격민감도",
        weight: 0.6,
        direction: "물가수준전망 CSI 148·기대인플레 2.6% → 가격민감 소비 우세",
        targetStance: 68,
      },
    ],
  },
  {
    title: "대한상공회의소 2024 소비 트렌드 조사 — 브랜드 충성도",
    description:
      "소비자 대상 소비 트렌드 조사. 고가 제품 구매 축소 49%, 저렴한 브랜드 의도적 탐색 43.8%, PB(자체 브랜드) 구매 증가 33%로 가성비 중심 전환이 뚜렷해 브랜드 충성도가 약화 → 브랜드충성도 성향을 낮게 보정.",
    methodology: "소비자 대상 설문조사",
    sampleSize: 1000,
    fieldedDate: "2024-08-31",
    status: "active",
    reliability: 90,
    appliedToPopulation: true,
    domain: "commercial",
    isReal: true,
    sourceAgency: "대한상공회의소",
    sourceTitle: "2024 하반기 소비트렌드 변화와 대응방안",
    fieldPeriod: "2024 하반기",
    sourceUrl:
      "http://www.korcham.net/nCham/Service/Economy/appl/KcciReportDetail.asp?SEQ_NO_C010=20120938356&CHAM_CD=B001",
    drivers: [
      {
        factor: "가성비 전환·브랜드 이탈",
        issue: "브랜드충성도",
        weight: 0.5,
        direction: "저렴 브랜드 탐색 43.8%·PB 구매 33% → 브랜드 충성도 약화",
        targetStance: 38,
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
  // ── 소비자조사: Lumen 상업트랙 소비자 태도 근거 ───────────────────────────────
  {
    name: "방송통신위원회 2024 방송매체 이용행태조사",
    agency: "방송통신위원회",
    category: "소비자조사",
    contributesTo: "디지털소비(OTT·스마트폰 이용)",
    recordCount: 8316,
    coverage: "전국 17개 시·도 13세 이상",
    referenceYear: "2024",
    sourceUrl:
      "https://www.kcc.go.kr/user.do?mode=view&page=A05030000&dc=K05030000&boardId=1113&boardSeq=64951",
  },
  {
    name: "과학기술정보통신부 2024 인터넷이용실태조사",
    agency: "과학기술정보통신부",
    category: "소비자조사",
    contributesTo: "신제품수용(AI·신기술 수용)",
    recordCount: 60229,
    coverage: "전국 25,509가구 만 3세 이상",
    referenceYear: "2024",
    sourceUrl: "https://www.korea.kr/briefing/pressReleaseView.do?newsId=156681493",
  },
  {
    name: "한국소비자원 친환경 소비 제도 이용 실태조사",
    agency: "한국소비자원",
    category: "소비자조사",
    contributesTo: "친환경소비(인식·실천)",
    recordCount: 3200,
    coverage: "전국 성인 소비자",
    referenceYear: "2025",
    sourceUrl:
      "https://www.kca.go.kr/home/board/download.do?menukey=4002&fno=10046976&bid=00000013&did=1003867815",
  },
  {
    name: "한국은행 소비자동향조사",
    agency: "한국은행",
    category: "소비자조사",
    contributesTo: "가격민감도(물가 전망)",
    recordCount: 2500,
    coverage: "전국 약 2,500가구 (월간)",
    referenceYear: "2025",
    sourceUrl:
      "https://www.bok.or.kr/portal/bbs/B0000501/view.do?nttId=10095310&menuNo=201264",
  },
  {
    name: "대한상공회의소 소비 트렌드 조사",
    agency: "대한상공회의소",
    category: "소비자조사",
    contributesTo: "브랜드충성도(가성비·PB 전환)",
    recordCount: 1000,
    coverage: "소비자 대상 설문",
    referenceYear: "2024",
    sourceUrl:
      "http://www.korcham.net/nCham/Service/Economy/appl/KcciReportDetail.asp?SEQ_NO_C010=20120938356&CHAM_CD=B001",
  },
];

async function main(): Promise<void> {
  await db.transaction(async (tx) => {
    await tx.delete(surveysTable).where(eq(surveysTable.isReal, true));
    await tx.insert(surveysTable).values(surveys);

    await tx
      .delete(dataSourcesTable)
      .where(inArray(dataSourcesTable.category, ["여론조사", "소비자조사"]));
    await tx.insert(dataSourcesTable).values(dataSources);
  });
  console.log(
    `Seeded ${surveys.length} real surveys + ${dataSources.length} data sources (여론조사 + 소비자조사).`,
  );
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
