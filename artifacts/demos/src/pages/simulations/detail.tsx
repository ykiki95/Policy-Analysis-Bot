import { useState } from "react";
import { useGetSimulation, getGetSimulationQueryKey, useListSimulationResponses, getListSimulationResponsesQueryKey, useDeleteSimulation, getListSimulationsQueryKey } from "@workspace/api-client-react";
import { useParams, Link, useLocation } from "wouter";
import { useQueryClient } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { ArrowLeft, Clock, CheckCircle2, Trash2, Loader2, DollarSign } from "lucide-react";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, ResponsiveContainer, Legend } from "recharts";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";

export default function SimulationDetail() {
  const params = useParams();
  const id = parseInt(params.id || "0", 10);
  const [, setLocation] = useLocation();
  const queryClient = useQueryClient();

  const { data: simDetail, isLoading } = useGetSimulation(id, {
    query: { 
      enabled: !!id, 
      queryKey: getGetSimulationQueryKey(id),
      // Poll every 1s if running or pending
      refetchInterval: (query) => {
        const status = query.state.data?.simulation.status;
        return status === "running" || status === "pending" ? 1000 : false;
      }
    }
  });

  const { data: responses, isLoading: responsesLoading } = useListSimulationResponses(id, {
    query: {
      enabled: !!id && simDetail?.simulation.status === "completed",
      queryKey: getListSimulationResponsesQueryKey(id)
    }
  });

  const deleteMut = useDeleteSimulation();

  if (isLoading || !simDetail) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-24" />
        <Skeleton className="h-24 w-full" />
        <Skeleton className="h-[400px] w-full" />
      </div>
    );
  }

  const sim = simDetail.simulation;
  const isRunning = sim.status === "running" || sim.status === "pending";

  const handleDelete = () => {
    deleteMut.mutate({ id }, {
      onSuccess: () => {
        queryClient.invalidateQueries({ queryKey: getListSimulationsQueryKey() });
        setLocation("/simulations");
      }
    });
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <Link href="/simulations" className="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground transition-colors">
          <ArrowLeft className="h-4 w-4" />
          목록으로 돌아가기
        </Link>
        <AlertDialog>
          <AlertDialogTrigger asChild>
            <Button variant="ghost" size="sm" className="text-destructive hover:text-destructive hover:bg-destructive/10">
              <Trash2 className="h-4 w-4 mr-2" /> 삭제
            </Button>
          </AlertDialogTrigger>
          <AlertDialogContent>
            <AlertDialogHeader>
              <AlertDialogTitle>시뮬레이션을 삭제하시겠습니까?</AlertDialogTitle>
              <AlertDialogDescription>
                이 작업은 되돌릴 수 없습니다. 관련된 모든 응답 데이터가 함께 삭제됩니다.
              </AlertDialogDescription>
            </AlertDialogHeader>
            <AlertDialogFooter>
              <AlertDialogCancel>취소</AlertDialogCancel>
              <AlertDialogAction onClick={handleDelete} className="bg-destructive text-destructive-foreground">삭제</AlertDialogAction>
            </AlertDialogFooter>
          </AlertDialogContent>
        </AlertDialog>
      </div>

      <div className="bg-card border rounded-xl p-6 shadow-sm">
        <div className="flex justify-between items-start gap-4">
          <div>
            <div className="flex items-center gap-3 mb-2">
              <h1 className="text-3xl font-bold tracking-tight">{sim.title}</h1>
              {sim.status === "completed" ? (
                <Badge className="bg-green-500"><CheckCircle2 className="w-3 h-3 mr-1"/> 완료됨</Badge>
              ) : (
                <Badge variant="secondary" className="animate-pulse"><Clock className="w-3 h-3 mr-1"/> 진행 중</Badge>
              )}
            </div>
            <div className="text-sm text-muted-foreground flex gap-3 mt-4">
              <span className="font-medium text-foreground">{sim.product}</span>
              <span>•</span>
              <span>{sim.audience} 대상</span>
              <span>•</span>
              <span>모델: {sim.model}</span>
            </div>
          </div>
          <div className="text-right">
            <p className="text-xs text-muted-foreground mb-1">소요 비용</p>
            <div className="flex items-center justify-end gap-1 text-xl font-semibold">
              <DollarSign className="w-5 h-5 text-muted-foreground" />
              {sim.costActualUsd ? sim.costActualUsd.toFixed(2) : sim.costEstimateUsd.toFixed(2)}
            </div>
          </div>
        </div>

        {isRunning && (
          <div className="mt-8 space-y-2 bg-muted/30 p-4 rounded-lg">
            <div className="flex justify-between text-sm">
              <span className="flex items-center gap-2 font-medium">
                <Loader2 className="w-4 h-4 animate-spin text-primary" />
                에이전트 반응 생성 중...
              </span>
              <span className="font-bold">{sim.progress}%</span>
            </div>
            <Progress value={sim.progress} className="h-2" />
          </div>
        )}

        <div className="mt-6 pt-6 border-t border-border">
          <h3 className="text-sm font-semibold mb-2">제시된 정책/메시지:</h3>
          <p className="text-sm text-muted-foreground whitespace-pre-wrap p-4 bg-muted/20 rounded-md">
            {sim.policyText}
          </p>
        </div>
      </div>

      {sim.status === "completed" && simDetail.results && (
        <>
          <div className="grid md:grid-cols-3 gap-6">
            <Card className="bg-primary text-primary-foreground border-primary">
              <CardContent className="p-6">
                <p className="text-sm font-medium opacity-80 mb-2">전체 찬성률</p>
                <div className="text-5xl font-bold">{sim.supportPct}%</div>
                <div className="mt-4 text-sm opacity-80 flex justify-between">
                  <span>반대: {sim.opposePct}%</span>
                  <span>중립: {sim.neutralPct}%</span>
                </div>
              </CardContent>
            </Card>

            <Card className="md:col-span-2">
              <CardHeader className="pb-2">
                <CardTitle className="text-sm font-medium">정치 성향별 지지율</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="h-[120px] w-full">
                  <ResponsiveContainer>
                    <BarChart data={simDetail.results.byLeaning} layout="vertical" margin={{ left: 10, right: 10 }}>
                      <XAxis type="number" hide />
                      <YAxis dataKey="key" type="category" axisLine={false} tickLine={false} fontSize={12} width={60} />
                      <RechartsTooltip cursor={{fill: 'rgba(0,0,0,0.05)'}} />
                      <Bar dataKey="supportPct" stackId="a" fill="#22c55e" name="찬성 %" />
                      <Bar dataKey="neutralPct" stackId="a" fill="#9ca3af" name="중립 %" />
                      <Bar dataKey="opposePct" stackId="a" fill="#ef4444" name="반대 %" />
                    </BarChart>
                  </ResponsiveContainer>
                </div>
              </CardContent>
            </Card>
          </div>

          <Card>
            <CardHeader>
              <CardTitle>연령대별 반응</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="h-[250px] w-full">
                <ResponsiveContainer>
                  <BarChart data={simDetail.results.byAgeBracket} margin={{ top: 20, right: 0, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} opacity={0.3} />
                    <XAxis dataKey="key" tick={{fontSize: 12}} />
                    <YAxis tick={{fontSize: 12}} />
                    <RechartsTooltip cursor={{fill: 'rgba(0,0,0,0.05)'}} />
                    <Legend />
                    <Bar dataKey="supportPct" name="찬성률 (%)" fill="hsl(var(--primary))" radius={[4, 4, 0, 0]} />
                    <Bar dataKey="opposePct" name="반대률 (%)" fill="hsl(var(--destructive))" radius={[4, 4, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>에이전트 개별 응답 샘플</CardTitle>
              <CardDescription>가장 확신도가 높은 응답 샘플입니다.</CardDescription>
            </CardHeader>
            <CardContent>
              {responsesLoading ? (
                <Skeleton className="h-64 w-full" />
              ) : (
                <div className="border rounded-md overflow-hidden">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>이름</TableHead>
                        <TableHead>연령/성별</TableHead>
                        <TableHead>입장</TableHead>
                        <TableHead>신뢰도</TableHead>
                        <TableHead className="w-1/2">추론 근거 (Reasoning)</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {responses?.map((res) => (
                        <TableRow key={res.id}>
                          <TableCell className="font-medium whitespace-nowrap">
                            <Link href={`/population/${res.agentId}`} className="hover:underline">
                              {res.agentName}
                            </Link>
                          </TableCell>
                          <TableCell className="whitespace-nowrap">{res.ageBracket} / {res.gender === 'Male' ? '남성' : '여성'}</TableCell>
                          <TableCell className="whitespace-nowrap">
                            <Badge variant={res.stance === 'Support' ? 'default' : res.stance === 'Oppose' ? 'destructive' : 'secondary'}>
                              {res.stance}
                            </Badge>
                          </TableCell>
                          <TableCell>{res.confidence}%</TableCell>
                          <TableCell className="text-xs text-muted-foreground">
                            {res.reasoning}
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </div>
              )}
            </CardContent>
          </Card>
        </>
      )}
    </div>
  );
}
