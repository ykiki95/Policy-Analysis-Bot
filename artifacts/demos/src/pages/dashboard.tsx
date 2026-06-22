import { useGetDashboardSummary } from "@workspace/api-client-react";
import { useAccuracyTrend } from "@/lib/accuracyTrend";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Link } from "wouter";
import { Users, Activity, Beaker, CheckCircle2, Microscope, Sparkles, ArrowRight, ArrowDown } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { formatCost } from "@/lib/cost";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip as RechartsTooltip,
  Legend,
  ResponsiveContainer,
} from "recharts";

const LOOP_STEPS = [
  { icon: Users, title: "합성 인구", desc: "서울·전국 합성 시민" },
  { icon: Beaker, title: "예측", desc: "LLM 시뮬레이션" },
  { icon: Microscope, title: "실제 결과", desc: "검증 이벤트·개표" },
  { icon: Sparkles, title: "보정·학습", desc: "편향 교정 후 환류" },
];

/** 합성 인구 → 예측 → 실제 결과 → 보정·학습으로 순환하는 폐루프 다이어그램. */
function FeedbackLoopDiagram() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>예측-검증 피드백 루프</CardTitle>
        <CardDescription>
          합성 인구로 예측하고, 실제 결과와 비교해 편향을 학습한 뒤 다시 인구에 반영하는 폐루프입니다.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <div className="flex flex-col md:flex-row md:items-stretch gap-2">
          {LOOP_STEPS.map((s, i) => (
            <div key={s.title} className="flex flex-col md:flex-row md:items-center gap-2 md:flex-1">
              <div className="flex-1 rounded-lg border bg-card p-4">
                <s.icon className="h-5 w-5 text-primary mb-2" />
                <div className="font-semibold text-sm">{s.title}</div>
                <p className="text-xs text-muted-foreground mt-1 leading-relaxed">{s.desc}</p>
              </div>
              {i < LOOP_STEPS.length - 1 && (
                <>
                  <ArrowRight className="hidden md:block h-5 w-5 text-muted-foreground shrink-0" />
                  <ArrowDown className="md:hidden h-5 w-5 text-muted-foreground self-center" />
                </>
              )}
            </div>
          ))}
        </div>
        <div className="mt-3 flex items-center justify-center gap-2 text-xs text-muted-foreground">
          <RefreshIndicator />
          보정·학습 결과는 다음 인구 재생성부터 합성 인구 기준선에 환류됩니다.
        </div>
      </CardContent>
    </Card>
  );
}

function RefreshIndicator() {
  return <Sparkles className="h-3.5 w-3.5 text-primary" />;
}

/** 검증 이벤트(보정 데이터) 기반 정확도 추이 — 원시 vs 보정 정확도(100−오차). */
function AccuracyTrend() {
  const { points: chartData, isLoading } = useAccuracyTrend();

  if (isLoading) {
    return <Skeleton className="h-72 w-full" />;
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>정확도 추이</CardTitle>
        <CardDescription>검증 이벤트별 원시·보정 정확도(100−오차%p)</CardDescription>
      </CardHeader>
      <CardContent>
        {chartData.length === 0 ? (
          <div className="py-16 text-center text-sm text-muted-foreground">
            검증 이벤트가 없습니다. 보정 및 검증에서 실측 이벤트를 등록하면 추이가 표시됩니다.
          </div>
        ) : (
          <div className="h-72 w-full">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={chartData} margin={{ top: 10, right: 20, left: 0, bottom: 5 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} opacity={0.3} />
                <XAxis dataKey="name" tick={{ fontSize: 11 }} />
                <YAxis domain={[0, 100]} tickFormatter={(v) => `${v}`} />
                <RechartsTooltip />
                <Legend />
                <Line type="monotone" dataKey="rawAccuracy" name="원시 정확도" stroke="hsl(var(--muted-foreground))" strokeWidth={2} dot={{ r: 3 }} />
                <Line type="monotone" dataKey="calibratedAccuracy" name="보정 정확도" stroke="hsl(var(--primary))" strokeWidth={2} dot={{ r: 3 }} />
              </LineChart>
            </ResponsiveContainer>
          </div>
        )}
      </CardContent>
    </Card>
  );
}

export default function Dashboard() {
  const { data: summary, isLoading } = useGetDashboardSummary();

  if (isLoading || !summary) {
    return (
      <div className="space-y-6">
        <div className="space-y-2">
          <Skeleton className="h-10 w-48" />
          <Skeleton className="h-5 w-64" />
        </div>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          <Skeleton className="h-32 w-full" />
          <Skeleton className="h-32 w-full" />
          <Skeleton className="h-32 w-full" />
          <Skeleton className="h-32 w-full" />
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">대시보드</h1>
        <p className="text-muted-foreground mt-1">합성 인구 및 시뮬레이션 개요</p>
      </div>

      <FeedbackLoopDiagram />

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">총 에이전트 수</CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{summary.totalAgents.toLocaleString()}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">실행된 시뮬레이션</CardTitle>
            <Beaker className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{summary.totalSimulations}</div>
            <p className="text-xs text-muted-foreground mt-1">
              완료: {summary.completedSimulations}
            </p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">평균 보정 정확도</CardTitle>
            <CheckCircle2 className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{summary.avgCalibratedAccuracy.toFixed(1)}%</div>
            <p className="text-xs text-muted-foreground mt-1">
              원시: {summary.avgRawAccuracy.toFixed(1)}%
            </p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">총 비용</CardTitle>
            <Activity className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{formatCost(summary.totalSpendUsd)}</div>
          </CardContent>
        </Card>
      </div>

      <AccuracyTrend />

      <div className="grid gap-4 md:grid-cols-2">
        <Card className="col-span-2">
          <CardHeader>
            <CardTitle>최근 시뮬레이션</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {summary.recentSimulations.length === 0 ? (
                <div className="text-center py-6 text-muted-foreground">
                  시뮬레이션 기록이 없습니다.
                </div>
              ) : (
                summary.recentSimulations.map((sim) => (
                  <Link key={sim.id} href={`/simulations/${sim.id}`} className="block">
                    <div className="flex items-center justify-between p-4 border rounded-lg hover:bg-accent/50 transition-colors">
                      <div className="space-y-1">
                        <div className="flex items-center gap-2">
                          <span className="font-semibold">{sim.title}</span>
                          <Badge variant={sim.status === "completed" ? "default" : sim.status === "running" ? "secondary" : "outline"}>
                            {sim.status === "completed" ? "완료" : sim.status === "running" ? "실행 중" : "대기 중"}
                          </Badge>
                        </div>
                        <div className="text-sm text-muted-foreground flex gap-3">
                          <span>{sim.product}</span>
                          <span>•</span>
                          <span>{sim.audience}</span>
                        </div>
                      </div>
                      {sim.status === "completed" && sim.overallSupport != null && (
                        <div className="text-right">
                          <div className="text-sm font-medium text-green-600 dark:text-green-400">
                            찬성 {sim.supportPct}%
                          </div>
                          <div className="text-xs text-muted-foreground">
                            반대 {sim.opposePct}%
                          </div>
                        </div>
                      )}
                    </div>
                  </Link>
                ))
              )}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
