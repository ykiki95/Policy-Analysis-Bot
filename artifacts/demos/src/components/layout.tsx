import { useState } from "react";
import { Link, useLocation } from "wouter";
import { useQueryClient } from "@tanstack/react-query";
import { Users, Activity, BarChart3, Database, Box, Beaker, Menu, X, Settings, LogOut, Wallet, ChevronDown, Check } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
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

/** 화면 표시 금액 포맷($X.XX). */
function fmtUsd(v: number): string {
  return `$${v.toFixed(2)}`;
}

function BudgetBadge() {
  const { data: budget } = useGetBudget();
  if (!budget) return null;
  const low = budget.remainingUsd <= budget.limitUsd * 0.1;
  return (
    <div className="hidden sm:flex items-center gap-2 rounded-md border border-border px-3 py-1.5 text-sm">
      <Wallet className={`h-4 w-4 ${low ? "text-destructive" : "text-muted-foreground"}`} />
      <span className={low ? "text-destructive font-medium" : "text-foreground"}>
        {fmtUsd(budget.remainingUsd)}
      </span>
      <span className="text-muted-foreground">/ {fmtUsd(budget.limitUsd)} 잔여</span>
    </div>
  );
}

function AccountSwitcher() {
  const { data: accounts } = useListAdminAccounts();
  const { selectedAccountId, selectAccount } = useAccountSwitcher();
  if (!accounts) return null;

  const current = accounts.find((a) => a.id === selectedAccountId);
  const label = current ? `${current.name} (@${current.username})` : "내 계정";

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
          <span className={selectedAccountId == null ? "font-medium" : "ml-6"}>내 계정</span>
        </DropdownMenuItem>
        {accounts.map((a) => (
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

function AccountMenu() {
  const { user, isAdmin } = useAuth();
  const queryClient = useQueryClient();
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
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" className="flex items-center gap-2 px-2">
          <Avatar className="h-8 w-8">
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
        <DropdownMenuItem
          onClick={() => logout.mutate()}
          disabled={logout.isPending}
        >
          <LogOut className="h-4 w-4 mr-2" />
          로그아웃
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}

export function Layout({ children }: { children: React.ReactNode }) {
  const [location] = useLocation();
  const { isAdmin } = useAuth();
  const [mobileOpen, setMobileOpen] = useState(false);

  const navItems = [
    { href: "/", label: "대시보드", icon: Activity },
    { href: "/population", label: "합성 인구", icon: Users },
    { href: "/simulations", label: "시뮬레이션", icon: Beaker },
    { href: "/surveys", label: "설문조사 기준", icon: Database },
    { href: "/calibration", label: "보정 및 검증", icon: BarChart3 },
    { href: "/products", label: "제품 라인업", icon: Box },
    { href: "/admin", label: isAdmin ? "관리자" : "설정", icon: Settings },
  ];

  return (
    <div className="min-h-screen bg-background flex flex-col md:flex-row">
      <aside className="w-full md:w-64 border-r border-border bg-card flex flex-col shrink-0">
        <div className="p-6 border-b border-border flex items-center justify-between md:block">
          <div>
            <h1 className="font-bold text-lg tracking-tight text-foreground">DEMOS</h1>
            <p className="text-xs text-muted-foreground uppercase tracking-widest mt-1">Synthetic Electorate</p>
          </div>
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
        <nav className={`flex-1 p-4 space-y-1 overflow-y-auto md:block ${mobileOpen ? "block" : "hidden"}`}>
          {navItems.map((item) => {
            const isActive = location === item.href || (item.href !== "/" && location.startsWith(item.href));
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
        </nav>
      </aside>
      <main className="flex-1 flex flex-col min-w-0 overflow-hidden">
        <header className="h-16 border-b border-border flex items-center justify-end gap-3 px-4 md:px-8 shrink-0">
          <BudgetBadge />
          {isAdmin && <AccountSwitcher />}
          <AccountMenu />
        </header>
        <div className="flex-1 overflow-y-auto p-4 md:p-8">
          <div className="mx-auto max-w-6xl">
            {children}
          </div>
        </div>
      </main>
    </div>
  );
}
