import { useCallback, useContext, useState } from "react";
import { useQueryClient } from "@tanstack/react-query";
import { setAccountId } from "@workspace/api-client-react";
import {
  AccountSwitcherContext,
  type AccountSwitcherValue,
} from "@/hooks/account-switcher-context";

export function AccountSwitcherProvider({ children }: { children: React.ReactNode }) {
  const queryClient = useQueryClient();
  const [selectedAccountId, setSelectedAccountId] = useState<number | null>(null);

  const selectAccount = useCallback(
    (id: number | null) => {
      setAccountId(id);
      setSelectedAccountId(id);
      // 계정 전환 시 모든 데이터 쿼리를 다시 가져온다.
      queryClient.invalidateQueries();
    },
    [queryClient],
  );

  return (
    <AccountSwitcherContext.Provider value={{ selectedAccountId, selectAccount }}>
      {children}
    </AccountSwitcherContext.Provider>
  );
}

export function useAccountSwitcher(): AccountSwitcherValue {
  const ctx = useContext(AccountSwitcherContext);
  if (!ctx) {
    throw new Error("useAccountSwitcher must be used within AccountSwitcherProvider");
  }
  return ctx;
}
