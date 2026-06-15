import { useState } from "react";
import { useGetAgentSummary, useListAgents } from "@workspace/api-client-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, ResponsiveContainer, Cell } from "recharts";
import { Link } from "wouter";
import { Search } from "lucide-react";

export default function Population() {
  const [district, setDistrict] = useState<string>("all");
  const [gender, setGender] = useState<string>("all");
  
  const { data: summary, isLoading: summaryLoading } = useGetAgentSummary();
  const { data: allAgents } = useListAgents({});
  const { data: agents, isLoading: agentsLoading } = useListAgents({ 
    district: district !== "all" ? district : undefined,
    gender: gender !== "all" ? gender : undefined,
    limit: 50
  });

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

  // Map visualization (Scatter plot of lat/lng)
  // Seoul approx bounds: lat 37.43 to 37.70, lng 126.80 to 127.18
  const latMin = 37.43, latMax = 37.70;
  const lngMin = 126.80, lngMax = 127.18;
  
  const getAgentColor = (leaning: number) => {
    if (leaning < -20) return "hsl(221, 83%, 53%)"; // Blue (Liberal)
    if (leaning > 20) return "hsl(0, 84%, 60%)"; // Red (Conservative)
    return "hsl(215, 16%, 65%)"; // Gray (Neutral)
  };

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">합성 인구</h1>
        <p className="text-muted-foreground mt-1">서울 시민 500명의 인구통계 및 지리적 분포</p>
      </div>

      <div className="grid md:grid-cols-3 gap-6">
        <Card className="md:col-span-2">
          <CardHeader>
            <CardTitle>지리적 분포 (정치 성향)</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="relative w-full aspect-[4/3] bg-muted/20 border rounded-lg overflow-hidden">
              <svg viewBox="0 0 1000 800" className="w-full h-full">
                {/* A very rough placeholder map outline could go here, but we will just plot the points */}
                {allAgents?.map(agent => {
                  const x = ((agent.lng - lngMin) / (lngMax - lngMin)) * 1000;
                  const y = 800 - (((agent.lat - latMin) / (latMax - latMin)) * 800);
                  return (
                    <Link key={agent.id} href={`/population/${agent.id}`}>
                      <circle 
                        cx={x} 
                        cy={y} 
                        r="4" 
                        fill={getAgentColor(agent.politicalLeaning)} 
                        opacity="0.8"
                        className="hover:opacity-100 transition-all cursor-pointer"
                      >
                        <title>{agent.name}</title>
                      </circle>
                    </Link>
                  );
                })}
              </svg>
              <div className="absolute bottom-4 right-4 bg-background/90 p-3 rounded-md border text-xs shadow-sm flex flex-col gap-2">
                <div className="flex items-center gap-2"><div className="w-3 h-3 rounded-full bg-blue-500"></div> 진보</div>
                <div className="flex items-center gap-2"><div className="w-3 h-3 rounded-full bg-gray-400"></div> 중도</div>
                <div className="flex items-center gap-2"><div className="w-3 h-3 rounded-full bg-red-500"></div> 보수</div>
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
                  <BarChart data={summary.byAgeBracket} layout="vertical" margin={{ left: 20 }}>
                    <XAxis type="number" hide />
                    <YAxis dataKey="key" type="category" axisLine={false} tickLine={false} fontSize={12} width={50} />
                    <RechartsTooltip cursor={{fill: 'rgba(0,0,0,0.05)'}} />
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
              <div className="text-3xl font-bold">{summary.avgLeaning > 0 ? '+' : ''}{summary.avgLeaning.toFixed(1)}</div>
              <div className="w-full bg-border h-2 mt-4 rounded-full overflow-hidden flex">
                <div className="bg-blue-500 h-full" style={{ width: '40%' }}></div>
                <div className="bg-gray-400 h-full" style={{ width: '20%' }}></div>
                <div className="bg-red-500 h-full" style={{ width: '40%' }}></div>
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
          <div className="flex items-center justify-between">
            <CardTitle>에이전트 목록</CardTitle>
            <div className="flex gap-2">
              <Select value={district} onValueChange={setDistrict}>
                <SelectTrigger className="w-[120px]">
                  <SelectValue placeholder="자치구" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">전체 구</SelectItem>
                  {summary.byDistrict.map(d => (
                    <SelectItem key={d.key} value={d.key}>{d.key}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <Select value={gender} onValueChange={setGender}>
                <SelectTrigger className="w-[100px]">
                  <SelectValue placeholder="성별" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">전체</SelectItem>
                  <SelectItem value="Male">남성</SelectItem>
                  <SelectItem value="Female">여성</SelectItem>
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
            <div className="border rounded-md">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>이름</TableHead>
                    <TableHead>자치구</TableHead>
                    <TableHead>연령대</TableHead>
                    <TableHead>성별</TableHead>
                    <TableHead>직업</TableHead>
                    <TableHead className="text-right">성향 (-100~100)</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {agents?.map((agent) => (
                    <TableRow key={agent.id} className="cursor-pointer hover:bg-muted/50">
                      <TableCell className="font-medium">
                        <Link href={`/population/${agent.id}`}>{agent.name}</Link>
                      </TableCell>
                      <TableCell>{agent.district}</TableCell>
                      <TableCell>{agent.ageBracket}</TableCell>
                      <TableCell>{agent.gender === 'Male' ? '남성' : '여성'}</TableCell>
                      <TableCell>{agent.occupation}</TableCell>
                      <TableCell className="text-right">
                        <span className={agent.politicalLeaning > 0 ? 'text-red-500' : agent.politicalLeaning < 0 ? 'text-blue-500' : 'text-gray-500'}>
                          {agent.politicalLeaning}
                        </span>
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
