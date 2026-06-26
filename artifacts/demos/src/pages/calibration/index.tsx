import {
  useListCalibrations,
  useGetElectionCalibration,
  useGetCalibrationSettings,
  useUpdateCalibrationSettings,
  useLearningOffsets,
  getGetCalibrationSettingsQueryKey,
  type Calibration,
  type OffsetAxis,
} from "@workspace/api-client-react";
import { useQueryClient } from "@tanstack/react-query";
import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, Legend, ResponsiveContainer } from "recharts";
import { useAccuracyTrend } from "@/lib/accuracyTrend";
import { Info, FlaskConical, FlaskRound, Microscope, RefreshCw, Sparkles, Printer, ArrowUpDown, ArrowUp, ArrowDown } from "lucide-react";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";
import { useAuth } from "@/hooks/use-auth";

const PRODUCT_META: { key: string; product: string; label: string; track: string }[] = [
  { key: "Dynamo", product: "Dynamo", label: "정치", track: "정치성향 기준선" },
  { key: "Lumen", product: "Lumen", label: "비즈니스", track: "소비 성향 기준선" },
  { key: "Seraph", product: "Seraph", label: "정부", track: "정책 태도 기준선" },
];

/**
 * 학습 효과 대표 지표 — 검증 이벤트가 쌓일수록 학습 전(원시) 예측 오차가
 * 줄어드는 추세를 라인차트로 보여준다. 대시보드 정확도 추이와 동일 데이터·계산
 * (useAccuracyTrend)을 공유한다.
 */
function AccuracyTrendLearning() {
  const { points, eventCount, avgRawError, isLoading } = useAccuracyTrend({
    includeElections: true,
  });

  if (isLoading) {
    return <Skeleton className="h-80 w-full" />;
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>정확도 추이 (학습 효과)</CardTitle>
        <CardDescription>
          검증 이벤트가 쌓일수록 학습 전 예측 오차가 줄어드는 추세를 보여줍니다. (입력 보정 ON 기준)
        </CardDescription>
      </CardHeader>
      <CardContent>
        {points.length === 0 ? (
          <div className="py-16 text-center text-sm text-muted-foreground">
            검증 이벤트가 없습니다. 검증 이벤트를 등록하면 학습 효과 추이가 표시됩니다.
          </div>
        ) : (
          <div className="space-y-6">
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="rounded-lg border bg-card p-4">
                <div className="text-xs text-muted-foreground">평균 원시 오차 (학습 전)</div>
                <div className="text-4xl font-bold text-primary mt-1">
                  {avgRawError.toFixed(1)}<span className="text-lg font-medium">%p</span>
                </div>
              </div>
              <div className="rounded-lg border bg-card p-4">
                <div className="text-xs text-muted-foreground">검증 이벤트 수</div>
                <div className="text-4xl font-bold mt-1">
                  {eventCount}<span className="text-lg font-medium">건</span>
                </div>
              </div>
            </div>
            <div className="h-72 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={points} margin={{ top: 10, right: 20, left: 0, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} opacity={0.3} />
                  <XAxis dataKey="name" tick={{ fontSize: 11 }} />
                  <YAxis tickFormatter={(v) => `${v}`} />
                  <RechartsTooltip />
                  <Line type="monotone" dataKey="rawError" name="원시 오차(학습 전)" stroke="hsl(var(--primary))" strokeWidth={2} dot={{ r: 3 }} />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  );
}

/**
 * 현재 전역 합성 인구에 적용 중인 도메인별 총 기준선 이동량 패널.
 * auto(자가학습 누적) + manual(입력 보정) = combined(한도 clamp 후). 두 레버가
 * 같은 방향으로 누적돼 한도에서 잘리면(clamped) 경고를 띄운다.
 */
function AppliedOffsetPanel() {
  const { data, isLoading } = useLearningOffsets();

  const AXES: { key: "political" | "consumer" | "policy"; label: string; track: string }[] = [
    { key: "political", label: "정치 (Dynamo)", track: "정치성향 기준선" },
    { key: "consumer", label: "비즈니스 (Lumen)", track: "소비 성향 기준선" },
    { key: "policy", label: "정부 (Seraph)", track: "정책 태도 기준선" },
  ];

  const fmt = (v: number) => `${v > 0 ? "+" : ""}${v.toFixed(1)}%p`;
  const anyClamped =
    !!data &&
    (data.political.clamped || data.consumer.clamped || data.policy.clamped);

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-base flex items-center gap-2">
          <ArrowUpDown className="h-4 w-4 text-primary" />
          현재 적용 중인 총 기준선 이동
        </CardTitle>
        <CardDescription>
          전역 합성 인구에 실제 반영되는 도메인별 누적 offset입니다. 자가학습(auto)과
          입력 보정(manual)의 합이며, 같은 방향으로 과도하게 누적되면 한도에서 잘립니다(clamp).
          {data ? (
            <> 입력 보정 인구 반영: <strong>{data.applyToPopulation ? "켜짐" : "꺼짐"}</strong>
            {!data.applyToPopulation && " (manual=0 — 토글을 켜야 합산)"}.</>
          ) : null}
        </CardDescription>
      </CardHeader>
      <CardContent>
        {isLoading || !data ? (
          <div className="grid gap-3 md:grid-cols-3">
            {AXES.map((a) => (
              <Skeleton key={a.key} className="h-28 w-full" />
            ))}
          </div>
        ) : (
          <>
            {anyClamped ? (
              <Alert variant="destructive" className="mb-3">
                <Info className="h-4 w-4" />
                <AlertTitle>한도 초과(clamp) 발생</AlertTitle>
                <AlertDescription>
                  자가학습과 입력 보정이 같은 방향으로 누적되어 합이 한도를 넘었습니다.
                  실제 적용값(combined)은 한도에서 잘립니다 — 두 레버가 중복 보정 중일 수 있으니
                  입력 보정 강도나 토글을 점검하세요.
                </AlertDescription>
              </Alert>
            ) : null}
            <div className="grid gap-3 md:grid-cols-3">
              {AXES.map((a) => {
                const ax = data[a.key] as OffsetAxis;
                return (
                  <div
                    key={a.key}
                    className={`rounded-lg border bg-card p-3 ${ax.clamped ? "border-destructive/50" : ""}`}
                  >
                    <div className="text-sm font-medium">{a.label}</div>
                    <div className="text-xs text-muted-foreground mt-0.5">{a.track}</div>
                    <div className="mt-2 flex items-baseline gap-1">
                      <span
                        className={`text-2xl font-bold ${ax.combined !== 0 ? "text-primary" : "text-muted-foreground"}`}
                      >
                        {fmt(ax.combined)}
                      </span>
                      <span className="text-xs text-muted-foreground">적용값</span>
                    </div>
                    <div className="mt-2 space-y-0.5 text-xs text-muted-foreground">
                      <div className="flex justify-between">
                        <span>자가학습 (auto)</span>
                        <span className="tabular-nums">{fmt(ax.auto)}</span>
                      </div>
                      <div className="flex justify-between">
                        <span>입력 보정 (manual)</span>
                        <span className="tabular-nums">{fmt(ax.manual)}</span>
                      </div>
                      <div className="flex justify-between border-t pt-0.5">
                        <span>합 (clamp 전)</span>
                        <span className="tabular-nums">{fmt(ax.sum)}</span>
                      </div>
                      {ax.clamped ? (
                        <div className="text-destructive">한도 ±{ax.limit}%p 초과 → 잘림</div>
                      ) : (
                        <div>한도 ±{ax.limit}%p</div>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </>
        )}
      </CardContent>
    </Card>
  );
}

/**
 * 보정 루프 허브 — 두 레버(출력 보정·입력 보정)와 4단계 피드백 루프를
 * 한눈에 보여주고, 입력 보정 토글(applyToPopulation)을 제어한다.
 * 제품별 평균 편향(actual-raw)을 클라이언트에서 계산해 기준선 이동 방향을 미리 보여준다.
 */
function CalibrationLoopHub({ calibrations }: { calibrations: Calibration[] }) {
  const { data: settings } = useGetCalibrationSettings();
  const { isAdmin } = useAuth();
  const queryClient = useQueryClient();
  const update = useUpdateCalibrationSettings({
    mutation: {
      onSuccess: () => {
        queryClient.invalidateQueries({ queryKey: getGetCalibrationSettingsQueryKey() });
      },
    },
  });

  const applyToPopulation = settings?.applyToPopulation ?? false;
  const shrinkage = settings?.shrinkageFactor ?? 0.4;

  const productBias = PRODUCT_META.map((m) => {
    const events = calibrations.filter((c) => c.product === m.product);
    const meanBias =
      events.length > 0
        ? events.reduce((acc, c) => acc + (c.actualValue - c.rawPrediction), 0) / events.length
        : 0;
    return { ...m, eventCount: events.length, meanBias };
  });

  function handleToggle(next: boolean) {
    if (!settings) return;
    update.mutate({
      data: {
        method: settings.method,
        benchmarkWeight: settings.benchmarkWeight,
        recencyWeight: settings.recencyWeight,
        shrinkageFactor: settings.shrinkageFactor,
        outlierTrimPct: settings.outlierTrimPct,
        applyToPopulation: next,
        description: settings.description,
      },
    });
  }

  const steps = [
    { icon: FlaskRound, title: "1. 시뮬레이션", desc: "합성 인구로 지지·찬성률을 예측합니다." },
    { icon: Microscope, title: "2. 검증 이벤트", desc: "과거 실제 결과를 등록해 원시 예측과의 편향을 측정합니다." },
    { icon: Sparkles, title: "3. 출력 보정", desc: "제품별 평균 편향으로 결과 화면의 예측을 사후 교정합니다. (항상 적용)" },
    { icon: RefreshCw, title: "4. 입력 보정", desc: "편향을 페르소나 기준선에 반영해 다음 인구 재생성부터 더 정확해집니다. (선택)" },
  ];

  return (
    <div className="space-y-4">
      <AppliedOffsetPanel />
      <Card>
        <CardHeader>
          <CardTitle>보정 피드백 루프</CardTitle>
          <CardDescription>
            예측 → 검증 → 보정으로 이어지는 폐루프. 출력 보정은 결과 화면에 자동 적용되고,
            입력 보정은 켜면 다음 인구 재생성부터 페르소나에 반영됩니다.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid gap-3 md:grid-cols-4">
            {steps.map((s) => (
              <div key={s.title} className="rounded-lg border bg-card p-4">
                <s.icon className="h-5 w-5 text-primary mb-2" />
                <div className="font-semibold text-sm">{s.title}</div>
                <p className="text-xs text-muted-foreground mt-1 leading-relaxed">{s.desc}</p>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      <Card className={applyToPopulation ? "border-primary/50 bg-primary/5" : undefined}>
        <CardHeader>
          <div className="flex items-start justify-between gap-4">
            <div className="space-y-1">
              <CardTitle className="text-base flex items-center gap-2">
                <RefreshCw className="h-4 w-4 text-primary" />
                입력 보정 — 인구 기준선에 편향 반영
              </CardTitle>
              <CardDescription>
                켜면 검증 이벤트의 평균 편향을 축소 계수({shrinkage})만큼 줄여 페르소나 기준선을 이동합니다.
                <strong> 다음 인구 재생성</strong>(관리자 → 인구)부터 적용됩니다. 기존 시뮬레이션 결과는 변하지 않습니다.
              </CardDescription>
            </div>
            <div className="flex items-center gap-2 shrink-0">
              <Label htmlFor="apply-to-pop" className="text-sm">
                {applyToPopulation ? "켜짐" : "꺼짐"}
              </Label>
              {isAdmin ? (
                <Switch
                  id="apply-to-pop"
                  checked={applyToPopulation}
                  onCheckedChange={handleToggle}
                  disabled={!settings || update.isPending}
                />
              ) : (
                <Badge variant="secondary" className="shrink-0">관리자 전용</Badge>
              )}
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="grid gap-3 md:grid-cols-3">
            {productBias.map((p) => {
              const noData = p.eventCount < 2;
              const dir = p.meanBias > 0 ? "보수/긍정(+)" : p.meanBias < 0 ? "진보/부정(−)" : "변화 없음";
              return (
                <div key={p.key} className="rounded-lg border bg-card p-3">
                  <div className="text-sm font-medium">{p.label}</div>
                  <div className="text-xs text-muted-foreground mt-0.5">{p.track}</div>
                  {noData ? (
                    <p className="text-xs text-muted-foreground mt-2">
                      검증 이벤트 {p.eventCount}건 — 2건 이상부터 반영
                    </p>
                  ) : (
                    <div className="mt-2">
                      <div className="text-xs text-muted-foreground">평균 편향 (실제−원시)</div>
                      <div className={`text-lg font-bold ${p.meanBias > 0 ? "text-primary" : "text-muted-foreground"}`}>
                        {p.meanBias > 0 ? "+" : ""}{p.meanBias.toFixed(1)}%p
                      </div>
                      <div className="text-xs text-muted-foreground">
                        기준선 {dir} 방향 {applyToPopulation ? "이동 예정" : "이동 (미적용)"}
                      </div>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}

type ElectionSortKey = "electionName" | "electionDate" | "regionCount" | "avgRawError" | "avgCalibratedError" | "improvement";

function SortableHeader({
  label,
  sortKey,
  activeKey,
  dir,
  onSort,
  align = "left",
}: {
  label: string;
  sortKey: ElectionSortKey;
  activeKey: ElectionSortKey;
  dir: "asc" | "desc";
  onSort: (key: ElectionSortKey) => void;
  align?: "left" | "right";
}) {
  const active = activeKey === sortKey;
  return (
    <TableHead className={align === "right" ? "text-right" : undefined}>
      <button
        type="button"
        onClick={() => onSort(sortKey)}
        className={`inline-flex items-center gap-1 hover:text-foreground transition-colors ${
          align === "right" ? "flex-row-reverse" : ""
        } ${active ? "text-foreground font-semibold" : ""}`}
      >
        {label}
        {active ? (
          dir === "asc" ? <ArrowUp className="h-3.5 w-3.5" /> : <ArrowDown className="h-3.5 w-3.5" />
        ) : (
          <ArrowUpDown className="h-3.5 w-3.5 opacity-40" />
        )}
      </button>
    </TableHead>
  );
}

function ElectionCalibrationView() {
  const { data, isLoading } = useGetElectionCalibration();
  const [selectedDate, setSelectedDate] = useState<string | null>(null);
  const [sortKey, setSortKey] = useState<ElectionSortKey>("electionDate");
  const [sortDir, setSortDir] = useState<"asc" | "desc">("desc");

  function toggleSort(key: ElectionSortKey) {
    if (key === sortKey) {
      setSortDir((d) => (d === "asc" ? "desc" : "asc"));
    } else {
      setSortKey(key);
      setSortDir(key === "electionName" || key === "electionDate" ? "asc" : "desc");
    }
  }

  if (isLoading || !data) {
    return (
      <div className="space-y-6">
        <div className="grid gap-4 md:grid-cols-3">
          <Skeleton className="h-24 w-full" />
          <Skeleton className="h-24 w-full" />
          <Skeleton className="h-24 w-full" />
        </div>
        <Skeleton className="h-96 w-full" />
      </div>
    );
  }

  const elections = data.elections ?? [];
  if (elections.length === 0) {
    return (
      <Alert>
        <Info className="h-4 w-4" />
        <AlertTitle>선거 데이터가 없습니다</AlertTitle>
        <AlertDescription>
          기준이 될 실제 선거 결과가 시드되지 않았습니다. 선거 데이터를 시드하면 자동으로 백테스트가 표시됩니다.
        </AlertDescription>
      </Alert>
    );
  }

  const selected =
    elections.find((e) => e.electionDate === selectedDate) ?? elections[0];

  const chartData = selected.rows
    .filter((r) => r.leaning === "conservative")
    .map((r) => ({
      name: r.regionName.replace(/(특별자치도|특별자치시|특별시|광역시|도)$/u, ""),
      rawError: r.rawError,
      calibratedError: r.calibratedError,
    }));

  const sortedElections = [...elections].sort((a, b) => {
    let cmp: number;
    switch (sortKey) {
      case "electionName":
        cmp = a.electionName.localeCompare(b.electionName, "ko");
        break;
      case "electionDate":
        cmp = a.electionDate.localeCompare(b.electionDate);
        break;
      case "regionCount":
        cmp = a.rows.length - b.rows.length;
        break;
      case "avgRawError":
        cmp = a.avgRawError - b.avgRawError;
        break;
      case "avgCalibratedError":
        cmp = a.avgCalibratedError - b.avgCalibratedError;
        break;
      case "improvement":
        cmp = (a.avgRawError - a.avgCalibratedError) - (b.avgRawError - b.avgCalibratedError);
        break;
    }
    return sortDir === "asc" ? cmp : -cmp;
  });

  return (
    <div className="space-y-6">
      <Alert>
        <Info className="h-4 w-4" />
        <AlertTitle>실제 선거 결과 기반 검증 (자동)</AlertTitle>
        <AlertDescription>
          합성 인구의 투표 성향(투표 의향 가중 로지스틱)으로 시·도별 득표율을 예측한 뒤,
          실제 <strong>{selected.electionName}</strong> 결과와 비교합니다.
          공개된 개표 결과가 정답이므로 별도 입력 없이 현재 합성 인구로 매번 다시 계산됩니다.
          사후 층화·축소(shrinkage {data.shrinkageFactor})로 원시 예측을 보정합니다.
        </AlertDescription>
      </Alert>

      <Card>
        <CardHeader className="pb-3">
          <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <CardTitle className="text-base">선거별 백테스트 비교</CardTitle>
              <CardDescription>등록된 모든 선거를 같은 합성 인구로 백테스트한 결과입니다. 표 머리글을 눌러 정렬하거나 행을 선택해 상세를 확인하세요.</CardDescription>
            </div>
            <div className="space-y-1.5">
              <Label className="text-xs">선거 선택</Label>
              <Select value={selected.electionDate} onValueChange={setSelectedDate}>
                <SelectTrigger className="sm:w-64">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {elections.map((e) => (
                    <SelectItem key={e.electionDate} value={e.electionDate}>
                      {e.electionName} ({e.electionDate})
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="border rounded-md overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <SortableHeader label="선거" sortKey="electionName" activeKey={sortKey} dir={sortDir} onSort={toggleSort} />
                  <SortableHeader label="선거일" sortKey="electionDate" activeKey={sortKey} dir={sortDir} onSort={toggleSort} />
                  <SortableHeader label="시·도 수" sortKey="regionCount" activeKey={sortKey} dir={sortDir} onSort={toggleSort} align="right" />
                  <SortableHeader label="평균 원시 오차" sortKey="avgRawError" activeKey={sortKey} dir={sortDir} onSort={toggleSort} align="right" />
                  <SortableHeader label="평균 보정 오차" sortKey="avgCalibratedError" activeKey={sortKey} dir={sortDir} onSort={toggleSort} align="right" />
                  <SortableHeader label="개선폭" sortKey="improvement" activeKey={sortKey} dir={sortDir} onSort={toggleSort} align="right" />
                </TableRow>
              </TableHeader>
              <TableBody>
                {sortedElections.map((e) => {
                  const improvement = e.avgRawError - e.avgCalibratedError;
                  const isSelected = e.electionDate === selected.electionDate;
                  return (
                    <TableRow
                      key={e.electionDate}
                      onClick={() => setSelectedDate(e.electionDate)}
                      className={`cursor-pointer ${isSelected ? "bg-primary/5" : ""}`}
                    >
                      <TableCell className="font-medium">{e.electionName}</TableCell>
                      <TableCell className="tabular-nums text-muted-foreground">{e.electionDate}</TableCell>
                      <TableCell className="text-right tabular-nums">{e.rows.length}</TableCell>
                      <TableCell className="text-right tabular-nums text-muted-foreground">{e.avgRawError.toFixed(2)}%p</TableCell>
                      <TableCell className="text-right tabular-nums font-semibold text-primary">{e.avgCalibratedError.toFixed(2)}%p</TableCell>
                      <TableCell className={`text-right tabular-nums font-medium ${improvement >= 0 ? "text-emerald-600" : "text-destructive"}`}>
                        {improvement >= 0 ? "−" : "+"}{Math.abs(improvement).toFixed(2)}%p
                      </TableCell>
                    </TableRow>
                  );
                })}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader className="pb-2"><CardTitle className="text-sm font-medium">보정 방법</CardTitle></CardHeader>
          <CardContent><div className="text-base font-semibold">{data.method}</div></CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2"><CardTitle className="text-sm font-medium">평균 원시 오차</CardTitle></CardHeader>
          <CardContent><div className="text-3xl font-bold text-muted-foreground">{selected.avgRawError.toFixed(2)}%p</div></CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2"><CardTitle className="text-sm font-medium">평균 보정 오차</CardTitle></CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-primary">{selected.avgCalibratedError.toFixed(2)}%p</div>
            <p className="text-xs text-muted-foreground mt-1">사후 층화 보정 후</p>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>시·도별 예측 오차 (보수 후보 득표율)</CardTitle>
          <CardDescription>{selected.electionName} · 원시 예측과 보정 예측의 오차(%p) 비교</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="h-[360px] w-full">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={chartData} margin={{ top: 20, right: 20, left: 0, bottom: 5 }} barGap={2} barCategoryGap="35%">
                <CartesianGrid strokeDasharray="3 3" vertical={false} opacity={0.3} />
                <XAxis dataKey="name" tick={{ fontSize: 11 }} interval={0} angle={-35} textAnchor="end" height={60} />
                <YAxis tickFormatter={(v) => `${v}`} />
                <RechartsTooltip cursor={{ fill: "rgba(0,0,0,0.05)" }} />
                <Legend />
                <Bar dataKey="rawError" name="원시 오차" fill="hsl(var(--muted-foreground))" radius={[4, 4, 0, 0]} maxBarSize={20} />
                <Bar dataKey="calibratedError" name="보정 오차" fill="hsl(var(--primary))" radius={[4, 4, 0, 0]} maxBarSize={20} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>예측 vs 실제 상세</CardTitle>
          <CardDescription>
            {selected.electionName} · {selected.electionDate} · 값은 {selected.rows[0]?.metric ?? "보수 후보 득표율"}이며, 배지는 해당 시·도 실제 1위 진영입니다.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="border rounded-md overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>지역</TableHead>
                  <TableHead>우세 진영</TableHead>
                  <TableHead className="text-right">실제</TableHead>
                  <TableHead className="text-right">원시 예측</TableHead>
                  <TableHead className="text-right">보정 예측</TableHead>
                  <TableHead className="text-right">원시 오차</TableHead>
                  <TableHead className="text-right">보정 오차</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {selected.rows.map((r) => (
                  <TableRow key={`${r.electionId}-${r.regionCode}-${r.leaning}`}>
                    <TableCell className="font-medium">{r.regionName}</TableCell>
                    <TableCell>
                      <Badge variant={r.actualWinner === "conservative" ? "destructive" : "default"}>
                        {r.actualWinner === "conservative" ? "보수 우세" : "진보 우세"}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-right tabular-nums">{r.actualValue}%</TableCell>
                    <TableCell className="text-right tabular-nums text-muted-foreground">{r.rawPrediction}%</TableCell>
                    <TableCell className="text-right tabular-nums font-semibold text-primary">{r.calibratedPrediction}%</TableCell>
                    <TableCell className="text-right tabular-nums text-muted-foreground">{r.rawError}</TableCell>
                    <TableCell className="text-right tabular-nums">{r.calibratedError}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}

/**
 * 실측 백테스트 뷰 — 관리자가 등록한 검증 이벤트(실제값 + 원시 예측)를 받아
 * 평균 오차 KPI, 이벤트별 오차 막대, 상세 테이블을 보여준다. Lumen/Seraph처럼
 * 공개 정답이 없는 도메인은 이 수동 백테스트가 유일한 검증 수단이다.
 */
function EventBacktestView({
  events,
  domainLabel,
  groundTruthHint,
}: {
  events: Calibration[];
  domainLabel: string;
  groundTruthHint: string;
}) {
  const hasEvents = events.length > 0;

  if (!hasEvents) {
    return (
      <div className="space-y-6">
        <Alert>
          <FlaskConical className="h-4 w-4" />
          <AlertTitle>{domainLabel} 실측 백테스트</AlertTitle>
          <AlertDescription>
            선거처럼 공개된 정답이 없으므로, {groundTruthHint}를 직접 등록해 모델을 검증·보정합니다.
          </AlertDescription>
        </Alert>
        <Card>
          <CardContent className="py-16 text-center text-sm text-muted-foreground">
            등록된 {domainLabel} 백테스트 데이터가 없습니다.<br />
            <span className="mt-1 inline-block">
              관리자 → 검증 이벤트에서 제품 라인을 <strong>{domainLabel}</strong>으로 선택해 과거 실측 결과를 추가하면 백테스트가 생성됩니다.
            </span>
          </CardContent>
        </Card>
      </div>
    );
  }

  const avgRawError = events.reduce((acc, c) => acc + c.rawError, 0) / events.length;
  const avgCalError = events.reduce((acc, c) => acc + c.calibratedError, 0) / events.length;

  const sortedAsc = [...events].sort(
    (a, b) => new Date(a.targetDate).getTime() - new Date(b.targetDate).getTime(),
  );
  const sortedDesc = [...sortedAsc].reverse();
  const chartData = sortedAsc.map((c) => ({
    name: c.title,
    rawError: c.rawError,
    calibratedError: c.calibratedError,
  }));

  return (
    <div className="space-y-6">
      <Alert>
        <FlaskConical className="h-4 w-4" />
        <AlertTitle>{domainLabel} 실측 백테스트</AlertTitle>
        <AlertDescription>
          {groundTruthHint}를 정답으로 등록하고, 모델의 원시 예측과 비교합니다.
          현재 보정 설정(축소 계수)에 따라 보정 예측·오차가 계산됩니다.
        </AlertDescription>
      </Alert>

      <div className="grid gap-4 md:grid-cols-2">
        <Card>
          <CardHeader className="pb-2"><CardTitle className="text-sm font-medium">평균 원시 오차</CardTitle></CardHeader>
          <CardContent><div className="text-3xl font-bold text-muted-foreground">{avgRawError.toFixed(2)}%p</div></CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2"><CardTitle className="text-sm font-medium">평균 보정 오차</CardTitle></CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-primary">{avgCalError.toFixed(2)}%p</div>
            <p className="text-xs text-muted-foreground mt-1">보정 후 정확도 향상</p>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>이벤트별 예측 오차 비교</CardTitle>
          <CardDescription>원시 예측과 보정 예측의 오차(%p) 비교</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="h-[360px] w-full">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={chartData} margin={{ top: 20, right: 20, left: 0, bottom: 5 }} barGap={2} barCategoryGap="35%">
                <CartesianGrid strokeDasharray="3 3" vertical={false} opacity={0.3} />
                <XAxis dataKey="name" tick={{ fontSize: 11 }} interval={0} angle={-20} textAnchor="end" height={70} />
                <YAxis tickFormatter={(v) => `${v}`} />
                <RechartsTooltip cursor={{ fill: "rgba(0,0,0,0.05)" }} />
                <Legend />
                <Bar dataKey="rawError" name="원시 오차" fill="hsl(var(--muted-foreground))" radius={[4, 4, 0, 0]} maxBarSize={20} />
                <Bar dataKey="calibratedError" name="보정 오차" fill="hsl(var(--primary))" radius={[4, 4, 0, 0]} maxBarSize={20} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>백테스트 상세</CardTitle>
          <CardDescription>최신순</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="border rounded-md overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>이벤트</TableHead>
                  <TableHead>유형</TableHead>
                  <TableHead>기준일</TableHead>
                  <TableHead className="text-right">실제</TableHead>
                  <TableHead className="text-right">원시 예측</TableHead>
                  <TableHead className="text-right">보정 예측</TableHead>
                  <TableHead className="text-right">원시 오차</TableHead>
                  <TableHead className="text-right">보정 오차</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {sortedDesc.map((c) => (
                  <TableRow key={c.id}>
                    <TableCell className="font-medium">
                      {c.title}
                      <div className="text-xs text-muted-foreground">{c.metric}</div>
                    </TableCell>
                    <TableCell><Badge variant="secondary">{c.eventType}</Badge></TableCell>
                    <TableCell className="whitespace-nowrap">{c.targetDate}</TableCell>
                    <TableCell className="text-right tabular-nums">{c.actualValue}%</TableCell>
                    <TableCell className="text-right tabular-nums text-muted-foreground">{c.rawPrediction}%</TableCell>
                    <TableCell className="text-right tabular-nums font-semibold text-primary">{c.calibratedPrediction}%</TableCell>
                    <TableCell className="text-right tabular-nums text-muted-foreground">{c.rawError}</TableCell>
                    <TableCell className="text-right tabular-nums">{c.calibratedError}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}

export default function Calibration() {
  const { data: calibrations, isLoading } = useListCalibrations();

  if (isLoading || !calibrations) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-10 w-48" />
        <Skeleton className="h-64 w-full" />
        <Skeleton className="h-96 w-full" />
      </div>
    );
  }

  const dynamoEvents = calibrations.filter((c) => c.product === "Dynamo");
  const lumenEvents = calibrations.filter((c) => c.product === "Lumen");
  const seraphEvents = calibrations.filter((c) => c.product === "Seraph");

  return (
    <div className="space-y-8">
      <div className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">정확도 검증</h1>
          <p className="text-muted-foreground mt-1">
            모델 예측을 실측 결과와 비교(백테스트)하고, 그 편향을 합성 인구에 학습시킵니다
          </p>
        </div>
        <Button variant="outline" size="sm" className="no-print shrink-0" onClick={() => window.print()}>
          <Printer className="h-4 w-4 mr-2" /> 보고서 인쇄 / PDF
        </Button>
      </div>

      {/* 인쇄 전용 보고서 헤더 (화면에서는 숨김) */}
      <div className="print-only print-block border-b pb-4">
        <p className="text-xs uppercase tracking-widest text-muted-foreground">DEMOS · 보정 및 검증 보고서</p>
        <h1 className="text-2xl font-bold mt-1">정확도 검증 리포트</h1>
        <p className="text-xs text-muted-foreground mt-1">발행일 {new Date().toLocaleString("ko-KR")}</p>
      </div>

      <Tabs defaultValue="backtest">
        <TabsList className="grid w-full grid-cols-2 max-w-lg no-print">
          <TabsTrigger value="backtest">정확도 검증 백테스트</TabsTrigger>
          <TabsTrigger value="learning">합성 인구 학습</TabsTrigger>
        </TabsList>

        <TabsContent value="backtest" className="mt-6 space-y-8">
          <Tabs defaultValue="dynamo">
            <TabsList className="grid w-full grid-cols-3 max-w-xl no-print">
              <TabsTrigger value="dynamo">정치</TabsTrigger>
              <TabsTrigger value="lumen">비즈니스</TabsTrigger>
              <TabsTrigger value="seraph">정부</TabsTrigger>
            </TabsList>

            <TabsContent value="dynamo" className="mt-6 space-y-8">
              <ElectionCalibrationView />
              {dynamoEvents.length > 0 && (
                <div className="space-y-4">
                  <h2 className="text-lg font-semibold">추가 검증 이벤트 (수동)</h2>
                  <EventBacktestView
                    events={dynamoEvents}
                    domainLabel="정치"
                    groundTruthHint="과거 선거·여론조사의 실제 결과"
                  />
                </div>
              )}
            </TabsContent>

            <TabsContent value="lumen" className="mt-6">
              <EventBacktestView
                events={lumenEvents}
                domainLabel="비즈니스"
                groundTruthHint="과거 제품 출시·캠페인의 실제 판매·전환·반응 지표"
              />
            </TabsContent>

            <TabsContent value="seraph" className="mt-6">
              <EventBacktestView
                events={seraphEvents}
                domainLabel="정부"
                groundTruthHint="과거 정책의 실제 수용률·찬성률 등 행정 지표"
              />
            </TabsContent>
          </Tabs>
        </TabsContent>

        <TabsContent value="learning" className="mt-6 space-y-8">
          <AccuracyTrendLearning />
          <CalibrationLoopHub calibrations={calibrations} />
        </TabsContent>
      </Tabs>
    </div>
  );
}
