import { pgTable, serial, text, integer } from "drizzle-orm/pg-core";

export const dataSourcesTable = pgTable("data_sources", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  agency: text("agency").notNull(),
  category: text("category").notNull(),
  contributesTo: text("contributes_to").notNull(),
  recordCount: integer("record_count").notNull(),
  coverage: text("coverage").notNull(),
  referenceYear: text("reference_year").notNull(),
  sourceUrl: text("source_url").notNull(),
});

export type DataSource = typeof dataSourcesTable.$inferSelect;
export type InsertDataSource = typeof dataSourcesTable.$inferInsert;
