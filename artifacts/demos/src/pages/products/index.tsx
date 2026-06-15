import { useListProducts } from "@workspace/api-client-react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Box, Target, Briefcase, Landmark } from "lucide-react";
import { Badge } from "@/components/ui/badge";

export default function Products() {
  const { data: products, isLoading } = useListProducts();

  if (isLoading || !products) {
    return (
      <div className="space-y-6">
        <div className="space-y-2">
          <Skeleton className="h-10 w-48" />
          <Skeleton className="h-5 w-64" />
        </div>
        <div className="grid gap-6 md:grid-cols-3">
          {[1, 2, 3].map(i => <Skeleton key={i} className="h-64 w-full" />)}
        </div>
      </div>
    );
  }

  const getIcon = (name: string) => {
    switch (name.toLowerCase()) {
      case "lumen": return <Briefcase className="h-6 w-6 text-blue-500" />;
      case "seraph": return <Landmark className="h-6 w-6 text-purple-500" />;
      case "dynamo": return <Target className="h-6 w-6 text-orange-500" />;
      default: return <Box className="h-6 w-6" />;
    }
  };

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">제품 라인업</h1>
        <p className="text-muted-foreground mt-1">대상 및 목적별 시뮬레이션 솔루션</p>
      </div>

      <div className="grid gap-6 md:grid-cols-3">
        {products.map((product) => (
          <Card key={product.id} className="flex flex-col">
            <CardHeader>
              <div className="flex items-center gap-3 mb-2">
                {getIcon(product.name)}
                <CardTitle className="text-2xl">{product.name}</CardTitle>
              </div>
              <CardDescription className="text-base font-medium text-foreground">
                {product.tagline}
              </CardDescription>
              <Badge variant="secondary" className="w-fit mt-2">대상: {product.audience}</Badge>
            </CardHeader>
            <CardContent className="flex-1 flex flex-col gap-4">
              <p className="text-sm text-muted-foreground">
                {product.description}
              </p>
              <div className="mt-auto pt-4 border-t border-border">
                <h4 className="text-sm font-semibold mb-2">주요 활용 사례:</h4>
                <ul className="space-y-2">
                  {product.useCases.map((useCase, idx) => (
                    <li key={idx} className="text-sm flex items-start gap-2">
                      <span className="text-primary mt-0.5">•</span>
                      <span>{useCase}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
