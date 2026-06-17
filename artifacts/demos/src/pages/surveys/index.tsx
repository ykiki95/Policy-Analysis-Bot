import { useState } from "react";
import { useListSurveys } from "@workspace/api-client-react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Link } from "wouter";
import { Database, Calendar, Users, Percent, BadgeCheck, Building2, ExternalLink, LayoutGrid, List } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";

type DomainKey = "commercial" | "policy" | string;

function domainBadgeClass(domain: DomainKey) {
  return domain === "commercial"
    ? "border-amber-500/50 text-amber-600 dark:text-amber-400"
    : domain === "policy"
      ? "border-violet-500/50 text-violet-600 dark:text-violet-400"
      : "border-sky-500/50 text-sky-600 dark:text-sky-400";
}

function domainLabel(domain: DomainKey) {
  return domain === "commercial" ? "소비" : domain === "policy" ? "정책" : "정치";
}

export default function Surveys() {
  const { data: surveys, isLoading } = useListSurveys();
  const [view, setView] = useState<"box" | "list">("box");

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

  const sorted = [...surveys].sort(
    (a, b) => new Date(b.fieldedDate).getTime() - new Date(a.fieldedDate).getTime(),
  );

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">설문조사 기준</h1>
          <p className="text-muted-foreground mt-1">합성 인구의 태도 모델을 훈련시키는 데 사용된 설문 데이터 목록입니다. (최신순)</p>
        </div>
        <div className="inline-flex items-center rounded-md border p-0.5 self-start sm:self-auto">
          <Button
            variant={view === "box" ? "secondary" : "ghost"}
            size="sm"
            className="h-8 gap-1.5"
            onClick={() => setView("box")}
            aria-pressed={view === "box"}
          >
            <LayoutGrid className="h-4 w-4" /> 박스형
          </Button>
          <Button
            variant={view === "list" ? "secondary" : "ghost"}
            size="sm"
            className="h-8 gap-1.5"
            onClick={() => setView("list")}
            aria-pressed={view === "list"}
          >
            <List className="h-4 w-4" /> 리스트형
          </Button>
        </div>
      </div>

      {view === "box" ? (
        <div className="grid gap-4 md:grid-cols-2">
          {sorted.map((survey) => (
            <Link key={survey.id} href={`/surveys/${survey.id}`}>
              <Card className="hover:border-primary transition-colors cursor-pointer h-full">
                <CardHeader>
                  <div className="flex justify-between items-start">
                    <div>
                      <CardTitle className="text-lg">{survey.title}</CardTitle>
                      <CardDescription className="mt-1 line-clamp-2">{survey.description}</CardDescription>
                    </div>
                    <div className="flex flex-col items-end gap-1.5 shrink-0">
                      <Badge variant="outline" className={domainBadgeClass(survey.domain)}>
                        {domainLabel(survey.domain)}
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
      ) : (
        <div className="border rounded-md divide-y">
          {sorted.map((survey) => (
            <Link key={survey.id} href={`/surveys/${survey.id}`}>
              <div className="flex items-center gap-4 px-4 py-3 hover:bg-muted/50 transition-colors cursor-pointer">
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2">
                    <span className="font-medium truncate">{survey.title}</span>
                    <Badge variant="outline" className={`shrink-0 ${domainBadgeClass(survey.domain)}`}>
                      {domainLabel(survey.domain)}
                    </Badge>
                    {survey.isReal && (
                      <Badge className="bg-emerald-600 hover:bg-emerald-600 gap-1 shrink-0">
                        <BadgeCheck className="h-3 w-3" />실데이터
                      </Badge>
                    )}
                  </div>
                  <div className="flex flex-wrap items-center gap-x-3 gap-y-0.5 text-xs text-muted-foreground mt-1">
                    {survey.sourceAgency && (
                      <span className="inline-flex items-center gap-1">
                        <Building2 className="h-3 w-3" />{survey.sourceAgency}
                      </span>
                    )}
                    <span className="inline-flex items-center gap-1">
                      <Calendar className="h-3 w-3" />{new Date(survey.fieldedDate).toLocaleDateString()}
                    </span>
                    <span className="inline-flex items-center gap-1">
                      <Users className="h-3 w-3" />{survey.sampleSize.toLocaleString()}명
                    </span>
                    <span className="inline-flex items-center gap-1">
                      <Percent className="h-3 w-3" />신뢰도 {survey.reliability}%
                    </span>
                  </div>
                </div>
                <Badge variant={survey.status === "active" ? "default" : "secondary"} className="shrink-0">
                  {survey.status === "active" ? "반영 중" : "종료"}
                </Badge>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
