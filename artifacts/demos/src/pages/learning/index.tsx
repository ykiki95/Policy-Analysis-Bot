import { useMemo, useState } from "react";
import {
  useLearningOverview,
  useListContributions,
  useCreateContribution,
  useRunLearning,
  useContributionDecision,
  getLearningOverviewQueryKey,
  getListContributionsQueryKey,
  type LearningContribution,
} from "@workspace/api-client-react";
import { useQueryClient } from "@tanstack/react-query";
import { useAuth } from "@/hooks/use-auth";
import { useAccountSwitcher } from "@/hooks/use-account-switcher";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import { useToast } from "@/hooks/use-toast";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip as RechartsTooltip,
  ResponsiveContainer,
} from "recharts";
import {
  TrendingUp,
  TrendingDown,
  Target,
  Users,
  CheckCircle2,
  ShieldAlert,
  AlertTriangle,
  Sparkles,
  RefreshCw,
  RotateCcw,
} from "lucide-react";

const DOMAIN_OPTIONS = [
  { value: "political", label: "정치 (Dynamo)" },
  { value: "commercial", label: "비즈니스 (Lumen)" },
  { value: "policy", label: "정부·정책 (Seraph)" },
] as const;

const DOMAIN_LABEL: Record<string, string> = {
  political: "정치 (Dynamo)",
  commercial: "비즈니스 (Lumen)",
  policy: "정부·정책 (Seraph)",
};

const STATUS_META: Record<
  string,
  { label: string; variant: "default" | "secondary" | "destructive" | "outline" }
> = {
  candidate: { label: "평가 대기", variant: "outline" },
  promoted: { label: "반영됨", variant: "default" },
  quarantined: { label: "격리", variant: "secondary" },
  flagged: { label: "검토 대기", variant: "destructive" },
  rejected: { label: "기각", variant: "secondary" },
};

function StatusBadge({ status }: { status: string }) {
  const meta = STATUS_META[status] ?? { label: status, variant: "outline" as const };
  return <Badge variant={meta.variant}>{meta.label}</Badge>;
}

function pct(v: number) {
  return `${v.toFixed(1)}%`;
}

export default function Learning() {
  const { isAdmin } = useAuth();
  const { selectedAccountId } = useAccountSwitcher();
  // 관리자가 '계정 보기 전환'으로 특정 사용자를 보는 중이면(=selectedAccountId 지정)
  // 관리 전용 컨트롤(학습 사이클 실행/검토 큐 승인·기각)을 숨겨 사용자 화면과 동일하게 보여준다.
  const canAdmin = isAdmin && selectedAccountId == null;
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const { data: overview, isLoading } = useLearningOverview({
    query: { queryKey: getLearningOverviewQueryKey() },
  });
  const { data: contributions } = useListContributions(undefined, {
    query: { queryKey: getListContributionsQueryKey() },
  });

  const createContribution = useCreateContribution();
  const runLearning = useRunLearning();
  const decision = useContributionDecision();

  const [domain, setDomain] = useState<string>("political");
  const [title, setTitle] = useState("");
  const [observedValue, setObservedValue] = useState("");
  const [sampleSize, setSampleSize] = useState("");

  const pending = useMemo(
    () => (contributions ?? []).filter((c) => c.status === "flagged" || c.status === "quarantined"),
    [contributions],
  );
  const recent = useMemo(() => (contributions ?? []).slice(0, 12), [contributions]);

  function invalidate() {
    queryClient.invalidateQueries({ queryKey: getLearningOverviewQueryKey() });
    queryClient.invalidateQueries({ queryKey: getListContributionsQueryKey() });
  }

  async function submit() {
    const obs = Number(observedValue);
    const n = Number(sampleSize);
    if (!title.trim() || Number.isNaN(obs) || Number.isNaN(n)) {
      toast({ title: "입력을 확인하세요", description: "제목·관찰값·표본 크기가 필요합니다.", variant: "destructive" });
      return;
    }
    try {
      const res = await createContribution.mutateAsync({
        data: { domain: domain as never, title: title.trim(), observedValue: obs, sampleSize: n },
      });
      const c = res.cycle;
      toast({
        title: "학습 기여 제출됨",
        description: `${c.promoted}건 자동 반영 · ${c.quarantined}건 격리 · ${c.flagged}건 검토 대기`,
      });
      setTitle("");
      setObservedValue("");
      setSampleSize("");
      invalidate();
    } catch {
      toast({ title: "제출 실패", description: "잠시 후 다시 시도하세요.", variant: "destructive" });
    }
  }

  async function runCycle() {
    try {
      const res = await runLearning.mutateAsync();
      toast({ title: "학습 사이클 완료", description: res.message });
      invalidate();
    } catch {
      toast({ title: "실행 실패", variant: "destructive" });
    }
  }

  async function decide(
    c: LearningContribution,
    action: "approve" | "reject" | "requeue",
  ) {
    try {
      await decision.mutateAsync({ id: c.id, data: { action } });
      toast({
        title:
          action === "approve"
            ? "승인 — 전역 인구에 반영"
            : action === "requeue"
              ? "검토 큐로 되돌림"
              : "기각됨",
        description: c.title,
      });
      invalidate();
    } catch {
      toast({ title: "처리 실패", variant: "destructive" });
    }
  }

  if (isLoading || !overview) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-40 w-full" />
        <Skeleton className="h-72 w-full" />
      </div>
    );
  }

  const up = overview.accuracyDelta >= 0;
  const chartData = overview.trend.map((t) => ({
    name: `#${t.cycle}`,
    정확도: t.accuracy,
    원시오차: t.rawError,
  }));

  return (
    <div className="space-y-6">
      {/* 히어로: 현실 일치도 */}
      <Card className="overflow-hidden border-primary/20 bg-gradient-to-br from-primary/5 to-transparent">
        <CardContent className="p-6 md:p-8">
          <div className="flex flex-col md:flex-row md:items-end md:justify-between gap-6">
            <div>
              <div className="flex items-center gap-2 text-sm text-muted-foreground">
                <Target className="h-4 w-4 text-primary" />
                전역 합성인구의 현실 일치도
              </div>
              <div className="mt-2 flex items-baseline gap-3">
                <span className="text-5xl font-bold tracking-tight">{pct(overview.accuracy)}</span>
                <span
                  className={`flex items-center gap-1 text-sm font-medium ${
                    up ? "text-emerald-600" : "text-red-600"
                  }`}
                >
                  {up ? <TrendingUp className="h-4 w-4" /> : <TrendingDown className="h-4 w-4" />}
                  {up ? "+" : ""}
                  {overview.accuracyDelta.toFixed(1)}p (학습 시작 대비)
                </span>
              </div>
              <p className="mt-2 max-w-xl text-sm text-muted-foreground leading-relaxed">
                실제 선거 개표결과를 ground-truth로 합성인구 예측 오차를 측정합니다. 사용자 학습
                기여가 검증 게이트를 통과하면 자동으로 전역 인구 기준선에 반영됩니다.
              </p>
            </div>
            {canAdmin && (
              <Button onClick={runCycle} disabled={runLearning.isPending} className="shrink-0">
                <RefreshCw className={`h-4 w-4 mr-2 ${runLearning.isPending ? "animate-spin" : ""}`} />
                학습 사이클 실행
              </Button>
            )}
          </div>
        </CardContent>
      </Card>

      {/* KPI */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <KpiCard icon={Sparkles} label="자동 반영" value={`${overview.autoApplied}건`} sub={`수동 ${overview.manualApplied}건`} />
        <KpiCard icon={ShieldAlert} label="격리" value={`${overview.quarantined}건`} sub="검증 미통과" />
        <KpiCard icon={AlertTriangle} label="검토 대기" value={`${overview.flaggedPending}건`} sub="관리자 확인 필요" />
        <KpiCard icon={Users} label="기여자 / 인구" value={`${overview.contributors}명`} sub={`인구 ${overview.populationSize.toLocaleString()}`} />
      </div>

      {/* 정확도 추이 */}
      <Card>
        <CardHeader>
          <CardTitle>정확도 추이 (학습 효과)</CardTitle>
          <CardDescription>
            사이클이 진행될수록 현실 일치도가 어떻게 변하는지 — 누적 {overview.cycles}회 학습.
          </CardDescription>
        </CardHeader>
        <CardContent>
          {chartData.length === 0 ? (
            <p className="text-sm text-muted-foreground py-12 text-center">
              아직 학습 스냅샷이 없습니다. 기여를 제출하거나 사이클을 실행하세요.
            </p>
          ) : (
            <ResponsiveContainer width="100%" height={280}>
              <AreaChart data={chartData} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
                <defs>
                  <linearGradient id="accFill" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="hsl(var(--primary))" stopOpacity={0.3} />
                    <stop offset="95%" stopColor="hsl(var(--primary))" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
                <XAxis dataKey="name" tick={{ fontSize: 12 }} />
                <YAxis tick={{ fontSize: 12 }} domain={[0, 100]} />
                <RechartsTooltip
                  formatter={(v: number, n: string) => [`${v}%`, n]}
                  contentStyle={{ fontSize: 12 }}
                />
                <Area type="monotone" dataKey="정확도" stroke="hsl(var(--primary))" fill="url(#accFill)" strokeWidth={2} />
              </AreaChart>
            </ResponsiveContainer>
          )}
        </CardContent>
      </Card>

      {/* 도메인별 정확도 */}
      <div className="grid md:grid-cols-3 gap-4">
        {overview.domains.map((d) => (
          <Card key={d.domain}>
            <CardHeader className="pb-2">
              <CardTitle className="text-base flex items-center justify-between">
                {DOMAIN_LABEL[d.domain] ?? d.domain}
                <Badge variant="outline">{d.product}</Badge>
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold">{pct(d.accuracy)}</div>
              <p className="text-xs text-muted-foreground mt-1">평균 오차 {pct(d.error)}</p>
              <div className="mt-3 h-2 w-full rounded-full bg-muted overflow-hidden">
                <div className="h-full rounded-full bg-primary" style={{ width: `${Math.min(100, d.accuracy)}%` }} />
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* 기여 폼 + 관리자 검토 큐 */}
      <div className="grid lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>학습 기여 제출</CardTitle>
            <CardDescription>
              현실에서 관찰한 실제 수치(지지·구매의향·수용률 %)를 입력하면 예측 대비 편향을 계산해
              검증 게이트로 자동 평가합니다.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label>도메인</Label>
              <Select value={domain} onValueChange={setDomain}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {DOMAIN_OPTIONS.map((o) => (
                    <SelectItem key={o.value} value={o.value}>
                      {o.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>제목 / 출처</Label>
              <Input
                placeholder="예: 2026 지방선거 서울 보수 득표율"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>관찰값 (%)</Label>
                <Input
                  type="number"
                  placeholder="예: 52.3"
                  value={observedValue}
                  onChange={(e) => setObservedValue(e.target.value)}
                />
              </div>
              <div className="space-y-2">
                <Label>표본 크기</Label>
                <Input
                  type="number"
                  placeholder="예: 1200"
                  value={sampleSize}
                  onChange={(e) => setSampleSize(e.target.value)}
                />
              </div>
            </div>
            <Button onClick={submit} disabled={createContribution.isPending} className="w-full">
              제출 및 자동 평가
            </Button>
          </CardContent>
        </Card>

        {canAdmin && (
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <ShieldAlert className="h-4 w-4 text-destructive" />
                검토 큐 ({pending.length})
              </CardTitle>
              <CardDescription>
                이상치로 플래그되거나 검증 게이트를 통과하지 못해 격리된 기여만 수동 검토합니다.
              </CardDescription>
            </CardHeader>
            <CardContent>
              {pending.length === 0 ? (
                <p className="text-sm text-muted-foreground py-8 text-center">
                  검토할 항목이 없습니다. 자동 루프가 정상 작동 중입니다.
                </p>
              ) : (
                <div className="space-y-3">
                  {pending.map((c) => (
                    <div key={c.id} className="rounded-lg border p-3">
                      <div className="flex items-start justify-between gap-2">
                        <div className="min-w-0">
                          <div className="font-medium text-sm truncate">{c.title}</div>
                          <div className="text-xs text-muted-foreground mt-0.5">
                            {DOMAIN_LABEL[c.domain] ?? c.domain} · 편향 {c.bias > 0 ? "+" : ""}
                            {c.bias.toFixed(1)}p · 제안 {c.proposedOffset > 0 ? "+" : ""}
                            {c.proposedOffset.toFixed(1)}
                          </div>
                          {c.flagReason && (
                            <div className="text-xs text-destructive mt-1">{c.flagReason}</div>
                          )}
                        </div>
                        <StatusBadge status={c.status} />
                      </div>
                      <div className="flex gap-2 mt-3">
                        <Button size="sm" onClick={() => decide(c, "approve")} disabled={decision.isPending}>
                          <CheckCircle2 className="h-3.5 w-3.5 mr-1" />
                          승인
                        </Button>
                        <Button
                          size="sm"
                          variant="outline"
                          onClick={() => decide(c, "reject")}
                          disabled={decision.isPending}
                        >
                          기각
                        </Button>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        )}
      </div>

      {/* 최근 기여 */}
      <Card>
        <CardHeader>
          <CardTitle>최근 학습 기여</CardTitle>
          <CardDescription>제출된 기여의 평가 결과(자동/수동)를 추적합니다.</CardDescription>
        </CardHeader>
        <CardContent>
          {recent.length === 0 ? (
            <p className="text-sm text-muted-foreground py-8 text-center">아직 기여가 없습니다.</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>제목</TableHead>
                  <TableHead>도메인</TableHead>
                  <TableHead className="text-right">관찰</TableHead>
                  <TableHead className="text-right">예측</TableHead>
                  <TableHead className="text-right">편향</TableHead>
                  <TableHead>상태</TableHead>
                  <TableHead>결정</TableHead>
                  {canAdmin && <TableHead className="text-right">작업</TableHead>}
                </TableRow>
              </TableHeader>
              <TableBody>
                {recent.map((c) => (
                  <TableRow key={c.id}>
                    <TableCell className="max-w-[200px] truncate font-medium">{c.title}</TableCell>
                    <TableCell className="text-xs">{DOMAIN_LABEL[c.domain] ?? c.domain}</TableCell>
                    <TableCell className="text-right">{pct(c.observedValue)}</TableCell>
                    <TableCell className="text-right text-muted-foreground">{pct(c.predictedValue)}</TableCell>
                    <TableCell className="text-right">
                      {c.bias > 0 ? "+" : ""}
                      {c.bias.toFixed(1)}p
                    </TableCell>
                    <TableCell>
                      <StatusBadge status={c.status} />
                    </TableCell>
                    <TableCell className="text-xs text-muted-foreground">
                      {c.decidedBy === "auto" ? "자동" : c.decidedBy === "admin" ? "관리자" : "—"}
                    </TableCell>
                    {canAdmin && (
                      <TableCell className="text-right">
                        {c.status === "rejected" && (
                          <Button
                            size="sm"
                            variant="outline"
                            onClick={() => decide(c, "requeue")}
                            disabled={decision.isPending}
                          >
                            <RotateCcw className="h-3.5 w-3.5 mr-1" />
                            다시 큐로
                          </Button>
                        )}
                      </TableCell>
                    )}
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>
    </div>
  );
}

function KpiCard({
  icon: Icon,
  label,
  value,
  sub,
}: {
  icon: typeof Target;
  label: string;
  value: string;
  sub: string;
}) {
  return (
    <Card>
      <CardContent className="p-4">
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          <Icon className="h-4 w-4" />
          {label}
        </div>
        <div className="mt-2 text-2xl font-bold">{value}</div>
        <div className="text-xs text-muted-foreground mt-0.5">{sub}</div>
      </CardContent>
    </Card>
  );
}
