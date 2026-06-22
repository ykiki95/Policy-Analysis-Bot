import { Switch, Route, Router as WouterRouter, Redirect, useLocation } from "wouter";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { Layout } from "@/components/layout";
import { useAuth } from "@/hooks/use-auth";
import { AccountSwitcherProvider } from "@/hooks/use-account-switcher";
import NotFound from "@/pages/not-found";

import Login from "@/pages/login";
import Signup from "@/pages/signup";
import Dashboard from "@/pages/dashboard";
import Products from "@/pages/products";
import Calibration from "@/pages/calibration";
import Surveys from "@/pages/surveys";
import SurveyDetail from "@/pages/surveys/detail";
import Population from "@/pages/population";
import AgentDetail from "@/pages/population/detail";
import Simulations from "@/pages/simulations";
import NewSimulation from "@/pages/simulations/new";
import SimulationDetail from "@/pages/simulations/detail";
import Signals from "@/pages/signals";
import Admin from "@/pages/admin";

const queryClient = new QueryClient();

function ProtectedApp() {
  return (
    <Layout>
      <Switch>
        <Route path="/" component={Dashboard} />
        <Route path="/population" component={Population} />
        <Route path="/population/:id" component={AgentDetail} />
        <Route path="/surveys" component={Surveys} />
        <Route path="/surveys/:id" component={SurveyDetail} />
        <Route path="/calibration" component={Calibration} />
        <Route path="/products" component={Products} />
        <Route path="/admin" component={Admin} />
        <Route path="/simulations" component={Simulations} />
        <Route path="/simulations/new" component={NewSimulation} />
        <Route path="/simulations/:id" component={SimulationDetail} />
        <Route path="/signals" component={Signals} />
        <Route component={NotFound} />
      </Switch>
    </Layout>
  );
}

function Router() {
  const { isAuthenticated, isLoading } = useAuth();
  const [location] = useLocation();

  const isAuthPage = location === "/login" || location === "/signup";

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center text-muted-foreground">
        불러오는 중…
      </div>
    );
  }

  if (!isAuthenticated) {
    return (
      <Switch>
        <Route path="/login" component={Login} />
        <Route path="/signup" component={Signup} />
        <Route>
          <Redirect to="/login" />
        </Route>
      </Switch>
    );
  }

  if (isAuthPage) {
    return <Redirect to="/" />;
  }

  return <ProtectedApp />;
}

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <AccountSwitcherProvider>
        <TooltipProvider>
          <WouterRouter base={import.meta.env.BASE_URL.replace(/\/$/, "")}>
            <Router />
          </WouterRouter>
          <Toaster />
        </TooltipProvider>
      </AccountSwitcherProvider>
    </QueryClientProvider>
  );
}

export default App;
