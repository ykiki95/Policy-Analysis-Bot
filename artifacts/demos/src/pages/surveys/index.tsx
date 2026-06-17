import { useListSurveys } from "@workspace/api-client-react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Link } from "wouter";
import { Database, Calendar, Users, Percent, BadgeCheck, Building2, ExternalLink } from "lucide-react";
import { Badge } from "@/components/ui/badge";

export default function Surveys() {
  const { data: surveys, isLoading } = useListSurveys();

  if (isLoading || !surveys) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-10 w-48" />
        <div className="grid gap-4">
          <Skeleton className="h-32 w-full" />
          <Skeleton className="h-32 w-full" />
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">설문조사 기준</h1>
        <p className="text-muted-foreground mt-1">합성 인구의 태도 모델을 훈련시키는 데 사용된 설문 데이터 목록입니다.</p>
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        {surveys.map((survey) => (
          <Link key={survey.id} href={`/surveys/${survey.id}`}>
            <Card className="hover:border-primary transition-colors cursor-pointer h-full">
              <CardHeader>
                <div className="flex justify-between items-start">
                  <div>
                    <CardTitle className="text-lg">{survey.title}</CardTitle>
                    <CardDescription className="mt-1 line-clamp-2">{survey.description}</CardDescription>
                  </div>
                  <div className="flex flex-col items-end gap-1.5 shrink-0">
                    <Badge
                      variant="outline"
                      className={
                        survey.domain === "commercial"
                          ? "border-amber-500/50 text-amber-600 dark:text-amber-400"
                          : survey.domain === "policy"
                            ? "border-violet-500/50 text-violet-600 dark:text-violet-400"
                            : "border-sky-500/50 text-sky-600 dark:text-sky-400"
                      }
                    >
                      {survey.domain === "commercial"
                        ? "소비"
                        : survey.domain === "policy"
                          ? "정책"
                          : "정치"}
                    </Badge>
                    {survey.isReal && (
                      <Badge className="bg-emerald-600 hover:bg-emerald-600 gap-1">
                        <BadgeCheck className="h-3 w-3" />실데이터
                      </Badge>
                    )}
                    <Badge variant={survey.status === "active" ? "default" : "secondary"}>
                      {survey.status === "active" ? "반영 중" : "종료"}
                    </Badge>
                  </div>
                </div>
                {survey.sourceAgency && (
                  <div className="flex items-center gap-1.5 text-xs text-muted-foreground mt-2">
                    <Building2 className="h-3.5 w-3.5" />
                    <span className="font-medium text-foreground/80">{survey.sourceAgency}</span>
                    {survey.fieldPeriod && <span>· {survey.fieldPeriod}</span>}
                  </div>
                )}
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-2 gap-4 text-sm mt-4">
                  <div className="flex items-center gap-2 text-muted-foreground">
                    <Users className="h-4 w-4" />
                    <span>표본: {survey.sampleSize.toLocaleString()}명</span>
                  </div>
                  <div className="flex items-center gap-2 text-muted-foreground">
                    <Calendar className="h-4 w-4" />
                    <span>조사일: {new Date(survey.fieldedDate).toLocaleDateString()}</span>
                  </div>
                  <div className="flex items-center gap-2 text-muted-foreground">
                    <Database className="h-4 w-4" />
                    <span className="truncate">방법론: {survey.methodology}</span>
                  </div>
                  <div className="flex items-center gap-2 text-muted-foreground">
                    <Percent className="h-4 w-4" />
                    <span>신뢰도: {survey.reliability}%</span>
                  </div>
                </div>
                {survey.sourceUrl && (
                  <span
                    role="link"
                    tabIndex={0}
                    onClick={(e) => {
                      e.preventDefault();
                      e.stopPropagation();
                      window.open(survey.sourceUrl!, "_blank", "noopener,noreferrer");
                    }}
                    className="mt-4 inline-flex items-center gap-1 text-xs text-primary hover:underline cursor-pointer"
                  >
                    출처 보기 <ExternalLink className="h-3 w-3" />
                  </span>
                )}
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>
    </div>
  );
}
