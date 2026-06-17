import { useGetSurvey, getGetSurveyQueryKey } from "@workspace/api-client-react";
import { useParams, Link } from "wouter";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { ArrowLeft, Database, Calendar, Users, Percent, CheckCircle, BadgeCheck, Building2, FileText, Clock, ExternalLink, Info } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Progress } from "@/components/ui/progress";

export default function SurveyDetail() {
  const params = useParams();
  const id = parseInt(params.id || "0", 10);

  const { data: survey, isLoading } = useGetSurvey(id, { 
    query: { enabled: !!id, queryKey: getGetSurveyQueryKey(id) } 
  });

  if (isLoading || !survey) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-24" />
        <Skeleton className="h-12 w-64" />
        <Skeleton className="h-48 w-full" />
        <Skeleton className="h-96 w-full" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <Link href="/surveys" className="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground w-fit transition-colors">
        <ArrowLeft className="h-4 w-4" />
        목록으로 돌아가기
      </Link>

      <div className="flex justify-between items-start">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">{survey.title}</h1>
          <p className="text-muted-foreground mt-2 max-w-3xl">{survey.description}</p>
        </div>
        <div className="flex flex-col items-end gap-2 shrink-0">
          <Badge
            variant="outline"
            className={
              survey.domain === "commercial"
                ? "border-amber-500/50 text-amber-600 dark:text-amber-400 text-sm px-3 py-1"
                : "border-sky-500/50 text-sky-600 dark:text-sky-400 text-sm px-3 py-1"
            }
          >
            {survey.domain === "commercial" ? "소비 도메인" : "정치 도메인"}
          </Badge>
          {survey.isReal && (
            <Badge className="bg-emerald-600 hover:bg-emerald-600 gap-1 text-sm px-3 py-1">
              <BadgeCheck className="h-3.5 w-3.5" />실데이터
            </Badge>
          )}
          <Badge variant={survey.status === "active" ? "default" : "secondary"} className="text-sm px-3 py-1">
            {survey.status === "active" ? "인구 반영 중" : "종료됨"}
          </Badge>
        </div>
      </div>

      {survey.sourceAgency && (
        <Card className="border-emerald-600/30 bg-emerald-50/30 dark:bg-emerald-950/10">
          <CardHeader>
            <div className="flex items-center gap-2">
              <Building2 className="h-5 w-5 text-emerald-600" />
              <CardTitle className="text-base">출처 (공표 자료)</CardTitle>
            </div>
            <CardDescription>이 설문은 실제 공표된 여론조사 집계를 출처와 함께 인용했습니다.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3 text-sm">
            <div className="grid sm:grid-cols-2 gap-x-8 gap-y-3">
              <div className="flex items-start gap-2">
                <Building2 className="h-4 w-4 text-muted-foreground mt-0.5 shrink-0" />
                <div>
                  <p className="text-xs text-muted-foreground">조사 기관</p>
                  <p className="font-medium">{survey.sourceAgency}</p>
                </div>
              </div>
              {survey.sourceTitle && (
                <div className="flex items-start gap-2">
                  <FileText className="h-4 w-4 text-muted-foreground mt-0.5 shrink-0" />
                  <div>
                    <p className="text-xs text-muted-foreground">조사명</p>
                    <p className="font-medium">{survey.sourceTitle}</p>
                  </div>
                </div>
              )}
              {survey.fieldPeriod && (
                <div className="flex items-start gap-2">
                  <Clock className="h-4 w-4 text-muted-foreground mt-0.5 shrink-0" />
                  <div>
                    <p className="text-xs text-muted-foreground">조사 기간</p>
                    <p className="font-medium">{survey.fieldPeriod}</p>
                  </div>
                </div>
              )}
              <div className="flex items-start gap-2">
                <Users className="h-4 w-4 text-muted-foreground mt-0.5 shrink-0" />
                <div>
                  <p className="text-xs text-muted-foreground">표본수</p>
                  <p className="font-medium">{survey.sampleSize.toLocaleString()}명</p>
                </div>
              </div>
            </div>
            {survey.sourceUrl && (
              <a
                href={survey.sourceUrl}
                target="_blank"
                rel="noreferrer"
                className="inline-flex items-center gap-1.5 text-primary hover:underline pt-1"
              >
                원문 보기 <ExternalLink className="h-3.5 w-3.5" />
              </a>
            )}
          </CardContent>
        </Card>
      )}

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Card>
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 bg-primary/10 rounded-full text-primary">
              <Users className="h-5 w-5" />
            </div>
            <div>
              <p className="text-xs text-muted-foreground">표본 크기</p>
              <p className="font-semibold">{survey.sampleSize.toLocaleString()}명</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 bg-primary/10 rounded-full text-primary">
              <Calendar className="h-5 w-5" />
            </div>
            <div>
              <p className="text-xs text-muted-foreground">조사일</p>
              <p className="font-semibold">{new Date(survey.fieldedDate).toLocaleDateString()}</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 bg-primary/10 rounded-full text-primary">
              <Database className="h-5 w-5" />
            </div>
            <div>
              <p className="text-xs text-muted-foreground">방법론</p>
              <p className="font-semibold">{survey.methodology}</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 bg-primary/10 rounded-full text-primary">
              <Percent className="h-5 w-5" />
            </div>
            <div>
              <p className="text-xs text-muted-foreground">신뢰도</p>
              <p className="font-semibold">{survey.reliability}%</p>
            </div>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <div className="flex items-center gap-2">
            <CheckCircle className="h-5 w-5 text-green-500" />
            <CardTitle>학습된 태도 동인 (Attitude Drivers)</CardTitle>
          </div>
          <CardDescription>
            합성 인구가 이 설문을 바탕으로 학습한 주요 이슈별 가중치와 방향성입니다.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>요인 (Factor)</TableHead>
                <TableHead>관련 이슈 (Issue)</TableHead>
                <TableHead>방향 (Direction)</TableHead>
                <TableHead className="w-[30%]">가중치 (Weight)</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {survey.drivers.map((driver, idx) => (
                <TableRow key={idx}>
                  <TableCell className="font-medium">{driver.factor}</TableCell>
                  <TableCell>
                    <Badge variant="outline">{driver.issue}</Badge>
                  </TableCell>
                  <TableCell>{driver.direction}</TableCell>
                  <TableCell>
                    <div className="flex items-center gap-2">
                      <Progress value={driver.weight * 100} className="h-2" />
                      <span className="text-xs text-muted-foreground w-8 text-right">
                        {(driver.weight * 100).toFixed(0)}%
                      </span>
                    </div>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      {survey.domain === "commercial" && (
        <Card className="border-amber-500/30 bg-amber-50/30 dark:bg-amber-950/10">
          <CardHeader>
            <div className="flex items-center gap-2">
              <Info className="h-5 w-5 text-amber-600" />
              <CardTitle className="text-base">공개 데이터 한계</CardTitle>
            </div>
          </CardHeader>
          <CardContent className="text-sm text-muted-foreground space-y-1.5">
            <p>
              본 소비자 태도 보정은 공표된 정부·공공기관 집계 통계에 기반합니다. 브랜드별
              선호, 세부 구매 채널, SKU 단위 전환율 등 세분화된 행태 데이터는 공개되지
              않으며, 정밀 분석에는 유료 소비자 패널 데이터가 필요합니다.
            </p>
            <p>
              따라서 합성 인구의 소비 성향은 거시 추세(가격 민감·디지털 소비 등)를
              반영한 근사치이며, 특정 제품의 실제 시장 점유율 예측이 아닙니다.
            </p>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
