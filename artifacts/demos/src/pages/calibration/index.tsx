import {
  useListCalibrations,
  useGetElectionCalibration,
  useGetCalibrationSettings,
  useUpdateCalibrationSettings,
  getGetCalibrationSettingsQueryKey,
  type Calibration,
} from "@workspace/api-client-react";
import { useQueryClient } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, Legend, ResponsiveContainer } from "recharts";
import { Info, FlaskConical, FlaskRound, Microscope, RefreshCw, Sparkles, Printer } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";

const PRODUCT_META: { key: string; product: string; label: string; track: string }[] = [
  { key: "Dynamo", product: "Dynamo", label: "정치", track: "정치성향 기준선" },
  { key: "Lumen", product: "Lumen", label: "비즈니스", track: "소비 성향 기준선" },
  { key: "Seraph", product: "Seraph", label: "정부", track: "정책 태도 기준선" },
];

/**
 * 보정 루프 허브 — 두 레버(출력 보정·입력 보정)와 4단계 피드백 루프를
 * 한눈에 보여주고, 입력 보정 토글(applyToPopulation)을 제어한다.
 * 제품별 평균 편향(actual-raw)을 클라이언트에서 계산해 기준선 이동 방향을 미리 보여준다.
 */
function CalibrationLoopHub({ calibrations }: { calibrations: Calibration[] }) {
  const { data: settings } = useGetCalibrationSettings();
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
              <Switch
                id="apply-to-pop"
                checked={applyToPopulation}
                onCheckedChange={handleToggle}
                disabled={!settings || update.isPending}
              />
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

function ElectionCalibrationView() {
  const { data, isLoading } = useGetElectionCalibration();

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

  if (data.rows.length === 0) {
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

  const chartData = data.rows
    .filter((r) => r.leaning === "conservative")
    .map((r) => ({
      name: r.regionName.replace(/(특별자치도|특별자치시|특별시|광역시|도)$/u, ""),
      rawError: r.rawError,
      calibratedError: r.calibratedError,
    }));

  return (
    <div className="space-y-6">
      <Alert>
        <Info className="h-4 w-4" />
        <AlertTitle>실제 선거 결과 기반 검증 (자동)</AlertTitle>
        <AlertDescription>
          합성 인구의 투표 성향(투표 의향 가중 로지스틱)으로 시·도별 득표율을 예측한 뒤,
          실제 <strong>{data.rows[0]?.electionName ?? "과거 선거"}</strong> 결과와 비교합니다.
          공개된 개표 결과가 정답이므로 별도 입력 없이 현재 합성 인구로 매번 다시 계산됩니다.
          사후 층화·축소(shrinkage {data.shrinkageFactor})로 원시 예측을 보정합니다.
        </AlertDescription>
      </Alert>

      <div className="grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader className="pb-2"><CardTitle className="text-sm font-medium">보정 방법</CardTitle></CardHeader>
          <CardContent><div className="text-base font-semibold">{data.method}</div></CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2"><CardTitle className="text-sm font-medium">평균 원시 오차</CardTitle></CardHeader>
          <CardContent><div className="text-3xl font-bold text-muted-foreground">{data.avgRawError.toFixed(2)}%p</div></CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2"><CardTitle className="text-sm font-medium">평균 보정 오차</CardTitle></CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-primary">{data.avgCalibratedError.toFixed(2)}%p</div>
            <p className="text-xs text-muted-foreground mt-1">사후 층화 보정 후</p>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>시·도별 예측 오차 (보수 후보 득표율)</CardTitle>
          <CardDescription>원시 예측과 보정 예측의 오차(%p) 비교</CardDescription>
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
          <CardDescription>{data.rows[0]?.electionName} · {data.rows[0]?.electionDate}</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="border rounded-md overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>지역</TableHead>
                  <TableHead>진영</TableHead>
                  <TableHead className="text-right">실제</TableHead>
                  <TableHead className="text-right">원시 예측</TableHead>
                  <TableHead className="text-right">보정 예측</TableHead>
                  <TableHead className="text-right">원시 오차</TableHead>
                  <TableHead className="text-right">보정 오차</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {data.rows.map((r) => (
                  <TableRow key={`${r.electionId}-${r.regionCode}-${r.leaning}`}>
                    <TableCell className="font-medium">{r.regionName}</TableCell>
                    <TableCell>
                      <Badge variant={r.leaning === "conservative" ? "destructive" : "default"}>
                        {r.leaning === "conservative" ? "보수" : "진보"}
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
            등록된 {domainLabel} 검증 이벤트가 없습니다.<br />
            <span className="mt-1 inline-block">
              관리자 → 검증 이벤트에서 제품 라인을 <strong>{domainLabel}</strong>으로 선택해 과거 이벤트를 추가하면 백테스트가 생성됩니다.
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
          <CardTitle>검증 이벤트 상세</CardTitle>
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

        <TabsContent value="learning" className="mt-6">
          <CalibrationLoopHub calibrations={calibrations} />
        </TabsContent>
      </Tabs>
    </div>
  );
}
