import type { RequestHandler, Request } from "express";
import { findUserById } from "./auth";
import type { User } from "@workspace/db";

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      /** requireAuth/withTenant 통과 후 로드된 현재 로그인 사용자. */
      currentUser?: User;
      /**
       * 이 요청이 대상으로 하는 테넌트(데이터 소유자) userId.
       * 일반 사용자는 본인. admin은 `?accountId=`로 타계정을 지정할 수 있다.
       */
      tenantId?: number;
    }
  }
}

/**
 * requireAuth 이후에 사용한다. 현재 사용자를 로드해 `req.currentUser`에 싣고,
 * 대상 테넌트를 결정해 `req.tenantId`에 싣는다. admin이 `?accountId=<id>`를
 * 보내면 해당 계정 데이터를 대상으로 한다(계정 스위처). 일반 사용자는 무시된다.
 */
export const withTenant: RequestHandler = async (req, res, next) => {
  const userId = req.session.userId;
  if (!userId) {
    res.status(401).json({ error: "로그인이 필요합니다." });
    return;
  }
  const user = await findUserById(userId);
  if (!user) {
    res.status(401).json({ error: "로그인이 필요합니다." });
    return;
  }
  req.currentUser = user;

  let target = user.id;
  const accountId = req.query["accountId"];
  if (accountId !== undefined && user.role === "admin") {
    const n = Number(accountId);
    if (Number.isInteger(n) && n > 0) target = n;
  }
  req.tenantId = target;
  next();
};

/** 현재 요청의 테넌트 userId. withTenant 이후에만 호출 가능. */
export function tenantId(req: Request): number {
  if (req.tenantId == null) {
    throw new Error("tenantId가 설정되지 않았습니다 (withTenant 미적용).");
  }
  return req.tenantId;
}

/**
 * 전역 "학습 자산" 소유자 sentinel userId.
 * 합성 학습 인구(agents)와 인구를 형성·보정하는 입력(설문·정확도검증·신호·
 * 보정설정)은 전 계정이 공유한다 — 관리자가 큐레이션하며 모든 계정의 합성인구
 * 학습에 반영된다. 실제 사용자 id는 항상 1 이상이라 0은 안전한 sentinel.
 */
export const GLOBAL_LEARNING_USER_ID = 0;

/**
 * 역할 기반 공유 데이터(신호·정확도검증)를 읽을 때 쓰는 소유자 id 목록.
 * 전역(관리자 큐레이션) + 본인(개인 입력)을 함께 본다. 인구 기준선(입력 레버)은
 * 전역만 반영해야 하므로 이 헬퍼가 아니라 GLOBAL_LEARNING_USER_ID 를 직접 쓴다.
 */
export function learningReadIds(req: Request): number[] {
  const me = tenantId(req);
  return me === GLOBAL_LEARNING_USER_ID
    ? [GLOBAL_LEARNING_USER_ID]
    : [GLOBAL_LEARNING_USER_ID, me];
}

/** 현재 로그인 사용자가 admin 인지. */
export function isAdmin(req: Request): boolean {
  return req.currentUser?.role === "admin";
}
