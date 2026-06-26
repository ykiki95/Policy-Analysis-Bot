import { useState } from "react";
import { Link, useLocation } from "wouter";
import { useQueryClient } from "@tanstack/react-query";
import { Users, Activity, BarChart3, Database, Box, Beaker, Radio, Menu, X, Settings, LogOut, Wallet, ChevronDown, Check, UserCog, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { ProfileDialog } from "@/components/profile-dialog";
import { avatarSrc } from "@/lib/avatars";
import { Badge } from "@/components/ui/badge";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useLogout, getGetMeQueryKey, useGetBudget, useListAdminAccounts } from "@workspace/api-client-react";
import { useAuth } from "@/hooks/use-auth";
import { useAccountSwitcher } from "@/hooks/use-account-switcher";
import { formatCost } from "@/lib/cost";

function BudgetBadge() {
  const { data: budget } = useGetBudget();
  if (!budget) return null;
  const low = budget.remainingUsd <= budget.limitUsd * 0.1;
  return (
    <div className="hidden sm:flex items-center gap-2.5 rounded-md border border-border px-3 py-1.5 text-sm">
      <Wallet className={`h-4 w-4 shrink-0 ${low ? "text-destructive" : "text-muted-foreground"}`} />
      <div className="flex items-center gap-2 leading-tight">
        <span className="flex items-baseline gap-1">
          <span className="text-[11px] text-muted-foreground">잔여</span>
          <span className={low ? "text-destructive font-semibold" : "text-foreground font-semibold"}>
            {formatCost(budget.remainingUsd)}
          </span>
        </span>
        <span className="text-[11px] text-muted-foreground">
          사용 {formatCost(budget.spentUsd)} · 한도 {formatCost(budget.limitUsd)}
        </span>
      </div>
    </div>
  );
}

function AccountSwitcher() {
  const { data: accounts } = useListAdminAccounts();
  const { selectedAccountId, selectAccount } = useAccountSwitcher();
  const { user } = useAuth();
  if (!accounts) return null;

  // 본인 계정은 "내 계정" 옵션으로 이미 표현되므로 제외(중복 방지).
  // 시스템 sentinel(id<=0, role=system)은 로그인 불가·테넌트 스코프 대상이 아니라 전환 목록에서 제외.
  const otherAccounts = accounts.filter(
    (a) => a.id !== user?.id && a.id > 0 && a.role !== "system",
  );
  const current = accounts.find((a) => a.id === selectedAccountId);
  const label = current
    ? `${current.name} (@${current.username})`
    : user
      ? `내 계정 (@${user.username})`
      : "내 계정";

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="outline" size="sm" className="gap-1.5">
          <Users className="h-4 w-4" />
          <span className="hidden md:inline max-w-[14rem] truncate">{label}</span>
          {selectedAccountId != null && (
            <Badge variant="secondary" className="ml-1 hidden md:inline">계정 전환됨</Badge>
          )}
          <ChevronDown className="h-3.5 w-3.5 opacity-60" />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-64 max-h-96 overflow-y-auto">
        <DropdownMenuLabel>보기 계정 선택</DropdownMenuLabel>
        <DropdownMenuSeparator />
        <DropdownMenuItem onClick={() => selectAccount(null)}>
          {selectedAccountId == null && <Check className="h-4 w-4 mr-2" />}
          <span className={selectedAccountId == null ? "font-medium" : "ml-6"}>
            내 계정{user && <span className="text-muted-foreground"> @{user.username}</span>}
          </span>
        </DropdownMenuItem>
        {otherAccounts.map((a) => (
          <DropdownMenuItem key={a.id} onClick={() => selectAccount(a.id)}>
            {selectedAccountId === a.id && <Check className="h-4 w-4 mr-2" />}
            <span className={selectedAccountId === a.id ? "font-medium" : "ml-6"}>
              {a.name} <span className="text-muted-foreground">@{a.username}</span>
            </span>
          </DropdownMenuItem>
        ))}
      </DropdownMenuContent>
    </DropdownMenu>
  );
}

function ViewAsBanner() {
  const { selectedAccountId, selectAccount } = useAccountSwitcher();
  const { data: accounts } = useListAdminAccounts();
  if (selectedAccountId == null) return null;
  const acct = accounts?.find((a) => a.id === selectedAccountId);
  return (
    <div className="no-print flex items-center justify-between gap-3 border-b border-amber-500/30 bg-amber-500/15 px-4 md:px-8 py-2 text-sm">
      <span className="flex items-center gap-2 text-amber-700 dark:text-amber-400">
        <UserCog className="h-4 w-4 shrink-0" />
        관리자 보기 — {acct ? `${acct.name} (@${acct.username})` : `계정 #${selectedAccountId}`} 계정으로 보는 중입니다.
      </span>
      <Button
        variant="outline"
        size="sm"
        className="h-7 shrink-0"
        onClick={() => selectAccount(null)}
      >
        내 계정으로 돌아가기
      </Button>
    </div>
  );
}

function AccountMenu() {
  const { user, isAdmin } = useAuth();
  const queryClient = useQueryClient();
  const [profileOpen, setProfileOpen] = useState(false);
  const logout = useLogout({
    mutation: {
      onSuccess: () => {
        queryClient.setQueryData(getGetMeQueryKey(), undefined);
        queryClient.clear();
        window.location.assign(import.meta.env.BASE_URL);
      },
    },
  });

  if (!user) return null;

  const initial = user.name?.charAt(0) || user.username.charAt(0);

  return (
    <>
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="ghost" className="flex items-center gap-2 px-2">
            <Avatar className="h-8 w-8">
              <AvatarImage src={avatarSrc(user)} alt={user.name} />
              <AvatarFallback className="text-xs">{initial}</AvatarFallback>
            </Avatar>
            <span className="hidden sm:inline text-sm font-medium">{user.name}</span>
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end" className="w-56">
          <DropdownMenuLabel>
            <div className="flex flex-col">
              <span className="font-medium">{user.name}</span>
              <span className="text-xs text-muted-foreground font-normal">
                @{user.username}
                {isAdmin && " · 관리자"}
              </span>
            </div>
          </DropdownMenuLabel>
          <DropdownMenuSeparator />
          <DropdownMenuItem onClick={() => setProfileOpen(true)}>
            <UserCog className="h-4 w-4 mr-2" />
            프로필 수정
          </DropdownMenuItem>
          <DropdownMenuItem
            onClick={() => logout.mutate()}
            disabled={logout.isPending}
          >
            <LogOut className="h-4 w-4 mr-2" />
            로그아웃
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
      <ProfileDialog user={user} open={profileOpen} onOpenChange={setProfileOpen} />
    </>
  );
}

export function Layout({ children }: { children: React.ReactNode }) {
  const [location] = useLocation();
  const { isAdmin } = useAuth();
  const { selectedAccountId } = useAccountSwitcher();
  // 관리자가 다른 계정으로 보는 중이면 좌측 메뉴를 그 사용자 관점("설정")으로 보여준다.
  const effectiveIsAdmin = isAdmin && selectedAccountId == null;
  const [mobileOpen, setMobileOpen] = useState(false);

  const navSections: {
    label: string | null;
    items: { href: string; label: string; icon: typeof Activity }[];
  }[] = [
    {
      label: null,
      items: [{ href: "/", label: "대시보드", icon: Activity }],
    },
    {
      label: "합성 인구",
      items: [
        { href: "/population", label: "인구 탐색", icon: Users },
        { href: "/surveys", label: "설문 기준", icon: Database },
      ],
    },
    {
      label: "예측 엔진",
      items: [
        { href: "/simulations", label: "시뮬레이션", icon: Beaker },
        { href: "/signals", label: "실시간 신호", icon: Radio },
      ],
    },
    {
      label: "검증 & 학습",
      items: [
        { href: "/calibration", label: "정확도 검증", icon: BarChart3 },
        { href: "/learning", label: "자가학습 루프", icon: Sparkles },
      ],
    },
    {
      label: "플랫폼",
      items: [
        { href: "/products", label: "제품 라인업", icon: Box },
        { href: "/admin", label: effectiveIsAdmin ? "관리자" : "설정", icon: Settings },
      ],
    },
  ];

  return (
    <div className="min-h-screen bg-background flex flex-col md:flex-row">
      <aside className="w-full md:w-64 border-r border-border bg-card flex flex-col shrink-0 no-print">
        <div className="p-6 border-b border-border flex items-center justify-between md:block">
          <Link href="/" onClick={() => setMobileOpen(false)} className="block group">
            <h1 className="font-bold text-lg tracking-tight text-foreground group-hover:text-primary transition-colors">AI Analytics Platform</h1>
            <p className="text-xs text-muted-foreground uppercase tracking-widest mt-1">Synthetic Electorate</p>
          </Link>
          <Button
            variant="ghost"
            size="icon"
            className="md:hidden"
            aria-label={mobileOpen ? "메뉴 닫기" : "메뉴 열기"}
            aria-expanded={mobileOpen}
            onClick={() => setMobileOpen((o) => !o)}
          >
            {mobileOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
          </Button>
        </div>
        <nav className={`flex-1 p-4 space-y-4 overflow-y-auto md:block ${mobileOpen ? "block" : "hidden"}`}>
          {navSections.map((section, idx) => (
            <div key={section.label ?? `section-${idx}`} className="space-y-1">
              {section.label && (
                <p className="px-3 pt-1 pb-1 text-[0.7rem] font-semibold uppercase tracking-widest text-muted-foreground/70">
                  {section.label}
                </p>
              )}
              {section.items.map((item) => {
                const isActive =
                  location === item.href ||
                  (item.href !== "/" && location.startsWith(item.href));
                const Icon = item.icon;
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    onClick={() => setMobileOpen(false)}
                    className={`flex items-center gap-3 px-3 py-2.5 rounded-md text-sm font-medium transition-colors ${
                      isActive
                        ? "bg-primary text-primary-foreground"
                        : "text-muted-foreground hover:bg-secondary hover:text-foreground"
                    }`}
                  >
                    <Icon className="h-4 w-4" />
                    {item.label}
                  </Link>
                );
              })}
            </div>
          ))}
        </nav>
      </aside>
      <main className="flex-1 flex flex-col min-w-0 overflow-hidden app-print-root">
        <header className="h-16 border-b border-border flex items-center justify-end gap-3 px-4 md:px-8 shrink-0 no-print">
          <BudgetBadge />
          {isAdmin && <AccountSwitcher />}
          <AccountMenu />
        </header>
        {isAdmin && <ViewAsBanner />}
        <div className="flex-1 overflow-y-auto p-4 md:p-8">
          <div className="mx-auto max-w-6xl">
            {children}
          </div>
        </div>
      </main>
    </div>
  );
}
