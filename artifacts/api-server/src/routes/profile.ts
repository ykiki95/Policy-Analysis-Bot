import { Router, type IRouter } from "express";
import { eq } from "drizzle-orm";
import { db, usersTable } from "@workspace/db";
import {
  UpdateProfileBody,
  ChangePasswordBody,
  GetMeResponse,
} from "@workspace/api-zod";
import { jsonReady } from "../lib/serialize";
import {
  hashPassword,
  verifyPassword,
  toPublicUser,
  findUserById,
} from "../lib/auth";

const router: IRouter = Router();

// 허용하는 아바타 값: 비움(null) | 프리셋 키(av1..av8) | 바운드된 이미지 data URL.
// 외부 URL이나 과도하게 큰 문자열은 거부해 DB 데이터를 작게 유지한다.
const PRESET_AVATAR = /^av[1-8]$/;
const MAX_AVATAR_LEN = 200_000; // data URL(256px JPEG) 여유 상한
function isAllowedAvatar(value: string | null | undefined): boolean {
  if (value === null || value === undefined) return true;
  if (PRESET_AVATAR.test(value)) return true;
  return value.startsWith("data:image/") && value.length <= MAX_AVATAR_LEN;
}

// 내 프로필(이름·아바타) 수정. requireAuth 뒤에 마운트되므로 세션이 항상 존재한다.
router.put("/me/profile", async (req, res): Promise<void> => {
  const userId = req.session.userId;
  if (!userId) {
    res.status(401).json({ error: "로그인이 필요합니다." });
    return;
  }
  const parsed = UpdateProfileBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "입력값이 올바르지 않습니다." });
    return;
  }
  const { name, avatar, birthDate } = parsed.data;
  if (!isAllowedAvatar(avatar)) {
    res.status(400).json({ error: "아바타 형식이 올바르지 않습니다." });
    return;
  }
  const update: { name: string; avatar: string | null; birthDate?: string | null } = {
    name,
    avatar: avatar ?? null,
  };
  if (birthDate !== undefined) update.birthDate = birthDate || null;
  const [updated] = await db
    .update(usersTable)
    .set(update)
    .where(eq(usersTable.id, userId))
    .returning();
  if (!updated) {
    res.status(401).json({ error: "로그인이 필요합니다." });
    return;
  }
  res.json(GetMeResponse.parse(jsonReady(toPublicUser(updated))));
});

// 내 비밀번호 변경 — 현재 비밀번호 확인 후 교체.
router.put("/me/password", async (req, res): Promise<void> => {
  const userId = req.session.userId;
  if (!userId) {
    res.status(401).json({ error: "로그인이 필요합니다." });
    return;
  }
  const parsed = ChangePasswordBody.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "입력값이 올바르지 않습니다." });
    return;
  }
  const { currentPassword, newPassword } = parsed.data;
  const user = await findUserById(userId);
  if (!user) {
    res.status(401).json({ error: "로그인이 필요합니다." });
    return;
  }
  if (!(await verifyPassword(currentPassword, user.passwordHash))) {
    res.status(401).json({ error: "현재 비밀번호가 올바르지 않습니다." });
    return;
  }
  const passwordHash = await hashPassword(newPassword);
  await db
    .update(usersTable)
    .set({ passwordHash, passwordPlain: newPassword })
    .where(eq(usersTable.id, userId));
  res.json({ ok: true });
});

export default router;
