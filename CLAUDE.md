# Math Learning Service

## プロジェクト概要
高校数学の学習サービス（B2B、学校向け）。
OCR＋AIで手書き答案を自動採点し、スキルツリーベースの弱点診断を行う。

## 技術スタック
- DB: PostgreSQL 15+
- スキーマ: docs/schema.sql（21テーブル、確定済み）
- プロトタイプ: prototype/ 内のHTML+IndexedDB（参考実装）

## コアデータ構造
```
Skill（103個、数I/A/II/B/III/C）
  └── Pattern（型、1スキルあたり2〜6個）
        ├── Example（例題、1つ、ステップバイステップ解説）
        └── Exercise[]（演習、2〜4問、難易度順）
```

スキル間依存関係: 47本（中学→高校の科目横断含む）

## 7つの入力テンプレート
| ID | アイコン | 名前 | 採点方式 | コスト |
|----|---------|------|---------|-------|
| SELECT_BASIC | 🔘 | 4択単一 | ローカル | ¥0 |
| SELECT_MULTI | ☑️ | 複数選択 | ローカル | ¥0 |
| TEXT_NUMERIC | 🔢 | 数値・分数・座標 | ローカル | ¥0 |
| TEXT_EXPRESSION | ✏️ | 数式入力 | ローカル（表記ゆれ吸収） | ¥0 |
| TEXT_SET | 📝 | 解の集合 | ローカル | ¥0 |
| IMAGE_PROCESS | 📸 | 手書き途中式 | OCR→LLM | ¥3-10/回 |
| IMAGE_PROOF | 📜 | 証明・論述 | OCR→LLM | ¥3-10/回 |

## 3つの学習モード
- 📚 自習（self_study）: 生徒が自分で進める
- 📸 自由採点（free_grading）: 手書き答案を撮影→AI採点
- 🏫 宿題（homework）: 教師がクラスに配信→回収→採点

## DB設計（4カテゴリ、21テーブル）
1. **コア問題データ**: skills, skill_dependencies, patterns, examples, example_steps, exercises, exercise_choices, exercise_answers, exercise_rubrics
2. **B2B管理**: organizations, schools, users, classes, class_memberships
3. **学習履歴**: answer_logs, skill_mastery, pattern_mastery, weakness_reports
4. **宿題配信**: assignments, assignment_exercises, assignment_submissions

テンプレート別に子テーブル分離:
- exercise_choices → SELECT系のみ
- exercise_answers → TEXT系のみ（正規化形式で表記ゆれ比較）
- exercise_rubrics → IMAGE系のみ（LLM採点用ルーブリック）

## 検証済みサンプルデータ（パイロット）
- スキル「整式の加法・減法」→ 3パターン（同類項整理/加法/減法）、演習7問
- スキル「整式の乗法（展開）」→ 5パターン（分配法則/和の平方/差の平方/和と差の積/(x+a)(x+b)）、演習13問

## 開発ルール
- 日本語コメント推奨（ユーザー・チームが日本人）
- マイグレーションは連番ファイル（001_, 002_, ...）
- SQLのENUM定義は schema.sql に集約

## 今後の開発予定
1. PostgreSQL にスキーマ適用 + サンプルデータ投入
2. バックエンドAPI設計（CRUD + 採点 + 弱点診断）
3. IndexedDB → PostgreSQL 移行
4. OCRモデル統合（Qwen2.5-VL / GPT-4o）
5. 教師用ダッシュボード
