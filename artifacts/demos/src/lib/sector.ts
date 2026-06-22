/**
 * 제품(내부 브랜드값) → 부문 표시 라벨.
 * 화면에는 이 라벨만 노출하고, 데이터 값은 제품 코드(Lumen/Seraph/Dynamo)를 유지한다.
 * 라벨을 바꾸려면 이 함수 한 곳만 수정하면 전 화면에 반영된다.
 */
export function sectorLabel(product: string): string {
  return product === "Lumen"
    ? "비즈니스"
    : product === "Seraph"
      ? "정부"
      : "정치";
}
