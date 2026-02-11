"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { supabase } from "@/lib/supabase";
import { UserProvider, type UserContextType } from "@/contexts/UserContext";

export default function AuthenticatedLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  const [user, setUser] = useState<UserContextType | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function checkAuth() {
      const {
        data: { user: authUser },
      } = await supabase.auth.getUser();

      if (!authUser) {
        router.replace("/login");
        return;
      }

      // public.users テーブルから auth_uid で検索
      const { data: publicUser } = await supabase
        .from("users")
        .select("id, display_name, email")
        .eq("auth_uid", authUser.id)
        .single();

      if (publicUser) {
        setUser({
          userId: publicUser.id,
          displayName: publicUser.display_name,
          email: publicUser.email,
        });
      } else {
        // トリガー遅延時のフォールバック
        setUser({
          userId: authUser.id,
          displayName:
            authUser.user_metadata?.display_name ??
            authUser.email?.split("@")[0] ??
            "",
          email: authUser.email ?? "",
        });
      }

      setLoading(false);
    }

    checkAuth();

    // ログアウト検知
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event) => {
      if (event === "SIGNED_OUT") {
        router.replace("/login");
      }
    });

    return () => subscription.unsubscribe();
  }, [router]);

  async function handleLogout() {
    await supabase.auth.signOut();
    router.replace("/login");
  }

  if (loading) {
    return (
      <div className="min-h-dvh flex items-center justify-center">
        <p className="text-gray-500 text-sm">読み込み中...</p>
      </div>
    );
  }

  if (!user) return null;

  return (
    <UserProvider value={user}>
      <header className="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-5 py-3 flex items-center justify-between">
        <Link href="/" className="block">
          <span className="text-lg font-bold tracking-tight">
            📐 数学学習サービス
          </span>
        </Link>
        <nav className="flex items-center gap-4 text-sm">
          <Link href="/" className="hover:text-blue-200 transition">
            学習
          </Link>
          <Link href="/history" className="hover:text-blue-200 transition">
            学習履歴
          </Link>
          <span className="text-blue-200 text-xs">{user.displayName}</span>
          <button
            onClick={handleLogout}
            className="text-xs bg-blue-500/30 hover:bg-blue-500/50 px-2.5 py-1 rounded transition"
          >
            ログアウト
          </button>
        </nav>
      </header>
      <main className="flex-1">{children}</main>
    </UserProvider>
  );
}
