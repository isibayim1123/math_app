// ビルド時に環境変数から prototype 用の設定ファイルを生成する
// public/prototype/config.js として出力される
import { writeFileSync, mkdirSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const outPath = join(__dirname, "..", "public", "prototype", "config.js");

const config = {
  supabaseUrl: process.env.NEXT_PUBLIC_SUPABASE_URL || "",
  supabaseAnonKey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "",
  hasOpenAI: !!process.env.OPENAI_API_KEY,
};

mkdirSync(dirname(outPath), { recursive: true });
writeFileSync(
  outPath,
  `// Auto-generated at build time - do not edit\nwindow.__PROTO_CONFIG__ = ${JSON.stringify(config, null, 2)};\n`
);

console.log("[generate-prototype-config] wrote", outPath);
console.log("  supabaseUrl:", config.supabaseUrl ? "set" : "(empty)");
console.log("  hasOpenAI:", config.hasOpenAI);
