# 데이터베이스 덤프 (스키마 + 데이터)

`demos_dump.sql` 은 DEMOS 앱 PostgreSQL DB의 **스키마 + 전체 데이터**(합성 시민, 시뮬레이션, 설문, 보정 등 샘플 데이터 포함) 덤프입니다.

- 생성: `pg_dump "$DATABASE_URL" --no-owner --no-privileges --clean --if-exists`
- PostgreSQL 16 기준.

## 복원 방법

새 빈 데이터베이스에 복원하려면:

```bash
psql "$DATABASE_URL" -f database/demos_dump.sql
```

`--clean --if-exists` 옵션으로 덤프됐기 때문에, 기존 동일 테이블이 있으면 **먼저 DROP 후 재생성**합니다. 기존 데이터를 덮어쓰므로 주의하세요.

## 참고

- 앱 코드만으로도 스키마는 `pnpm --filter @workspace/db run push` 로 만들 수 있고, 합성 인구·설문 등 샘플 데이터는 시드 로직(`agentGenerator`, `scripts/`)으로 재생성할 수 있습니다.
- 이 덤프는 "현재 시점의 실제 데이터 스냅샷"이 필요할 때(백업/이전/리뷰용) 사용하세요.
