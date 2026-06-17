import { useGetAgent, getGetAgentQueryKey } from "@workspace/api-client-react";
import { useParams, Link } from "wouter";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { ArrowLeft, MapPin, Briefcase, GraduationCap, DollarSign, Home, Heart, Tv, ShoppingCart, Landmark } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";

export default function AgentDetail() {
  const params = useParams();
  const id = parseInt(params.id || "0", 10);

  const { data: agent, isLoading } = useGetAgent(id, {
    query: { enabled: !!id, queryKey: getGetAgentQueryKey(id) }
  });

  if (isLoading || !agent) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-24" />
        <Skeleton className="h-24 w-full" />
        <div className="grid grid-cols-2 gap-4">
          <Skeleton className="h-64 w-full" />
          <Skeleton className="h-64 w-full" />
        </div>
      </div>
    );
  }

  const getLeaningColor = (val: number) => {
    if (val < -20) return "text-blue-500 bg-blue-500/10";
    if (val > 20) return "text-red-500 bg-red-500/10";
    return "text-gray-500 bg-gray-500/10";
  };

  return (
    <div className="space-y-6">
      <Link href="/population" className="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground w-fit transition-colors">
        <ArrowLeft className="h-4 w-4" />
        인구 목록으로 돌아가기
      </Link>

      <div className="flex flex-col md:flex-row gap-6 items-start">
        <div className="flex-1 space-y-2">
          <div className="flex items-center gap-3">
            <h1 className="text-3xl font-bold tracking-tight">{agent.name}</h1>
            <Badge variant="outline" className={getLeaningColor(agent.politicalLeaning)}>
              정치 성향: {agent.politicalLeaning > 0 ? '+' : ''}{agent.politicalLeaning}
            </Badge>
          </div>
          <p className="text-muted-foreground text-lg">
            {agent.age}세 • {agent.gender === 'Male' ? '남성' : '여성'} • {agent.district}
          </p>
          <div className="pt-4 text-sm leading-relaxed border-t border-border mt-4">
            {agent.personaSummary}
          </div>
        </div>
      </div>

      <div className="grid md:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>인구통계 프로필</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex items-center gap-3">
              <Briefcase className="h-4 w-4 text-muted-foreground" />
              <div>
                <p className="text-xs text-muted-foreground">직업</p>
                <p className="font-medium">{agent.occupation}</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <GraduationCap className="h-4 w-4 text-muted-foreground" />
              <div>
                <p className="text-xs text-muted-foreground">학력</p>
                <p className="font-medium">{agent.education}</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <DollarSign className="h-4 w-4 text-muted-foreground" />
              <div>
                <p className="text-xs text-muted-foreground">소득 분위</p>
                <p className="font-medium">{agent.incomeBracket}</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <Home className="h-4 w-4 text-muted-foreground" />
              <div>
                <p className="text-xs text-muted-foreground">가구 형태</p>
                <p className="font-medium">{agent.householdType}</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <Heart className="h-4 w-4 text-muted-foreground" />
              <div>
                <p className="text-xs text-muted-foreground">정당 지지도</p>
                <p className="font-medium">{agent.partyAffinity}</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>주요 이슈 입장 (0-100)</CardTitle>
            <CardDescription>높을수록 해당 이슈에 대한 긍정적/적극적 태도를 의미합니다.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-5">
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="font-medium">경제 성향</span>
                <span>{agent.issueStances.economy}</span>
              </div>
              <Progress value={agent.issueStances.economy} className="h-2" />
            </div>
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="font-medium">복지 정책</span>
                <span>{agent.issueStances.welfare}</span>
              </div>
              <Progress value={agent.issueStances.welfare} className="h-2" />
            </div>
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="font-medium">안보/외교</span>
                <span>{agent.issueStances.security}</span>
              </div>
              <Progress value={agent.issueStances.security} className="h-2" />
            </div>
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="font-medium">환경 문제</span>
                <span>{agent.issueStances.environment}</span>
              </div>
              <Progress value={agent.issueStances.environment} className="h-2" />
            </div>
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="font-medium">주거/부동산</span>
                <span>{agent.issueStances.housing}</span>
              </div>
              <Progress value={agent.issueStances.housing} className="h-2" />
            </div>
          </CardContent>
        </Card>

        <Card className="md:col-span-2">
          <CardHeader>
            <div className="flex items-center gap-2">
              <ShoppingCart className="h-5 w-5 text-amber-600" />
              <CardTitle>소비 성향 (0-100)</CardTitle>
            </div>
            <CardDescription>
              Lumen(비즈니스) 시뮬레이션에서 사용되는 소비자 태도 축입니다. 공개 소비자
              조사 통계로 보정된 합성 값입니다.
            </CardDescription>
          </CardHeader>
          <CardContent className="grid sm:grid-cols-2 gap-x-8 gap-y-5">
            {[
              { label: "가격 민감도", value: agent.consumerStances.priceSensitivity },
              { label: "브랜드 충성도", value: agent.consumerStances.brandLoyalty },
              { label: "신제품 수용", value: agent.consumerStances.noveltySeeking },
              { label: "친환경 소비", value: agent.consumerStances.ecoConsciousness },
              { label: "디지털 소비", value: agent.consumerStances.digitalConsumption },
            ].map((axis) => (
              <div key={axis.label} className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="font-medium">{axis.label}</span>
                  <span>{axis.value}</span>
                </div>
                <Progress value={axis.value} className="h-2" />
              </div>
            ))}
          </CardContent>
        </Card>

        <Card className="md:col-span-2">
          <CardHeader>
            <div className="flex items-center gap-2">
              <Landmark className="h-5 w-5 text-violet-600" />
              <CardTitle>정책 성향 (0-100)</CardTitle>
            </div>
            <CardDescription>
              Seraph(정부) 시뮬레이션에서 사용되는 정책·행정 태도 축입니다. 사회통합실태조사
              ·사회조사·전자정부 이용실태 등 공개 통계로 보정된 합성 값입니다.
            </CardDescription>
          </CardHeader>
          <CardContent className="grid sm:grid-cols-2 gap-x-8 gap-y-5">
            {[
              { label: "정부 신뢰", value: agent.policyStances.governmentTrust },
              { label: "정책 수용성", value: agent.policyStances.policyAcceptance },
              { label: "증세 수용", value: agent.policyStances.taxTolerance },
              { label: "규제 선호", value: agent.policyStances.regulationPreference },
              {
                label: "공공서비스 만족",
                value: agent.policyStances.publicServiceSatisfaction,
              },
            ].map((axis) => (
              <div key={axis.label} className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="font-medium">{axis.label}</span>
                  <span>{axis.value}</span>
                </div>
                <Progress value={axis.value} className="h-2" />
              </div>
            ))}
          </CardContent>
        </Card>

        <Card className="md:col-span-2">
          <CardHeader>
            <CardTitle>추가 정보</CardTitle>
          </CardHeader>
          <CardContent className="grid md:grid-cols-2 gap-6">
            <div>
              <div className="flex items-center gap-2 mb-3 text-sm font-semibold">
                <Tv className="h-4 w-4" />
                미디어 소비
              </div>
              <p className="text-sm text-muted-foreground bg-muted/30 p-3 rounded-md">
                {agent.mediaDiet}
              </p>
            </div>
            <div>
              <div className="flex items-center gap-2 mb-3 text-sm font-semibold">
                <Heart className="h-4 w-4" />
                핵심 가치관
              </div>
              <div className="flex flex-wrap gap-2">
                {agent.values.map((v, i) => (
                  <Badge key={i} variant="secondary">{v}</Badge>
                ))}
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
