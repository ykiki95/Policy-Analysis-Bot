import { useListCalibrations } from "@workspace/api-client-react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, Legend, ResponsiveContainer } from "recharts";
import { Info } from "lucide-react";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";

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

  const avgRawError = calibrations.reduce((acc, curr) => acc + curr.rawError, 0) / calibrations.length;
  const avgCalError = calibrations.reduce((acc, curr) => acc + curr.calibratedError, 0) / calibrations.length;

  const chartData = calibrations.map(c => ({
    name: c.title,
    rawError: c.rawError,
    calibratedError: c.calibratedError
  }));

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">보정 및 검증</h1>
        <p className="text-muted-foreground mt-1">과거 가상 이벤트 기반의 모델 신뢰도 평가</p>
      </div>

      <Alert>
        <Info className="h-4 w-4" />
        <AlertTitle>신뢰도의 근거</AlertTitle>
        <AlertDescription>
          본 플랫폼은 지속적인 검증 루프를 통해 모델의 예측값을 보정합니다. 
          원시 예측(Raw Prediction)에 대비해 보정 예측(Calibrated Prediction)의 오차가 현저히 낮음을 확인할 수 있습니다.
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
        </CardContent>
      </Card>

      <div className="space-y-4">
        <h3 className="text-lg font-semibold">검증 이벤트 내역</h3>
        <div className="grid gap-4">
          {calibrations.map((cal) => (
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
    </div>
  );
}
