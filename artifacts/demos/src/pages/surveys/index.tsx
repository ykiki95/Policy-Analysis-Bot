import { useListSurveys } from "@workspace/api-client-react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Link } from "wouter";
import { Database, Calendar, Users, Percent } from "lucide-react";
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
                  <Badge variant={survey.status === "active" ? "default" : "secondary"}>
                    {survey.status === "active" ? "활성" : "종료"}
                  </Badge>
                </div>
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
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>
    </div>
  );
}
