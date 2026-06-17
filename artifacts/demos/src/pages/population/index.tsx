import { useState, useMemo } from "react";
import { useGetAgentSummary, useListAgents } from "@workspace/api-client-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { BarChart, Bar, XAxis, YAxis, Tooltip as RechartsTooltip, ResponsiveContainer } from "recharts";
import { MapContainer, TileLayer, CircleMarker, Tooltip as LeafletTooltip } from "react-leaflet";
import { Link } from "wouter";
import { Search, ChevronLeft, ChevronRight } from "lucide-react";

const AGE_ORDER = ["18-29", "30-39", "40-49", "50-59", "60-69", "70+"];
const PAGE_SIZE_OPTIONS = [20, 50, 100];

function getAgentColor(leaning: number) {
  if (leaning < -20) return "#2563eb"; // 진보 (blue)
  if (leaning > 20) return "#dc2626"; // 보수 (red)
  return "#9ca3af"; // 중도 (gray)
}

export default function Population() {
  const [district, setDistrict] = useState<string>("all");
  const [gender, setGender] = useState<string>("all");
  const [ageBracket, setAgeBracket] = useState<string>("all");
  const [occupation, setOccupation] = useState<string>("all");
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);

  const { data: summary, isLoading: summaryLoading } = useGetAgentSummary();
  const { data: allAgents, isLoading: agentsLoading } = useListAgents({});

  const occupations = useMemo(() => {
    if (!allAgents) return [];
    return Array.from(new Set(allAgents.map((a) => a.occupation))).sort((a, b) =>
      a.localeCompare(b, "ko"),
    );
  }, [allAgents]);

  const ageChartData = useMemo(() => {
    if (!summary) return [];
    return [...summary.byAgeBracket].sort(
      (a, b) => AGE_ORDER.indexOf(a.key) - AGE_ORDER.indexOf(b.key),
    );
  }, [summary]);

  const filtered = useMemo(() => {
    if (!allAgents) return [];
    return allAgents.filter((a) => {
      if (district !== "all" && a.district !== district) return false;
      if (gender !== "all" && a.gender !== gender) return false;
      if (ageBracket !== "all" && a.ageBracket !== ageBracket) return false;
      if (occupation !== "all" && a.occupation !== occupation) return false;
      if (search && !a.name.includes(search) && !a.occupation.includes(search)) return false;
      return true;
    });
  }, [allAgents, district, gender, ageBracket, occupation, search]);

  const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize));
  const currentPage = Math.min(page, totalPages);
  const pageRows = filtered.slice((currentPage - 1) * pageSize, currentPage * pageSize);

  if (summaryLoading || !summary) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-10 w-48" />
        <Skeleton className="h-[400px] w-full" />
        <div className="grid grid-cols-2 gap-4">
          <Skeleton className="h-64 w-full" />
          <Skeleton className="h-64 w-full" />
        </div>
      </div>
    );
  }

  const resetPage = () => setPage(1);

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">합성 인구</h1>
        <p className="text-muted-foreground mt-1">전국 17개 시·도 합성 시민 {summary.total.toLocaleString()}명의 인구통계 및 지리적 분포</p>
      </div>

      <div className="grid md:grid-cols-3 gap-6">
        <Card className="md:col-span-2 overflow-hidden">
          <CardHeader>
            <CardTitle>지리적 분포 (정치 성향)</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="relative w-full h-[460px] rounded-lg overflow-hidden border z-0">
              <MapContainer
                center={[36.5, 127.8]}
                zoom={7}
                scrollWheelZoom={false}
                style={{ height: "100%", width: "100%" }}
              >
                <TileLayer
                  attribution='&copy; OpenStreetMap'
                  url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                />
                {allAgents?.map((agent) => (
                  <CircleMarker
                    key={agent.id}
                    center={[agent.lat, agent.lng]}
                    radius={4}
                    pathOptions={{
                      color: getAgentColor(agent.politicalLeaning),
                      fillColor: getAgentColor(agent.politicalLeaning),
                      fillOpacity: 0.7,
                      weight: 1,
                    }}
                  >
                    <LeafletTooltip>
                      {agent.name} · {agent.district} · 성향 {agent.politicalLeaning}
                    </LeafletTooltip>
                  </CircleMarker>
                ))}
              </MapContainer>
              <div className="absolute bottom-4 right-4 bg-background/90 p-3 rounded-md border text-xs shadow-sm flex flex-col gap-2 z-[1000]">
                <div className="flex items-center gap-2"><div className="w-3 h-3 rounded-full bg-blue-600"></div> 진보</div>
                <div className="flex items-center gap-2"><div className="w-3 h-3 rounded-full bg-gray-400"></div> 중도</div>
                <div className="flex items-center gap-2"><div className="w-3 h-3 rounded-full bg-red-600"></div> 보수</div>
              </div>
            </div>
          </CardContent>
        </Card>

        <div className="space-y-6">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm">연령대 분포</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="h-48 w-full">
                <ResponsiveContainer>
                  <BarChart data={ageChartData} layout="vertical" margin={{ left: 20 }}>
                    <XAxis type="number" hide />
                    <YAxis dataKey="key" type="category" axisLine={false} tickLine={false} fontSize={12} width={50} />
                    <RechartsTooltip cursor={{ fill: "rgba(0,0,0,0.05)" }} />
                    <Bar dataKey="count" fill="hsl(var(--primary))" radius={[0, 4, 4, 0]} barSize={20} />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm">평균 정치 성향</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold">{summary.avgLeaning > 0 ? "+" : ""}{summary.avgLeaning.toFixed(1)}</div>
              <div className="w-full bg-border h-2 mt-4 rounded-full overflow-hidden flex">
                <div className="bg-blue-500 h-full" style={{ width: "40%" }}></div>
                <div className="bg-gray-400 h-full" style={{ width: "20%" }}></div>
                <div className="bg-red-500 h-full" style={{ width: "40%" }}></div>
              </div>
              <div className="flex justify-between text-xs text-muted-foreground mt-2">
                <span>진보</span>
                <span>중도</span>
                <span>보수</span>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>

      <Card>
        <CardHeader>
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <CardTitle>에이전트 목록 <span className="text-sm font-normal text-muted-foreground">({filtered.length.toLocaleString()}명)</span></CardTitle>
            <div className="flex flex-wrap gap-2">
              <div className="relative">
                <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="이름·직업 검색"
                  value={search}
                  onChange={(e) => { setSearch(e.target.value); resetPage(); }}
                  className="pl-8 w-[160px]"
                />
              </div>
              <Select value={district} onValueChange={(v) => { setDistrict(v); resetPage(); }}>
                <SelectTrigger className="w-[140px]">
                  <SelectValue placeholder="지역" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">전체 지역</SelectItem>
                  {summary.byDistrict.map((d) => (
                    <SelectItem key={d.key} value={d.key}>{d.key}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <Select value={gender} onValueChange={(v) => { setGender(v); resetPage(); }}>
                <SelectTrigger className="w-[100px]">
                  <SelectValue placeholder="성별" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">전체</SelectItem>
                  <SelectItem value="Male">남성</SelectItem>
                  <SelectItem value="Female">여성</SelectItem>
                </SelectContent>
              </Select>
              <Select value={ageBracket} onValueChange={(v) => { setAgeBracket(v); resetPage(); }}>
                <SelectTrigger className="w-[110px]">
                  <SelectValue placeholder="연령대" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">전체 연령</SelectItem>
                  {AGE_ORDER.map((a) => (
                    <SelectItem key={a} value={a}>{a}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <Select value={occupation} onValueChange={(v) => { setOccupation(v); resetPage(); }}>
                <SelectTrigger className="w-[130px]">
                  <SelectValue placeholder="직업" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">전체 직업</SelectItem>
                  {occupations.map((o) => (
                    <SelectItem key={o} value={o}>{o}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          {agentsLoading ? (
            <div className="space-y-4">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
            </div>
          ) : (
            <>
              <div className="border rounded-md">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>이름</TableHead>
                      <TableHead>지역</TableHead>
                      <TableHead>연령대</TableHead>
                      <TableHead>성별</TableHead>
                      <TableHead>직업</TableHead>
                      <TableHead className="text-right">성향 (-100~100)</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {pageRows.map((agent, idx) => (
                      <TableRow
                        key={agent.id}
                        className={`cursor-pointer hover:bg-muted/50 ${Math.floor(idx / 5) % 2 === 1 ? "bg-muted/30" : ""}`}
                      >
                        <TableCell className="font-medium">
                          <Link href={`/population/${agent.id}`}>{agent.name}</Link>
                        </TableCell>
                        <TableCell>{agent.district}</TableCell>
                        <TableCell>{agent.ageBracket}</TableCell>
                        <TableCell>{agent.gender === "Male" ? "남성" : "여성"}</TableCell>
                        <TableCell>{agent.occupation}</TableCell>
                        <TableCell className="text-right">
                          <span className={agent.politicalLeaning > 0 ? "text-red-500" : agent.politicalLeaning < 0 ? "text-blue-500" : "text-gray-500"}>
                            {agent.politicalLeaning}
                          </span>
                        </TableCell>
                      </TableRow>
                    ))}
                    {pageRows.length === 0 && (
                      <TableRow>
                        <TableCell colSpan={6} className="text-center text-muted-foreground py-8">
                          조건에 맞는 에이전트가 없습니다.
                        </TableCell>
                      </TableRow>
                    )}
                  </TableBody>
                </Table>
              </div>
              <div className="flex items-center justify-between mt-4">
                <div className="flex items-center gap-3">
                  <span className="text-sm text-muted-foreground">
                    {currentPage} / {totalPages} 페이지
                  </span>
                  <Select value={String(pageSize)} onValueChange={(v) => { setPageSize(Number(v)); resetPage(); }}>
                    <SelectTrigger className="w-[120px] h-8">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      {PAGE_SIZE_OPTIONS.map((n) => (
                        <SelectItem key={n} value={String(n)}>{n}개씩 보기</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                <div className="flex gap-2">
                  <Button variant="outline" size="sm" disabled={currentPage <= 1} onClick={() => setPage(currentPage - 1)}>
                    <ChevronLeft className="h-4 w-4" /> 이전
                  </Button>
                  <Button variant="outline" size="sm" disabled={currentPage >= totalPages} onClick={() => setPage(currentPage + 1)}>
                    다음 <ChevronRight className="h-4 w-4" />
                  </Button>
                </div>
              </div>
            </>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
