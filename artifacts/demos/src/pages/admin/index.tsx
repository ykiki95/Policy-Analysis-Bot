import { useState, useEffect, useMemo } from "react";
import { useQueryClient } from "@tanstack/react-query";
import {
  useGetAgentSummary,
  useListDataSources,
  useListRegions,
  useListDemographicMargins,
  useRegeneratePopulation,
  useListSurveyUploads,
  useCreateSurveyUpload,
  useGetCalibrationSettings,
  useUpdateCalibrationSettings,
  useListCalibrations,
  useCreateCalibration,
  useDeleteCalibration,
  useListSurveys,
  useCreateSurvey,
  useDeleteSurvey,
  useSetSurveyApplied,
  useSuggestSurveyDrivers,
  useGetSurveyImpact,
  useListElectionSources,
  useImportElection,
  useListAdminAccounts,
  useUpdateAccountBudget,
  getListCalibrationsQueryKey,
  getListSurveysQueryKey,
  getGetSurveyImpactQueryKey,
  getListAdminAccountsQueryKey,
  type SurveyUploadColumn,
  type SurveyDriver,
  type Calibration,
  type CalibrationInput,
  type CalibrationInputProduct,
  type ElectionSource,
  type AdminAccount,
} from "@workspace/api-client-react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Slider } from "@/components/ui/slider";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Switch } from "@/components/ui/switch";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription,
  AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import { useToast } from "@/hooks/use-toast";
import { Users, Database, Upload, SlidersHorizontal, ExternalLink, FileSpreadsheet, Loader2, Download, Plus, Trash2, CheckCircle2, Sparkles, TrendingUp, Pencil, RotateCcw, Vote, Wallet } from "lucide-react";
import { useAuth } from "@/hooks/use-auth";

const CALIBRATION_METHODS = [
  "베이지안 축소 (Bayesian Shrinkage)",
  "사후 층화 가중 (Post-stratification)",
  "레이킹 (Iterative Proportional Fitting)",
  "회귀 보정 (Regression Calibration)",
];

const METHOD_DESCRIPTIONS: Record<string, string> = {
  "베이지안 축소 (Bayesian Shrinkage)":
    "원시 예측을 과거 벤치마크(사전 분포) 쪽으로 일정 비율 당겨, 표본이 적거나 변동이 큰 예측의 과신을 줄입니다. 축소 계수가 클수록 벤치마크에 더 가까워집니다.",
  "사후 층화 가중 (Post-stratification)":
    "응답을 자치구·연령·성별 등 인구 셀로 나눈 뒤, 각 셀을 실제 인구 비율에 맞게 가중합니다. 특정 집단이 과대·과소 대표될 때 전체 추정의 편향을 보정합니다.",
  "레이킹 (Iterative Proportional Fitting)":
    "여러 인구 변수의 주변 분포(예: 연령별·성별 합계)에 동시에 맞도록 가중치를 반복 조정합니다. 셀별 목표값을 모를 때 주변 합만으로 보정할 수 있습니다.",
  "회귀 보정 (Regression Calibration)":
    "과거 예측값과 실제값의 관계를 회귀모형으로 학습해, 새 예측에 체계적 오차(편향·기울기)를 보정 적용합니다. 일관된 과대·과소 예측 경향을 교정하는 데 적합합니다.",
};

const EVENT_TYPE_OPTIONS = ["선거", "정책 반응", "여론조사", "제품 반응", "기타"];

const CALIBRATION_PRODUCT_OPTIONS: { value: CalibrationInputProduct; label: string }[] = [
  { value: "Dynamo", label: "정치" },
  { value: "Lumen", label: "비즈니스" },
  { value: "Seraph", label: "정부" },
];

/** 제품(내부 브랜드값) → 도메인 표시 라벨(비즈니스/정부/정치). */
function productDomainLabel(product: string): string {
  return product === "Lumen" ? "비즈니스" : product === "Seraph" ? "정부" : "정치";
}

const DEFAULT_CALIBRATION_SETTINGS = {
  method: "베이지안 축소 (Bayesian Shrinkage)",
  benchmarkWeight: 0.6,
  recencyWeight: 0.3,
  shrinkageFactor: 0.4,
  outlierTrimPct: 5,
  description:
    "과거 가상 이벤트 벤치마크에 가중치를 두고, 최근 데이터에 더 큰 비중을 부여하여 원시 예측을 보정합니다.",
};

const SAMPLE_COLUMNS = [
  { name: "respondent_id", desc: "응답자 식별자" },
  { name: "district", desc: "자치구 (예: 강남구)" },
  { name: "age_group", desc: "연령대 (예: 30-39)" },
  { name: "gender", desc: "성별 (남성/여성)" },
  { name: "question", desc: "설문 문항" },
  { name: "answer", desc: "응답값 (예: 찬성/반대/중립 또는 점수)" },
  { name: "weight", desc: "가중치 (선택, 기본 1)" },
];

const SAMPLE_ROWS = [
  { respondent_id: "R0001", district: "강남구", age_group: "30-39", gender: "여성", question: "주 4일제 도입 찬반", answer: "찬성", weight: "1.0" },
  { respondent_id: "R0002", district: "은평구", age_group: "50-59", gender: "남성", question: "주 4일제 도입 찬반", answer: "반대", weight: "1.2" },
  { respondent_id: "R0003", district: "마포구", age_group: "18-29", gender: "여성", question: "주 4일제 도입 찬반", answer: "중립", weight: "0.9" },
];

function downloadFile(name: string, content: string, type: string) {
  const blob = new Blob([content], { type });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = name;
  a.click();
  URL.revokeObjectURL(url);
}

function parseUpload(text: string, fileName: string): { format: string; columns: string[]; rows: Record<string, string>[] } | null {
  const trimmed = text.trim();
  if (!trimmed) return null;
  if (fileName.endsWith(".json") || trimmed.startsWith("[") || trimmed.startsWith("{")) {
    try {
      const parsed = JSON.parse(trimmed);
      const arr = Array.isArray(parsed) ? parsed : [parsed];
      if (arr.length === 0) return null;
      const columns = Object.keys(arr[0]);
      const rows = arr.map((r: Record<string, unknown>) => {
        const o: Record<string, string> = {};
        for (const c of columns) o[c] = String(r[c] ?? "");
        return o;
      });
      return { format: "JSON", columns, rows };
    } catch {
      return null;
    }
  }
  const lines = trimmed.split(/\r?\n/).filter((l) => l.length > 0);
  if (lines.length < 2) return null;
  const columns = lines[0].split(",").map((c) => c.trim());
  const rows = lines.slice(1).map((line) => {
    const cells = line.split(",");
    const o: Record<string, string> = {};
    columns.forEach((c, i) => { o[c] = (cells[i] ?? "").trim(); });
    return o;
  });
  return { format: "CSV", columns, rows };
}

function ElectionImportSection({
  sources,
  isPending,
  onImport,
}: {
  sources: ElectionSource[];
  isPending: boolean;
  onImport: (sgId: string) => void | Promise<void>;
}) {
  const [selected, setSelected] = useState<string>("");
  const effective = selected || sources[0]?.sgId || "";

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Vote className="h-5 w-5 text-primary" />
          실제 선거 데이터 연동 (data.go.kr)
        </CardTitle>
        <CardDescription>
          중앙선거관리위원회 공공데이터(투·개표 정보 API)에서 실제 시·도별 보수 후보 득표율을
          불러와 선거 검증의 기준값(ground truth)을 채웁니다. 불러온 선거가 기존 기준 데이터를
          교체하며, 선거 검증 화면에 즉시 반영됩니다.
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="flex flex-col sm:flex-row gap-3 sm:items-end">
          <div className="space-y-1.5 flex-1">
            <Label className="text-xs">선거 선택</Label>
            <Select value={effective} onValueChange={setSelected}>
              <SelectTrigger>
                <SelectValue placeholder="선거를 선택하세요" />
              </SelectTrigger>
              <SelectContent>
                {sources.map((s) => (
                  <SelectItem key={s.sgId} value={s.sgId}>
                    {s.name} ({s.electionDate})
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <Button
            onClick={() => effective && onImport(effective)}
            disabled={!effective || isPending}
            className="sm:w-auto"
          >
            {isPending ? (
              <Loader2 className="h-4 w-4 mr-1.5 animate-spin" />
            ) : (
              <Download className="h-4 w-4 mr-1.5" />
            )}
            실제 결과 불러오기
          </Button>
        </div>
        <p className="text-xs text-muted-foreground leading-relaxed">
          출처: 중앙선거관리위원회 · 공공데이터포털(data.go.kr). 보수 후보 = 국민의힘 후보 기준
          (제20대 윤석열 / 제21대 김문수). 시·도별 득표율 = 후보 득표수 ÷ 유효투표수.
        </p>
      </CardContent>
    </Card>
  );
}

function AccountRow({ account }: { account: AdminAccount }) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const updateBudget = useUpdateAccountBudget();
  const [editing, setEditing] = useState(false);
  const [value, setValue] = useState(String(account.budgetLimitUsd));

  const save = async () => {
    const next = Number(value);
    if (!Number.isFinite(next) || next < 0) {
      toast({ title: "올바른 금액을 입력하세요", variant: "destructive" });
      return;
    }
    try {
      await updateBudget.mutateAsync({ id: account.id, data: { budgetLimitUsd: next } });
      await queryClient.invalidateQueries({ queryKey: getListAdminAccountsQueryKey() });
      toast({ title: "한도 변경 완료", description: `${account.name}의 예산 한도를 $${next.toFixed(2)}로 설정했습니다.` });
      setEditing(false);
    } catch {
      toast({ title: "한도 변경 실패", description: "잠시 후 다시 시도해 주세요.", variant: "destructive" });
    }
  };

  return (
    <TableRow>
      <TableCell>
        <div className="flex flex-col">
          <span className="font-medium">{account.name}</span>
          <span className="text-xs text-muted-foreground">@{account.username}</span>
        </div>
      </TableCell>
      <TableCell>
        {account.role === "admin" ? (
          <Badge variant="secondary">관리자</Badge>
        ) : (
          <Badge variant="outline">사용자</Badge>
        )}
      </TableCell>
      <TableCell className="tabular-nums">
        {editing ? (
          <div className="flex items-center gap-2">
            <Input
              type="number"
              min={0}
              step="0.01"
              value={value}
              onChange={(e) => setValue(e.target.value)}
              className="w-28 h-8"
            />
            <Button size="sm" onClick={save} disabled={updateBudget.isPending}>
              {updateBudget.isPending && <Loader2 className="h-3.5 w-3.5 mr-1 animate-spin" />}
              저장
            </Button>
            <Button size="sm" variant="ghost" onClick={() => { setEditing(false); setValue(String(account.budgetLimitUsd)); }}>
              취소
            </Button>
          </div>
        ) : (
          <div className="flex items-center gap-2">
            <span>${account.budgetLimitUsd.toFixed(2)}</span>
            <Button size="sm" variant="ghost" onClick={() => setEditing(true)}>
              <Pencil className="h-3.5 w-3.5" />
            </Button>
          </div>
        )}
      </TableCell>
      <TableCell className="tabular-nums text-muted-foreground">${account.spentUsd.toFixed(2)}</TableCell>
      <TableCell className="tabular-nums font-medium">${account.remainingUsd.toFixed(2)}</TableCell>
    </TableRow>
  );
}

function AccountsSection() {
  const { data: accounts, isLoading } = useListAdminAccounts();

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Wallet className="h-5 w-5 text-primary" />
          계정 및 예산 관리
        </CardTitle>
        <CardDescription>
          모든 계정의 예산 한도와 누적 사용액을 관리합니다. 모든 금액은 화면 표시 금액(실비 ×10)
          기준입니다. 상단의 계정 전환기로 각 계정의 데이터를 직접 조회할 수 있습니다.
        </CardDescription>
      </CardHeader>
      <CardContent>
        {isLoading || !accounts ? (
          <Skeleton className="h-40 w-full" />
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>계정</TableHead>
                <TableHead>역할</TableHead>
                <TableHead>예산 한도</TableHead>
                <TableHead>누적 사용</TableHead>
                <TableHead>잔여</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {accounts.map((a) => (
                <AccountRow key={a.id} account={a} />
              ))}
            </TableBody>
          </Table>
        )}
      </CardContent>
    </Card>
  );
}

export default function Admin() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const { isAdmin } = useAuth();

  const { data: summary } = useGetAgentSummary();
  const { data: dataSources, isLoading: dsLoading } = useListDataSources();
  const { data: regions } = useListRegions();
  const { data: margins } = useListDemographicMargins();
  const { data: uploads } = useListSurveyUploads();
  const { data: calibration, isLoading: calLoading } = useGetCalibrationSettings();
  const { data: calibrationEvents, isLoading: eventsLoading } = useListCalibrations();

  const { data: electionSources } = useListElectionSources();
  const regenerate = useRegeneratePopulation();
  const createUpload = useCreateSurveyUpload();
  const updateCalibration = useUpdateCalibrationSettings();
  const createEvent = useCreateCalibration();
  const deleteEvent = useDeleteCalibration();
  const importElection = useImportElection();

  const [count, setCount] = useState(500);
  const [regionScope, setRegionScope] = useState("NATIONAL");
  useEffect(() => {
    if (summary?.total) setCount(summary.total);
  }, [summary?.total]);

  const scopeName =
    regionScope === "NATIONAL"
      ? "전국"
      : (regions?.find((r) => r.code === regionScope)?.name ?? regionScope);

  const handleRegenerate = async () => {
    try {
      await regenerate.mutateAsync({ data: { count, regionScope } });
      await queryClient.invalidateQueries();
      toast({ title: "인구 재생성 완료", description: `${scopeName} 합성 시민 ${count.toLocaleString()}명을 생성했습니다.` });
    } catch {
      toast({ title: "재생성 실패", description: "잠시 후 다시 시도해 주세요.", variant: "destructive" });
    }
  };

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">{isAdmin ? "관리자" : "설정"}</h1>
        <p className="text-muted-foreground mt-1">
          {isAdmin
            ? "합성 인구 구성, 데이터 출처, 설문 기준, 보정 방법, 계정 예산을 관리합니다."
            : "내 합성 인구 구성, 설문 업로드, 보정 방법, 검증 이벤트를 직접 관리합니다."}
        </p>
      </div>

      <Tabs defaultValue="population">
        <TabsList className={`grid w-full grid-cols-2 ${isAdmin ? "md:grid-cols-6" : "md:grid-cols-5"}`}>
          <TabsTrigger value="population"><Users className="h-4 w-4 mr-1.5" />인구 구성</TabsTrigger>
          <TabsTrigger value="sources"><Database className="h-4 w-4 mr-1.5" />데이터 출처</TabsTrigger>
          <TabsTrigger value="surveys"><Upload className="h-4 w-4 mr-1.5" />설문 업로드</TabsTrigger>
          <TabsTrigger value="calibration"><SlidersHorizontal className="h-4 w-4 mr-1.5" />보정 설정</TabsTrigger>
          <TabsTrigger value="events"><CheckCircle2 className="h-4 w-4 mr-1.5" />검증 이벤트</TabsTrigger>
          {isAdmin && <TabsTrigger value="accounts"><Wallet className="h-4 w-4 mr-1.5" />계정 관리</TabsTrigger>}
        </TabsList>

        <TabsContent value="population" className="mt-6">
          <Card>
            <CardHeader>
              <CardTitle>합성 인구 규모</CardTitle>
              <CardDescription>
                에이전트 수를 조정하면 공공 통계 분포에 따라 인구가 결정적으로 재생성됩니다. 기존 시뮬레이션 결과는 보존됩니다.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="flex items-center gap-4">
                <div className="text-sm text-muted-foreground">현재 인구</div>
                <div className="text-2xl font-bold">{summary?.total?.toLocaleString() ?? "—"}명</div>
              </div>
              <div className="space-y-2">
                <Label>생성 범위 (시·도)</Label>
                <Select value={regionScope} onValueChange={setRegionScope}>
                  <SelectTrigger className="w-full md:w-72">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent position="popper" side="bottom" sideOffset={4} avoidCollisions={false}>
                    <SelectItem value="NATIONAL">전국 (17개 시·도)</SelectItem>
                    {regions?.map((r) => (
                      <SelectItem key={r.code} value={r.code}>{r.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                <p className="text-xs text-muted-foreground">
                  특정 시·도를 선택하면 해당 지역에 한정해 합성 인구를 생성합니다. 연령·성별 분포는 공공 통계 마진에 맞춰 래킹됩니다.
                </p>
              </div>
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <Label>목표 에이전트 수</Label>
                  <span className="text-lg font-semibold tabular-nums">{count.toLocaleString()}명</span>
                </div>
                <Slider
                  min={50}
                  max={5000}
                  step={50}
                  value={[count]}
                  onValueChange={(v) => setCount(v[0])}
                />
                <div className="flex items-center justify-between text-xs text-muted-foreground">
                  <span>50명</span>
                  <span>5,000명</span>
                </div>
                <div className="flex items-center gap-3">
                  <Input
                    type="number"
                    min={50}
                    max={5000}
                    value={count}
                    onChange={(e) => setCount(Math.min(5000, Math.max(50, Number(e.target.value) || 50)))}
                    className="w-32"
                  />
                  <span className="text-xs text-muted-foreground">50 ~ 5,000명 범위</span>
                </div>
              </div>
              <AlertDialog>
                <AlertDialogTrigger asChild>
                  <Button disabled={regenerate.isPending}>
                    {regenerate.isPending && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
                    인구 재생성
                  </Button>
                </AlertDialogTrigger>
                <AlertDialogContent>
                  <AlertDialogHeader>
                    <AlertDialogTitle>인구를 재생성하시겠습니까?</AlertDialogTitle>
                    <AlertDialogDescription>
                      기존 {summary?.total?.toLocaleString()}명의 에이전트가 <strong>{scopeName}</strong> 범위의 {count.toLocaleString()}명으로 교체됩니다.
                      이 작업은 되돌릴 수 없으며, 새 시뮬레이션은 새 인구를 대상으로 실행됩니다.
                    </AlertDialogDescription>
                  </AlertDialogHeader>
                  <AlertDialogFooter>
                    <AlertDialogCancel>취소</AlertDialogCancel>
                    <AlertDialogAction onClick={handleRegenerate}>재생성</AlertDialogAction>
                  </AlertDialogFooter>
                </AlertDialogContent>
              </AlertDialog>
            </CardContent>
          </Card>

          <Card className="mt-6">
            <CardHeader>
              <CardTitle>공공 통계 마진 (래킹 타깃)</CardTitle>
              <CardDescription>
                지역·연령·성별 공식 인구 분포를 타깃으로 IPF(반복 비례 적합) 래킹하여 합성 인구의 교차 분포를 결정합니다.
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid md:grid-cols-3 gap-6">
                {(["region", "age", "gender"] as const).map((dim) => {
                  const dimRows = (margins ?? []).filter((m) => m.dimension === dim);
                  const dimTotal = dimRows.reduce((s, m) => s + m.population, 0) || 1;
                  const title = dim === "region" ? "지역 (17개 시·도)" : dim === "age" ? "연령대" : "성별";
                  return (
                    <div key={dim} className="space-y-2">
                      <div className="text-sm font-semibold">{title}</div>
                      <div className="space-y-1.5">
                        {dimRows.map((m) => {
                          const pct = (m.population / dimTotal) * 100;
                          return (
                            <div key={m.id} className="text-xs">
                              <div className="flex justify-between">
                                <span className="text-muted-foreground">{m.label}</span>
                                <span className="tabular-nums">{pct.toFixed(1)}%</span>
                              </div>
                              <div className="h-1.5 bg-border rounded-full overflow-hidden">
                                <div className="h-full bg-primary" style={{ width: `${pct}%` }} />
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  );
                })}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="sources" className="mt-6">
          <Card>
            <CardHeader>
              <CardTitle>공공 데이터 출처</CardTitle>
              <CardDescription>합성 인구의 인구통계·정치성향·미디어 이용 분포는 다음 공개 데이터에 근거합니다.</CardDescription>
            </CardHeader>
            <CardContent>
              {dsLoading ? (
                <div className="space-y-3"><Skeleton className="h-10 w-full" /><Skeleton className="h-10 w-full" /><Skeleton className="h-10 w-full" /></div>
              ) : (
                <div className="border rounded-md overflow-x-auto">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>데이터셋</TableHead>
                        <TableHead>기관</TableHead>
                        <TableHead>반영 항목</TableHead>
                        <TableHead className="text-right">표본/건수</TableHead>
                        <TableHead>기준연도</TableHead>
                        <TableHead></TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {dataSources?.map((ds) => (
                        <TableRow key={ds.id}>
                          <TableCell className="font-medium">
                            {ds.name}
                            <div className="text-xs text-muted-foreground">{ds.category} · {ds.coverage}</div>
                          </TableCell>
                          <TableCell>{ds.agency}</TableCell>
                          <TableCell className="text-sm">{ds.contributesTo}</TableCell>
                          <TableCell className="text-right tabular-nums">{ds.recordCount.toLocaleString()}</TableCell>
                          <TableCell>{ds.referenceYear}</TableCell>
                          <TableCell>
                            <a href={ds.sourceUrl} target="_blank" rel="noreferrer" className="text-primary inline-flex items-center gap-1 text-xs">
                              출처 <ExternalLink className="h-3 w-3" />
                            </a>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="surveys" className="mt-6">
          <SurveyUploadSection
            uploads={uploads ?? []}
            onUpload={async (input) => {
              try {
                await createUpload.mutateAsync({ data: input });
                await queryClient.invalidateQueries();
                toast({ title: "설문 기준 업로드 완료", description: `${input.fileName} (${input.rowCount}행)이 등록되었습니다.` });
                return true;
              } catch {
                toast({ title: "업로드 실패", description: "파일 형식을 확인해 주세요.", variant: "destructive" });
                return false;
              }
            }}
            isPending={createUpload.isPending}
          />
        </TabsContent>

        <TabsContent value="calibration" className="mt-6 space-y-6">
          {isAdmin && (
            <ElectionImportSection
              sources={electionSources ?? []}
              isPending={importElection.isPending}
              onImport={async (sgId) => {
                try {
                  const result = await importElection.mutateAsync({ data: { sgId } });
                  await queryClient.invalidateQueries();
                  toast({
                    title: "실제 선거 데이터 연동 완료",
                    description: `${result.electionName} · ${result.metric} · ${result.imported}개 시·도 (출처: ${result.source})`,
                  });
                } catch {
                  toast({
                    title: "연동 실패",
                    description: "공공데이터포털 응답을 확인해 주세요. 활용신청 승인 상태가 필요할 수 있습니다.",
                    variant: "destructive",
                  });
                }
              }}
            />
          )}
          {calLoading || !calibration ? (
            <Card><CardContent className="py-10"><Skeleton className="h-40 w-full" /></CardContent></Card>
          ) : (
            <CalibrationSection
              initial={calibration}
              isPending={updateCalibration.isPending}
              onSave={async (input) => {
                try {
                  await updateCalibration.mutateAsync({ data: input });
                  await queryClient.invalidateQueries();
                  toast({ title: "보정 설정 저장 완료", description: "새 보정 방법이 검증에 반영됩니다." });
                } catch {
                  toast({ title: "저장 실패", description: "값을 확인해 주세요.", variant: "destructive" });
                }
              }}
            />
          )}
        </TabsContent>

        <TabsContent value="events" className="mt-6">
          <CalibrationEventsSection
            events={calibrationEvents ?? []}
            isLoading={eventsLoading}
            isCreating={createEvent.isPending}
            onCreate={async (input) => {
              try {
                await createEvent.mutateAsync({ data: input });
                await queryClient.invalidateQueries({ queryKey: getListCalibrationsQueryKey() });
                toast({ title: "검증 이벤트 추가됨", description: `${input.title} 이벤트가 등록되었습니다.` });
                return true;
              } catch {
                toast({ title: "추가 실패", description: "값을 확인해 주세요.", variant: "destructive" });
                return false;
              }
            }}
            onDelete={async (id) => {
              try {
                await deleteEvent.mutateAsync({ id });
                await queryClient.invalidateQueries({ queryKey: getListCalibrationsQueryKey() });
                toast({ title: "검증 이벤트 삭제됨" });
              } catch {
                toast({ title: "삭제 실패", description: "잠시 후 다시 시도해 주세요.", variant: "destructive" });
              }
            }}
          />
        </TabsContent>

        {isAdmin && (
          <TabsContent value="accounts" className="mt-6">
            <AccountsSection />
          </TabsContent>
        )}
      </Tabs>
    </div>
  );
}

type ParsedUpload = ReturnType<typeof parseUpload>;

const ISSUE_OPTIONS = ["경제", "복지", "안보", "환경", "주거"];

function DriverBuilder({
  drivers,
  setDrivers,
}: {
  drivers: SurveyDriver[];
  setDrivers: (d: SurveyDriver[]) => void;
}) {
  const update = (i: number, patch: Partial<SurveyDriver>) => {
    setDrivers(drivers.map((d, idx) => (idx === i ? { ...d, ...patch } : d)));
  };
  const remove = (i: number) => setDrivers(drivers.filter((_, idx) => idx !== i));
  const add = () =>
    setDrivers([...drivers, { factor: "", issue: "경제", weight: 0.5, direction: "" }]);

  return (
    <div className="space-y-3">
      {drivers.map((d, i) => (
        <div key={i} className="rounded-md border p-3 space-y-3 bg-muted/20">
          <div className="flex items-center justify-between">
            <span className="text-xs font-medium text-muted-foreground">동인 {i + 1}</span>
            <Button
              variant="ghost"
              size="sm"
              className="h-7 px-2 text-muted-foreground"
              onClick={() => remove(i)}
              disabled={drivers.length <= 1}
            >
              <Trash2 className="h-3.5 w-3.5" />
            </Button>
          </div>
          <div className="grid sm:grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <Label className="text-xs">이슈</Label>
              <Select value={d.issue} onValueChange={(v) => update(i, { issue: v })}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {ISSUE_OPTIONS.map((o) => <SelectItem key={o} value={o}>{o}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1.5">
              <Label className="text-xs">요인 (선택)</Label>
              <Input
                placeholder="예: 연령, 소득, 자치구"
                value={d.factor}
                onChange={(e) => update(i, { factor: e.target.value })}
              />
            </div>
          </div>
          <div className="space-y-1.5">
            <Label className="text-xs">방향 설명</Label>
            <Input
              placeholder="예: 고령일수록 복지 확대 지지"
              value={d.direction}
              onChange={(e) => update(i, { direction: e.target.value })}
            />
          </div>
          <div className="space-y-1.5">
            <div className="flex items-center justify-between">
              <Label className="text-xs">영향 강도 (가중치)</Label>
              <span className="text-xs font-semibold tabular-nums">{d.weight.toFixed(2)}</span>
            </div>
            <Slider
              min={0}
              max={1}
              step={0.05}
              value={[d.weight]}
              onValueChange={(v) => update(i, { weight: v[0] })}
            />
          </div>
        </div>
      ))}
      <Button variant="outline" size="sm" onClick={add}>
        <Plus className="h-4 w-4 mr-1.5" /> 동인 추가
      </Button>
    </div>
  );
}

function SurveyUploadSection({
  uploads,
  onUpload,
  isPending,
}: {
  uploads: { id: number; fileName: string; format: string; rowCount: number; description: string; status: string; createdAt: string }[];
  onUpload: (input: { fileName: string; description: string; format: string; rowCount: number; columns: SurveyUploadColumn[]; sampleRows: Record<string, string>[] }) => Promise<boolean>;
  isPending: boolean;
}) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const { data: surveys } = useListSurveys();
  const { data: impact } = useGetSurveyImpact();

  const createSurvey = useCreateSurvey();
  const deleteSurvey = useDeleteSurvey();
  const setApplied = useSetSurveyApplied();
  const suggestDrivers = useSuggestSurveyDrivers();

  const [fileName, setFileName] = useState("");
  const [description, setDescription] = useState("");
  const [parsed, setParsed] = useState<ParsedUpload>(null);
  const [error, setError] = useState("");

  const [draftSummary, setDraftSummary] = useState("");
  const [draftDrivers, setDraftDrivers] = useState<SurveyDriver[]>([]);
  const [draftTitle, setDraftTitle] = useState("");
  const [showDraft, setShowDraft] = useState(false);

  const [manualTitle, setManualTitle] = useState("");
  const [manualDescription, setManualDescription] = useState("");
  const [manualDrivers, setManualDrivers] = useState<SurveyDriver[]>([
    { factor: "", issue: "경제", weight: 0.5, direction: "" },
  ]);

  const invalidateAll = async () => {
    await queryClient.invalidateQueries({ queryKey: getListSurveysQueryKey() });
    await queryClient.invalidateQueries({ queryKey: getGetSurveyImpactQueryKey() });
  };

  const handleFile = async (file: File) => {
    setError("");
    setShowDraft(false);
    setFileName(file.name);
    const text = await file.text();
    const result = parseUpload(text, file.name);
    if (!result) {
      setError("CSV(헤더 포함) 또는 JSON 배열 형식만 지원합니다.");
      setParsed(null);
      return;
    }
    setParsed(result);
  };

  const handleSubmit = async () => {
    if (!parsed || !fileName) return;
    const ok = await onUpload({
      fileName,
      description,
      format: parsed.format,
      rowCount: parsed.rows.length,
      columns: parsed.columns.map((c) => ({ name: c, mappedTo: "unmapped" })),
      sampleRows: parsed.rows.slice(0, 5),
    });
    if (ok) {
      setFileName("");
      setDescription("");
      setParsed(null);
      setShowDraft(false);
    }
  };

  const handleSuggest = async () => {
    if (!parsed) return;
    try {
      const result = await suggestDrivers.mutateAsync({
        data: {
          fileName,
          description,
          columns: parsed.columns,
          sampleRows: parsed.rows.slice(0, 8),
        },
      });
      setDraftSummary(result.summary);
      setDraftDrivers(result.drivers);
      setDraftTitle(fileName.replace(/\.(csv|json)$/i, "") || "업로드 설문");
      setShowDraft(true);
      if (result.drivers.length === 0) {
        toast({ title: "동인을 찾지 못했습니다", description: "표본을 보강하거나 동인을 직접 추가해 주세요.", variant: "destructive" });
      }
    } catch {
      toast({ title: "자동 매핑 실패", description: "잠시 후 다시 시도해 주세요.", variant: "destructive" });
    }
  };

  const handleSaveDraft = async () => {
    const cleanDrivers = draftDrivers
      .filter((d) => d.direction.trim().length > 0)
      .map((d) => ({ ...d, factor: d.factor.trim() || "직접 입력", direction: d.direction.trim() }));
    if (!draftTitle.trim() || cleanDrivers.length === 0) {
      toast({ title: "입력 확인", description: "제목과 최소 1개의 동인이 필요합니다.", variant: "destructive" });
      return;
    }
    try {
      await createSurvey.mutateAsync({
        data: {
          title: draftTitle.trim(),
          description: description || draftSummary,
          methodology: "LLM 자동 매핑",
          drivers: cleanDrivers,
          appliedToPopulation: false,
        },
      });
      await invalidateAll();
      toast({ title: "설문 기준 저장됨", description: `"${draftTitle.trim()}"이(가) 등록되었습니다. 인구 반영을 켜면 다음 재생성부터 적용됩니다.` });
      setShowDraft(false);
      setParsed(null);
      setFileName("");
      setDescription("");
      setDraftDrivers([]);
    } catch {
      toast({ title: "저장 실패", description: "값을 확인해 주세요.", variant: "destructive" });
    }
  };

  const handleManualSave = async () => {
    const cleanDrivers = manualDrivers
      .filter((d) => d.direction.trim().length > 0)
      .map((d) => ({ ...d, factor: d.factor.trim() || "직접 입력", direction: d.direction.trim() }));
    if (!manualTitle.trim() || cleanDrivers.length === 0) {
      toast({ title: "입력 확인", description: "제목과 최소 1개의 동인(방향 설명 포함)이 필요합니다.", variant: "destructive" });
      return;
    }
    try {
      await createSurvey.mutateAsync({
        data: {
          title: manualTitle.trim(),
          description: manualDescription,
          methodology: "직접 입력",
          drivers: cleanDrivers,
          appliedToPopulation: false,
        },
      });
      await invalidateAll();
      toast({ title: "설문 기준 추가됨", description: `"${manualTitle.trim()}"이(가) 등록되었습니다.` });
      setManualTitle("");
      setManualDescription("");
      setManualDrivers([{ factor: "", issue: "경제", weight: 0.5, direction: "" }]);
    } catch {
      toast({ title: "추가 실패", description: "값을 확인해 주세요.", variant: "destructive" });
    }
  };

  const handleToggleApplied = async (id: number, value: boolean) => {
    try {
      await setApplied.mutateAsync({ id, data: { appliedToPopulation: value } });
      await invalidateAll();
    } catch {
      toast({ title: "변경 실패", description: "잠시 후 다시 시도해 주세요.", variant: "destructive" });
    }
  };

  const handleDeleteSurvey = async (id: number, title: string) => {
    try {
      await deleteSurvey.mutateAsync({ id });
      await invalidateAll();
      toast({ title: "설문 삭제됨", description: `"${title}"이(가) 제거되었습니다.` });
    } catch {
      toast({ title: "삭제 실패", description: "잠시 후 다시 시도해 주세요.", variant: "destructive" });
    }
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2"><TrendingUp className="h-4 w-4" /> 설문 반영 현황</CardTitle>
          <CardDescription>
            "인구 반영"이 켜진 설문의 동인들이 합성 인구의 이슈별 태도 생성에 적용됩니다. 가중치가 클수록 해당 이슈의 태도가 인구통계와 더 강하게 결합되고, 무작위성(노이즈)은 줄어듭니다. 설정 변경 후 <strong>인구 재생성</strong> 시 반영됩니다.
          </CardDescription>
        </CardHeader>
        <CardContent>
          {!impact ? (
            <div className="space-y-3"><Skeleton className="h-10 w-full" /><Skeleton className="h-24 w-full" /></div>
          ) : (
            <div className="space-y-4">
              <div className="text-sm text-muted-foreground">
                현재 <span className="font-semibold text-foreground">{impact.appliedSurveyCount}개</span> 설문이 인구 생성에 반영되고 있습니다.
              </div>
              <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3">
                {impact.items.map((it) => {
                  const active = it.driverCount > 0;
                  return (
                    <div key={it.key} className={`rounded-md border p-3 ${active ? "bg-primary/5 border-primary/30" : "bg-muted/20"}`}>
                      <div className="flex items-center justify-between">
                        <span className="text-sm font-medium">{it.issue}</span>
                        <Badge variant={active ? "default" : "secondary"} className="text-[10px]">{it.driverCount}개 동인</Badge>
                      </div>
                      <div className="mt-2 space-y-1">
                        <div className="flex items-center justify-between text-xs">
                          <span className="text-muted-foreground">결합 강도</span>
                          <span className="font-semibold tabular-nums">×{it.multiplier.toFixed(2)}</span>
                        </div>
                        <div className="flex items-center justify-between text-xs">
                          <span className="text-muted-foreground">노이즈</span>
                          <span className="font-semibold tabular-nums">×{it.noiseScale.toFixed(2)}</span>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>설문 기준 <span className="text-sm font-normal text-muted-foreground">({(surveys?.length ?? 0) + uploads.length}개)</span></CardTitle>
          <CardDescription>합성 인구의 태도를 형성하는 기준 설문입니다. "인구 반영" 스위치로 각 설문을 인구 생성에 적용/해제할 수 있습니다. 시드된 기본 설문과 직접 추가·업로드한 설문이 함께 표시됩니다.</CardDescription>
        </CardHeader>
        <CardContent>
          {!surveys ? (
            <div className="space-y-3"><Skeleton className="h-10 w-full" /><Skeleton className="h-10 w-full" /></div>
          ) : surveys.length === 0 && uploads.length === 0 ? (
            <p className="text-sm text-muted-foreground py-4 text-center">등록된 설문 기준이 없습니다.</p>
          ) : (
            <div className="border rounded-md overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>유형</TableHead>
                    <TableHead>제목 / 파일명</TableHead>
                    <TableHead>동인</TableHead>
                    <TableHead className="text-center">인구 반영</TableHead>
                    <TableHead>상태</TableHead>
                    <TableHead></TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {surveys.map((s) => (
                    <TableRow key={`survey-${s.id}`}>
                      <TableCell><Badge variant="outline">기준</Badge></TableCell>
                      <TableCell className="font-medium whitespace-nowrap">
                        {s.title}
                        <div className="text-xs text-muted-foreground font-normal max-w-xs truncate">{s.description}</div>
                      </TableCell>
                      <TableCell>
                        <div className="flex flex-wrap gap-1 max-w-xs">
                          {s.drivers.length === 0 ? (
                            <span className="text-xs text-muted-foreground">—</span>
                          ) : (
                            s.drivers.map((d, i) => (
                              <Badge key={i} variant="secondary" className="text-[10px] font-normal" title={`${d.factor}: ${d.direction} (${d.weight.toFixed(2)})`}>
                                {d.issue} {d.weight.toFixed(1)}
                              </Badge>
                            ))
                          )}
                        </div>
                      </TableCell>
                      <TableCell className="text-center">
                        <Switch
                          checked={s.appliedToPopulation}
                          disabled={s.drivers.length === 0 || setApplied.isPending}
                          onCheckedChange={(v) => handleToggleApplied(s.id, v)}
                        />
                      </TableCell>
                      <TableCell><Badge variant={s.status === "active" ? "default" : "secondary"}>{s.status === "active" ? "활성" : "종료"}</Badge></TableCell>
                      <TableCell>
                        <AlertDialog>
                          <AlertDialogTrigger asChild>
                            <Button variant="ghost" size="sm" className="h-8 px-2 text-muted-foreground hover:text-destructive">
                              <Trash2 className="h-4 w-4" />
                            </Button>
                          </AlertDialogTrigger>
                          <AlertDialogContent>
                            <AlertDialogHeader>
                              <AlertDialogTitle>설문 기준을 삭제하시겠습니까?</AlertDialogTitle>
                              <AlertDialogDescription>
                                "{s.title}"을(를) 삭제합니다. 이 작업은 되돌릴 수 없습니다. 이미 실행된 시뮬레이션 결과에는 영향을 주지 않습니다.
                              </AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                              <AlertDialogCancel>취소</AlertDialogCancel>
                              <AlertDialogAction onClick={() => handleDeleteSurvey(s.id, s.title)}>삭제</AlertDialogAction>
                            </AlertDialogFooter>
                          </AlertDialogContent>
                        </AlertDialog>
                      </TableCell>
                    </TableRow>
                  ))}
                  {uploads.map((u) => (
                    <TableRow key={`upload-${u.id}`}>
                      <TableCell><Badge variant="secondary">{u.format}</Badge></TableCell>
                      <TableCell className="font-medium whitespace-nowrap">
                        {u.fileName}
                        <div className="text-xs text-muted-foreground font-normal max-w-xs truncate">{u.description || "—"}</div>
                      </TableCell>
                      <TableCell className="text-xs text-muted-foreground">원본 업로드 ({u.rowCount.toLocaleString()}행)</TableCell>
                      <TableCell className="text-center text-xs text-muted-foreground">—</TableCell>
                      <TableCell><Badge>{u.status === "processed" ? "처리됨" : u.status}</Badge></TableCell>
                      <TableCell></TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          )}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2"><Pencil className="h-4 w-4" /> 설문 기준 직접 추가</CardTitle>
          <CardDescription>업로드 없이 이슈별 태도 동인을 직접 정의해 설문 기준을 추가합니다. 저장 후 "인구 반영"을 켜면 다음 재생성부터 적용됩니다.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label>제목</Label>
            <Input placeholder="예: 2026 청년 주거 인식 조사" value={manualTitle} onChange={(e) => setManualTitle(e.target.value)} />
          </div>
          <div className="space-y-2">
            <Label>설명 (선택)</Label>
            <Textarea placeholder="이 설문이 무엇을 측정하는지 간단히 설명" value={manualDescription} onChange={(e) => setManualDescription(e.target.value)} />
          </div>
          <div className="space-y-2">
            <Label>태도 동인</Label>
            <DriverBuilder drivers={manualDrivers} setDrivers={setManualDrivers} />
          </div>
          <Button onClick={handleManualSave} disabled={createSurvey.isPending}>
            {createSurvey.isPending && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
            설문 기준 추가
          </Button>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>설문 기준 업로드</CardTitle>
          <CardDescription>CSV 또는 JSON 형식의 설문 데이터를 업로드하면 합성 인구 태도의 보정 기준으로 등록됩니다.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="border rounded-md p-4 bg-muted/30 space-y-3">
            <div className="flex flex-wrap items-center justify-between gap-2">
              <div>
                <p className="text-sm font-medium">권장 파일 형식</p>
                <p className="text-xs text-muted-foreground">응답자 1명당 1행. 첫 줄은 헤더(컬럼명). JSON은 객체 배열.</p>
              </div>
              <div className="flex gap-2">
                <Button variant="outline" size="sm" onClick={() => downloadFile(
                  "survey_sample.csv",
                  [SAMPLE_COLUMNS.map((c) => c.name).join(","), ...SAMPLE_ROWS.map((r) => SAMPLE_COLUMNS.map((c) => (r as Record<string, string>)[c.name] ?? "").join(","))].join("\n"),
                  "text/csv",
                )}>
                  <Download className="h-4 w-4 mr-1.5" /> CSV 샘플
                </Button>
                <Button variant="outline" size="sm" onClick={() => downloadFile(
                  "survey_sample.json",
                  JSON.stringify(SAMPLE_ROWS, null, 2),
                  "application/json",
                )}>
                  <Download className="h-4 w-4 mr-1.5" /> JSON 샘플
                </Button>
              </div>
            </div>
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>컬럼</TableHead>
                    <TableHead>설명</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {SAMPLE_COLUMNS.map((c) => (
                    <TableRow key={c.name}>
                      <TableCell className="font-mono text-xs whitespace-nowrap">{c.name}</TableCell>
                      <TableCell className="text-xs text-muted-foreground">{c.desc}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          </div>
          <div className="space-y-2">
            <Label>설문 파일 (.csv / .json)</Label>
            <Input type="file" accept=".csv,.json" onChange={(e) => { const f = e.target.files?.[0]; if (f) handleFile(f); }} />
            {error && <p className="text-sm text-destructive">{error}</p>}
          </div>
          <div className="space-y-2">
            <Label>설명 (선택)</Label>
            <Textarea placeholder="예: 2024 분기별 정책 인식 조사 결과" value={description} onChange={(e) => setDescription(e.target.value)} />
          </div>

          {parsed && (
            <div className="border rounded-md p-4 bg-muted/30 space-y-3">
              <div className="flex items-center gap-2 text-sm">
                <FileSpreadsheet className="h-4 w-4" />
                <span className="font-medium">{fileName}</span>
                <Badge variant="secondary">{parsed.format}</Badge>
                <span className="text-muted-foreground">{parsed.rows.length}행 · {parsed.columns.length}개 항목</span>
              </div>
              <div className="overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow>{parsed.columns.map((c) => <TableHead key={c}>{c}</TableHead>)}</TableRow>
                  </TableHeader>
                  <TableBody>
                    {parsed.rows.slice(0, 3).map((row, i) => (
                      <TableRow key={i}>{parsed.columns.map((c) => <TableCell key={c} className="text-xs">{row[c]}</TableCell>)}</TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>
            </div>
          )}

          <div className="flex flex-wrap gap-2">
            <Button onClick={handleSuggest} disabled={!parsed || suggestDrivers.isPending}>
              {suggestDrivers.isPending ? <Loader2 className="h-4 w-4 mr-2 animate-spin" /> : <Sparkles className="h-4 w-4 mr-2" />}
              LLM 자동 매핑 제안
            </Button>
            <Button variant="outline" onClick={handleSubmit} disabled={!parsed || isPending}>
              {isPending && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
              원본만 업로드
            </Button>
          </div>

          {showDraft && (
            <div className="border rounded-md p-4 space-y-4 bg-primary/5 border-primary/30">
              <div className="flex items-center gap-2 text-sm font-medium">
                <Sparkles className="h-4 w-4 text-primary" /> 자동 매핑 초안 (검토 후 저장)
              </div>
              {draftSummary && <p className="text-xs text-muted-foreground leading-relaxed">{draftSummary}</p>}
              <p className="text-xs text-muted-foreground">아래 동인은 LLM이 제안한 초안입니다. 수정·삭제·추가한 뒤 설문 기준으로 저장하세요.</p>
              <div className="space-y-2">
                <Label>제목</Label>
                <Input value={draftTitle} onChange={(e) => setDraftTitle(e.target.value)} />
              </div>
              <div className="space-y-2">
                <Label>태도 동인</Label>
                {draftDrivers.length === 0 ? (
                  <DriverBuilder drivers={[{ factor: "", issue: "경제", weight: 0.5, direction: "" }]} setDrivers={setDraftDrivers} />
                ) : (
                  <DriverBuilder drivers={draftDrivers} setDrivers={setDraftDrivers} />
                )}
              </div>
              <div className="flex gap-2">
                <Button onClick={handleSaveDraft} disabled={createSurvey.isPending}>
                  {createSurvey.isPending && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
                  설문 기준으로 저장
                </Button>
                <Button variant="ghost" onClick={() => setShowDraft(false)}>취소</Button>
              </div>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}

function CalibrationSection({
  initial,
  onSave,
  isPending,
}: {
  initial: { method: string; benchmarkWeight: number; recencyWeight: number; shrinkageFactor: number; outlierTrimPct: number; description: string };
  onSave: (input: { method: string; benchmarkWeight: number; recencyWeight: number; shrinkageFactor: number; outlierTrimPct: number; description: string }) => Promise<void>;
  isPending: boolean;
}) {
  const [method, setMethod] = useState(initial.method);
  const [benchmarkWeight, setBenchmarkWeight] = useState(initial.benchmarkWeight);
  const [recencyWeight, setRecencyWeight] = useState(initial.recencyWeight);
  const [shrinkageFactor, setShrinkageFactor] = useState(initial.shrinkageFactor);
  const [outlierTrimPct, setOutlierTrimPct] = useState(initial.outlierTrimPct);
  const [description, setDescription] = useState(initial.description);

  const handleReset = async () => {
    const d = DEFAULT_CALIBRATION_SETTINGS;
    setMethod(d.method);
    setBenchmarkWeight(d.benchmarkWeight);
    setRecencyWeight(d.recencyWeight);
    setShrinkageFactor(d.shrinkageFactor);
    setOutlierTrimPct(d.outlierTrimPct);
    setDescription(d.description);
    await onSave({ ...d });
  };

  const methodOptions = useMemo(() => {
    return CALIBRATION_METHODS.includes(method) ? CALIBRATION_METHODS : [method, ...CALIBRATION_METHODS];
  }, [method]);

  const weightSlider = (label: string, value: number, set: (n: number) => void, hint: string) => (
    <div className="space-y-2">
      <div className="flex items-center justify-between">
        <Label>{label}</Label>
        <span className="text-sm font-semibold tabular-nums">{value.toFixed(2)}</span>
      </div>
      <Slider min={0} max={1} step={0.05} value={[value]} onValueChange={(v) => set(v[0])} />
      <p className="text-xs text-muted-foreground">{hint}</p>
    </div>
  );

  return (
    <Card>
      <CardHeader>
        <CardTitle>보정 및 검증 방법</CardTitle>
        <CardDescription>원시 LLM 예측을 실제 결과에 맞추기 위한 보정 알고리즘과 가중치를 설정합니다.</CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="space-y-2">
          <Label>보정 방법</Label>
          <Select value={method} onValueChange={setMethod}>
            <SelectTrigger><SelectValue /></SelectTrigger>
            <SelectContent>
              {methodOptions.map((m) => <SelectItem key={m} value={m}>{m}</SelectItem>)}
            </SelectContent>
          </Select>
          {METHOD_DESCRIPTIONS[method] && (
            <p className="text-xs text-muted-foreground leading-relaxed">{METHOD_DESCRIPTIONS[method]}</p>
          )}
        </div>

        <div className="grid sm:grid-cols-2 gap-3">
          {CALIBRATION_METHODS.map((m) => (
            <div key={m} className="rounded-md border p-3 bg-muted/20">
              <p className="text-sm font-medium">{m}</p>
              <p className="text-xs text-muted-foreground mt-1 leading-relaxed">{METHOD_DESCRIPTIONS[m]}</p>
            </div>
          ))}
        </div>

        <div className="grid md:grid-cols-2 gap-6">
          {weightSlider("벤치마크 가중치", benchmarkWeight, setBenchmarkWeight, "과거 가상 이벤트 실제 결과에 두는 비중")}
          {weightSlider("최근성 가중치", recencyWeight, setRecencyWeight, "최근 데이터에 부여하는 비중")}
          {weightSlider("축소 계수", shrinkageFactor, setShrinkageFactor, "원시 예측을 벤치마크 쪽으로 당기는 정도")}
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <Label>이상치 절삭 (%)</Label>
              <span className="text-sm font-semibold tabular-nums">{outlierTrimPct}%</span>
            </div>
            <Slider min={0} max={25} step={1} value={[outlierTrimPct]} onValueChange={(v) => setOutlierTrimPct(v[0])} />
            <p className="text-xs text-muted-foreground">분포 양 끝에서 제외할 이상치 비율</p>
          </div>
        </div>

        <div className="space-y-2">
          <Label>설명</Label>
          <Textarea value={description} onChange={(e) => setDescription(e.target.value)} />
        </div>

        <div className="flex flex-wrap items-center gap-3">
          <Button
            onClick={() => onSave({ method, benchmarkWeight, recencyWeight, shrinkageFactor, outlierTrimPct, description })}
            disabled={isPending}
          >
            {isPending && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
            설정 저장
          </Button>
          <AlertDialog>
            <AlertDialogTrigger asChild>
              <Button variant="outline" disabled={isPending}>
                <RotateCcw className="h-4 w-4 mr-2" />
                기본값으로 초기화
              </Button>
            </AlertDialogTrigger>
            <AlertDialogContent>
              <AlertDialogHeader>
                <AlertDialogTitle>보정 설정을 기본값으로 초기화하시겠습니까?</AlertDialogTitle>
                <AlertDialogDescription>
                  보정 방법과 모든 가중치가 권장 기본값(베이지안 축소 · 축소 계수 0.4 등)으로 되돌아가며 즉시 저장됩니다. 이 작업은 되돌릴 수 없습니다.
                </AlertDialogDescription>
              </AlertDialogHeader>
              <AlertDialogFooter>
                <AlertDialogCancel>취소</AlertDialogCancel>
                <AlertDialogAction onClick={handleReset}>초기화</AlertDialogAction>
              </AlertDialogFooter>
            </AlertDialogContent>
          </AlertDialog>
        </div>
      </CardContent>
    </Card>
  );
}

function CalibrationEventsSection({
  events,
  isLoading,
  isCreating,
  onCreate,
  onDelete,
}: {
  events: Calibration[];
  isLoading: boolean;
  isCreating: boolean;
  onCreate: (input: CalibrationInput) => Promise<boolean>;
  onDelete: (id: number) => Promise<void>;
}) {
  const [title, setTitle] = useState("");
  const [product, setProduct] = useState(CALIBRATION_PRODUCT_OPTIONS[0].value);
  const [eventType, setEventType] = useState(EVENT_TYPE_OPTIONS[0]);
  const [targetDate, setTargetDate] = useState("");
  const [metric, setMetric] = useState("");
  const [actualValue, setActualValue] = useState("");
  const [rawPrediction, setRawPrediction] = useState("");

  const valid =
    title.trim() &&
    targetDate.trim() &&
    metric.trim() &&
    actualValue !== "" &&
    rawPrediction !== "";

  const handleSubmit = async () => {
    if (!valid) return;
    const ok = await onCreate({
      title: title.trim(),
      product,
      eventType,
      targetDate: targetDate.trim(),
      metric: metric.trim(),
      actualValue: Number(actualValue),
      rawPrediction: Number(rawPrediction),
    });
    if (ok) {
      setTitle("");
      setTargetDate("");
      setMetric("");
      setActualValue("");
      setRawPrediction("");
    }
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>검증 이벤트 추가</CardTitle>
          <CardDescription>
            결과가 알려진 과거 이벤트의 실제값과 모델의 원시 예측을 입력하면, 현재 보정 설정(축소 계수)에 따라
            보정 예측과 오차가 자동 계산되어 검증 내역에 추가됩니다.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid md:grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>이벤트 제목</Label>
              <Input placeholder="예: 2024 서울시장 보궐선거" value={title} onChange={(e) => setTitle(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>제품 라인</Label>
              <Select value={product} onValueChange={(v) => setProduct(v as CalibrationInputProduct)}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {CALIBRATION_PRODUCT_OPTIONS.map((p) => <SelectItem key={p.value} value={p.value}>{p.label}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>이벤트 유형</Label>
              <Select value={eventType} onValueChange={setEventType}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {EVENT_TYPE_OPTIONS.map((t) => <SelectItem key={t} value={t}>{t}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>기준일</Label>
              <Input placeholder="예: 2024-04-10" value={targetDate} onChange={(e) => setTargetDate(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>지표</Label>
              <Input placeholder="예: 후보 A 득표율" value={metric} onChange={(e) => setMetric(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>실제값 (%)</Label>
              <Input type="number" min={0} max={100} placeholder="예: 52.3" value={actualValue} onChange={(e) => setActualValue(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>원시 예측 (%)</Label>
              <Input type="number" min={0} max={100} placeholder="예: 48.5" value={rawPrediction} onChange={(e) => setRawPrediction(e.target.value)} />
            </div>
          </div>
          <Button onClick={handleSubmit} disabled={!valid || isCreating}>
            {isCreating ? <Loader2 className="h-4 w-4 mr-2 animate-spin" /> : <Plus className="h-4 w-4 mr-2" />}
            이벤트 추가
          </Button>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>검증 이벤트 내역 <span className="text-sm font-normal text-muted-foreground">({events.length}개)</span></CardTitle>
          <CardDescription>오래된 이벤트는 삭제하고 최신 이벤트를 추가하는 방식으로 관리합니다.</CardDescription>
        </CardHeader>
        <CardContent>
          {isLoading ? (
            <div className="space-y-3"><Skeleton className="h-10 w-full" /><Skeleton className="h-10 w-full" /></div>
          ) : events.length === 0 ? (
            <p className="text-sm text-muted-foreground py-4 text-center">등록된 검증 이벤트가 없습니다.</p>
          ) : (
            <div className="border rounded-md overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>이벤트</TableHead>
                    <TableHead>제품</TableHead>
                    <TableHead>유형</TableHead>
                    <TableHead>기준일</TableHead>
                    <TableHead className="text-right">실제값</TableHead>
                    <TableHead className="text-right">원시 예측</TableHead>
                    <TableHead className="text-right">보정 예측</TableHead>
                    <TableHead className="text-right">원시 오차</TableHead>
                    <TableHead className="text-right">보정 오차</TableHead>
                    <TableHead></TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {events.map((ev) => (
                    <TableRow key={ev.id}>
                      <TableCell className="font-medium">
                        {ev.title}
                        <div className="text-xs text-muted-foreground">{ev.metric}</div>
                      </TableCell>
                      <TableCell><Badge variant="outline">{productDomainLabel(ev.product)}</Badge></TableCell>
                      <TableCell><Badge variant="secondary">{ev.eventType}</Badge></TableCell>
                      <TableCell className="whitespace-nowrap">{ev.targetDate}</TableCell>
                      <TableCell className="text-right tabular-nums">{ev.actualValue}%</TableCell>
                      <TableCell className="text-right tabular-nums">{ev.rawPrediction}%</TableCell>
                      <TableCell className="text-right tabular-nums text-primary font-medium">{ev.calibratedPrediction}%</TableCell>
                      <TableCell className="text-right tabular-nums text-muted-foreground">{ev.rawError}%</TableCell>
                      <TableCell className="text-right tabular-nums text-primary">{ev.calibratedError}%</TableCell>
                      <TableCell>
                        <AlertDialog>
                          <AlertDialogTrigger asChild>
                            <Button variant="ghost" size="icon" className="h-8 w-8 text-destructive hover:text-destructive hover:bg-destructive/10">
                              <Trash2 className="h-4 w-4" />
                            </Button>
                          </AlertDialogTrigger>
                          <AlertDialogContent>
                            <AlertDialogHeader>
                              <AlertDialogTitle>이 검증 이벤트를 삭제하시겠습니까?</AlertDialogTitle>
                              <AlertDialogDescription>
                                "{ev.title}" 이벤트가 검증 내역에서 제거됩니다. 이 작업은 되돌릴 수 없습니다.
                              </AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                              <AlertDialogCancel>취소</AlertDialogCancel>
                              <AlertDialogAction onClick={() => onDelete(ev.id)} className="bg-destructive text-destructive-foreground">삭제</AlertDialogAction>
                            </AlertDialogFooter>
                          </AlertDialogContent>
                        </AlertDialog>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
