import { useEffect, useMemo, useState } from "react";
import {
  useListSignals,
  useCreateSignal,
  useUpdateSignal,
  useGetSignalSettings,
  useListSimulations,
  getListSignalsQueryKey,
  type SignalBatch,
} from "@workspace/api-client-react";
import { useQueryClient } from "@tanstack/react-query";
import { useAuth } from "@/hooks/use-auth";
import { useAccountSwitcher } from "@/hooks/use-account-switcher";
import { sectorLabel } from "@/lib/sector";
import { Link } from "wouter";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import { Slider } from "@/components/ui/slider";
import { useToast } from "@/hooks/use-toast";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Radio,
  Layers,
  Clock,
  Hash,
  ArrowUpRight,
  ArrowDownRight,
  Newspaper,
  Search,
  MessagesSquare,
  Loader2,
  Plus,
  ExternalLink,
} from "lucide-react";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  ResponsiveContainer,
  Legend,
  ReferenceDot,
  ReferenceLine,
  PieChart,
  Pie,
  Cell,
  BarChart,
  Bar,
  Tooltip as RechartsTooltip,
} from "recharts";

const PRODUCTS = ["Lumen", "Seraph", "Dynamo"] as const;
const SOURCES = ["뉴스", "검색트렌드", "SNS·커뮤니티"] as const;
type Product = (typeof PRODUCTS)[number];
type Source = (typeof SOURCES)[number];

const PRODUCT_COLOR: Record<Product, string> = {
  Lumen: "#6366f1",
  Seraph: "#0ea5e9",
  Dynamo: "#f59e0b",
};

const SENTIMENT_COLOR = {
  pos: "#22c55e",
  neu: "#94a3b8",
  neg: "#ef4444",
};

function sourceIcon(source: string) {
  if (source === "뉴스") return Newspaper;
  if (source === "검색트렌드") return Search;
  return MessagesSquare;
}

function fmtDateTime(s: string): string {
  return new Date(s).toLocaleString("ko-KR", {
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function fmtDate(s: string): string {
  return new Date(s).toLocaleDateString("ko-KR", {
    month: "short",
    day: "numeric",
  });
}

function SourceBadge({ source }: { source: string }) {
  const Icon = sourceIcon(source);
  return (
    <Badge variant="secondary" className="gap-1 font-normal">
      <Icon className="h-3 w-3" />
      {source}
    </Badge>
  );
}

function SentimentBar({ b }: { b: SignalBatch }) {
  return (
    <div className="flex h-2 w-28 overflow-hidden rounded-full">
      <div style={{ width: `${b.sentimentPos}%`, background: SENTIMENT_COLOR.pos }} />
      <div style={{ width: `${b.sentimentNeu}%`, background: SENTIMENT_COLOR.neu }} />
      <div style={{ width: `${b.sentimentNeg}%`, background: SENTIMENT_COLOR.neg }} />
    </div>
  );
}

function DeltaChip({ b }: { b: SignalBatch }) {
  const delta = Math.round((b.valueAfter - b.valueBefore) * 10) / 10;
  const up = delta >= 0;
  const Icon = up ? ArrowUpRight : ArrowDownRight;
  return (
    <div className="flex items-center gap-1.5 whitespace-nowrap text-sm">
      <span className="text-muted-foreground">
        {b.valueBefore}% → {b.valueAfter}%
      </span>
      <span
        className={`inline-flex items-center gap-0.5 font-medium ${
          up
            ? "text-green-600 dark:text-green-400"
            : "text-red-600 dark:text-red-400"
        }`}
      >
        <Icon className="h-3.5 w-3.5" />
        {up ? "+" : ""}
        {delta}
      </span>
    </div>
  );
}

function NewBatchDialog() {
  const qc = useQueryClient();
  const createSignal = useCreateSignal();
  const { data: simulations } = useListSimulations();
  const { toast } = useToast();
  const [open, setOpen] = useState(false);
  const [collecting, setCollecting] = useState(false);
  // 실시간 실제 수집은 Google 뉴스 RSS 기반이라 소스는 '뉴스' 고정.
  const source: Source = "뉴스";
  const [product, setProduct] = useState<Product | "">("");
  const [simId, setSimId] = useState<string>("none");
  const [title, setTitle] = useState("");

  const canSubmit = product !== "" && !collecting;

  const handleSubmit = async () => {
    if (product === "") return;
    setCollecting(true);
    try {
      await createSignal.mutateAsync({
        data: {
          source,
          linkedProduct: product,
          title: title.trim() || undefined,
          linkedSimulationId: simId === "none" ? undefined : Number(simId),
        },
      });
      await qc.invalidateQueries({ queryKey: getListSignalsQueryKey() });
      setOpen(false);
      setProduct("");
      setSimId("none");
      setTitle("");
    } catch (err) {
      const msg =
        (err as { response?: { data?: { error?: string } } })?.response?.data
          ?.error ?? "실시간 신호 수집에 실패했습니다. 잠시 후 다시 시도해 주세요.";
      toast({
        variant: "destructive",
        title: "신호 수집 실패",
        description: msg,
      });
    } finally {
      setCollecting(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={(o) => !collecting && setOpen(o)}>
      <DialogTrigger asChild>
        <Button>
          <Plus className="mr-2 h-4 w-4" />새 배치 수집
        </Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>새 신호 배치 수집</DialogTitle>
          <DialogDescription>
            검색어와 부문을 지정하면 Google 뉴스 RSS에서 실제 기사를 수집해
            LLM으로 감성·요약을 분석합니다.
          </DialogDescription>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-2">
            <Label>신호 소스</Label>
            <div className="flex items-center gap-2 rounded-md border bg-muted/40 px-3 py-2 text-sm">
              <Newspaper className="h-4 w-4 text-muted-foreground" />
              뉴스 (Google 뉴스 RSS · 실시간)
            </div>
          </div>
          <div className="space-y-2">
            <Label>연결 부문</Label>
            <Select value={product} onValueChange={(v) => setProduct(v as Product)}>
              <SelectTrigger>
                <SelectValue placeholder="부문 선택" />
              </SelectTrigger>
              <SelectContent>
                {PRODUCTS.map((p) => (
                  <SelectItem key={p} value={p}>
                    {sectorLabel(p)}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label>연결 시뮬레이션 (선택)</Label>
            <Select value={simId} onValueChange={setSimId}>
              <SelectTrigger>
                <SelectValue placeholder="시뮬레이션 선택" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="none">연결 안 함</SelectItem>
                {(simulations ?? []).map((s) => (
                  <SelectItem key={s.id} value={String(s.id)}>
                    {s.title}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label>검색어 (선택)</Label>
            <Input
              placeholder="예: 청년 월세지원 / 비워두면 부문 기본 주제로 수집"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
            />
          </div>
        </div>
        <DialogFooter>
          <Button onClick={handleSubmit} disabled={!canSubmit}>
            {collecting ? (
              <>
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                수집중…
              </>
            ) : (
              "수집 시작"
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function DetailDialog({
  batch,
  open,
  onOpenChange,
  isAdmin,
}: {
  batch: SignalBatch | null;
  open: boolean;
  onOpenChange: (o: boolean) => void;
  isAdmin: boolean;
}) {
  const qc = useQueryClient();
  const { toast } = useToast();
  const updateSignal = useUpdateSignal();
  const [current, setCurrent] = useState<SignalBatch | null>(batch);
  const [direction, setDirection] = useState<"up" | "down">("up");
  const [magnitude, setMagnitude] = useState(0);

  useEffect(() => {
    setCurrent(batch);
    if (batch) {
      setDirection(batch.valueAfter >= batch.valueBefore ? "up" : "down");
      setMagnitude(Math.round(Math.abs(batch.valueAfter - batch.valueBefore) * 10) / 10);
    }
  }, [batch]);

  if (!current) return null;
  const pieData = [
    { name: "긍정", value: current.sentimentPos, color: SENTIMENT_COLOR.pos },
    { name: "중립", value: current.sentimentNeu, color: SENTIMENT_COLOR.neu },
    { name: "부정", value: current.sentimentNeg, color: SENTIMENT_COLOR.neg },
  ];
  const barData = [
    { name: "수집 전", value: current.valueBefore },
    { name: "수집 후", value: current.valueAfter },
  ];
  const color = PRODUCT_COLOR[current.linkedProduct as Product] ?? "#6366f1";
  const projected = Math.min(
    100,
    Math.max(0, Math.round((current.valueBefore + (direction === "up" ? 1 : -1) * magnitude) * 10) / 10),
  );

  const handleAdjust = async () => {
    try {
      const updated = await updateSignal.mutateAsync({
        id: current.id,
        data: { direction, magnitude },
      });
      await qc.invalidateQueries({ queryKey: getListSignalsQueryKey() });
      setCurrent(updated);
      toast({
        title: "효과 조정 완료",
        description: `${updated.metric} ${updated.valueBefore}% → ${updated.valueAfter}%`,
      });
    } catch {
      toast({ title: "조정 실패", description: "잠시 후 다시 시도해 주세요.", variant: "destructive" });
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl">
        <DialogHeader>
          <div className="flex items-center gap-2">
            <SourceBadge source={current.source} />
            <Badge style={{ background: color }} className="text-white">
              {sectorLabel(current.linkedProduct)}
            </Badge>
          </div>
          <DialogTitle className="pt-1">{current.title}</DialogTitle>
          <DialogDescription>
            {fmtDateTime(current.collectedAt)} · {current.itemCount.toLocaleString()}건 수집
          </DialogDescription>
        </DialogHeader>

        <p className="text-sm leading-relaxed text-muted-foreground">
          {current.summary}
        </p>

        <div className="grid gap-4 md:grid-cols-2">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm">감성 분포</CardTitle>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={180}>
                <PieChart>
                  <Pie
                    data={pieData}
                    dataKey="value"
                    nameKey="name"
                    innerRadius={45}
                    outerRadius={70}
                    paddingAngle={2}
                  >
                    {pieData.map((d) => (
                      <Cell key={d.name} fill={d.color} />
                    ))}
                  </Pie>
                  <RechartsTooltip formatter={(v: number) => `${v}%`} />
                  <Legend />
                </PieChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm">{current.metric} 변화</CardTitle>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={180}>
                <BarChart data={barData}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} />
                  <XAxis dataKey="name" fontSize={12} />
                  <YAxis fontSize={12} domain={["dataMin - 4", "dataMax + 4"]} />
                  <RechartsTooltip formatter={(v: number) => `${v}%`} />
                  <Bar dataKey="value" radius={[4, 4, 0, 0]} fill={color} />
                </BarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </div>

        {isAdmin && (
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm">효과 조정 (관리자)</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <div className="space-y-2">
                <Label className="text-xs text-muted-foreground">효과 방향</Label>
                <div className="flex gap-2">
                  <Button
                    type="button"
                    variant={direction === "up" ? "default" : "outline"}
                    size="sm"
                    className="flex-1"
                    onClick={() => setDirection("up")}
                  >
                    <ArrowUpRight className="mr-1 h-3.5 w-3.5" />상승
                  </Button>
                  <Button
                    type="button"
                    variant={direction === "down" ? "default" : "outline"}
                    size="sm"
                    className="flex-1"
                    onClick={() => setDirection("down")}
                  >
                    <ArrowDownRight className="mr-1 h-3.5 w-3.5" />하락
                  </Button>
                </div>
              </div>
              <div className="space-y-2">
                <div className="flex items-center justify-between">
                  <Label className="text-xs text-muted-foreground">효과 강도</Label>
                  <span className="text-sm font-semibold tabular-nums">{magnitude.toFixed(1)}%p</span>
                </div>
                <Slider min={0} max={15} step={0.5} value={[magnitude]} onValueChange={(v) => setMagnitude(v[0])} />
                <p className="text-xs text-muted-foreground">
                  {current.metric} {current.valueBefore}% → <span className="font-medium text-foreground">{projected}%</span>
                </p>
              </div>
              <Button size="sm" onClick={handleAdjust} disabled={updateSignal.isPending}>
                {updateSignal.isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                효과 적용
              </Button>
            </CardContent>
          </Card>
        )}

        <div className="flex items-center justify-between pt-1">
          <DeltaChip b={current} />
          {current.linkedSimulationId != null ? (
            <Link href={`/simulations/${current.linkedSimulationId}`}>
              <Button variant="outline" size="sm">
                반영된 시뮬레이션
                <ExternalLink className="ml-2 h-3.5 w-3.5" />
              </Button>
            </Link>
          ) : (
            <span className="text-sm text-muted-foreground">연결된 시뮬레이션 없음</span>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}

/** 추이 차트의 한 신호 점. 차트 좌표(idx/value)와 hover·콜아웃에 쓸 메타를 함께 담는다. */
type ChartPoint = {
  id: number;
  idx: number;
  date: string;
  product: Product;
  color: string;
  value: number;
  before: number;
  after: number;
  delta: number;
  deltaTxt: string;
  metric: string;
  source: string;
  title: string;
  sector: string;
  pos: number;
  neu: number;
  neg: number;
  collectedLabel: string;
  batch: SignalBatch;
};

type ChartRow = {
  idx: number;
  date: string;
  meta: ChartPoint;
} & Partial<Record<Product, number>>;

/** 추이 차트 hover 툴팁 — 수집시각·부문·제목·감성·지표 변화를 보여준다. */
function ChartTooltip({
  active,
  payload,
}: {
  active?: boolean;
  payload?: Array<{ payload: ChartRow }>;
}) {
  if (!active || !payload || payload.length === 0) return null;
  const m = payload[0]?.payload?.meta;
  if (!m) return null;
  return (
    <div className="max-w-[17rem] space-y-1.5 rounded-lg border bg-background p-3 text-xs shadow-md">
      <div className="flex items-center gap-1.5">
        <span
          className="inline-block h-2.5 w-2.5 rounded-full"
          style={{ background: m.color }}
        />
        <span className="font-medium">{m.source}</span>
        <span className="text-muted-foreground">·</span>
        <span className="text-muted-foreground">{m.sector}</span>
      </div>
      <div className="text-sm font-semibold leading-snug">{m.title}</div>
      <div className="text-muted-foreground">{m.collectedLabel}</div>
      <div>
        감성 · 긍정 {m.pos}% / 중립 {m.neu}% / 부정 {m.neg}%
      </div>
      <div className="font-medium">
        {m.metric} {m.before}% → {m.after}%{" "}
        <span className={m.delta >= 0 ? "text-green-600 dark:text-green-400" : "text-red-600 dark:text-red-400"}>
          ({m.deltaTxt})
        </span>
      </div>
    </div>
  );
}

export default function Signals() {
  const { data: signals, isLoading } = useListSignals();
  const { data: settings } = useGetSignalSettings();
  const { isAdmin } = useAuth();
  const { selectedAccountId } = useAccountSwitcher();
  // 관리자 '계정 보기 전환' 중(특정 사용자 보기)에는 관리 전용 컨트롤을 숨겨 사용자 화면과 동일하게.
  const canAdmin = isAdmin && selectedAccountId == null;
  const [selected, setSelected] = useState<SignalBatch | null>(null);
  const [detailOpen, setDetailOpen] = useState(false);
  const applyToPrediction = settings?.applyToPrediction ?? true;

  const openDetail = (b: SignalBatch) => {
    setSelected(b);
    setDetailOpen(true);
  };

  const points = useMemo<ChartPoint[]>(() => {
    if (!signals) return [];
    const sorted = [...signals].sort(
      (a, b) =>
        new Date(a.collectedAt).getTime() - new Date(b.collectedAt).getTime(),
    );
    return sorted.map((s, idx) => {
      const before = s.valueBefore;
      const after = s.valueAfter;
      const delta = Math.round((after - before) * 10) / 10;
      const product = (PRODUCTS as readonly string[]).includes(s.linkedProduct)
        ? (s.linkedProduct as Product)
        : "Dynamo";
      return {
        id: s.id,
        idx,
        date: fmtDate(s.collectedAt),
        product,
        color: PRODUCT_COLOR[product],
        value: applyToPrediction ? after : before,
        before,
        after,
        delta,
        deltaTxt: `${delta >= 0 ? "+" : ""}${delta}%p`,
        metric: s.metric,
        source: s.source,
        title: s.title,
        sector: sectorLabel(s.linkedProduct),
        pos: s.sentimentPos,
        neu: s.sentimentNeu,
        neg: s.sentimentNeg,
        collectedLabel: fmtDateTime(s.collectedAt),
        batch: s,
      };
    });
  }, [signals, applyToPrediction]);

  const chartData = useMemo<ChartRow[]>(
    () =>
      points.map((p) => ({
        idx: p.idx,
        date: p.date,
        meta: p,
        [p.product]: p.value,
      })),
    [points],
  );

  // |Δ| 상위 최대 3개 → 콜아웃 라벨. |Δ| ≥ 4 → 신호발생 기준선.
  const calloutIds = useMemo(() => {
    const ranked = [...points]
      .filter((p) => Math.abs(p.delta) >= 2)
      .sort((a, b) => Math.abs(b.delta) - Math.abs(a.delta))
      .slice(0, 3);
    return new Set(ranked.map((p) => p.id));
  }, [points]);

  const bigSwings = useMemo(
    () => points.filter((p) => Math.abs(p.delta) >= 4),
    [points],
  );

  const kpi = useMemo(() => {
    if (!signals || signals.length === 0)
      return { count: 0, last: null as string | null, items: 0 };
    const sortedDesc = [...signals].sort(
      (a, b) =>
        new Date(b.collectedAt).getTime() - new Date(a.collectedAt).getTime(),
    );
    return {
      count: signals.length,
      last: sortedDesc[0].collectedAt,
      items: signals.reduce((acc, s) => acc + s.itemCount, 0),
    };
  }, [signals]);

  if (isLoading || !signals) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-10 w-64" />
        <div className="grid gap-4 md:grid-cols-3">
          <Skeleton className="h-28 w-full" />
          <Skeleton className="h-28 w-full" />
          <Skeleton className="h-28 w-full" />
        </div>
        <Skeleton className="h-72 w-full" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">실시간 신호 인제스트</h1>
          <p className="text-muted-foreground mt-1">
            뉴스·검색트렌드·SNS를 배치로 수집해 합성 여론의 변화를 추적합니다.
          </p>
        </div>
        {canAdmin && <NewBatchDialog />}
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">누적 배치 수</CardTitle>
            <Layers className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{kpi.count}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">마지막 수집 시각</CardTitle>
            <Clock className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {kpi.last ? fmtDateTime(kpi.last) : "-"}
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">누적 신호 건수</CardTitle>
            <Hash className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{kpi.items.toLocaleString()}</div>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <div className="flex flex-wrap items-center justify-between gap-3">
            <CardTitle className="flex items-center gap-2">
              <Radio className="h-5 w-5 text-muted-foreground" />
              신호 반영 지표 추이
              <Badge variant={applyToPrediction ? "default" : "secondary"} className="font-normal">
                {applyToPrediction ? "신호 반영 후 기준" : "신호 반영 전 기준"}
              </Badge>
            </CardTitle>
            <p className="text-xs text-muted-foreground">
              점을 클릭하면 해당 신호 배치 상세가 열립니다.
            </p>
          </div>
        </CardHeader>
        <CardContent>
          {chartData.length === 0 ? (
            <div className="py-12 text-center text-muted-foreground">
              표시할 신호 배치가 없습니다.
            </div>
          ) : (
            <ResponsiveContainer width="100%" height={340}>
              <LineChart data={chartData} margin={{ top: 24, right: 24, bottom: 0, left: -8 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} />
                <XAxis
                  dataKey="idx"
                  type="number"
                  domain={[-0.5, Math.max(0, points.length - 0.5)]}
                  ticks={points.map((p) => p.idx)}
                  tickFormatter={(v: number) => points[v]?.date ?? ""}
                  allowDecimals={false}
                  fontSize={12}
                />
                <YAxis fontSize={12} unit="%" domain={["dataMin - 4", "dataMax + 4"]} />
                <RechartsTooltip content={<ChartTooltip />} />
                <Legend />
                {PRODUCTS.map((p) => (
                  <Line
                    key={p}
                    type="monotone"
                    dataKey={p}
                    name={sectorLabel(p)}
                    stroke={PRODUCT_COLOR[p]}
                    strokeWidth={2}
                    dot={false}
                    connectNulls
                  />
                ))}
                {/* |Δ| ≥ 4 신호발생 기준선 */}
                {bigSwings.map((p) => (
                  <ReferenceLine
                    key={`swing-${p.id}`}
                    x={p.idx}
                    stroke={p.color}
                    strokeDasharray="4 4"
                    strokeOpacity={0.35}
                  />
                ))}
                {/* 점별 클릭 가능 신호점 + 상위 변동 콜아웃 */}
                {points.map((p) => {
                  const isCallout = calloutIds.has(p.id);
                  return (
                    <ReferenceDot
                      key={`dot-${p.id}`}
                      x={p.idx}
                      y={p.value}
                      r={isCallout ? 6 : 4}
                      shape={(props: { cx?: number; cy?: number }) => (
                        <circle
                          cx={props.cx}
                          cy={props.cy}
                          r={isCallout ? 6 : 4}
                          fill={p.color}
                          stroke="#fff"
                          strokeWidth={1.5}
                          style={{ cursor: "pointer" }}
                          onClick={() => openDetail(p.batch)}
                        />
                      )}
                      label={
                        isCallout
                          ? {
                              value: `${p.title.length > 14 ? `${p.title.slice(0, 14)}…` : p.title} ${p.deltaTxt}`,
                              position: "top",
                              fill: p.color,
                              fontSize: 11,
                            }
                          : undefined
                      }
                    />
                  );
                })}
              </LineChart>
            </ResponsiveContainer>
          )}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>수집된 신호 배치</CardTitle>
        </CardHeader>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="pl-6">소스</TableHead>
                <TableHead>제목</TableHead>
                <TableHead>부문</TableHead>
                <TableHead>수집 시각</TableHead>
                <TableHead className="text-right">건수</TableHead>
                <TableHead>감성</TableHead>
                <TableHead className="pr-6">{`지표 변화`}</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {signals.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} className="py-8 text-center text-muted-foreground">
                    수집된 신호 배치가 없습니다.
                  </TableCell>
                </TableRow>
              ) : (
                signals.map((b) => (
                  <TableRow
                    key={b.id}
                    className="cursor-pointer hover:bg-muted/50 transition-colors"
                    onClick={() => openDetail(b)}
                  >
                    <TableCell className="pl-6">
                      <SourceBadge source={b.source} />
                    </TableCell>
                    <TableCell className="max-w-[18rem] truncate font-medium">
                      {b.title}
                    </TableCell>
                    <TableCell>
                      <Badge
                        style={{ background: PRODUCT_COLOR[b.linkedProduct as Product] }}
                        className="text-white"
                      >
                        {sectorLabel(b.linkedProduct)}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-sm text-muted-foreground whitespace-nowrap">
                      {fmtDateTime(b.collectedAt)}
                    </TableCell>
                    <TableCell className="text-right text-sm">
                      {b.itemCount.toLocaleString()}
                    </TableCell>
                    <TableCell>
                      <SentimentBar b={b} />
                    </TableCell>
                    <TableCell className="pr-6">
                      <DeltaChip b={b} />
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <DetailDialog batch={selected} open={detailOpen} onOpenChange={setDetailOpen} isAdmin={canAdmin} />
    </div>
  );
}
