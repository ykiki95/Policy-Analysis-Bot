import { useMemo, useState } from "react";
import {
  useListSignals,
  useCreateSignal,
  useListSimulations,
  getListSignalsQueryKey,
  type SignalBatch,
} from "@workspace/api-client-react";
import { useQueryClient } from "@tanstack/react-query";
import { useAuth } from "@/hooks/use-auth";
import { Link } from "wouter";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
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
  Tooltip as RechartsTooltip,
  ResponsiveContainer,
  Legend,
  PieChart,
  Pie,
  Cell,
  BarChart,
  Bar,
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

function DemoBadge() {
  return (
    <Badge variant="outline" className="border-amber-400 text-amber-600 dark:text-amber-400">
      데모 · 향후 구현
    </Badge>
  );
}

function NewBatchDialog() {
  const qc = useQueryClient();
  const createSignal = useCreateSignal();
  const { data: simulations } = useListSimulations();
  const [open, setOpen] = useState(false);
  const [collecting, setCollecting] = useState(false);
  const [source, setSource] = useState<Source | "">("");
  const [product, setProduct] = useState<Product | "">("");
  const [simId, setSimId] = useState<string>("none");
  const [title, setTitle] = useState("");

  const canSubmit = source !== "" && product !== "" && !collecting;

  const handleSubmit = async () => {
    if (source === "" || product === "") return;
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
      // '수집중' 연출: 짧은 로딩 후 목록/차트/KPI 갱신
      await new Promise((r) => setTimeout(r, 1500));
      await qc.invalidateQueries({ queryKey: getListSignalsQueryKey() });
      setOpen(false);
      setSource("");
      setProduct("");
      setSimId("none");
      setTitle("");
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
            소스와 제품을 선택하면 신호 배치를 수집합니다. 효과 수치는 데모용
            예시값으로 채워집니다.
          </DialogDescription>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-2">
            <Label>신호 소스</Label>
            <Select value={source} onValueChange={(v) => setSource(v as Source)}>
              <SelectTrigger>
                <SelectValue placeholder="소스 선택" />
              </SelectTrigger>
              <SelectContent>
                {SOURCES.map((s) => (
                  <SelectItem key={s} value={s}>
                    {s}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label>연결 제품</Label>
            <Select value={product} onValueChange={(v) => setProduct(v as Product)}>
              <SelectTrigger>
                <SelectValue placeholder="제품 선택" />
              </SelectTrigger>
              <SelectContent>
                {PRODUCTS.map((p) => (
                  <SelectItem key={p} value={p}>
                    {p}
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
            <Label>제목 (선택)</Label>
            <Input
              placeholder="예: 청년 월세지원 관련 보도 급증"
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
}: {
  batch: SignalBatch | null;
  open: boolean;
  onOpenChange: (o: boolean) => void;
}) {
  if (!batch) return null;
  const pieData = [
    { name: "긍정", value: batch.sentimentPos, color: SENTIMENT_COLOR.pos },
    { name: "중립", value: batch.sentimentNeu, color: SENTIMENT_COLOR.neu },
    { name: "부정", value: batch.sentimentNeg, color: SENTIMENT_COLOR.neg },
  ];
  const barData = [
    { name: "수집 전", value: batch.valueBefore },
    { name: "수집 후", value: batch.valueAfter },
  ];
  const color = PRODUCT_COLOR[batch.linkedProduct as Product] ?? "#6366f1";

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl">
        <DialogHeader>
          <div className="flex items-center gap-2">
            <SourceBadge source={batch.source} />
            <Badge style={{ background: color }} className="text-white">
              {batch.linkedProduct}
            </Badge>
          </div>
          <DialogTitle className="pt-1">{batch.title}</DialogTitle>
          <DialogDescription>
            {fmtDateTime(batch.collectedAt)} · {batch.itemCount.toLocaleString()}건 수집
          </DialogDescription>
        </DialogHeader>

        <p className="text-sm leading-relaxed text-muted-foreground">
          {batch.summary}
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
              <CardTitle className="text-sm">{batch.metric} 변화</CardTitle>
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

        <div className="flex items-center justify-between pt-1">
          <DeltaChip b={batch} />
          {batch.linkedSimulationId != null ? (
            <Link href={`/simulations/${batch.linkedSimulationId}`}>
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

export default function Signals() {
  const { data: signals, isLoading } = useListSignals();
  const { isAdmin } = useAuth();
  const [selected, setSelected] = useState<SignalBatch | null>(null);
  const [detailOpen, setDetailOpen] = useState(false);

  const chartData = useMemo(() => {
    if (!signals) return [];
    // collectedAt asc, 한 시점에 여러 제품이 있을 수 있어 제품별 키로 분리
    const sorted = [...signals].sort(
      (a, b) =>
        new Date(a.collectedAt).getTime() - new Date(b.collectedAt).getTime(),
    );
    return sorted.map((s) => ({
      date: fmtDate(s.collectedAt),
      [s.linkedProduct]: s.valueAfter,
    }));
  }, [signals]);

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

  const openDetail = (b: SignalBatch) => {
    setSelected(b);
    setDetailOpen(true);
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="text-3xl font-bold tracking-tight">실시간 신호 인제스트</h1>
            <DemoBadge />
          </div>
          <p className="text-muted-foreground mt-1">
            뉴스·검색트렌드·SNS를 배치로 수집해 합성 여론의 변화를 추적합니다.
          </p>
        </div>
        {isAdmin && <NewBatchDialog />}
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
          <CardTitle className="flex items-center gap-2">
            <Radio className="h-5 w-5 text-muted-foreground" />
            신호 반영 지지율 추이
          </CardTitle>
        </CardHeader>
        <CardContent>
          {chartData.length === 0 ? (
            <div className="py-12 text-center text-muted-foreground">
              표시할 신호 배치가 없습니다.
            </div>
          ) : (
            <ResponsiveContainer width="100%" height={320}>
              <LineChart data={chartData} margin={{ top: 8, right: 16, bottom: 0, left: -8 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} />
                <XAxis dataKey="date" fontSize={12} />
                <YAxis fontSize={12} unit="%" domain={["dataMin - 4", "dataMax + 4"]} />
                <RechartsTooltip formatter={(v: number) => `${v}%`} />
                <Legend />
                {PRODUCTS.map((p) => (
                  <Line
                    key={p}
                    type="monotone"
                    dataKey={p}
                    stroke={PRODUCT_COLOR[p]}
                    strokeWidth={2}
                    dot={{ r: 3 }}
                    connectNulls
                  />
                ))}
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
                <TableHead>제품</TableHead>
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
                        {b.linkedProduct}
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

      <DetailDialog batch={selected} open={detailOpen} onOpenChange={setDetailOpen} />
    </div>
  );
}
