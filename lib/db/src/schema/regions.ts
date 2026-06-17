import { pgTable, text, integer, doublePrecision } from "drizzle-orm/pg-core";

export const regionsTable = pgTable("regions", {
  code: text("code").primaryKey(),
  name: text("name").notNull(),
  lat: doublePrecision("lat").notNull(),
  lng: doublePrecision("lng").notNull(),
  leaningBias: integer("leaning_bias").notNull(),
  macroRegion: text("macro_region").notNull(),
  displayOrder: integer("display_order").notNull(),
});

export type Region = typeof regionsTable.$inferSelect;
export type InsertRegion = typeof regionsTable.$inferInsert;
