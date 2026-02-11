# Math Learning Service

高校数学の学習サービス（B2B、学校向け）。
OCR＋AIで手書き答案を自動採点し、スキルツリーベースの弱点診断を提供します。
103スキル・7種類の入力テンプレート・3つの学習モードに対応。

## 技術スタック

- **フロントエンド**: Next.js 16 (App Router) + TypeScript + Tailwind CSS
- **DB**: Supabase (PostgreSQL)
- **数式**: KaTeX
- **デプロイ**: Vercel

## ディレクトリ構成

```
math-learning-service/
├── CLAUDE.md                        # プロジェクトコンテキスト（AI開発支援用）
├── README.md
├── .gitignore
├── package.json
├── tsconfig.json
├── next.config.ts
├── vercel.json
│
├── src/
│   ├── app/
│   │   ├── layout.tsx               # ルートレイアウト（HTML/body）
│   │   ├── globals.css              # Tailwind + KaTeX CSS
│   │   ├── login/page.tsx           # ログインページ
│   │   ├── signup/page.tsx          # 新規登録ページ
│   │   └── (authenticated)/         # 認証必須エリア
│   │       ├── layout.tsx           # 認証チェック + ヘッダー + ナビ
│   │       ├── page.tsx             # トップ: 単元一覧
│   │       ├── UnitAccordion.tsx
│   │       ├── skills/[skillId]/
│   │       │   ├── page.tsx         # スキル詳細: パターン + 例題
│   │       │   └── PatternCard.tsx
│   │       ├── exercises/[skillId]/
│   │       │   ├── page.tsx         # 演習: 問題を順番に出題
│   │       │   └── ExerciseSession.tsx
│   │       └── history/page.tsx     # 学習履歴ダッシュボード
│   ├── components/
│   │   ├── exercise/
│   │   │   ├── ExerciseRenderer.tsx # input_template で振り分け
│   │   │   ├── SelectBasic.tsx      # 4択単一
│   │   │   ├── SelectMulti.tsx      # 複数選択
│   │   │   └── ImageProcess.tsx     # カメラ/画像（TEXT系もこれで表示）
│   │   └── ui/
│   │       └── MathText.tsx         # KaTeX レンダリング
│   ├── contexts/
│   │   └── UserContext.tsx          # ユーザー情報コンテキスト
│   ├── lib/
│   │   ├── supabase.ts             # Supabase クライアント
│   │   ├── learning-history.ts     # 解答ログ・習熟度更新
│   │   └── katex-utils.ts          # 数式変換ユーティリティ
│   └── types/
│       └── database.ts             # DB型定義
│
├── docs/
│   ├── schema.sql                   # PostgreSQL スキーマ（21テーブル）
│   ├── schema_design.md
│   ├── er_diagram.mermaid
│   └── requirements.md
│
├── db/
│   ├── migrations/
│   │   ├── 001_initial_schema.sql
│   │   ├── 002_auth_trigger.sql     # auth.users → public.users 連携
│   │   └── 004_rls_policies.sql     # RLSポリシー
│   ├── seeds/
│   │   ├── 001_sample_data.sql
│   │   ├── 002_quad_func_seed.sql
│   │   ├── 003_numbers_and_expressions_seed.sql
│   │   ├── 004_trigonometry_seed.sql
│   │   └── 005_demo_org.sql         # デモ用組織データ
│   └── queries/verification.sql
│
└── prototype/                       # 静的HTMLデモ（参考実装）
    ├── index.html
    └── exercise-demo.html
```

## セットアップ

### 1. 依存パッケージのインストール

```bash
npm install
```

### 2. Supabase の設定

1. [Supabase](https://supabase.com) でプロジェクトを作成
2. SQL Editor で `docs/schema.sql` を実行（スキーマ作成）
3. SQL Editor で以下のファイルを順番に実行:
   - `db/migrations/002_auth_trigger.sql` — auth.users → public.users 自動連携トリガー
   - `db/migrations/004_rls_policies.sql` — Row Level Security ポリシー
   - `db/seeds/005_demo_org.sql` — デモ用組織データ
4. SQL Editor で `db/seeds/` 内のシードデータを **番号順** に実行:
   - `002_quad_func_seed.sql`
   - `003_numbers_and_expressions_seed.sql`
   - `004_trigonometry_seed.sql`
5. `.env.local` に接続情報を設定:

```
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOi...
```

### 3. 認証の設定

1. Supabase ダッシュボード > **Authentication** > **Settings** > **Email Auth** で「**Confirm email**」を **OFF** にする
   - これにより、ユーザー登録後すぐにログイン可能になります（メール確認スキップ）
2. `npm run dev` で開発サーバーを起動
3. `/signup` でアカウントを作成
4. `/login` でログイン

### 4. 開発サーバー起動

```bash
npm run dev
```

http://localhost:3000 でアクセス。未ログインの場合は `/login` にリダイレクトされます。

### 4. Vercel デプロイ

1. Vercel にリポジトリを接続
2. Environment Variables に `NEXT_PUBLIC_SUPABASE_URL` と `NEXT_PUBLIC_SUPABASE_ANON_KEY` を設定
3. デプロイ

## 学習フロー

1. **ログイン** (`/login`) — メール + パスワードでログイン
2. **トップページ** (`/`) — 単元を選ぶ
3. **スキル詳細** (`/skills/[id]`) — パターンと例題を確認
4. **演習** (`/exercises/[id]`) — 問題を解く → 正誤判定 → 解説 → 結果サマリー
5. **学習履歴** (`/history`) — 解答履歴・スキル習熟度の確認

## ライセンス

Private
