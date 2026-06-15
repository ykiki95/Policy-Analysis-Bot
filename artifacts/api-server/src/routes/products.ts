import { Router, type IRouter } from "express";
import { ListProductsResponse } from "@workspace/api-zod";

const router: IRouter = Router();

const PRODUCTS = [
  {
    id: "lumen",
    name: "Lumen",
    audience: "비즈니스",
    tagline: "출시 전에 시장의 반응을 읽다",
    description:
      "신제품, 가격 정책, 브랜드 메시지를 500명의 서울 합성 소비자 패널에 던져 실제 출시 전에 수용도와 세그먼트별 반응을 예측합니다.",
    useCases: [
      "신제품 컨셉 테스트",
      "가격 민감도 분석",
      "광고 메시지 A/B 사전 검증",
      "세그먼트별 수용도 예측",
    ],
  },
  {
    id: "seraph",
    name: "Seraph",
    audience: "정부",
    tagline: "정책이 시민에게 닿기 전에 시뮬레이션하다",
    description:
      "공공 정책 초안을 자치구·연령·소득별로 분포된 합성 시민에게 적용해 지지율과 반발 지점을 사전에 파악하고, 보정된 예측으로 신뢰도를 확보합니다.",
    useCases: [
      "정책 수용성 사전 평가",
      "자치구별 반응 격차 분석",
      "공공 커뮤니케이션 메시지 최적화",
      "이해관계자 반발 지점 탐지",
    ],
  },
  {
    id: "dynamo",
    name: "Dynamo",
    audience: "정치",
    tagline: "유권자를 움직이는 메시지를 찾다",
    description:
      "캠페인 메시지와 공약을 정치성향·투표성향이 반영된 합성 유권자에게 테스트하여 어떤 메시지가 어떤 집단을 설득하는지 보정된 예측으로 제시합니다.",
    useCases: [
      "캠페인 메시지 테스트",
      "스윙 보터 설득 시뮬레이션",
      "공약 반응 예측",
      "지역구별 전략 수립",
    ],
  },
];

router.get("/products", async (_req, res): Promise<void> => {
  res.json(ListProductsResponse.parse(PRODUCTS));
});

export default router;
