import { useGetDashboardSummary } from "@workspace/api-client-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Link } from "wouter";
import { Users, Activity, BarChart3, Database, Box, Beaker, Play, CheckCircle2 } from "lucide-react";
import { Badge } from "@/components/ui/badge";

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
            <div className="text-2xl font-bold">${(summary.totalSpendUsd * 10).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</div>
          </CardContent>
        </Card>
      </div>

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
