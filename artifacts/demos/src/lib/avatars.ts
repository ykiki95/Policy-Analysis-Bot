import av1 from "@/assets/avatars/av1.png";
import av2 from "@/assets/avatars/av2.png";
import av3 from "@/assets/avatars/av3.png";
import av4 from "@/assets/avatars/av4.png";
import av5 from "@/assets/avatars/av5.png";
import av6 from "@/assets/avatars/av6.png";
import av7 from "@/assets/avatars/av7.png";
import av8 from "@/assets/avatars/av8.png";

/** 프로필 아바타 프리셋(가상 인물 일러스트). key 는 DB users.avatar 에 저장한다. */
export const AVATARS: { key: string; src: string }[] = [
  { key: "av1", src: av1 },
  { key: "av2", src: av2 },
  { key: "av3", src: av3 },
  { key: "av4", src: av4 },
  { key: "av5", src: av5 },
  { key: "av6", src: av6 },
  { key: "av7", src: av7 },
  { key: "av8", src: av8 },
];

/**
 * 사용자에게 보여줄 아바타 이미지 URL.
 * - avatar 가 업로드한 사진(data URL / http / 절대경로)이면 그대로 사용
 * - 프리셋 키(av1..av8)면 해당 일러스트
 * - 비어 있으면 id 기반으로 결정론적 기본 아바타를 고른다(가입 전/레거시 계정 대비)
 */
export function avatarSrc(
  user?: { id?: number; avatar?: string | null } | null,
): string {
  const v = user?.avatar;
  if (v) {
    if (
      v.startsWith("data:") ||
      v.startsWith("http://") ||
      v.startsWith("https://") ||
      v.startsWith("/")
    ) {
      return v;
    }
    const found = AVATARS.find((a) => a.key === v);
    if (found) return found.src;
  }
  const id = user?.id ?? 0;
  return AVATARS[id % AVATARS.length].src;
}

/** avatar 값이 사용자가 직접 올린 사진(프리셋이 아님)인지 여부. */
export function isUploadedAvatar(value?: string | null): boolean {
  return (
    !!value &&
    (value.startsWith("data:") ||
      value.startsWith("http://") ||
      value.startsWith("https://") ||
      value.startsWith("/"))
  );
}

/**
 * 사용자가 고른 이미지 파일/blob 을 정사각형으로 잘라 축소한 JPEG data URL 로 변환한다.
 * (파일 업로드·드래그앤드롭·붙여넣기 모두 동일 경로로 처리)
 */
export async function fileToAvatarDataUrl(
  file: Blob,
  size = 256,
): Promise<string> {
  if (!file.type.startsWith("image/")) {
    throw new Error("이미지 파일만 사용할 수 있습니다.");
  }
  const sourceUrl = await new Promise<string>((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result as string);
    reader.onerror = () => reject(reader.error ?? new Error("파일을 읽을 수 없습니다."));
    reader.readAsDataURL(file);
  });
  const img = await new Promise<HTMLImageElement>((resolve, reject) => {
    const image = new Image();
    image.onload = () => resolve(image);
    image.onerror = () => reject(new Error("이미지를 불러올 수 없습니다."));
    image.src = sourceUrl;
  });
  const canvas = document.createElement("canvas");
  canvas.width = size;
  canvas.height = size;
  const ctx = canvas.getContext("2d");
  if (!ctx) throw new Error("이미지를 처리할 수 없습니다.");
  // 정사각형 중앙 크롭 후 size×size 로 그린다.
  const side = Math.min(img.width, img.height);
  const sx = (img.width - side) / 2;
  const sy = (img.height - side) / 2;
  ctx.drawImage(img, sx, sy, side, side, 0, 0, size, size);
  return canvas.toDataURL("image/jpeg", 0.85);
}
