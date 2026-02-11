"use client";

import { createContext, useContext } from "react";

export interface UserContextType {
  userId: string;         // public.users.id
  displayName: string;
  email: string;
}

const UserContext = createContext<UserContextType | null>(null);

export function UserProvider({
  value,
  children,
}: {
  value: UserContextType;
  children: React.ReactNode;
}) {
  return <UserContext.Provider value={value}>{children}</UserContext.Provider>;
}

export function useUser(): UserContextType {
  const ctx = useContext(UserContext);
  if (!ctx) {
    throw new Error("useUser must be used within a UserProvider");
  }
  return ctx;
}
