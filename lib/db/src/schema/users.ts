import {
  pgTable,
  serial,
  text,
  timestamp,
  doublePrecision,
} from "drizzle-orm/pg-core";

/**
 * 상용화용 사용자 계정. 현재는 아이디(username)/비밀번호 기반이며, 향후 username을
 * 이메일로 전환할 예정이다. `role`은 "user" | "admin" — admin만 관리자 메뉴/라우트에
 * 접근할 수 있다. 비밀번호는 bcrypt 해시(`passwordHash`)로만 저장한다.
 * `budgetLimitUsd`는 계정별 LLM 지출 한도(실제 USD). 화면 표시는 ×10.
 */
export const usersTable = pgTable("users", {
  id: serial("id").primaryKey(),
  username: text("username").notNull().unique(),
  name: text("name").notNull(),
  birthDate: text("birth_date"),
  // 프로필 아바타 프리셋 키(예: "av1"). null 이면 프런트에서 id 기반 기본 아바타 표시.
  avatar: text("avatar"),
  passwordHash: text("password_hash").notNull(),
  role: text("role").notNull().default("user"),
  // LLM 지출 한도(실제 USD). 화면 표시는 ×10 (기본 $1 실비 = 화면 $10).
  budgetLimitUsd: doublePrecision("budget_limit_usd").notNull().default(1),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export type User = typeof usersTable.$inferSelect;
export type InsertUser = typeof usersTable.$inferInsert;
