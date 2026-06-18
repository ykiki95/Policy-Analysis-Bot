import { createContext, useCallback, useContext, useState } from "react";
import { useQueryClient } from "@tanstack/react-query";
import { setAccountId } from "@workspace/api-client-react";

type AccountSwitcherValue = {
  /** 현재 보고 있는 계정 id. null 이면 내 계정. (admin 전용 기능) */
  selectedAccountId: number | null;
  /** 보는 계정을 변경한다. 모든 쿼리를 무효화해 즉시 재조회한다. */
  selectAccount: (id: number | null) => void;
};

const AccountSwitcherContext = createContext<AccountSwitcherValue | null>(null);

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
