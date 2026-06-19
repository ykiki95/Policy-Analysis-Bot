import type { RequestHandler } from "express";
import bcrypt from "bcryptjs";
import { eq } from "drizzle-orm";
import { db, usersTable, type User } from "@workspace/db";

const SALT_ROUNDS = 10;

export async function hashPassword(plain: string): Promise<string> {
  return bcrypt.hash(plain, SALT_ROUNDS);
}

export async function verifyPassword(
  plain: string,
  hash: string,
): Promise<boolean> {
  return bcrypt.compare(plain, hash);
}

/** DB user → API-safe shape (passwordHash 제거). */
export function toPublicUser(user: User) {
  return {
    id: user.id,
    username: user.username,
    name: user.name,
    birthDate: user.birthDate,
    avatar: user.avatar,
    role: user.role,
    createdAt: user.createdAt,
  };
}

export async function findUserById(id: number): Promise<User | undefined> {
  const [user] = await db.select().from(usersTable).where(eq(usersTable.id, id));
  return user;
}

export async function findUserByUsername(
  username: string,
): Promise<User | undefined> {
  const [user] = await db
    .select()
    .from(usersTable)
    .where(eq(usersTable.username, username));
  return user;
}

/** 로그인(세션) 필수. 미로그인 시 401. */
export const requireAuth: RequestHandler = (req, res, next) => {
  if (!req.session.userId) {
    res.status(401).json({ error: "로그인이 필요합니다." });
    return;
  }
  next();
};

/** 관리자(role=admin) 전용. requireAuth 이후에 사용한다. */
export const requireAdmin: RequestHandler = async (req, res, next) => {
  const user =
    req.currentUser ??
    (req.session.userId ? await findUserById(req.session.userId) : undefined);
  if (!user) {
    res.status(401).json({ error: "로그인이 필요합니다." });
    return;
  }
  if (user.role !== "admin") {
    res.status(403).json({ error: "관리자 권한이 필요합니다." });
    return;
  }
  next();
};
