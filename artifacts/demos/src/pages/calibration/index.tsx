import { useListCalibrations, useGetElectionCalibration } from "@workspace/api-client-react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, Legend, ResponsiveContainer } from "recharts";
import { Info } from "lucide-react";
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
        <AlertTitle>실제 선거 결과 기반 검증</AlertTitle>
        <AlertDescription>
          합성 인구의 투표 성향(투표 의향 가중 로지스틱)으로 시·도별 득표율을 예측한 뒤,
          실제 <strong>{data.rows[0]?.electionName ?? "과거 선거"}</strong> 결과와 비교합니다.
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

  const hasEvents = calibrations.length > 0;
  const avgRawError = hasEvents ? calibrations.reduce((acc, curr) => acc + curr.rawError, 0) / calibrations.length : 0;
  const avgCalError = hasEvents ? calibrations.reduce((acc, curr) => acc + curr.calibratedError, 0) / calibrations.length : 0;

  const sortedAsc = [...calibrations].sort(
    (a, b) => new Date(a.targetDate).getTime() - new Date(b.targetDate).getTime()
  );
  const sortedDesc = [...sortedAsc].reverse();

  const chartData = sortedAsc.map(c => ({
    name: c.title,
    rawError: c.rawError,
    calibratedError: c.calibratedError
  }));

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">보정 및 검증</h1>
        <p className="text-muted-foreground mt-1">실제 선거 결과 및 과거 가상 이벤트 기반의 모델 신뢰도 평가</p>
      </div>

      <Tabs defaultValue="elections">
        <TabsList className="grid w-full grid-cols-2 max-w-md">
          <TabsTrigger value="elections">실제 선거 검증</TabsTrigger>
          <TabsTrigger value="events">가상 이벤트 검증</TabsTrigger>
        </TabsList>

        <TabsContent value="elections" className="mt-6">
          <ElectionCalibrationView />
        </TabsContent>

        <TabsContent value="events" className="mt-6 space-y-8">
      <Alert>
        <Info className="h-4 w-4" />
        <AlertTitle>신뢰도의 근거</AlertTitle>
        <AlertDescription>
          본 플랫폼은 지속적인 검증 루프를 통해 모델의 예측값을 보정합니다. 
          원시 예측(Raw Prediction)에 대비해 보정 예측(Calibrated Prediction)의 오차가 현저히 낮음을 확인할 수 있습니다.
          <span className="mt-2 block">
            <strong>설문 기준</strong>은 합성 인구의 <em>태도를 형성</em>하는 입력 데이터이고,
            아래 <strong>검증 이벤트</strong>는 결과가 이미 알려진 과거 사건으로 <em>모델의 예측 정확도를 사후 검증·보정</em>하는 데 쓰입니다. 두 데이터는 역할이 다르므로 개수도 서로 무관합니다.
          </span>
        </AlertDescription>
      </Alert>

      <div className="grid gap-4 md:grid-cols-2">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium">평균 원시 오차</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-muted-foreground">{avgRawError.toFixed(2)}%</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium">평균 보정 오차</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-primary">{avgCalError.toFixed(2)}%</div>
            <p className="text-xs text-muted-foreground mt-1">보정 후 정확도 향상</p>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>이벤트별 예측 오차 비교</CardTitle>
          <CardDescription>원시 예측과 보정 예측의 오차율(%) 비교</CardDescription>
        </CardHeader>
        <CardContent>
          {hasEvents ? (
            <div className="h-[400px] w-full">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={chartData} margin={{ top: 20, right: 30, left: 0, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} opacity={0.3} />
                  <XAxis dataKey="name" tick={{fontSize: 12}} />
                  <YAxis tickFormatter={(val) => `${val}%`} />
                  <RechartsTooltip cursor={{fill: 'rgba(0,0,0,0.05)'}} />
                  <Legend />
                  <Bar dataKey="rawError" name="원시 오차" fill="hsl(var(--muted-foreground))" radius={[4, 4, 0, 0]} />
                  <Bar dataKey="calibratedError" name="보정 오차" fill="hsl(var(--primary))" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          ) : (
            <p className="text-sm text-muted-foreground py-16 text-center">
              등록된 검증 이벤트가 없습니다. 관리자 → 검증 이벤트에서 과거 이벤트를 추가하세요.
            </p>
          )}
        </CardContent>
      </Card>

      <div className="space-y-4">
        <h3 className="text-lg font-semibold">검증 이벤트 내역</h3>
        {!hasEvents && (
          <p className="text-sm text-muted-foreground">등록된 검증 이벤트가 없습니다.</p>
        )}
        <div className="grid gap-4">
          {sortedDesc.map((cal) => (
            <Card key={cal.id}>
              <CardContent className="p-4 flex flex-col md:flex-row items-center justify-between gap-4">
                <div>
                  <h4 className="font-semibold">{cal.title}</h4>
                  <div className="text-sm text-muted-foreground flex gap-2 mt-1">
                    <span>{cal.targetDate}</span>
                    <span>•</span>
                    <span>{cal.metric}</span>
                  </div>
                </div>
                <div className="flex items-center gap-6 text-sm text-right">
                  <div>
                    <p className="text-muted-foreground mb-1">실제값</p>
                    <p className="font-medium">{cal.actualValue}%</p>
                  </div>
                  <div>
                    <p className="text-muted-foreground mb-1">원시 예측</p>
                    <p className="font-medium">{cal.rawPrediction}%</p>
                  </div>
                  <div className="bg-primary/10 px-3 py-1 rounded-md">
                    <p className="text-primary font-medium mb-1">보정 예측</p>
                    <p className="font-bold text-primary">{cal.calibratedPrediction}%</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
        </TabsContent>
      </Tabs>
    </div>
  );
}
