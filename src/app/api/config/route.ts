// Supabase 公開設定 + OpenAI 利用可否をクライアントに返す
// Supabase の URL と Anon Key は NEXT_PUBLIC_ なので公開OK
// OpenAI キーは公開せず、設定済みかどうかだけ返す
export async function GET() {
  return Response.json({
    supabaseUrl: process.env.NEXT_PUBLIC_SUPABASE_URL || "",
    supabaseAnonKey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "",
    hasOpenAI: !!process.env.OPENAI_API_KEY,
  });
}
