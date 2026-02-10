import { createClient, type SupabaseClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || "";
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "";

// URL未設定時はダミークライアント（ビルド通過用）
// 実行時はSupabaseのレスポンスが空になるだけ
export const supabase: SupabaseClient = supabaseUrl
  ? createClient(supabaseUrl, supabaseAnonKey)
  : createClient("https://placeholder.supabase.co", "placeholder");

export const isSupabaseConfigured = !!process.env.NEXT_PUBLIC_SUPABASE_URL;
