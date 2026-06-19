/**
 * 데이터 백업을 GitHub에 자동으로 올리기 (automated DB backup → GitHub).
 *
 * 한 번의 명령으로:
 *   1) pg_dump 로 최신 DB 덤프 생성 (`db/backup/demos_full_dump.sql`)
 *   2) 민감정보(users.password_hash, public.session) 기본 마스킹/제외
 *   3) `github` 리모트로 백업 파일만 커밋 후 푸시
 *
 * 인증: 설정된 GitHub 연동(access token)을 런타임에 가져와 사용한다.
 *   - 토큰은 git config 에 저장하지 않고, 명령줄/로그에도 남기지 않는다.
 *   - GIT_ASKPASS 헬퍼를 통해 자식 git 프로세스에만 전달한다.
 *
 * 사용법:
 *   pnpm --filter @workspace/scripts run backup:db                # 마스킹 백업 + 푸시
 *   pnpm --filter @workspace/scripts run backup:db -- --with-secrets   # 민감정보 포함
 *   pnpm --filter @workspace/scripts run backup:db -- --dry-run        # 덤프만, 커밋/푸시 X
 *   pnpm --filter @workspace/scripts run backup:db -- --no-push        # 커밋만, 푸시 X
 *
 * 환경변수:
 *   DATABASE_URL                필수. 덤프 대상 DB.
 *   BACKUP_REMOTE               푸시 리모트 이름 (기본: github)
 *   BACKUP_BRANCH               푸시 대상 브랜치 (기본: 현재 브랜치)
 *   REPLIT_CONNECTORS_HOSTNAME / REPL_IDENTITY / WEB_REPL_RENEWAL
 *                               Replit 이 자동 주입 — GitHub 연동 토큰 조회에 사용.
 */
import { spawnSync } from "node:child_process";
import { mkdtempSync, rmSync, writeFileSync, mkdirSync, chmodSync } from "node:fs";
import { tmpdir } from "node:os";
import { join, dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = resolve(__dirname, "..", "..");
const BACKUP_REL = "db/backup/demos_full_dump.sql";
const BACKUP_ABS = join(REPO_ROOT, BACKUP_REL);

const SENSITIVE_TABLE = "public.session";
const MASK_PLACEHOLDER = "***MASKED***";

interface Options {
  withSecrets: boolean;
  dryRun: boolean;
  noPush: boolean;
}

function parseArgs(argv: string[]): Options {
  const opts: Options = { withSecrets: false, dryRun: false, noPush: false };
  for (const arg of argv) {
    switch (arg) {
      case "--":
        // pnpm 이 인자 구분자를 그대로 전달하는 경우 무시.
        break;
      case "--with-secrets":
        opts.withSecrets = true;
        break;
      case "--dry-run":
        opts.dryRun = true;
        break;
      case "--no-push":
        opts.noPush = true;
        break;
      case "--help":
      case "-h":
        printHelpAndExit();
        break;
      default:
        console.error(`알 수 없는 인자: ${arg}`);
        printHelpAndExit(1);
    }
  }
  return opts;
}

function printHelpAndExit(code = 0): never {
  console.log(
    [
      "사용법: backup:db [--with-secrets] [--dry-run] [--no-push]",
      "",
      "  --with-secrets   민감정보(password_hash, session 데이터)를 마스킹하지 않고 포함",
      "  --dry-run        덤프 파일만 생성. git add/commit/push 건너뜀",
      "  --no-push        커밋까지만. 푸시 건너뜀",
    ].join("\n"),
  );
  process.exit(code);
}

function run(
  cmd: string,
  args: string[],
  extra: { env?: NodeJS.ProcessEnv; cwd?: string; maxBuffer?: number } = {},
): { stdout: string; stderr: string; status: number } {
  const res = spawnSync(cmd, args, {
    cwd: extra.cwd ?? REPO_ROOT,
    env: extra.env ?? process.env,
    encoding: "utf8",
    maxBuffer: extra.maxBuffer ?? 1024 * 1024 * 256,
  });
  if (res.error) {
    throw new Error(`'${cmd}' 실행 실패: ${res.error.message}`);
  }
  return {
    stdout: res.stdout ?? "",
    stderr: res.stderr ?? "",
    status: res.status ?? 1,
  };
}

/**
 * pg_dump 로 전체 DB 덤프를 만든다. 기본적으로 session 테이블의 *데이터*는
 * 제외하고(스키마는 유지), withSecrets 일 때만 포함한다.
 */
function generateDump(databaseUrl: string, withSecrets: boolean): string {
  const args = [
    "--no-owner",
    "--no-privileges",
    "--no-acl",
    databaseUrl,
  ];
  if (!withSecrets) {
    // 세션 데이터 제외 (스키마는 유지). password_hash 는 후처리로 마스킹.
    args.unshift(`--exclude-table-data=${SENSITIVE_TABLE}`);
  }
  const res = run("pg_dump", args);
  if (res.status !== 0) {
    throw new Error(`pg_dump 실패 (status ${res.status}):\n${res.stderr}`);
  }
  if (!res.stdout.includes("PostgreSQL database dump")) {
    throw new Error("pg_dump 출력이 예상과 다릅니다 (덤프 헤더 없음).");
  }
  return res.stdout;
}

/**
 * users COPY 블록에서 password_hash 컬럼 값을 마스킹한다.
 * COPY 헤더의 컬럼 목록을 파싱해 인덱스를 찾으므로 컬럼 순서 변경에 안전하다.
 */
function maskPasswordHash(dump: string): string {
  const lines = dump.split("\n");
  const headerRe = /^COPY public\.users \(([^)]*)\) FROM stdin;$/;
  let i = 0;
  for (; i < lines.length; i++) {
    const m = lines[i].match(headerRe);
    if (!m) continue;
    const cols = m[1].split(",").map((c) => c.trim());
    const idx = cols.indexOf("password_hash");
    if (idx === -1) {
      // 컬럼이 없으면 마스킹할 것도 없음.
      return dump;
    }
    let masked = 0;
    for (let j = i + 1; j < lines.length; j++) {
      if (lines[j] === "\\.") break;
      const fields = lines[j].split("\t");
      if (idx < fields.length && fields[idx] !== "\\N") {
        fields[idx] = MASK_PLACEHOLDER;
        lines[j] = fields.join("\t");
        masked++;
      }
    }
    console.log(`  password_hash ${masked}건 마스킹 완료`);
    return lines.join("\n");
  }
  // users 데이터가 없으면 그대로.
  return dump;
}

/**
 * GitHub 연동 access token 을 Replit connectors 프록시에서 런타임 조회.
 * 토큰은 메모리에만 두고 디스크/로그/ git config 에 남기지 않는다.
 */
async function fetchGithubToken(): Promise<string> {
  const hostname = process.env.REPLIT_CONNECTORS_HOSTNAME;
  if (!hostname) {
    throw new Error(
      "REPLIT_CONNECTORS_HOSTNAME 가 없습니다. GitHub 연동 토큰을 조회할 수 없습니다.",
    );
  }
  const xReplitToken = process.env.REPL_IDENTITY
    ? "repl " + process.env.REPL_IDENTITY
    : process.env.WEB_REPL_RENEWAL
      ? "depl " + process.env.WEB_REPL_RENEWAL
      : null;
  if (!xReplitToken) {
    throw new Error(
      "REPL_IDENTITY / WEB_REPL_RENEWAL 가 없습니다. 인증 컨텍스트가 없습니다.",
    );
  }
  const url = `https://${hostname}/api/v2/connection?include_secrets=true&connector_names=github`;
  const resp = await fetch(url, {
    headers: { Accept: "application/json", X_REPLIT_TOKEN: xReplitToken },
  });
  if (!resp.ok) {
    throw new Error(
      `GitHub 연동 조회 실패 (HTTP ${resp.status}). 연동이 연결되어 있는지 확인하세요.`,
    );
  }
  const data: any = await resp.json();
  const settings = data?.items?.[0]?.settings ?? {};
  const token =
    settings.access_token ?? settings.oauth?.credentials?.access_token ?? null;
  if (!token) {
    throw new Error(
      "GitHub access token 을 찾을 수 없습니다. 연동을 다시 연결해야 할 수 있습니다.",
    );
  }
  return token;
}

/** 현재 체크아웃된 브랜치 이름. */
function currentBranch(): string {
  const res = run("git", ["rev-parse", "--abbrev-ref", "HEAD"]);
  if (res.status !== 0) {
    throw new Error(`현재 브랜치 확인 실패:\n${res.stderr}`);
  }
  return res.stdout.trim();
}

/** 백업 파일만 스테이징 후, 변경이 있을 때만 커밋. 커밋 여부 반환. */
function stageAndCommit(dryRun: boolean): boolean {
  const add = run("git", ["add", "--", BACKUP_REL]);
  if (add.status !== 0) {
    throw new Error(`git add 실패:\n${add.stderr}`);
  }
  // 백업 파일에 스테이징된 변경이 있는지 확인.
  const diff = run("git", ["diff", "--cached", "--quiet", "--", BACKUP_REL]);
  if (diff.status === 0) {
    console.log("변경된 백업 데이터가 없습니다. 커밋/푸시를 건너뜁니다.");
    return false;
  }
  if (dryRun) {
    console.log("[dry-run] 변경 감지됨. 커밋/푸시는 생략합니다.");
    return false;
  }
  const stamp = new Date().toISOString();
  const commit = run("git", [
    "commit",
    "-m",
    `chore(db): automated backup ${stamp}`,
    "--",
    BACKUP_REL,
  ]);
  if (commit.status !== 0) {
    throw new Error(`git commit 실패:\n${commit.stderr || commit.stdout}`);
  }
  console.log(`커밋 완료: automated backup ${stamp}`);
  return true;
}

/**
 * GIT_ASKPASS 헬퍼를 통해 토큰을 자식 git 프로세스에만 전달하여 푸시한다.
 * 토큰은 리모트 URL/명령줄/ git config 어디에도 기록되지 않는다.
 */
function pushWithToken(remote: string, branch: string, token: string): void {
  const askpassDir = mkdtempSync(join(tmpdir(), "git-askpass-"));
  const askpassPath = join(askpassDir, "askpass.sh");
  try {
    // git 은 username, 그다음 password 를 묻는다. username 은 고정, password 는 토큰.
    writeFileSync(
      askpassPath,
      [
        "#!/bin/sh",
        'case "$1" in',
        '  Username*) printf "%s" "x-access-token" ;;',
        '  *) printf "%s" "$GIT_BACKUP_TOKEN" ;;',
        "esac",
        "",
      ].join("\n"),
      { mode: 0o700 },
    );
    chmodSync(askpassPath, 0o700);

    const env: NodeJS.ProcessEnv = {
      ...process.env,
      GIT_ASKPASS: askpassPath,
      GIT_BACKUP_TOKEN: token,
      GIT_TERMINAL_PROMPT: "0",
    };
    const res = run("git", ["push", remote, `HEAD:${branch}`], { env });
    if (res.status !== 0) {
      // 토큰이 노출되지 않도록 stderr 를 그대로 출력 (git 은 비밀번호를 로그하지 않음).
      throw new Error(`git push 실패:\n${res.stderr || res.stdout}`);
    }
    console.log(`푸시 완료 → ${remote} ${branch}`);
  } finally {
    rmSync(askpassDir, { recursive: true, force: true });
  }
}

async function main(): Promise<void> {
  const opts = parseArgs(process.argv.slice(2));

  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    throw new Error("DATABASE_URL 환경변수가 필요합니다.");
  }

  console.log(
    `DB 덤프 생성 중... (민감정보 ${opts.withSecrets ? "포함" : "마스킹/제외"})`,
  );
  let dump = generateDump(databaseUrl, opts.withSecrets);
  if (!opts.withSecrets) {
    dump = maskPasswordHash(dump);
  }

  mkdirSync(dirname(BACKUP_ABS), { recursive: true });
  writeFileSync(BACKUP_ABS, dump, "utf8");
  console.log(
    `덤프 작성 완료: ${BACKUP_REL} (${(dump.length / 1024).toFixed(0)} KB)`,
  );

  const committed = stageAndCommit(opts.dryRun);
  if (!committed || opts.noPush) {
    if (opts.noPush && committed) console.log("--no-push: 푸시를 건너뜁니다.");
    return;
  }

  const remote = process.env.BACKUP_REMOTE || "github";
  const branch = process.env.BACKUP_BRANCH || currentBranch();
  const token = await fetchGithubToken();
  pushWithToken(remote, branch, token);
}

main().catch((err) => {
  console.error(`백업 실패: ${err instanceof Error ? err.message : String(err)}`);
  process.exit(1);
});
