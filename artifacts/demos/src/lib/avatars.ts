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
 * avatar 키가 설정돼 있으면 해당 프리셋, 없으면 id 기반으로 결정론적 기본 아바타를 고른다
 * (계정마다 항상 같은 가상 인물이 보이도록).
 */
export function avatarSrc(
  user?: { id?: number; avatar?: string | null } | null,
): string {
  if (user?.avatar) {
    const found = AVATARS.find((a) => a.key === user.avatar);
    if (found) return found.src;
  }
  const id = user?.id ?? 0;
  return AVATARS[id % AVATARS.length].src;
}
