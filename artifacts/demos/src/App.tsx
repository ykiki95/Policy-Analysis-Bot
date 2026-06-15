import { Switch, Route, Router as WouterRouter } from "wouter";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { Layout } from "@/components/layout";
import NotFound from "@/pages/not-found";

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
import Admin from "@/pages/admin";

const queryClient = new QueryClient();

function Router() {
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
        <Route component={NotFound} />
      </Switch>
    </Layout>
  );
}

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <TooltipProvider>
        <WouterRouter base={import.meta.env.BASE_URL.replace(/\/$/, "")}>
          <Router />
        </WouterRouter>
        <Toaster />
      </TooltipProvider>
    </QueryClientProvider>
  );
}

export default App;
