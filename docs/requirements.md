# 要件サマリー

## サービス概要

高校数学の学習サービス（B2B、学校向け）。
OCR＋AIによる手書き答案の自動採点と、スキルツリーベースの弱点診断を提供する。

## 対象ユーザー

| ロール | 説明 |
|--------|------|
| 組織管理者（org_admin） | 教育委員会・塾グループの管理者 |
| 学校管理者（school_admin） | 学校単位の管理者 |
| 教師（teacher） | クラス管理、宿題配信、採点確認 |
| 生徒（student） | 学習、回答、弱点確認 |

## コンテンツ構造

- **スキル**: 103個（数I / 数A / 数II / 数B / 数III / 数C）
- **パターン（型）**: 1スキルあたり2〜6個
- **例題**: 1パターンにつき1つ（ステップバイステップ解説付き）
- **演習問題**: 1パターンにつき2〜4問（難易度順）
- **スキル依存関係**: 47本（中学→高校の科目横断含む）

## 7つの入力テンプレート

| ID | 名前 | 採点方式 | コスト |
|----|------|---------|-------|
| SELECT_BASIC | 4択単一 | ローカル | ¥0 |
| SELECT_MULTI | 複数選択 | ローカル | ¥0 |
| TEXT_NUMERIC | 数値・分数・座標 | ローカル | ¥0 |
| TEXT_EXPRESSION | 数式入力 | ローカル（表記ゆれ吸収） | ¥0 |
| TEXT_SET | 解の集合 | ローカル | ¥0 |
| IMAGE_PROCESS | 手書き途中式 | OCR→LLM | ¥3-10/回 |
| IMAGE_PROOF | 証明・論述 | OCR→LLM | ¥3-10/回 |

テンプレート種別ごとにデータを子テーブルに分離:
- `exercise_choices` → SELECT系（選択肢）
- `exercise_answers` → TEXT系（正規化形式で表記ゆれ比較）
- `exercise_rubrics` → IMAGE系（LLM採点用ルーブリック）

## 3つの学習モード

| モード | 説明 |
|--------|------|
| 自習（self_study） | 生徒が自分で進める |
| 自由採点（free_grading） | 手書き答案を撮影→AI採点 |
| 宿題（homework） | 教師がクラスに配信→回収→採点 |

## データベース設計

21テーブル、4カテゴリ:

1. **コア問題データ（9テーブル）**: skills, skill_dependencies, patterns, examples, example_steps, exercises, exercise_choices, exercise_answers, exercise_rubrics
2. **B2B管理（5テーブル）**: organizations, schools, users, classes, class_memberships
3. **学習履歴（4テーブル）**: answer_logs, skill_mastery, pattern_mastery, weakness_reports
4. **宿題配信（3テーブル）**: assignments, assignment_exercises, assignment_submissions

分析用ビュー4つ:
- `v_class_skill_accuracy` — スキル別クラス正答率
- `v_assignment_progress` — 宿題進捗サマリー
- `v_student_weak_skills` — 生徒の弱点スキル
- `v_monthly_grading_cost` — 月次採点コスト集計

## データ量見積もり（1年目）

| テーブル | レコード数 | 備考 |
|---------|-----------|------|
| skills | 103 | 固定マスタ |
| patterns | ~400 | 103 × 平均4パターン |
| exercises | ~1,200 | 400 × 平均3問 |
| users | ~5,000 | 10校 × 500人 |
| answer_logs | ~2,000,000 | 5000人 × 400回答/年 |
| skill_mastery | ~500,000 | 5000人 × 103スキル |

## 習熟度判定基準

| レベル | 条件 |
|--------|------|
| not_started | attempts = 0 |
| struggling | accuracy < 0.4 かつ attempts >= 3 |
| developing | 0.4 <= accuracy < 0.8 |
| proficient | accuracy >= 0.8 かつ streak >= 3 |
| mastered | accuracy >= 0.9 かつ streak >= 5 かつ attempts >= 10 |

## 今後の開発予定

1. PostgreSQL にスキーマ適用 + サンプルデータ投入
2. バックエンドAPI設計（CRUD + 採点 + 弱点診断）
3. IndexedDB → PostgreSQL 移行
4. OCRモデル統合（Qwen2.5-VL / GPT-4o）
5. 教師用ダッシュボード
