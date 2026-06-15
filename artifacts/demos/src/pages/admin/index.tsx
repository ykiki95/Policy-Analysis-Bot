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
  useListCalibrations,
  useCreateCalibration,
  useDeleteCalibration,
  useListSurveys,
  getListCalibrationsQueryKey,
  type SurveyUploadColumn,
  type Calibration,
  type CalibrationInput,
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
import { Users, Database, Upload, SlidersHorizontal, ExternalLink, FileSpreadsheet, Loader2, Download, Plus, Trash2, CheckCircle2 } from "lucide-react";

const CALIBRATION_METHODS = [
  "베이지안 축소 (Bayesian Shrinkage)",
  "사후 층화 가중 (Post-stratification)",
  "레이킹 (Iterative Proportional Fitting)",
  "회귀 보정 (Regression Calibration)",
];

const METHOD_DESCRIPTIONS: Record<string, string> = {
  "베이지안 축소 (Bayesian Shrinkage)":
    "원시 예측을 과거 벤치마크(사전 분포) 쪽으로 일정 비율 당겨, 표본이 적거나 변동이 큰 예측의 과신을 줄입니다. 축소 계수가 클수록 벤치마크에 더 가까워집니다.",
  "사후 층화 가중 (Post-stratification)":
    "응답을 자치구·연령·성별 등 인구 셀로 나눈 뒤, 각 셀을 실제 인구 비율에 맞게 가중합니다. 특정 집단이 과대·과소 대표될 때 전체 추정의 편향을 보정합니다.",
  "레이킹 (Iterative Proportional Fitting)":
    "여러 인구 변수의 주변 분포(예: 연령별·성별 합계)에 동시에 맞도록 가중치를 반복 조정합니다. 셀별 목표값을 모를 때 주변 합만으로 보정할 수 있습니다.",
  "회귀 보정 (Regression Calibration)":
    "과거 예측값과 실제값의 관계를 회귀모형으로 학습해, 새 예측에 체계적 오차(편향·기울기)를 보정 적용합니다. 일관된 과대·과소 예측 경향을 교정하는 데 적합합니다.",
};

const EVENT_TYPE_OPTIONS = ["선거", "정책 반응", "여론조사", "제품 반응", "기타"];

const SAMPLE_COLUMNS = [
  { name: "respondent_id", desc: "응답자 식별자" },
  { name: "district", desc: "자치구 (예: 강남구)" },
  { name: "age_group", desc: "연령대 (예: 30-39)" },
  { name: "gender", desc: "성별 (남성/여성)" },
  { name: "question", desc: "설문 문항" },
  { name: "answer", desc: "응답값 (예: 찬성/반대/중립 또는 점수)" },
  { name: "weight", desc: "가중치 (선택, 기본 1)" },
];

const SAMPLE_ROWS = [
  { respondent_id: "R0001", district: "강남구", age_group: "30-39", gender: "여성", question: "주 4일제 도입 찬반", answer: "찬성", weight: "1.0" },
  { respondent_id: "R0002", district: "은평구", age_group: "50-59", gender: "남성", question: "주 4일제 도입 찬반", answer: "반대", weight: "1.2" },
  { respondent_id: "R0003", district: "마포구", age_group: "18-29", gender: "여성", question: "주 4일제 도입 찬반", answer: "중립", weight: "0.9" },
];

function downloadFile(name: string, content: string, type: string) {
  const blob = new Blob([content], { type });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = name;
  a.click();
  URL.revokeObjectURL(url);
}

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
  const { data: calibrationEvents, isLoading: eventsLoading } = useListCalibrations();

  const regenerate = useRegeneratePopulation();
  const createUpload = useCreateSurveyUpload();
  const updateCalibration = useUpdateCalibrationSettings();
  const createEvent = useCreateCalibration();
  const deleteEvent = useDeleteCalibration();

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
        <TabsList className="grid w-full grid-cols-2 md:grid-cols-5">
          <TabsTrigger value="population"><Users className="h-4 w-4 mr-1.5" />인구 구성</TabsTrigger>
          <TabsTrigger value="sources"><Database className="h-4 w-4 mr-1.5" />데이터 출처</TabsTrigger>
          <TabsTrigger value="surveys"><Upload className="h-4 w-4 mr-1.5" />설문 업로드</TabsTrigger>
          <TabsTrigger value="calibration"><SlidersHorizontal className="h-4 w-4 mr-1.5" />보정 설정</TabsTrigger>
          <TabsTrigger value="events"><CheckCircle2 className="h-4 w-4 mr-1.5" />검증 이벤트</TabsTrigger>
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
                <div className="flex items-center justify-between text-xs text-muted-foreground">
                  <span>50명</span>
                  <span>5,000명</span>
                </div>
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

        <TabsContent value="events" className="mt-6">
          <CalibrationEventsSection
            events={calibrationEvents ?? []}
            isLoading={eventsLoading}
            isCreating={createEvent.isPending}
            onCreate={async (input) => {
              try {
                await createEvent.mutateAsync({ data: input });
                await queryClient.invalidateQueries({ queryKey: getListCalibrationsQueryKey() });
                toast({ title: "검증 이벤트 추가됨", description: `${input.title} 이벤트가 등록되었습니다.` });
                return true;
              } catch {
                toast({ title: "추가 실패", description: "값을 확인해 주세요.", variant: "destructive" });
                return false;
              }
            }}
            onDelete={async (id) => {
              try {
                await deleteEvent.mutateAsync({ id });
                await queryClient.invalidateQueries({ queryKey: getListCalibrationsQueryKey() });
                toast({ title: "검증 이벤트 삭제됨" });
              } catch {
                toast({ title: "삭제 실패", description: "잠시 후 다시 시도해 주세요.", variant: "destructive" });
              }
            }}
          />
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
  const { data: surveys } = useListSurveys();
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
          <CardTitle>설문 기준 <span className="text-sm font-normal text-muted-foreground">({(surveys?.length ?? 0) + uploads.length}개)</span></CardTitle>
          <CardDescription>합성 인구의 태도를 형성하는 기준 설문입니다. 시드된 기본 설문("설문조사 기준" 페이지와 동일)과 직접 업로드한 설문이 함께 표시됩니다.</CardDescription>
        </CardHeader>
        <CardContent>
          {!surveys ? (
            <div className="space-y-3"><Skeleton className="h-10 w-full" /><Skeleton className="h-10 w-full" /></div>
          ) : surveys.length === 0 && uploads.length === 0 ? (
            <p className="text-sm text-muted-foreground py-4 text-center">등록된 설문 기준이 없습니다.</p>
          ) : (
            <div className="border rounded-md overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>유형</TableHead>
                    <TableHead>제목 / 파일명</TableHead>
                    <TableHead>설명</TableHead>
                    <TableHead className="text-right">행 수</TableHead>
                    <TableHead>상태</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {surveys.map((s) => (
                    <TableRow key={`survey-${s.id}`}>
                      <TableCell><Badge variant="outline">기준</Badge></TableCell>
                      <TableCell className="font-medium whitespace-nowrap">{s.title}</TableCell>
                      <TableCell className="text-sm text-muted-foreground max-w-md truncate">{s.description}</TableCell>
                      <TableCell className="text-right text-muted-foreground">—</TableCell>
                      <TableCell><Badge variant={s.status === "active" ? "default" : "secondary"}>{s.status === "active" ? "활성" : "종료"}</Badge></TableCell>
                    </TableRow>
                  ))}
                  {uploads.map((u) => (
                    <TableRow key={`upload-${u.id}`}>
                      <TableCell><Badge variant="secondary">{u.format}</Badge></TableCell>
                      <TableCell className="font-medium whitespace-nowrap">{u.fileName}</TableCell>
                      <TableCell className="text-sm text-muted-foreground max-w-md truncate">{u.description || "—"}</TableCell>
                      <TableCell className="text-right tabular-nums">{u.rowCount.toLocaleString()}</TableCell>
                      <TableCell><Badge>{u.status === "processed" ? "처리됨" : u.status}</Badge></TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          )}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>설문 기준 업로드</CardTitle>
          <CardDescription>CSV 또는 JSON 형식의 설문 데이터를 업로드하면 합성 인구 태도의 보정 기준으로 등록됩니다.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="border rounded-md p-4 bg-muted/30 space-y-3">
            <div className="flex flex-wrap items-center justify-between gap-2">
              <div>
                <p className="text-sm font-medium">권장 파일 형식</p>
                <p className="text-xs text-muted-foreground">응답자 1명당 1행. 첫 줄은 헤더(컬럼명). JSON은 객체 배열.</p>
              </div>
              <div className="flex gap-2">
                <Button variant="outline" size="sm" onClick={() => downloadFile(
                  "survey_sample.csv",
                  [SAMPLE_COLUMNS.map((c) => c.name).join(","), ...SAMPLE_ROWS.map((r) => SAMPLE_COLUMNS.map((c) => (r as Record<string, string>)[c.name] ?? "").join(","))].join("\n"),
                  "text/csv",
                )}>
                  <Download className="h-4 w-4 mr-1.5" /> CSV 샘플
                </Button>
                <Button variant="outline" size="sm" onClick={() => downloadFile(
                  "survey_sample.json",
                  JSON.stringify(SAMPLE_ROWS, null, 2),
                  "application/json",
                )}>
                  <Download className="h-4 w-4 mr-1.5" /> JSON 샘플
                </Button>
              </div>
            </div>
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>컬럼</TableHead>
                    <TableHead>설명</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {SAMPLE_COLUMNS.map((c) => (
                    <TableRow key={c.name}>
                      <TableCell className="font-mono text-xs whitespace-nowrap">{c.name}</TableCell>
                      <TableCell className="text-xs text-muted-foreground">{c.desc}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          </div>
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
          {METHOD_DESCRIPTIONS[method] && (
            <p className="text-xs text-muted-foreground leading-relaxed">{METHOD_DESCRIPTIONS[method]}</p>
          )}
        </div>

        <div className="grid sm:grid-cols-2 gap-3">
          {CALIBRATION_METHODS.map((m) => (
            <div key={m} className="rounded-md border p-3 bg-muted/20">
              <p className="text-sm font-medium">{m}</p>
              <p className="text-xs text-muted-foreground mt-1 leading-relaxed">{METHOD_DESCRIPTIONS[m]}</p>
            </div>
          ))}
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

function CalibrationEventsSection({
  events,
  isLoading,
  isCreating,
  onCreate,
  onDelete,
}: {
  events: Calibration[];
  isLoading: boolean;
  isCreating: boolean;
  onCreate: (input: CalibrationInput) => Promise<boolean>;
  onDelete: (id: number) => Promise<void>;
}) {
  const [title, setTitle] = useState("");
  const [eventType, setEventType] = useState(EVENT_TYPE_OPTIONS[0]);
  const [targetDate, setTargetDate] = useState("");
  const [metric, setMetric] = useState("");
  const [actualValue, setActualValue] = useState("");
  const [rawPrediction, setRawPrediction] = useState("");

  const valid =
    title.trim() &&
    targetDate.trim() &&
    metric.trim() &&
    actualValue !== "" &&
    rawPrediction !== "";

  const handleSubmit = async () => {
    if (!valid) return;
    const ok = await onCreate({
      title: title.trim(),
      eventType,
      targetDate: targetDate.trim(),
      metric: metric.trim(),
      actualValue: Number(actualValue),
      rawPrediction: Number(rawPrediction),
    });
    if (ok) {
      setTitle("");
      setTargetDate("");
      setMetric("");
      setActualValue("");
      setRawPrediction("");
    }
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>검증 이벤트 추가</CardTitle>
          <CardDescription>
            결과가 알려진 과거 이벤트의 실제값과 모델의 원시 예측을 입력하면, 현재 보정 설정(축소 계수)에 따라
            보정 예측과 오차가 자동 계산되어 검증 내역에 추가됩니다.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid md:grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>이벤트 제목</Label>
              <Input placeholder="예: 2024 서울시장 보궐선거" value={title} onChange={(e) => setTitle(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>이벤트 유형</Label>
              <Select value={eventType} onValueChange={setEventType}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {EVENT_TYPE_OPTIONS.map((t) => <SelectItem key={t} value={t}>{t}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>기준일</Label>
              <Input placeholder="예: 2024-04-10" value={targetDate} onChange={(e) => setTargetDate(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>지표</Label>
              <Input placeholder="예: 후보 A 득표율" value={metric} onChange={(e) => setMetric(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>실제값 (%)</Label>
              <Input type="number" min={0} max={100} placeholder="예: 52.3" value={actualValue} onChange={(e) => setActualValue(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>원시 예측 (%)</Label>
              <Input type="number" min={0} max={100} placeholder="예: 48.5" value={rawPrediction} onChange={(e) => setRawPrediction(e.target.value)} />
            </div>
          </div>
          <Button onClick={handleSubmit} disabled={!valid || isCreating}>
            {isCreating ? <Loader2 className="h-4 w-4 mr-2 animate-spin" /> : <Plus className="h-4 w-4 mr-2" />}
            이벤트 추가
          </Button>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>검증 이벤트 내역 <span className="text-sm font-normal text-muted-foreground">({events.length}개)</span></CardTitle>
          <CardDescription>오래된 이벤트는 삭제하고 최신 이벤트를 추가하는 방식으로 관리합니다.</CardDescription>
        </CardHeader>
        <CardContent>
          {isLoading ? (
            <div className="space-y-3"><Skeleton className="h-10 w-full" /><Skeleton className="h-10 w-full" /></div>
          ) : events.length === 0 ? (
            <p className="text-sm text-muted-foreground py-4 text-center">등록된 검증 이벤트가 없습니다.</p>
          ) : (
            <div className="border rounded-md overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>이벤트</TableHead>
                    <TableHead>유형</TableHead>
                    <TableHead>기준일</TableHead>
                    <TableHead className="text-right">실제값</TableHead>
                    <TableHead className="text-right">원시 예측</TableHead>
                    <TableHead className="text-right">보정 예측</TableHead>
                    <TableHead className="text-right">원시 오차</TableHead>
                    <TableHead className="text-right">보정 오차</TableHead>
                    <TableHead></TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {events.map((ev) => (
                    <TableRow key={ev.id}>
                      <TableCell className="font-medium">
                        {ev.title}
                        <div className="text-xs text-muted-foreground">{ev.metric}</div>
                      </TableCell>
                      <TableCell><Badge variant="secondary">{ev.eventType}</Badge></TableCell>
                      <TableCell className="whitespace-nowrap">{ev.targetDate}</TableCell>
                      <TableCell className="text-right tabular-nums">{ev.actualValue}%</TableCell>
                      <TableCell className="text-right tabular-nums">{ev.rawPrediction}%</TableCell>
                      <TableCell className="text-right tabular-nums text-primary font-medium">{ev.calibratedPrediction}%</TableCell>
                      <TableCell className="text-right tabular-nums text-muted-foreground">{ev.rawError}%</TableCell>
                      <TableCell className="text-right tabular-nums text-primary">{ev.calibratedError}%</TableCell>
                      <TableCell>
                        <AlertDialog>
                          <AlertDialogTrigger asChild>
                            <Button variant="ghost" size="icon" className="h-8 w-8 text-destructive hover:text-destructive hover:bg-destructive/10">
                              <Trash2 className="h-4 w-4" />
                            </Button>
                          </AlertDialogTrigger>
                          <AlertDialogContent>
                            <AlertDialogHeader>
                              <AlertDialogTitle>이 검증 이벤트를 삭제하시겠습니까?</AlertDialogTitle>
                              <AlertDialogDescription>
                                "{ev.title}" 이벤트가 검증 내역에서 제거됩니다. 이 작업은 되돌릴 수 없습니다.
                              </AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                              <AlertDialogCancel>취소</AlertDialogCancel>
                              <AlertDialogAction onClick={() => onDelete(ev.id)} className="bg-destructive text-destructive-foreground">삭제</AlertDialogAction>
                            </AlertDialogFooter>
                          </AlertDialogContent>
                        </AlertDialog>
                      </TableCell>
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
