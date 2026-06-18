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

/** 현재 로그인 사용자가 admin 인지. */
export function isAdmin(req: Request): boolean {
  return req.currentUser?.role === "admin";
}
