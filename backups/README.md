# 데이터베이스 백업

`database_dump.sql` — DEMOS PostgreSQL 데이터베이스의 스키마 + 데이터 전체 덤프입니다.

- `pg_dump --no-owner --no-privileges --clean --if-exists` 로 생성.
- 로그인 세션 테이블(`session`)의 **데이터는 제외**(스키마는 포함)합니다 — 세션 쿠키는 백업 대상이 아닙니다.
- 환경 변수/시크릿(`DATABASE_URL`, `SESSION_SECRET`, `DATA_GO_KR_API_KEY` 등)은 덤프에 포함되지 않습니다.

## 복원 방법

```bash
psql "$DATABASE_URL" -f backups/database_dump.sql
```

`--clean --if-exists` 옵션으로 생성되어 기존 테이블을 먼저 DROP 후 재생성합니다.
빈 데이터베이스 또는 덮어써도 되는 데이터베이스에만 적용하세요.

## 재생성 방법

```bash
pg_dump "$DATABASE_URL" --no-owner --no-privileges --clean --if-exists \
  --exclude-table-data='session' -f backups/database_dump.sql
```
