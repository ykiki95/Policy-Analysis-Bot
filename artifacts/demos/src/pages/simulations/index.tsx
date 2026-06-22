import { useListSimulations } from "@workspace/api-client-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Link } from "wouter";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Plus, Beaker, Clock, CheckCircle2, ListChecks, XCircle, Target, ClipboardCheck, GraduationCap } from "lucide-react";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";

export default function Simulations() {
  const { data: simulations, isLoading } = useListSimulations();

  if (isLoading || !simulations) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-10 w-48" />
        <Skeleton className="h-64 w-full" />
      </div>
    );
  }

  const getStatusBadge = (status: string) => {
    switch(status) {
      case "completed": return <Badge className="bg-green-500 hover:bg-green-600"><CheckCircle2 className="w-3 h-3 mr-1"/> 완료됨</Badge>;
      case "running": return <Badge variant="secondary" className="animate-pulse"><Clock className="w-3 h-3 mr-1"/> 실행 중</Badge>;
      case "queued": return <Badge variant="outline" className="text-amber-600 border-amber-300"><ListChecks className="w-3 h-3 mr-1"/> 대기열</Badge>;
      case "failed": return <Badge variant="destructive"><XCircle className="w-3 h-3 mr-1"/> 실패</Badge>;
      default: return <Badge variant="outline">대기 중</Badge>;
    }
  };

  // 완료된 시뮬레이션의 예측→실제→학습 라이프사이클 단계 배지.
  const getStageBadge = (sim: { status: string; learnedAt?: string | null; actualValue?: number | null }) => {
    if (sim.status !== "completed") return null;
    if (sim.learnedAt != null) {
      return <Badge variant="outline" className="text-primary border-primary/40"><GraduationCap className="w-3 h-3 mr-1"/> 학습 반영</Badge>;
    }
    if (sim.actualValue != null) {
      return <Badge variant="outline" className="text-blue-600 border-blue-300"><ClipboardCheck className="w-3 h-3 mr-1"/> 실제 입력됨</Badge>;
    }
    return <Badge variant="outline" className="text-muted-foreground"><Target className="w-3 h-3 mr-1"/> 예측 잠금</Badge>;
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">시뮬레이션</h1>
          <p className="text-muted-foreground mt-1">정책, 메시지, 제품에 대한 인구 반응 실험 내역</p>
        </div>
        <Link href="/simulations/new">
          <Button>
            <Plus className="mr-2 h-4 w-4" />
            새 시뮬레이션
          </Button>
        </Link>
      </div>

      <Card>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="pl-6">상태</TableHead>
                <TableHead>제목</TableHead>
                <TableHead>대상 / 제품</TableHead>
                <TableHead>결과 (찬/반/중)</TableHead>
                <TableHead className="text-right pr-6">생성일</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {simulations.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={5} className="text-center py-8 text-muted-foreground">
                    등록된 시뮬레이션이 없습니다.
                  </TableCell>
                </TableRow>
              ) : (
                simulations.map((sim) => (
                  <TableRow key={sim.id} className="cursor-pointer hover:bg-muted/50 transition-colors">
                    <TableCell className="pl-6">{getStatusBadge(sim.status)}</TableCell>
                    <TableCell className="font-medium">
                      <Link href={`/simulations/${sim.id}`} className="hover:underline">
                        {sim.title}
                      </Link>
                      <div className="mt-1">{getStageBadge(sim)}</div>
                    </TableCell>
                    <TableCell>
                      <div className="flex flex-col text-sm">
                        <span>{sim.audience}</span>
                        <span className="text-muted-foreground">{sim.product}</span>
                      </div>
                    </TableCell>
                    <TableCell>
                      {sim.status === "completed" && sim.supportPct != null ? (
                        <div className="flex items-center gap-2 text-sm">
                          <span className="text-green-600 dark:text-green-400 font-medium">{sim.supportPct}%</span>
                          <span className="text-red-500 font-medium">{sim.opposePct}%</span>
                          <span className="text-gray-500">{sim.neutralPct}%</span>
                        </div>
                      ) : (
                        <span className="text-muted-foreground text-sm">-</span>
                      )}
                    </TableCell>
                    <TableCell className="text-right pr-6 text-sm text-muted-foreground">
                      {new Date(sim.createdAt).toLocaleDateString()}
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
