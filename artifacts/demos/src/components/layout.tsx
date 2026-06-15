import { Link, useLocation } from "wouter";
import { Users, Activity, BarChart3, Database, Box, Beaker, Menu } from "lucide-react";
import { Button } from "@/components/ui/button";

export function Layout({ children }: { children: React.ReactNode }) {
  const [location] = useLocation();

  const navItems = [
    { href: "/", label: "대시보드", icon: Activity },
    { href: "/population", label: "합성 인구", icon: Users },
    { href: "/simulations", label: "시뮬레이션", icon: Beaker },
    { href: "/surveys", label: "설문조사 기준", icon: Database },
    { href: "/calibration", label: "보정 및 검증", icon: BarChart3 },
    { href: "/products", label: "제품 라인업", icon: Box },
  ];

  return (
    <div className="min-h-screen bg-background flex flex-col md:flex-row">
      <aside className="w-full md:w-64 border-r border-border bg-card flex flex-col shrink-0">
        <div className="p-6 border-b border-border flex items-center justify-between md:block">
          <div>
            <h1 className="font-bold text-lg tracking-tight text-foreground">DEMOS</h1>
            <p className="text-xs text-muted-foreground uppercase tracking-widest mt-1">Synthetic Electorate</p>
          </div>
          <Button variant="ghost" size="icon" className="md:hidden">
            <Menu className="h-5 w-5" />
          </Button>
        </div>
        <nav className="flex-1 p-4 space-y-1 overflow-y-auto hidden md:block">
          {navItems.map((item) => {
            const isActive = location === item.href || (item.href !== "/" && location.startsWith(item.href));
            const Icon = item.icon;
            return (
              <Link
                key={item.href}
                href={item.href}
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
        <div className="flex-1 overflow-y-auto p-4 md:p-8">
          <div className="mx-auto max-w-6xl">
            {children}
          </div>
        </div>
      </main>
    </div>
  );
}
