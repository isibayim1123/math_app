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

## 数式表記ルール（問題データ生成時の規約）

### 保存形式
- DB内の数式はすべて **LaTeX形式** で保存する
- フロントエンドでは **KaTeX** でレンダリングする想定

### LaTeX記法の統一ルール
| 項目 | ✅ 使う | ❌ 使わない |
|------|--------|------------|
| 累乗 | `x^2`, `x^{10}` | `x²`, `x**2` |
| 分数 | `\frac{1}{2}` | `1/2`（問題文の文中では可） |
| 括弧 | `\left( \right)` は大きい式のみ。通常は `( )` | |
| 掛け算 | `2x`, `ab`（省略）、必要時 `\cdot` | `×`, `*` |
| 根号 | `\sqrt{3}`, `\sqrt[3]{x}` | `√3` |
| 絶対値 | `\lvert x \rvert` | `\|x\|`（パース曖昧） |
| 不等号 | `\leqq`, `\geqq` | `≦`, `≧`, `\leq`, `\geq` |
| ベクトル | `\vec{a}` | `→a` |
| 添え字 | `a_{n}`, `x_{1}` | `a_n`（1文字なら可） |

### 問題文のフォーマット
- 問題文（question_text）は **プレーンテキスト＋LaTeX** の混在
- インライン数式は `$...$` で囲む
- ディスプレイ数式は `$$...$$` で囲む

例:
```
question_text: "二次関数 $y = 2(x - 3)^2 + 1$ のグラフの頂点の座標を求めよ。"
question_expr: "y = 2(x - 3)^2 + 1"
```

- `question_text` → UIに表示する全文（$で囲んだ部分をKaTeXレンダリング）
- `question_expr` → メインの数式だけ抽出（検索・比較用、$不要）

### 選択肢・正解パターンの数式
- `choice_expr`, `answer_expr` は **$なしの生LaTeX**
- 例: `(x + 2)^2 + 3`（`$`で囲まない）

### normalized_form のルール
正解比較用。以下を統一:
- 空白をすべて除去
- `²` → `^2` 等のUnicode正規化
- `y=` の `=` 前後のスペース除去
- 例: `y = -2(x + 1)^2 + 4` → `y=-2(x+1)^2+4`

### 解説のフォーマット
- explanation はマークダウン形式
- 数式は `$...$` で囲む
- ステップの区切りは改行2つ

## 問題生成の品質基準

### 演習の構成パターン
各パターン内の演習は **難易度順** に並べ、原則として以下の流れ:
1. SELECT_BASIC（難易度1-2）: 概念理解の確認
2. TEXT_NUMERIC or TEXT_EXPRESSION（難易度2-3）: 自力で解く
3. TEXT_EXPRESSION（難易度3-4）: 応用・変形

### ディストラクター（誤答選択肢）の設計
各誤答は **実際の生徒がやりがちなミス** を再現すること:
- 符号ミス（最頻出）
- 係数の計算ミス
- 公式の一部を忘れる
- 概念の取り違え（x座標とy座標を逆にする等）

各 choice に `distractor_note` を必ず記載し、どのミスを想定しているか明記する。

### 正解パターン（表記ゆれ）
TEXT系の `exercise_answers` には以下を網羅:
- スペースあり/なし
- 括弧あり/なし（座標）
- 展開形/因数分解形（両方正解の場合）

`is_primary = true` は模範解答として解説に使う形式を1つだけ指定。

### 解説の粒度
- 「何をしたか」と「なぜそうするか」の両方を含める
- 中間式を省略しない
- つまずきポイント（符号ミスしやすい箇所等）に言及する

## 検証済みサンプルデータ（パイロット）
- スキル「整式の加法・減法」→ 3パターン（同類項整理/加法/減法）、演習7問
- スキル「整式の乗法（展開）」→ 5パターン（分配法則/和の平方/差の平方/和と差の積/(x+a)(x+b)）、演習13問
- スキル「二次関数のグラフ」→ 4パターン（標準形/平方完成/平行移動/グラフの決定）、演習11問

## 開発ルール
- 日本語コメント推奨（ユーザー・チームが日本人）
- マイグレーションは連番ファイル（001_, 002_, ...）
- SQLのENUM定義は schema.sql に集約
- シードデータは db/seeds/ に配置（001_sample_data.sql, 002_quad_func.sql, ...）

## 今後の開発予定
1. PostgreSQL にスキーマ適用 + サンプルデータ投入
2. バックエンドAPI設計（CRUD + 採点 + 弱点診断）
3. IndexedDB → PostgreSQL 移行
4. OCRモデル統合（Qwen2.5-VL / GPT-4o）
5. 教師用ダッシュボード
