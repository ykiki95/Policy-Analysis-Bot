import {
  pgTable,
  serial,
  text,
  integer,
  boolean,
  jsonb,
  timestamp,
} from "drizzle-orm/pg-core";

export type SurveyUploadColumn = {
  name: string;
  mappedTo: string;
};

export const surveyUploadsTable = pgTable("survey_uploads", {
  id: serial("id").primaryKey(),
  userId: integer("user_id").notNull(),
  fileName: text("file_name").notNull(),
  description: text("description").notNull(),
  format: text("format").notNull(),
  rowCount: integer("row_count").notNull(),
  status: text("status").notNull(),
  appliedToPopulation: boolean("applied_to_population").notNull().default(false),
  columns: jsonb("columns").$type<SurveyUploadColumn[]>().notNull(),
  sampleRows: jsonb("sample_rows").$type<Record<string, string>[]>().notNull(),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export type SurveyUpload = typeof surveyUploadsTable.$inferSelect;
export type InsertSurveyUpload = typeof surveyUploadsTable.$inferInsert;
