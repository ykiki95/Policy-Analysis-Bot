import { createContext } from "react";

export type AccountSwitcherValue = {
  /** 현재 보고 있는 계정 id. null 이면 내 계정. (admin 전용 기능) */
  selectedAccountId: number | null;
  /** 보는 계정을 변경한다. 모든 쿼리를 무효화해 즉시 재조회한다. */
  selectAccount: (id: number | null) => void;
};

// 컨텍스트 객체는 별도 모듈에 둔다 — Provider/hook 파일이 HMR(Fast Refresh)로
// 재평가될 때 컨텍스트 식별자(identity)가 새로 만들어져 마운트된 Provider(구 컨텍스트)와
// 소비 측(신 컨텍스트)이 어긋나 useContext 가 null 을 반환하는 크래시를 막는다.
export const AccountSwitcherContext = createContext<AccountSwitcherValue | null>(
  null,
);
