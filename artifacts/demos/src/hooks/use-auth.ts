import { useGetMe, getGetMeQueryKey } from "@workspace/api-client-react";
import type { User } from "@workspace/api-client-react";

export function useAuth() {
  const { data, isLoading, isError, refetch } = useGetMe({
    query: { retry: false, staleTime: 60_000, queryKey: getGetMeQueryKey() },
  });

  const user: User | undefined = isError ? undefined : data;

  return {
    user,
    isLoading,
    isAuthenticated: !!user,
    isAdmin: user?.role === "admin",
    refetch,
  };
}
