import { useState, useEffect, useRef, useCallback } from "react";
import { useQueryClient } from "@tanstack/react-query";
import { Loader2, Check, Upload, X } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import {
  useUpdateProfile,
  useChangePassword,
  getGetMeQueryKey,
  getListAdminAccountsQueryKey,
  type User,
} from "@workspace/api-client-react";
import { useToast } from "@/hooks/use-toast";
import {
  AVATARS,
  avatarSrc,
  fileToAvatarDataUrl,
  isUploadedAvatar,
} from "@/lib/avatars";

export function ProfileDialog({
  user,
  open,
  onOpenChange,
}: {
  user: User;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const updateProfile = useUpdateProfile();
  const changePassword = useChangePassword();

  const [name, setName] = useState(user.name);
  const [avatar, setAvatar] = useState<string | null>(user.avatar ?? null);
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [isDragging, setIsDragging] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  // 다이얼로그를 열 때마다 현재 사용자 값으로 초기화한다.
  useEffect(() => {
    if (open) {
      setName(user.name);
      setAvatar(user.avatar ?? null);
      setCurrentPassword("");
      setNewPassword("");
      setConfirmPassword("");
      setIsDragging(false);
    }
  }, [open, user.name, user.avatar]);

  // 이미지 파일/blob → 축소된 data URL 로 변환해 아바타로 설정한다.
  const applyImage = useCallback(
    async (file: Blob | null | undefined) => {
      if (!file) return;
      try {
        const dataUrl = await fileToAvatarDataUrl(file);
        setAvatar(dataUrl);
      } catch (err) {
        toast({
          title: "사진을 사용할 수 없습니다",
          description:
            err instanceof Error ? err.message : "다른 이미지를 시도해 주세요.",
          variant: "destructive",
        });
      }
    },
    [toast],
  );

  // 붙여넣기(클립보드 이미지) 지원 — 다이얼로그가 열려 있는 동안만.
  useEffect(() => {
    if (!open) return;
    const onPaste = (e: ClipboardEvent) => {
      const items = e.clipboardData?.items;
      if (!items) return;
      for (const item of items) {
        if (item.type.startsWith("image/")) {
          const file = item.getAsFile();
          if (file) {
            e.preventDefault();
            void applyImage(file);
            break;
          }
        }
      }
    };
    window.addEventListener("paste", onPaste);
    return () => window.removeEventListener("paste", onPaste);
  }, [open, applyImage]);

  const saveProfile = async () => {
    if (!name.trim()) {
      toast({ title: "이름을 입력하세요", variant: "destructive" });
      return;
    }
    try {
      await updateProfile.mutateAsync({ data: { name: name.trim(), avatar } });
      await queryClient.invalidateQueries({ queryKey: getGetMeQueryKey() });
      await queryClient.invalidateQueries({ queryKey: getListAdminAccountsQueryKey() });
      toast({ title: "프로필 저장 완료", description: "변경 사항이 적용되었습니다." });
      onOpenChange(false);
    } catch {
      toast({ title: "프로필 저장 실패", description: "잠시 후 다시 시도해 주세요.", variant: "destructive" });
    }
  };

  const savePassword = async () => {
    if (!currentPassword) {
      toast({ title: "현재 비밀번호를 입력하세요", variant: "destructive" });
      return;
    }
    if (newPassword.length < 4) {
      toast({ title: "새 비밀번호는 4자 이상이어야 합니다", variant: "destructive" });
      return;
    }
    if (newPassword !== confirmPassword) {
      toast({ title: "새 비밀번호가 일치하지 않습니다", variant: "destructive" });
      return;
    }
    try {
      await changePassword.mutateAsync({ data: { currentPassword, newPassword } });
      toast({ title: "비밀번호 변경 완료", description: "다음 로그인부터 새 비밀번호를 사용하세요." });
      setCurrentPassword("");
      setNewPassword("");
      setConfirmPassword("");
      onOpenChange(false);
    } catch {
      toast({
        title: "비밀번호 변경 실패",
        description: "현재 비밀번호가 올바른지 확인해 주세요.",
        variant: "destructive",
      });
    }
  };

  const previewSrc = avatarSrc({ id: user.id, avatar });
  const initial = name.charAt(0) || user.username.charAt(0);

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>프로필 수정</DialogTitle>
          <DialogDescription>
            프로필 사진과 이름을 변경하거나 비밀번호를 변경할 수 있습니다.
          </DialogDescription>
        </DialogHeader>

        <Tabs defaultValue="profile">
          <TabsList className="grid w-full grid-cols-2">
            <TabsTrigger value="profile">프로필</TabsTrigger>
            <TabsTrigger value="password">비밀번호</TabsTrigger>
          </TabsList>

          <TabsContent value="profile" className="space-y-4 pt-2">
            <div className="flex items-center gap-4">
              <Avatar className="h-16 w-16">
                <AvatarImage src={previewSrc} alt={name} />
                <AvatarFallback>{initial}</AvatarFallback>
              </Avatar>
              <div className="text-sm text-muted-foreground">
                내 사진을 올리거나 아래 기본 아바타를 선택하세요.
              </div>
            </div>

            <input
              ref={fileInputRef}
              type="file"
              accept="image/*"
              className="hidden"
              onChange={(e) => {
                void applyImage(e.target.files?.[0]);
                e.target.value = "";
              }}
            />

            <div
              role="button"
              tabIndex={0}
              onClick={() => fileInputRef.current?.click()}
              onKeyDown={(e) => {
                if (e.key === "Enter" || e.key === " ") {
                  e.preventDefault();
                  fileInputRef.current?.click();
                }
              }}
              onDragOver={(e) => {
                e.preventDefault();
                setIsDragging(true);
              }}
              onDragLeave={(e) => {
                e.preventDefault();
                setIsDragging(false);
              }}
              onDrop={(e) => {
                e.preventDefault();
                setIsDragging(false);
                void applyImage(e.dataTransfer.files?.[0]);
              }}
              className={`flex cursor-pointer flex-col items-center justify-center gap-2 rounded-lg border-2 border-dashed p-5 text-center transition ${
                isDragging
                  ? "border-primary bg-primary/5"
                  : "border-border hover:border-primary/50 hover:bg-muted/40"
              }`}
            >
              <Upload className="h-5 w-5 text-muted-foreground" />
              <div className="text-sm font-medium">사진 업로드</div>
              <div className="text-xs text-muted-foreground">
                클릭해서 선택 · 드래그앤드롭 · 붙여넣기(Ctrl/⌘+V)
              </div>
            </div>

            {isUploadedAvatar(avatar) && (
              <div className="flex items-center justify-between rounded-md bg-muted/40 px-3 py-2 text-sm">
                <span className="text-muted-foreground">내 사진이 적용됩니다.</span>
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  className="h-7 px-2"
                  onClick={() => setAvatar(null)}
                >
                  <X className="mr-1 h-3.5 w-3.5" />
                  사진 제거
                </Button>
              </div>
            )}

            <div className="grid grid-cols-4 gap-2">
              {AVATARS.map((a) => {
                const selected = avatar === a.key;
                return (
                  <button
                    key={a.key}
                    type="button"
                    onClick={() => setAvatar(a.key)}
                    aria-label={`아바타 ${a.key} 선택`}
                    aria-pressed={selected}
                    className={`relative rounded-full ring-offset-2 ring-offset-background transition ${
                      selected ? "ring-2 ring-primary" : "ring-1 ring-border hover:ring-primary/50"
                    }`}
                  >
                    <Avatar className="h-14 w-14">
                      <AvatarImage src={a.src} alt={a.key} />
                      <AvatarFallback>{a.key}</AvatarFallback>
                    </Avatar>
                    {selected && (
                      <span className="absolute -right-1 -top-1 flex h-5 w-5 items-center justify-center rounded-full bg-primary text-primary-foreground">
                        <Check className="h-3 w-3" />
                      </span>
                    )}
                  </button>
                );
              })}
            </div>

            <div className="space-y-2">
              <Label htmlFor="profile-name">이름</Label>
              <Input
                id="profile-name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="이름"
              />
            </div>

            <DialogFooter>
              <Button onClick={saveProfile} disabled={updateProfile.isPending}>
                {updateProfile.isPending && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
                저장
              </Button>
            </DialogFooter>
          </TabsContent>

          <TabsContent value="password" className="space-y-4 pt-2">
            <div className="space-y-2">
              <Label htmlFor="current-password">현재 비밀번호</Label>
              <Input
                id="current-password"
                type="password"
                value={currentPassword}
                onChange={(e) => setCurrentPassword(e.target.value)}
                autoComplete="current-password"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="new-password">새 비밀번호</Label>
              <Input
                id="new-password"
                type="password"
                value={newPassword}
                onChange={(e) => setNewPassword(e.target.value)}
                autoComplete="new-password"
                placeholder="4자 이상"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="confirm-password">새 비밀번호 확인</Label>
              <Input
                id="confirm-password"
                type="password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                autoComplete="new-password"
              />
            </div>

            <DialogFooter>
              <Button onClick={savePassword} disabled={changePassword.isPending}>
                {changePassword.isPending && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
                비밀번호 변경
              </Button>
            </DialogFooter>
          </TabsContent>
        </Tabs>
      </DialogContent>
    </Dialog>
  );
}
