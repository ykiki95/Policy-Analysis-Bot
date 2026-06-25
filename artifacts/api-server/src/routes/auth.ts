import { Router, type IRouter } from "express";
import { jsonReady } from "../lib/serialize";
import { db, usersTable } from "@workspace/db";
import { SignupBody, LoginBody, GetMeResponse } from "@workspace/api-zod";
import {
  hashPassword,
  verifyPassword,
  toPublicUser,
  findUserById,
  findUserByUsername,
} from "../lib/auth";
import { authLimiter } from "../lib/rateLimit";
import { recordEvent } from "../lib/analytics";

const router: IRouter = Router();

/** 로그인 시도를 접속 분석에 기록(성공/실패). 클라이언트가 보낸 추적 ID 가 있으면
 * 같은 세션으로 묶고, 없으면 헤더에서 추출하거나 익명 식별자를 만든다. */
function loginTrackingIds(req: {
  body: { clientId?: unknown; sessionId?: unknown };
}): { clientId: string; sessionId: string } {
  const cid =
    typeof req.body?.clientId === "string" && req.body.clientId.trim()
      ? req.body.clientId
      : "login-form";
  const sid =
    typeof req.body?.sessionId === "string" && req.body.sessionId.trim()
      ? req.body.sessionId
      : "login-form";
  return { clientId: cid, sessionId: sid };
}

router.post("/auth/signup", authLimiter, async (req, res): Promise<void> => {
  const parsed = SignupBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "입력값이 올바르지 않습니다." });
    return;
  }
  const { name, username, birthDate, password } = parsed.data;

  const existing = await findUserByUsername(username);
  if (existing) {
    res.status(409).json({ error: "이미 사용 중인 아이디입니다." });
    return;
  }

  const passwordHash = await hashPassword(password);
  // 가입 시 기본 아바타를 무작위 프리셋(av1..av8)으로 부여한다.
  const avatar = `av${1 + Math.floor(Math.random() * 8)}`;
  const [created] = await db
    .insert(usersTable)
    .values({ name, username, birthDate, passwordHash, role: "user", avatar })
    .returning();

  req.session.regenerate((err) => {
    if (err) {
      req.log.error({ err }, "세션 재생성 실패");
      res.status(500).json({ error: "회원가입에 실패했습니다." });
      return;
    }
    req.session.userId = created.id;
    res.status(201).json(GetMeResponse.parse(jsonReady(toPublicUser(created))));
  });
});

router.post("/auth/login", authLimiter, async (req, res): Promise<void> => {
  const parsed = LoginBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "입력값이 올바르지 않습니다." });
    return;
  }
  const { username, password } = parsed.data;
  const ids = loginTrackingIds(req);

  const user = await findUserByUsername(username);
  if (!user || !(await verifyPassword(password, user.passwordHash))) {
    await recordEvent(req, {
      ...ids,
      userId: user?.id ?? null,
      path: "/login",
      type: "login",
      success: false,
    });
    res.status(401).json({ error: "아이디 또는 비밀번호가 올바르지 않습니다." });
    return;
  }

  await recordEvent(req, {
    ...ids,
    userId: user.id,
    path: "/login",
    type: "login",
    success: true,
  });

  req.session.regenerate((err) => {
    if (err) {
      req.log.error({ err }, "세션 재생성 실패");
      res.status(500).json({ error: "로그인에 실패했습니다." });
      return;
    }
    req.session.userId = user.id;
    res.json(GetMeResponse.parse(jsonReady(toPublicUser(user))));
  });
});

router.post("/auth/logout", (req, res): void => {
  req.session.destroy((err) => {
    if (err) {
      req.log.error({ err }, "세션 종료 실패");
      res.status(500).json({ error: "로그아웃에 실패했습니다." });
      return;
    }
    res.clearCookie("connect.sid");
    res.status(204).end();
  });
});

router.get("/auth/me", async (req, res): Promise<void> => {
  const userId = req.session.userId;
  if (!userId) {
    res.status(401).json({ error: "로그인이 필요합니다." });
    return;
  }
  const user = await findUserById(userId);
  if (!user) {
    req.session.destroy(() => {});
    res.status(401).json({ error: "로그인이 필요합니다." });
    return;
  }
  res.json(GetMeResponse.parse(jsonReady(toPublicUser(user))));
});

export default router;
