import { useState, useEffect, useMemo } from "react";
import { useQueryClient } from "@tanstack/react-query";
import {
  useGetAgentSummary,
  useListDataSources,
  useRegeneratePopulation,
  useListSurveyUploads,
  useCreateSurveyUpload,
  useGetCalibrationSettings,
  useUpdateCalibrationSettings,
  type SurveyUploadColumn,
} from "@workspace/api-client-react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Slider } from "@/components/ui/slider";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription,
  AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import { useToast } from "@/hooks/use-toast";
import { Users, Database, Upload, SlidersHorizontal, ExternalLink, FileSpreadsheet, Loader2 } from "lucide-react";

const CALIBRATION_METHODS = [
  "베이지안 축소 (Bayesian Shrinkage)",
  "사후 층화 가중 (Post-stratification)",
  "레이킹 (Iterative Proportional Fitting)",
  "회귀 보정 (Regression Calibration)",
];

function parseUpload(text: string, fileName: string): { format: string; columns: string[]; rows: Record<string, string>[] } | null {
  const trimmed = text.trim();
  if (!trimmed) return null;
  if (fileName.endsWith(".json") || trimmed.startsWith("[") || trimmed.startsWith("{")) {
    try {
      const parsed = JSON.parse(trimmed);
      const arr = Array.isArray(parsed) ? parsed : [parsed];
      if (arr.length === 0) return null;
      const columns = Object.keys(arr[0]);
      const rows = arr.map((r: Record<string, unknown>) => {
        const o: Record<string, string> = {};
        for (const c of columns) o[c] = String(r[c] ?? "");
        return o;
      });
      return { format: "JSON", columns, rows };
    } catch {
      return null;
    }
  }
  const lines = trimmed.split(/\r?\n/).filter((l) => l.length > 0);
  if (lines.length < 2) return null;
  const columns = lines[0].split(",").map((c) => c.trim());
  const rows = lines.slice(1).map((line) => {
    const cells = line.split(",");
    const o: Record<string, string> = {};
    columns.forEach((c, i) => { o[c] = (cells[i] ?? "").trim(); });
    return o;
  });
  return { format: "CSV", columns, rows };
}

export default function Admin() {
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const { data: summary } = useGetAgentSummary();
  const { data: dataSources, isLoading: dsLoading } = useListDataSources();
  const { data: uploads } = useListSurveyUploads();
  const { data: calibration, isLoading: calLoading } = useGetCalibrationSettings();

  const regenerate = useRegeneratePopulation();
  const createUpload = useCreateSurveyUpload();
  const updateCalibration = useUpdateCalibrationSettings();

  const [count, setCount] = useState(500);
  useEffect(() => {
    if (summary?.total) setCount(summary.total);
  }, [summary?.total]);

  const handleRegenerate = async () => {
    try {
      await regenerate.mutateAsync({ data: { count } });
      await queryClient.invalidateQueries();
      toast({ title: "인구 재생성 완료", description: `${count.toLocaleString()}명의 합성 시민을 생성했습니다.` });
    } catch {
      toast({ title: "재생성 실패", description: "잠시 후 다시 시도해 주세요.", variant: "destructive" });
    }
  };

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">관리자</h1>
        <p className="text-muted-foreground mt-1">합성 인구 구성, 데이터 출처, 설문 기준, 보정 방법을 관리합니다.</p>
      </div>

      <Tabs defaultValue="population">
        <TabsList className="grid w-full grid-cols-2 md:grid-cols-4">
          <TabsTrigger value="population"><Users className="h-4 w-4 mr-1.5" />인구 구성</TabsTrigger>
          <TabsTrigger value="sources"><Database className="h-4 w-4 mr-1.5" />데이터 출처</TabsTrigger>
          <TabsTrigger value="surveys"><Upload className="h-4 w-4 mr-1.5" />설문 업로드</TabsTrigger>
          <TabsTrigger value="calibration"><SlidersHorizontal className="h-4 w-4 mr-1.5" />보정 설정</TabsTrigger>
        </TabsList>

        <TabsContent value="population" className="mt-6">
          <Card>
            <CardHeader>
              <CardTitle>합성 인구 규모</CardTitle>
              <CardDescription>
                에이전트 수를 조정하면 공공 통계 분포에 따라 인구가 결정적으로 재생성됩니다. 기존 시뮬레이션 결과는 보존됩니다.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="flex items-center gap-4">
                <div className="text-sm text-muted-foreground">현재 인구</div>
                <div className="text-2xl font-bold">{summary?.total?.toLocaleString() ?? "—"}명</div>
              </div>
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <Label>목표 에이전트 수</Label>
                  <span className="text-lg font-semibold tabular-nums">{count.toLocaleString()}명</span>
                </div>
                <Slider
                  min={50}
                  max={5000}
                  step={50}
                  value={[count]}
                  onValueChange={(v) => setCount(v[0])}
                />
                <div className="flex items-center gap-3">
                  <Input
                    type="number"
                    min={50}
                    max={5000}
                    value={count}
                    onChange={(e) => setCount(Math.min(5000, Math.max(50, Number(e.target.value) || 50)))}
                    className="w-32"
                  />
                  <span className="text-xs text-muted-foreground">50 ~ 5,000명 범위</span>
                </div>
              </div>
              <AlertDialog>
                <AlertDialogTrigger asChild>
                  <Button disabled={regenerate.isPending || count === summary?.total}>
                    {regenerate.isPending && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
                    인구 재생성
                  </Button>
                </AlertDialogTrigger>
                <AlertDialogContent>
                  <AlertDialogHeader>
                    <AlertDialogTitle>인구를 재생성하시겠습니까?</AlertDialogTitle>
                    <AlertDialogDescription>
                      기존 {summary?.total?.toLocaleString()}명의 에이전트가 {count.toLocaleString()}명으로 교체됩니다.
                      이 작업은 되돌릴 수 없으며, 새 시뮬레이션은 새 인구를 대상으로 실행됩니다.
                    </AlertDialogDescription>
                  </AlertDialogHeader>
                  <AlertDialogFooter>
                    <AlertDialogCancel>취소</AlertDialogCancel>
                    <AlertDialogAction onClick={handleRegenerate}>재생성</AlertDialogAction>
                  </AlertDialogFooter>
                </AlertDialogContent>
              </AlertDialog>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="sources" className="mt-6">
          <Card>
            <CardHeader>
              <CardTitle>공공 데이터 출처</CardTitle>
              <CardDescription>합성 인구의 인구통계·정치성향·미디어 이용 분포는 다음 공개 데이터에 근거합니다.</CardDescription>
            </CardHeader>
            <CardContent>
              {dsLoading ? (
                <div className="space-y-3"><Skeleton className="h-10 w-full" /><Skeleton className="h-10 w-full" /><Skeleton className="h-10 w-full" /></div>
              ) : (
                <div className="border rounded-md overflow-x-auto">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>데이터셋</TableHead>
                        <TableHead>기관</TableHead>
                        <TableHead>반영 항목</TableHead>
                        <TableHead className="text-right">표본/건수</TableHead>
                        <TableHead>기준연도</TableHead>
                        <TableHead></TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {dataSources?.map((ds) => (
                        <TableRow key={ds.id}>
                          <TableCell className="font-medium">
                            {ds.name}
                            <div className="text-xs text-muted-foreground">{ds.category} · {ds.coverage}</div>
                          </TableCell>
                          <TableCell>{ds.agency}</TableCell>
                          <TableCell className="text-sm">{ds.contributesTo}</TableCell>
                          <TableCell className="text-right tabular-nums">{ds.recordCount.toLocaleString()}</TableCell>
                          <TableCell>{ds.referenceYear}</TableCell>
                          <TableCell>
                            <a href={ds.sourceUrl} target="_blank" rel="noreferrer" className="text-primary inline-flex items-center gap-1 text-xs">
                              출처 <ExternalLink className="h-3 w-3" />
                            </a>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="surveys" className="mt-6">
          <SurveyUploadSection
            uploads={uploads ?? []}
            onUpload={async (input) => {
              try {
                await createUpload.mutateAsync({ data: input });
                await queryClient.invalidateQueries();
                toast({ title: "설문 기준 업로드 완료", description: `${input.fileName} (${input.rowCount}행)이 등록되었습니다.` });
                return true;
              } catch {
                toast({ title: "업로드 실패", description: "파일 형식을 확인해 주세요.", variant: "destructive" });
                return false;
              }
            }}
            isPending={createUpload.isPending}
          />
        </TabsContent>

        <TabsContent value="calibration" className="mt-6">
          {calLoading || !calibration ? (
            <Card><CardContent className="py-10"><Skeleton className="h-40 w-full" /></CardContent></Card>
          ) : (
            <CalibrationSection
              initial={calibration}
              isPending={updateCalibration.isPending}
              onSave={async (input) => {
                try {
                  await updateCalibration.mutateAsync({ data: input });
                  await queryClient.invalidateQueries();
                  toast({ title: "보정 설정 저장 완료", description: "새 보정 방법이 검증에 반영됩니다." });
                } catch {
                  toast({ title: "저장 실패", description: "값을 확인해 주세요.", variant: "destructive" });
                }
              }}
            />
          )}
        </TabsContent>
      </Tabs>
    </div>
  );
}

type ParsedUpload = ReturnType<typeof parseUpload>;

function SurveyUploadSection({
  uploads,
  onUpload,
  isPending,
}: {
  uploads: { id: number; fileName: string; format: string; rowCount: number; description: string; status: string; createdAt: string }[];
  onUpload: (input: { fileName: string; description: string; format: string; rowCount: number; columns: SurveyUploadColumn[]; sampleRows: Record<string, string>[] }) => Promise<boolean>;
  isPending: boolean;
}) {
  const [fileName, setFileName] = useState("");
  const [description, setDescription] = useState("");
  const [parsed, setParsed] = useState<ParsedUpload>(null);
  const [error, setError] = useState("");

  const handleFile = async (file: File) => {
    setError("");
    setFileName(file.name);
    const text = await file.text();
    const result = parseUpload(text, file.name);
    if (!result) {
      setError("CSV(헤더 포함) 또는 JSON 배열 형식만 지원합니다.");
      setParsed(null);
      return;
    }
    setParsed(result);
  };

  const handleSubmit = async () => {
    if (!parsed || !fileName) return;
    const ok = await onUpload({
      fileName,
      description,
      format: parsed.format,
      rowCount: parsed.rows.length,
      columns: parsed.columns.map((c) => ({ name: c, mappedTo: "unmapped" })),
      sampleRows: parsed.rows.slice(0, 5),
    });
    if (ok) {
      setFileName("");
      setDescription("");
      setParsed(null);
    }
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>설문 기준 업로드</CardTitle>
          <CardDescription>CSV 또는 JSON 형식의 설문 데이터를 업로드하면 합성 인구 태도의 보정 기준으로 등록됩니다.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label>설문 파일 (.csv / .json)</Label>
            <Input type="file" accept=".csv,.json" onChange={(e) => { const f = e.target.files?.[0]; if (f) handleFile(f); }} />
            {error && <p className="text-sm text-destructive">{error}</p>}
          </div>
          <div className="space-y-2">
            <Label>설명 (선택)</Label>
            <Textarea placeholder="예: 2024 분기별 정책 인식 조사 결과" value={description} onChange={(e) => setDescription(e.target.value)} />
          </div>

          {parsed && (
            <div className="border rounded-md p-4 bg-muted/30 space-y-3">
              <div className="flex items-center gap-2 text-sm">
                <FileSpreadsheet className="h-4 w-4" />
                <span className="font-medium">{fileName}</span>
                <Badge variant="secondary">{parsed.format}</Badge>
                <span className="text-muted-foreground">{parsed.rows.length}행 · {parsed.columns.length}개 항목</span>
              </div>
              <div className="overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow>{parsed.columns.map((c) => <TableHead key={c}>{c}</TableHead>)}</TableRow>
                  </TableHeader>
                  <TableBody>
                    {parsed.rows.slice(0, 3).map((row, i) => (
                      <TableRow key={i}>{parsed.columns.map((c) => <TableCell key={c} className="text-xs">{row[c]}</TableCell>)}</TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>
            </div>
          )}

          <Button onClick={handleSubmit} disabled={!parsed || isPending}>
            {isPending && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
            업로드
          </Button>
        </CardContent>
      </Card>

      <Card>
        <CardHeader><CardTitle>업로드된 설문 기준</CardTitle></CardHeader>
        <CardContent>
          {uploads.length === 0 ? (
            <p className="text-sm text-muted-foreground py-4 text-center">아직 업로드된 설문이 없습니다.</p>
          ) : (
            <div className="border rounded-md">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>파일명</TableHead>
                    <TableHead>형식</TableHead>
                    <TableHead className="text-right">행 수</TableHead>
                    <TableHead>설명</TableHead>
                    <TableHead>상태</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {uploads.map((u) => (
                    <TableRow key={u.id}>
                      <TableCell className="font-medium">{u.fileName}</TableCell>
                      <TableCell><Badge variant="secondary">{u.format}</Badge></TableCell>
                      <TableCell className="text-right tabular-nums">{u.rowCount.toLocaleString()}</TableCell>
                      <TableCell className="text-sm text-muted-foreground">{u.description || "—"}</TableCell>
                      <TableCell><Badge>{u.status === "processed" ? "처리됨" : u.status}</Badge></TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}

function CalibrationSection({
  initial,
  onSave,
  isPending,
}: {
  initial: { method: string; benchmarkWeight: number; recencyWeight: number; shrinkageFactor: number; outlierTrimPct: number; description: string };
  onSave: (input: { method: string; benchmarkWeight: number; recencyWeight: number; shrinkageFactor: number; outlierTrimPct: number; description: string }) => Promise<void>;
  isPending: boolean;
}) {
  const [method, setMethod] = useState(initial.method);
  const [benchmarkWeight, setBenchmarkWeight] = useState(initial.benchmarkWeight);
  const [recencyWeight, setRecencyWeight] = useState(initial.recencyWeight);
  const [shrinkageFactor, setShrinkageFactor] = useState(initial.shrinkageFactor);
  const [outlierTrimPct, setOutlierTrimPct] = useState(initial.outlierTrimPct);
  const [description, setDescription] = useState(initial.description);

  const methodOptions = useMemo(() => {
    return CALIBRATION_METHODS.includes(method) ? CALIBRATION_METHODS : [method, ...CALIBRATION_METHODS];
  }, [method]);

  const weightSlider = (label: string, value: number, set: (n: number) => void, hint: string) => (
    <div className="space-y-2">
      <div className="flex items-center justify-between">
        <Label>{label}</Label>
        <span className="text-sm font-semibold tabular-nums">{value.toFixed(2)}</span>
      </div>
      <Slider min={0} max={1} step={0.05} value={[value]} onValueChange={(v) => set(v[0])} />
      <p className="text-xs text-muted-foreground">{hint}</p>
    </div>
  );

  return (
    <Card>
      <CardHeader>
        <CardTitle>보정 및 검증 방법</CardTitle>
        <CardDescription>원시 LLM 예측을 실제 결과에 맞추기 위한 보정 알고리즘과 가중치를 설정합니다.</CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="space-y-2">
          <Label>보정 방법</Label>
          <Select value={method} onValueChange={setMethod}>
            <SelectTrigger><SelectValue /></SelectTrigger>
            <SelectContent>
              {methodOptions.map((m) => <SelectItem key={m} value={m}>{m}</SelectItem>)}
            </SelectContent>
          </Select>
        </div>

        <div className="grid md:grid-cols-2 gap-6">
          {weightSlider("벤치마크 가중치", benchmarkWeight, setBenchmarkWeight, "과거 가상 이벤트 실제 결과에 두는 비중")}
          {weightSlider("최근성 가중치", recencyWeight, setRecencyWeight, "최근 데이터에 부여하는 비중")}
          {weightSlider("축소 계수", shrinkageFactor, setShrinkageFactor, "원시 예측을 벤치마크 쪽으로 당기는 정도")}
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <Label>이상치 절삭 (%)</Label>
              <span className="text-sm font-semibold tabular-nums">{outlierTrimPct}%</span>
            </div>
            <Slider min={0} max={25} step={1} value={[outlierTrimPct]} onValueChange={(v) => setOutlierTrimPct(v[0])} />
            <p className="text-xs text-muted-foreground">분포 양 끝에서 제외할 이상치 비율</p>
          </div>
        </div>

        <div className="space-y-2">
          <Label>설명</Label>
          <Textarea value={description} onChange={(e) => setDescription(e.target.value)} />
        </div>

        <Button
          onClick={() => onSave({ method, benchmarkWeight, recencyWeight, shrinkageFactor, outlierTrimPct, description })}
          disabled={isPending}
        >
          {isPending && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
          설정 저장
        </Button>
      </CardContent>
    </Card>
  );
}
