import { useState, useMemo, useEffect, useRef } from "react";
import { useGetSimulation, getGetSimulationQueryKey, useListSimulationResponses, getListSimulationResponsesQueryKey, useDeleteSimulation, getListSimulationsQueryKey, useTickSimulation, useRunSimulation, useGetBudget } from "@workspace/api-client-react";
import { runErrorMessage } from "@/lib/utils";
import { useParams, Link, useLocation } from "wouter";
import { useQueryClient } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Progress } from "@/components/ui/progress";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { ArrowLeft, Clock, CheckCircle2, Trash2, Loader2, DollarSign, Search, ChevronLeft, ChevronRight, Sparkles } from "lucide-react";
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

const ageStart = (key: string) => {
  const m = key.match(/\d+/);
  return m ? parseInt(m[0], 10) : 999;
};
const RESPONSES_PAGE_SIZE = 20;

/** 제품(내부 브랜드값) → 도메인 표시 라벨(비즈니스/정부/정치). */
function productDomainLabel(product: string): string {
  return product === "Lumen" ? "비즈니스" : product === "Seraph" ? "정부" : "정치";
}

/** 남은 초 → 사람이 읽기 좋은 한국어 표기. */
function formatEta(totalSeconds: number): string {
  if (totalSeconds <= 0) return "곧 완료";
  if (totalSeconds < 60) return `약 ${totalSeconds}초`;
  const m = Math.floor(totalSeconds / 60);
  const s = totalSeconds % 60;
  if (m < 60) return s > 0 ? `약 ${m}분 ${s}초` : `약 ${m}분`;
  const h = Math.floor(m / 60);
  return `약 ${h}시간 ${m % 60}분`;
}

export default function SimulationDetail() {
  const params = useParams();
  const id = parseInt(params.id || "0", 10);
  const [, setLocation] = useLocation();
  const queryClient = useQueryClient();
  const [resSearch, setResSearch] = useState("");
  const [resPage, setResPage] = useState(1);

  const { data: simDetail, isLoading } = useGetSimulation(id, {
    query: { 
      enabled: !!id, 
      queryKey: getGetSimulationQueryKey(id),
      // Poll every 1s if running or pending
      refetchInterval: (query) => {
        const status = query.state.data?.simulation.status;
        return status === "running" || status === "queued" ? 1000 : false;
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
  const tickMut = useTickSimulation();
  const runMut = useRunSimulation();
  const { data: budget } = useGetBudget();
  const [runError, setRunError] = useState<string | null>(null);

  // 클라이언트 구동(B1) 처리: 이 화면을 열어 두는 동안 시뮬레이션을 한 배치씩
  // 전진시킨다. /tick 요청이 서버에서 에이전트 일부를 평가하고 진행률을 갱신하면,
  // 위의 GET 폴링이 새 진행률을 가져온다. 한 번에 하나의 tick만 진행하도록 ref로
  // 직렬화한다(겹친 호출은 서버에서도 즉시 반환되지만 요청 자체를 줄인다).
  const status = simDetail?.simulation.status;
  const tickingRef = useRef(false);
  useEffect(() => {
    if (!id) return;
    if (status !== "queued" && status !== "running") return;

    const advance = () => {
      if (tickingRef.current) return;
      tickingRef.current = true;
      tickMut.mutate(
        { id },
        {
          onSettled: () => {
            tickingRef.current = false;
            queryClient.invalidateQueries({ queryKey: getGetSimulationQueryKey(id) });
          },
        },
      );
    };

    advance(); // 화면 진입 즉시 첫 배치 시작
    const timer = setInterval(advance, 1500);
    return () => clearInterval(timer);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id, status]);

  // 예상 남은 시간(ETA): 화면을 보는 동안 관측한 진행 속도로 추정한다. 진행은
  // 이 화면이 열려 있을 때만 일어나므로(B1), 현재 세션의 처리 속도가 곧 ETA의 근거다.
  const progress = simDetail?.simulation.progress ?? 0;
  const totalAgents = simDetail?.simulation.totalAgents ?? 0;
  const etaSamplesRef = useRef<{ t: number; done: number }[]>([]);
  const [etaSeconds, setEtaSeconds] = useState<number | null>(null);
  useEffect(() => {
    if (status !== "running" && status !== "queued") {
      etaSamplesRef.current = [];
      setEtaSeconds(null);
      return;
    }
    if (totalAgents <= 0) return;
    const done = Math.round((progress / 100) * totalAgents);
    const samples = etaSamplesRef.current;
    const last = samples[samples.length - 1];
    if (!last || last.done !== done) {
      samples.push({ t: Date.now(), done });
      if (samples.length > 8) samples.shift();
    }
    if (samples.length >= 2) {
      const first = samples[0];
      const latest = samples[samples.length - 1];
      const dDone = latest.done - first.done;
      const dT = latest.t - first.t;
      if (dDone > 0 && dT > 500) {
        const remaining = Math.max(0, totalAgents - latest.done);
        setEtaSeconds(Math.round(remaining / (dDone / dT) / 1000));
      }
    }
  }, [status, progress, totalAgents]);

  const ageChartData = useMemo(() => {
    const rows = simDetail?.results?.byAgeBracket;
    if (!rows) return [];
    return [...rows].sort((a, b) => ageStart(a.key) - ageStart(b.key));
  }, [simDetail]);

  const filteredResponses = useMemo(() => {
    if (!responses) return [];
    const q = resSearch.trim();
    if (!q) return responses;
    return responses.filter(
      (r) => r.agentName.includes(q) || r.reasoning.includes(q),
    );
  }, [responses, resSearch]);

  const resTotalPages = Math.max(1, Math.ceil(filteredResponses.length / RESPONSES_PAGE_SIZE));
  const resCurrentPage = Math.min(resPage, resTotalPages);
  const resPageRows = filteredResponses.slice(
    (resCurrentPage - 1) * RESPONSES_PAGE_SIZE,
    resCurrentPage * RESPONSES_PAGE_SIZE,
  );

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
  const isQueued = sim.status === "queued";
  const isRunning = sim.status === "running" || isQueued;
  const needsRun = sim.status === "pending" || sim.status === "failed";
  const runCost = (sim.costEstimateUsd ?? 0) * 10;
  const insufficientBudget = budget != null && budget.remainingUsd < runCost;
  const completedAgents = Math.min(
    sim.totalAgents,
    Math.round(((sim.progress ?? 0) / 100) * (sim.totalAgents ?? 0)),
  );

  const handleRun = () => {
    setRunError(null);
    runMut.mutate(
      { id },
      {
        onSuccess: () => {
          queryClient.invalidateQueries({ queryKey: getGetSimulationQueryKey(id) });
        },
        onError: (err) => {
          setRunError(runErrorMessage(err));
        },
      },
    );
  };

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
              ) : sim.status === "failed" ? (
                <Badge variant="destructive"><Clock className="w-3 h-3 mr-1"/> 실패</Badge>
              ) : isQueued ? (
                <Badge variant="outline" className="text-amber-600 border-amber-300 animate-pulse"><Clock className="w-3 h-3 mr-1"/> 대기열</Badge>
              ) : sim.status === "pending" ? (
                <Badge variant="outline" className="text-muted-foreground"><Clock className="w-3 h-3 mr-1"/> 미실행</Badge>
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
            <p className="text-xs text-muted-foreground mb-1">
              소요 비용{needsRun && budget ? " / 잔여 예산" : ""}
            </p>
            <div className="flex items-center justify-end gap-1 text-xl font-semibold">
              <DollarSign className="w-5 h-5 text-muted-foreground" />
              <span className={needsRun && insufficientBudget ? "text-destructive" : ""}>
                {((sim.costActualUsd ?? sim.costEstimateUsd) * 10).toFixed(2)}
              </span>
              {needsRun && budget && (
                <>
                  <span className="text-muted-foreground font-normal">/</span>
                  <span className="text-muted-foreground font-normal">{budget.remainingUsd.toFixed(2)}</span>
                </>
              )}
            </div>
          </div>
        </div>

        {needsRun && (
          <div className="mt-8 space-y-3 bg-muted/30 p-4 rounded-lg">
            <div className="flex items-center justify-between gap-4 flex-wrap">
              <div className="text-sm">
                <p className="font-medium">
                  {sim.status === "failed" ? "실행이 중단되었습니다." : "아직 실행되지 않았습니다."}
                </p>
                <p className="text-muted-foreground mt-1">
                  실행하면 {sim.totalAgents.toLocaleString()}명의 합성 에이전트가 반응을 생성합니다. 예상 비용 ${runCost.toFixed(2)}.
                </p>
              </div>
              <Button onClick={handleRun} disabled={runMut.isPending || insufficientBudget}>
                {runMut.isPending ? (
                  <><Loader2 className="w-4 h-4 mr-2 animate-spin" /> 시작하는 중…</>
                ) : (
                  <><Sparkles className="w-4 h-4 mr-2" /> {sim.status === "failed" ? "다시 실행" : "실행"}</>
                )}
              </Button>
            </div>
            <p className="text-xs text-muted-foreground/80 leading-relaxed">
              실행은 이 화면이 열려 있는 동안 진행됩니다. 시작 후 화면을 열어 두세요.
            </p>
            {runError && <p className="text-sm text-destructive">{runError}</p>}
          </div>
        )}

        {isRunning && (
          <div className="mt-8 space-y-3 bg-muted/30 p-4 rounded-lg">
            <div className="flex justify-between text-sm">
              <span className="flex items-center gap-2 font-medium">
                <Loader2 className="w-4 h-4 animate-spin text-primary" />
                {isQueued ? "대기열에서 시작 준비 중..." : "에이전트 반응 생성 중..."}
              </span>
              <span className="font-bold">{sim.progress}%</span>
            </div>
            <Progress value={sim.progress} className="h-2" />
            <div className="flex flex-wrap justify-between gap-x-4 gap-y-1 text-xs text-muted-foreground">
              <span>
                <span className="font-semibold text-foreground">{completedAgents.toLocaleString()}</span>
                {" / "}
                {sim.totalAgents.toLocaleString()} 에이전트 완료
              </span>
              {etaSeconds !== null && (
                <span className="flex items-center gap-1">
                  <Clock className="w-3 h-3" />
                  예상 남은 시간 {formatEta(etaSeconds)}
                </span>
              )}
            </div>
            <p className="text-xs text-muted-foreground/80 leading-relaxed">
              이 화면이 열려 있는 동안만 진행됩니다. 탭을 닫으면 일시정지되고, 다시 열면 이어서 진행됩니다.
            </p>
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
                    <BarChart data={simDetail.results.byLeaning} layout="vertical" margin={{ left: 10, right: 10 }} barCategoryGap="35%">
                      <XAxis type="number" hide />
                      <YAxis dataKey="key" type="category" axisLine={false} tickLine={false} fontSize={12} width={60} />
                      <RechartsTooltip cursor={{fill: 'rgba(0,0,0,0.05)'}} />
                      <Bar dataKey="supportPct" stackId="a" fill="#22c55e" name="찬성 %" maxBarSize={18} />
                      <Bar dataKey="neutralPct" stackId="a" fill="#9ca3af" name="중립 %" maxBarSize={18} />
                      <Bar dataKey="opposePct" stackId="a" fill="#ef4444" name="반대 %" maxBarSize={18} />
                    </BarChart>
                  </ResponsiveContainer>
                </div>
              </CardContent>
            </Card>
          </div>

          {simDetail.calibration && (
            simDetail.calibration.applied &&
            simDetail.calibration.calibratedSupportPct != null ? (
              <Card className="border-primary/40 bg-primary/5">
                <CardHeader>
                  <div className="flex items-center gap-2">
                    <Sparkles className="h-4 w-4 text-primary" />
                    <CardTitle className="text-base">예측 보정 (출력)</CardTitle>
                    <Badge variant="secondary" className="ml-1">자동</Badge>
                  </div>
                  <CardDescription>
                    {productDomainLabel(sim.product)} 도메인의 과거 검증 {simDetail.calibration.eventCount}건에서 학습한 평균 편향
                    {" "}{simDetail.calibration.meanBias > 0 ? "+" : ""}{simDetail.calibration.meanBias}%p를
                    축소 계수 {simDetail.calibration.shrinkage}로 적용해 원시 예측을 교정했습니다.
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-5">
                  <div className="grid grid-cols-2 gap-4 max-w-md">
                    <div className="rounded-lg border bg-card p-4">
                      <p className="text-xs text-muted-foreground mb-1">원시 찬성률</p>
                      <div className="text-3xl font-bold text-muted-foreground">{sim.supportPct}%</div>
                    </div>
                    <div className="rounded-lg border border-primary bg-card p-4">
                      <p className="text-xs text-primary mb-1">보정 찬성률</p>
                      <div className="text-3xl font-bold text-primary">
                        {simDetail.calibration.calibratedSupportPct}%
                      </div>
                      <p className="text-xs text-muted-foreground mt-1">
                        {(() => {
                          const d = simDetail.calibration.calibratedSupportPct - (sim.supportPct ?? 0);
                          return `${d > 0 ? "▲ +" : d < 0 ? "▼ " : ""}${Math.abs(d) < 0.05 ? "0" : d.toFixed(1)}%p`;
                        })()}
                      </p>
                    </div>
                  </div>

                  {simDetail.calibration.events.length > 0 && (
                    <div className="rounded-lg border bg-card/50">
                      <div className="px-4 py-2.5 border-b">
                        <p className="text-sm font-medium">사용된 검증 이벤트</p>
                        <p className="text-xs text-muted-foreground">
                          이 보정에 반영된 과거 실제 결과입니다. 평균 편향(실제−원시)이 보정량의 근거입니다.
                        </p>
                      </div>
                      <Table>
                        <TableHeader>
                          <TableRow>
                            <TableHead>검증 이벤트</TableHead>
                            <TableHead>유형</TableHead>
                            <TableHead className="whitespace-nowrap">기준일</TableHead>
                            <TableHead className="text-right">실제</TableHead>
                            <TableHead className="text-right">원시 예측</TableHead>
                            <TableHead className="text-right">편향(실제−원시)</TableHead>
                          </TableRow>
                        </TableHeader>
                        <TableBody>
                          {simDetail.calibration.events.map((ev) => (
                            <TableRow key={ev.id}>
                              <TableCell className="font-medium">{ev.title}</TableCell>
                              <TableCell>
                                <Badge variant="secondary">{ev.eventType}</Badge>
                              </TableCell>
                              <TableCell className="whitespace-nowrap text-muted-foreground">{ev.targetDate}</TableCell>
                              <TableCell className="text-right tabular-nums">{ev.actualValue}%</TableCell>
                              <TableCell className="text-right tabular-nums text-muted-foreground">{ev.rawPrediction}%</TableCell>
                              <TableCell className={`text-right tabular-nums font-medium ${ev.bias > 0 ? "text-emerald-600 dark:text-emerald-400" : ev.bias < 0 ? "text-rose-600 dark:text-rose-400" : ""}`}>
                                {ev.bias > 0 ? "+" : ""}{ev.bias}%p
                              </TableCell>
                            </TableRow>
                          ))}
                        </TableBody>
                      </Table>
                    </div>
                  )}
                </CardContent>
              </Card>
            ) : (
              <Card className="border-dashed">
                <CardContent className="py-5 flex items-start gap-3 text-sm text-muted-foreground">
                  <Sparkles className="h-4 w-4 mt-0.5 shrink-0" />
                  <span>
                    출력 보정 미적용 — {productDomainLabel(sim.product)} 도메인의 검증 이벤트가{" "}
                    {simDetail.calibration.eventCount}건뿐입니다. 보정 및 검증 화면에서 과거 실제 결과를 2건 이상 등록하면
                    원시 예측을 자동 교정한 <strong>보정 찬성률</strong>이 함께 표시됩니다.
                  </span>
                </CardContent>
              </Card>
            )
          )}

          <Card>
            <CardHeader>
              <CardTitle>연령대별 반응</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="h-[250px] w-full">
                <ResponsiveContainer>
                  <BarChart data={ageChartData} margin={{ top: 20, right: 0, left: -20, bottom: 0 }} barCategoryGap="30%">
                    <CartesianGrid strokeDasharray="3 3" vertical={false} opacity={0.3} />
                    <XAxis dataKey="key" tick={{fontSize: 12}} />
                    <YAxis tick={{fontSize: 12}} />
                    <RechartsTooltip cursor={{fill: 'rgba(0,0,0,0.05)'}} />
                    <Legend />
                    <Bar dataKey="supportPct" name="찬성률 (%)" fill="hsl(var(--primary))" radius={[4, 4, 0, 0]} maxBarSize={32} />
                    <Bar dataKey="opposePct" name="반대률 (%)" fill="hsl(var(--destructive))" radius={[4, 4, 0, 0]} maxBarSize={32} />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </CardContent>
          </Card>

          {simDetail.results.byPolicyAxis && simDetail.results.byPolicyAxis.length > 0 && (
            <Card>
              <CardHeader>
                <CardTitle>정책 축별 수용도</CardTitle>
                <CardDescription>
                  정책 성향(정부신뢰·증세수용·규제선호 등) 상/중/하 그룹별 수용·거부 분포입니다. 정책 의사결정 시 어떤 시민층에서 수용도가 높고 낮은지 파악할 수 있습니다.
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="grid md:grid-cols-2 xl:grid-cols-3 gap-6">
                  {simDetail.results.byPolicyAxis.map((axis) => (
                    <div key={axis.axis} className="space-y-2">
                      <h4 className="text-sm font-semibold">{axis.label}</h4>
                      <div className="h-[160px] w-full">
                        <ResponsiveContainer>
                          <BarChart data={axis.segments} layout="vertical" margin={{ left: 10, right: 10 }} barCategoryGap="30%">
                            <XAxis type="number" hide domain={[0, 100]} />
                            <YAxis dataKey="key" type="category" axisLine={false} tickLine={false} fontSize={12} width={28} />
                            <RechartsTooltip cursor={{ fill: 'rgba(0,0,0,0.05)' }} />
                            <Bar dataKey="supportPct" stackId="a" fill="#22c55e" name="수용 %" maxBarSize={22} />
                            <Bar dataKey="neutralPct" stackId="a" fill="#9ca3af" name="중립 %" maxBarSize={22} />
                            <Bar dataKey="opposePct" stackId="a" fill="#ef4444" name="거부 %" maxBarSize={22} />
                          </BarChart>
                        </ResponsiveContainer>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}

          <Card>
            <CardHeader>
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                  <CardTitle>에이전트 개별 응답 <span className="text-sm font-normal text-muted-foreground">({filteredResponses.length.toLocaleString()}건)</span></CardTitle>
                  <CardDescription>개별 에이전트의 입장과 추론 근거입니다.</CardDescription>
                </div>
                <div className="relative">
                  <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                  <Input
                    placeholder="이름·근거 검색"
                    value={resSearch}
                    onChange={(e) => { setResSearch(e.target.value); setResPage(1); }}
                    className="pl-8 w-[200px]"
                  />
                </div>
              </div>
            </CardHeader>
            <CardContent>
              {responsesLoading ? (
                <Skeleton className="h-64 w-full" />
              ) : (
                <>
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
                        {resPageRows.map((res, idx) => (
                          <TableRow key={res.id} className={Math.floor(idx / 5) % 2 === 1 ? "bg-muted/30" : ""}>
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
                        {resPageRows.length === 0 && (
                          <TableRow>
                            <TableCell colSpan={5} className="text-center text-muted-foreground py-8">
                              조건에 맞는 응답이 없습니다.
                            </TableCell>
                          </TableRow>
                        )}
                      </TableBody>
                    </Table>
                  </div>
                  <div className="flex items-center justify-between mt-4">
                    <span className="text-sm text-muted-foreground">
                      {resCurrentPage} / {resTotalPages} 페이지
                    </span>
                    <div className="flex gap-2">
                      <Button variant="outline" size="sm" disabled={resCurrentPage <= 1} onClick={() => setResPage(resCurrentPage - 1)}>
                        <ChevronLeft className="h-4 w-4" /> 이전
                      </Button>
                      <Button variant="outline" size="sm" disabled={resCurrentPage >= resTotalPages} onClick={() => setResPage(resCurrentPage + 1)}>
                        다음 <ChevronRight className="h-4 w-4" />
                      </Button>
                    </div>
                  </div>
                </>
              )}
            </CardContent>
          </Card>
        </>
      )}
    </div>
  );
}
