# Math Learning Service

高校数学の学習サービス（B2B、学校向け）。
OCR＋AIで手書き答案を自動採点し、スキルツリーベースの弱点診断を提供します。
103スキル・7種類の入力テンプレート・3つの学習モードに対応。

## ディレクトリ構成

```
math-learning-service/
├── CLAUDE.md                  # プロジェクトコンテキスト（AI開発支援用）
├── README.md                  # このファイル
├── .gitignore
│
├── docs/
│   ├── schema.sql             # PostgreSQL スキーマ定義（21テーブル）
│   ├── schema_design.md       # スキーマ設計書
│   ├── er_diagram.mermaid     # ER図（Mermaid形式）
│   └── requirements.md        # 要件サマリー
│
├── prototype/
│   └── *.html                 # 既存HTMLプロトタイプ（IndexedDB版）
│
├── db/
│   └── migrations/
│       └── 001_initial_schema.sql  # 初期スキーマ マイグレーション
│
└── src/                       # アプリケーションコード（今後開発）
    └── .gitkeep
```

## セットアップ

### 前提条件

- PostgreSQL 15 以上

### データベース構築

```bash
# データベース作成
createdb math_learning

# スキーマ適用
psql -d math_learning -f db/migrations/001_initial_schema.sql
```

## ライセンス

Private
