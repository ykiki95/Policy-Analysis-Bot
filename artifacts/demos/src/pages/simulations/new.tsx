import { useState, useEffect, useRef } from "react";
import { useEstimateSimulation, useCreateSimulation, useRunSimulation, getListSimulationsQueryKey, getGetDashboardSummaryQueryKey, getGetBudgetQueryKey, ApiError } from "@workspace/api-client-react";
import { useLocation } from "wouter";
import { useQueryClient } from "@tanstack/react-query";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import * as z from "zod";

import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Form, FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Loader2, Calculator, PlayCircle, AlertCircle } from "lucide-react";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";

const formSchema = z.object({
  title: z.string().min(2, { message: "제목은 2자 이상이어야 합니다." }),
  product: z.string().min(1, { message: "제품 라인을 선택해주세요." }),
  model: z.string().min(1),
  policyText: z.string().min(10, { message: "내용은 최소 10자 이상 입력해주세요." }),
});

/** 제품 라인이 트랙·대상을 결정한다 (audience는 설명용 라벨). */
const PRODUCT_OPTIONS: { value: string; label: string; audience: string }[] = [
  { value: "Lumen", label: "Lumen (비즈니스)", audience: "비즈니스" },
  { value: "Seraph", label: "Seraph (정부/공공)", audience: "정부" },
  { value: "Dynamo", label: "Dynamo (정치/캠페인)", audience: "정치" },
];

function audienceForProduct(product: string): string {
  return PRODUCT_OPTIONS.find((p) => p.value === product)?.audience ?? "";
}

export default function NewSimulation() {
  const [, setLocation] = useLocation();
  const queryClient = useQueryClient();
  const [estimateLoading, setEstimateLoading] = useState(false);
  const [estimatedCost, setEstimatedCost] = useState<{min: number, max: number, time: number, totalAgents: number} | null>(null);
  const [runError, setRunError] = useState<string | null>(null);

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      title: "",
      product: "Seraph",
      model: "gpt-5-mini",
      policyText: "",
    },
  });

  const estimateMut = useEstimateSimulation();
  const createMut = useCreateSimulation();
  const runMut = useRunSimulation();

  const watchModel = form.watch("model");
  const watchProduct = form.watch("product");
  const derivedAudience = audienceForProduct(watchProduct);

  useEffect(() => {
    // Automatically estimate when model changes
    setEstimateLoading(true);
    estimateMut.mutate(
      { data: { model: watchModel } },
      {
        onSuccess: (data) => {
          setEstimatedCost({
            min: data.estimatedLowUsd,
            max: data.estimatedHighUsd,
            time: data.estimatedSeconds,
            totalAgents: data.totalAgents
          });
          setEstimateLoading(false);
        },
        onError: () => setEstimateLoading(false)
      }
    );
  }, [watchModel]);

  const onSubmit = (values: z.infer<typeof formSchema>) => {
    setRunError(null);
    createMut.mutate(
      { data: { ...values, audience: audienceForProduct(values.product) } },
      {
        onSuccess: (sim) => {
          queryClient.invalidateQueries({ queryKey: getListSimulationsQueryKey() });
          queryClient.invalidateQueries({ queryKey: getGetDashboardSummaryQueryKey() });

          // 큐에 적재(워커가 실행). 예산 초과 시 402.
          runMut.mutate({ id: sim.id }, {
            onSuccess: () => {
              queryClient.invalidateQueries({ queryKey: getGetBudgetQueryKey() });
              setLocation(`/simulations/${sim.id}`);
            },
            onError: (err) => {
              if (err instanceof ApiError && err.status === 402) {
                setRunError(
                  "예산 한도를 초과하여 실행할 수 없습니다. 관리자에게 한도 상향을 요청하세요. (시뮬레이션은 생성되었으나 대기 상태입니다.)",
                );
              } else {
                setRunError("실행 요청에 실패했습니다. 잠시 후 다시 시도해 주세요.");
              }
            },
          });
        },
      }
    );
  };

  return (
    <div className="space-y-6 max-w-3xl mx-auto">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">새 시뮬레이션</h1>
        <p className="text-muted-foreground mt-1">전국 합성 인구를 대상으로 실험을 설계하고 실행합니다.</p>
      </div>

      <div className="grid md:grid-cols-3 gap-6">
        <div className="md:col-span-2 space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>시뮬레이션 설정</CardTitle>
            </CardHeader>
            <CardContent>
              <Form {...form}>
                <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
                  <FormField
                    control={form.control}
                    name="title"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>시뮬레이션 제목</FormLabel>
                        <FormControl>
                          <Input placeholder="예: 2025 서울시 청년 주거 지원 정책" {...field} />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="product"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>제품 라인</FormLabel>
                        <Select onValueChange={field.onChange} defaultValue={field.value}>
                          <FormControl>
                            <SelectTrigger>
                              <SelectValue placeholder="선택하세요" />
                            </SelectTrigger>
                          </FormControl>
                          <SelectContent>
                            {PRODUCT_OPTIONS.map((p) => (
                              <SelectItem key={p.value} value={p.value}>{p.label}</SelectItem>
                            ))}
                          </SelectContent>
                        </Select>
                        <FormDescription>
                          제품 라인이 시뮬레이션 트랙과 대상 부문을 결정합니다.{" "}
                          {derivedAudience && (
                            <>대상 부문: <span className="font-medium text-foreground">{derivedAudience}</span></>
                          )}
                        </FormDescription>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="model"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>LLM 추론 모델</FormLabel>
                        <Select onValueChange={field.onChange} defaultValue={field.value}>
                          <FormControl>
                            <SelectTrigger>
                              <SelectValue placeholder="선택하세요" />
                            </SelectTrigger>
                          </FormControl>
                          <SelectContent>
                            <SelectItem value="gpt-5-nano">gpt-5-nano (가장 빠름, 저비용)</SelectItem>
                            <SelectItem value="gpt-5-mini">gpt-5-mini (기본, 균형)</SelectItem>
                            <SelectItem value="gpt-5">gpt-5 (최고 품질, 고비용)</SelectItem>
                          </SelectContent>
                        </Select>
                        <FormDescription>
                          추론 복잡도와 예산에 따라 모델을 선택하세요.
                        </FormDescription>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="policyText"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>정책 / 메시지 원문</FormLabel>
                        <FormControl>
                          <Textarea 
                            placeholder="에이전트들에게 제시할 정책, 메시지 또는 제품 컨셉을 구체적으로 작성하세요." 
                            className="h-32" 
                            {...field} 
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  {runError && (
                    <Alert variant="destructive">
                      <AlertCircle className="h-4 w-4" />
                      <AlertTitle>실행할 수 없습니다</AlertTitle>
                      <AlertDescription>{runError}</AlertDescription>
                    </Alert>
                  )}

                  <Button type="submit" disabled={createMut.isPending || runMut.isPending} className="w-full">
                    {createMut.isPending || runMut.isPending ? (
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    ) : (
                      <PlayCircle className="mr-2 h-4 w-4" />
                    )}
                    생성 및 실행
                  </Button>
                </form>
              </Form>
            </CardContent>
          </Card>
        </div>

        <div className="space-y-6">
          <Alert>
            <Calculator className="h-4 w-4" />
            <AlertTitle>예상 실행 비용</AlertTitle>
            <AlertDescription className="mt-2">
              {estimateLoading || !estimatedCost ? (
                <div className="flex items-center gap-2 mt-2">
                  <Loader2 className="h-4 w-4 animate-spin" />
                  <span>비용 산출 중...</span>
                </div>
              ) : (
                <div className="space-y-2">
                  <div className="text-2xl font-bold text-primary">
                    ${(estimatedCost.min * 10).toFixed(2)} - ${(estimatedCost.max * 10).toFixed(2)}
                  </div>
                  <div className="text-sm text-muted-foreground">
                    대상 에이전트: {estimatedCost.totalAgents.toLocaleString()}명<br/>
                    예상 소요 시간: 약 {estimatedCost.time}초
                  </div>
                </div>
              )}
            </AlertDescription>
          </Alert>
          
          <Card className="bg-muted/50 border-none shadow-none">
            <CardContent className="p-4 text-sm text-muted-foreground leading-relaxed">
              <p className="font-semibold mb-2 text-foreground">주의사항</p>
              <ul className="list-disc pl-4 space-y-1">
                <li>실제 비용은 생성되는 응답의 길이에 따라 약간의 오차가 있을 수 있습니다.</li>
                <li>실행 버튼을 누르면 비용이 청구되며 취소할 수 없습니다.</li>
                <li>응답은 <strong>결과 화면을 열어 두는 동안</strong> 수집됩니다. 창을 닫으면 일시 중지되고, 다시 열면 이어서 진행됩니다.</li>
              </ul>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
