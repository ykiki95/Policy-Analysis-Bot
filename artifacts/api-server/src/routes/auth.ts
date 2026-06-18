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

const router: IRouter = Router();

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
  const [created] = await db
    .insert(usersTable)
    .values({ name, username, birthDate, passwordHash, role: "user" })
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

  const user = await findUserByUsername(username);
  if (!user || !(await verifyPassword(password, user.passwordHash))) {
    res.status(401).json({ error: "아이디 또는 비밀번호가 올바르지 않습니다." });
    return;
  }

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
