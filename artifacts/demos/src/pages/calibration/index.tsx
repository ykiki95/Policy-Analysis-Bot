import { useListCalibrations, useGetElectionCalibration, type Calibration } from "@workspace/api-client-react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, Legend, ResponsiveContainer } from "recharts";
import { Info, FlaskConical } from "lucide-react";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";

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
              <BarChart data={chartData} margin={{ top: 20, right: 20, left: 0, bottom: 5 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} opacity={0.3} />
                <XAxis dataKey="name" tick={{ fontSize: 11 }} interval={0} angle={-35} textAnchor="end" height={60} />
                <YAxis tickFormatter={(v) => `${v}`} />
                <RechartsTooltip cursor={{ fill: "rgba(0,0,0,0.05)" }} />
                <Legend />
                <Bar dataKey="rawError" name="원시 오차" fill="hsl(var(--muted-foreground))" radius={[4, 4, 0, 0]} />
                <Bar dataKey="calibratedError" name="보정 오차" fill="hsl(var(--primary))" radius={[4, 4, 0, 0]} />
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
              <BarChart data={chartData} margin={{ top: 20, right: 20, left: 0, bottom: 5 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} opacity={0.3} />
                <XAxis dataKey="name" tick={{ fontSize: 11 }} interval={0} angle={-20} textAnchor="end" height={70} />
                <YAxis tickFormatter={(v) => `${v}`} />
                <RechartsTooltip cursor={{ fill: "rgba(0,0,0,0.05)" }} />
                <Legend />
                <Bar dataKey="rawError" name="원시 오차" fill="hsl(var(--muted-foreground))" radius={[4, 4, 0, 0]} />
                <Bar dataKey="calibratedError" name="보정 오차" fill="hsl(var(--primary))" radius={[4, 4, 0, 0]} />
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
      <div>
        <h1 className="text-3xl font-bold tracking-tight">보정 및 검증</h1>
        <p className="text-muted-foreground mt-1">제품 라인별로 모델 예측을 실측 결과와 비교·보정합니다</p>
      </div>

      <Tabs defaultValue="dynamo">
        <TabsList className="grid w-full grid-cols-3 max-w-xl">
          <TabsTrigger value="dynamo">정치 (Dynamo)</TabsTrigger>
          <TabsTrigger value="lumen">비즈니스 (Lumen)</TabsTrigger>
          <TabsTrigger value="seraph">정부 (Seraph)</TabsTrigger>
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
    </div>
  );
}
