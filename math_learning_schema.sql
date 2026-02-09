-- ============================================================
-- 高校数学学習サービス データベーススキーマ
-- PostgreSQL 15+
-- ============================================================

-- =========================
-- 0. 共通型・ENUM定義
-- =========================

CREATE TYPE subject AS ENUM (
  'math_1',    -- 数学I
  'math_A',    -- 数学A
  'math_2',    -- 数学II
  'math_B',    -- 数学B
  'math_3',    -- 数学III
  'math_C'     -- 数学C
);

CREATE TYPE input_template AS ENUM (
  'SELECT_BASIC',     -- 🔘 4択単一（ローカル採点, ¥0）
  'SELECT_MULTI',     -- ☑️ 複数選択
  'TEXT_NUMERIC',     -- 🔢 数値・分数・座標
  'TEXT_EXPRESSION',  -- ✏️ 数式（表記ゆれ吸収）
  'TEXT_SET',         -- 📝 解の集合
  'IMAGE_PROCESS',   -- 📸 手書き途中式（OCR→LLM, ¥3-10/回）
  'IMAGE_PROOF'      -- 📜 証明・論述
);

CREATE TYPE learning_mode AS ENUM (
  'self_study',    -- 📚 自習
  'free_grading',  -- 📸 自由採点
  'homework'       -- 🏫 宿題
);

CREATE TYPE mastery_level AS ENUM (
  'not_started',  -- 未着手
  'struggling',   -- 苦戦中
  'developing',   -- 発展途上
  'proficient',   -- 習得
  'mastered'      -- 完全習得
);

CREATE TYPE assignment_status AS ENUM (
  'draft',       -- 下書き
  'published',   -- 配信済み
  'closed'       -- 締切済み
);

CREATE TYPE submission_status AS ENUM (
  'not_started',  -- 未着手
  'in_progress',  -- 取り組み中
  'submitted',    -- 提出済み
  'graded'        -- 採点済み
);

CREATE TYPE user_role AS ENUM (
  'org_admin',      -- 組織管理者
  'school_admin',   -- 学校管理者
  'teacher',        -- 教師
  'student'         -- 生徒
);


-- =========================
-- 1. コア問題データ
-- =========================

-- ----- 1.1 スキル（103個） -----
CREATE TABLE skills (
  id              TEXT PRIMARY KEY,         -- 例: 'poly_add_sub'
  subject         subject NOT NULL,
  unit_name       TEXT NOT NULL,            -- 例: '整式'
  subunit_name    TEXT NOT NULL,            -- 例: '整式の加法・減法'
  display_name    TEXT NOT NULL,            -- UI表示名
  description     TEXT,
  sort_order      INT NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_skills_subject ON skills(subject);

-- ----- 1.2 スキル依存関係（47本） -----
CREATE TABLE skill_dependencies (
  id                  SERIAL PRIMARY KEY,
  prerequisite_id     TEXT NOT NULL REFERENCES skills(id),
  dependent_id        TEXT NOT NULL REFERENCES skills(id),
  dependency_type     TEXT NOT NULL DEFAULT 'required',  -- required / recommended
  UNIQUE (prerequisite_id, dependent_id),
  CHECK (prerequisite_id <> dependent_id)
);

CREATE INDEX idx_skill_deps_prereq ON skill_dependencies(prerequisite_id);
CREATE INDEX idx_skill_deps_dep    ON skill_dependencies(dependent_id);

-- ----- 1.3 パターン（型）-----
CREATE TABLE patterns (
  id              TEXT PRIMARY KEY,         -- 例: 'poly_add_sub__like_terms'
  skill_id        TEXT NOT NULL REFERENCES skills(id),
  display_name    TEXT NOT NULL,            -- 例: '同類項の整理'
  description     TEXT,
  sort_order      INT NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_patterns_skill ON patterns(skill_id);

-- ----- 1.4 例題（1パターンにつき1つ） -----
CREATE TABLE examples (
  id              TEXT PRIMARY KEY,         -- 例: 'ex_poly_add_sub__like_terms'
  pattern_id      TEXT NOT NULL UNIQUE REFERENCES patterns(id),  -- 1:1
  question_text   TEXT NOT NULL,            -- 問題文（マークダウン可）
  question_expr   TEXT,                     -- 数式（LaTeX）
  answer_text     TEXT NOT NULL,            -- 答え
  learning_point  TEXT,                     -- 学習ポイント
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ----- 1.5 例題の解法ステップ -----
CREATE TABLE example_steps (
  id              SERIAL PRIMARY KEY,
  example_id      TEXT NOT NULL REFERENCES examples(id) ON DELETE CASCADE,
  step_number     INT NOT NULL,
  label           TEXT NOT NULL,            -- 例: 'Step 1: 同類項をまとめる'
  expr            TEXT,                     -- 数式（LaTeX）
  explanation     TEXT,                     -- 補足説明
  UNIQUE (example_id, step_number)
);

CREATE INDEX idx_example_steps_example ON example_steps(example_id);

-- ----- 1.6 演習問題 -----
CREATE TABLE exercises (
  id              TEXT PRIMARY KEY,         -- 例: 'drill_poly_add_sub__like_terms_01'
  pattern_id      TEXT NOT NULL REFERENCES patterns(id),
  sort_order      INT NOT NULL DEFAULT 0,  -- 難易度順（0が最易）
  input_template  input_template NOT NULL,
  difficulty      INT NOT NULL DEFAULT 1 CHECK (difficulty BETWEEN 1 AND 5),
  question_text   TEXT NOT NULL,            -- 問題文
  question_expr   TEXT,                     -- 数式（LaTeX）
  explanation     TEXT,                     -- 解説
  grading_cost    NUMERIC(6,2) DEFAULT 0,  -- 採点コスト（円）概算
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_exercises_pattern ON exercises(pattern_id);
CREATE INDEX idx_exercises_template ON exercises(input_template);

-- ----- 1.7 選択肢（SELECT_BASIC / SELECT_MULTI 用） -----
CREATE TABLE exercise_choices (
  id              SERIAL PRIMARY KEY,
  exercise_id     TEXT NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
  choice_label    TEXT NOT NULL,            -- 'A', 'B', 'C', 'D'
  choice_expr     TEXT NOT NULL,            -- 選択肢の数式/テキスト
  is_correct      BOOLEAN NOT NULL DEFAULT false,
  distractor_note TEXT,                     -- ディストラクター設計意図
  sort_order      INT NOT NULL DEFAULT 0
);

CREATE INDEX idx_choices_exercise ON exercise_choices(exercise_id);

-- 選択式は少なくとも1つ正解を持つ（アプリ側バリデーション）

-- ----- 1.8 正解パターン（TEXT系テンプレート用） -----
CREATE TABLE exercise_answers (
  id              SERIAL PRIMARY KEY,
  exercise_id     TEXT NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
  answer_expr     TEXT NOT NULL,            -- 正解表現（LaTeX / normalized）
  normalized_form TEXT NOT NULL,            -- 正規化形式（比較用）
  is_primary      BOOLEAN NOT NULL DEFAULT false,  -- 模範解答フラグ
  note            TEXT                      -- 表記ゆれの説明
);

CREATE INDEX idx_answers_exercise ON exercise_answers(exercise_id);

-- ----- 1.9 IMAGE系の採点ルーブリック -----
CREATE TABLE exercise_rubrics (
  id              SERIAL PRIMARY KEY,
  exercise_id     TEXT NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
  criterion       TEXT NOT NULL,            -- 評価基準名
  max_points      INT NOT NULL,
  description     TEXT,                     -- LLMプロンプト用の詳細
  sort_order      INT NOT NULL DEFAULT 0
);

CREATE INDEX idx_rubrics_exercise ON exercise_rubrics(exercise_id);


-- =========================
-- 2. B2B管理
-- =========================

-- ----- 2.1 組織（教育委員会・塾グループ等） -----
CREATE TABLE organizations (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name            TEXT NOT NULL,
  slug            TEXT NOT NULL UNIQUE,     -- URL用
  plan            TEXT NOT NULL DEFAULT 'trial',  -- trial / basic / premium
  max_students    INT NOT NULL DEFAULT 100,
  contract_start  DATE,
  contract_end    DATE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ----- 2.2 学校 -----
CREATE TABLE schools (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id),
  name            TEXT NOT NULL,
  school_code     TEXT,                     -- 学校コード
  prefecture      TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_schools_org ON schools(organization_id);

-- ----- 2.3 ユーザー（教師・生徒・管理者を統合） -----
CREATE TABLE users (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id),
  school_id       UUID REFERENCES schools(id),
  role            user_role NOT NULL,
  email           TEXT UNIQUE,
  display_name    TEXT NOT NULL,
  auth_provider   TEXT DEFAULT 'email',     -- email / google / apple
  auth_uid        TEXT,                     -- 外部認証UID
  is_active       BOOLEAN NOT NULL DEFAULT true,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_users_org    ON users(organization_id);
CREATE INDEX idx_users_school ON users(school_id);
CREATE INDEX idx_users_role   ON users(role);

-- ----- 2.4 クラス -----
CREATE TABLE classes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id       UUID NOT NULL REFERENCES schools(id),
  name            TEXT NOT NULL,            -- 例: '1年A組'
  academic_year   INT NOT NULL,             -- 年度
  grade           INT NOT NULL CHECK (grade BETWEEN 1 AND 3),  -- 学年
  is_active       BOOLEAN NOT NULL DEFAULT true,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_classes_school ON classes(school_id);

-- ----- 2.5 クラス所属（生徒は複数クラス可能） -----
CREATE TABLE class_memberships (
  id              SERIAL PRIMARY KEY,
  class_id        UUID NOT NULL REFERENCES classes(id),
  user_id         UUID NOT NULL REFERENCES users(id),
  role            TEXT NOT NULL DEFAULT 'student',  -- student / teacher
  UNIQUE (class_id, user_id)
);

CREATE INDEX idx_class_members_class ON class_memberships(class_id);
CREATE INDEX idx_class_members_user  ON class_memberships(user_id);


-- =========================
-- 3. 学習履歴
-- =========================

-- ----- 3.1 回答ログ（全モード共通） -----
CREATE TABLE answer_logs (
  id              BIGSERIAL PRIMARY KEY,
  user_id         UUID NOT NULL REFERENCES users(id),
  exercise_id     TEXT NOT NULL REFERENCES exercises(id),
  assignment_id   UUID,                     -- 宿題モード時のみ（FK後で定義）
  mode            learning_mode NOT NULL,
  -- 回答データ
  answer_raw      TEXT,                     -- 生の入力（テキスト or OCR結果）
  answer_image_url TEXT,                    -- IMAGE系の撮影画像URL
  -- 採点結果
  is_correct      BOOLEAN,                  -- TEXT/SELECT系: true/false, IMAGE系: NULL可
  score           NUMERIC(5,2),             -- IMAGE系: ルーブリック合計点
  max_score       NUMERIC(5,2),             -- IMAGE系: 満点
  grading_method  TEXT,                     -- 'local' / 'llm_gpt4' / 'llm_gemini'
  grading_cost    NUMERIC(6,2) DEFAULT 0,   -- 実際の採点コスト（円）
  llm_feedback    JSONB,                    -- LLM採点時のフィードバック詳細
  -- メタデータ
  time_spent_sec  INT,                      -- 回答にかかった秒数
  attempt_number  INT NOT NULL DEFAULT 1,   -- 同一問題の何回目か
  answered_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_answer_logs_user       ON answer_logs(user_id);
CREATE INDEX idx_answer_logs_exercise   ON answer_logs(exercise_id);
CREATE INDEX idx_answer_logs_assignment ON answer_logs(assignment_id);
CREATE INDEX idx_answer_logs_answered   ON answer_logs(answered_at);
-- 弱点分析クエリ高速化
CREATE INDEX idx_answer_logs_user_correct ON answer_logs(user_id, is_correct);

-- ----- 3.2 スキル習熟度（集計キャッシュ） -----
CREATE TABLE skill_mastery (
  id              SERIAL PRIMARY KEY,
  user_id         UUID NOT NULL REFERENCES users(id),
  skill_id        TEXT NOT NULL REFERENCES skills(id),
  mastery         mastery_level NOT NULL DEFAULT 'not_started',
  total_attempts  INT NOT NULL DEFAULT 0,
  correct_count   INT NOT NULL DEFAULT 0,
  accuracy        NUMERIC(5,4),              -- 正答率 0.0000〜1.0000
  last_practiced  TIMESTAMPTZ,
  streak          INT NOT NULL DEFAULT 0,    -- 連続正解数
  best_streak     INT NOT NULL DEFAULT 0,
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, skill_id)
);

CREATE INDEX idx_skill_mastery_user    ON skill_mastery(user_id);
CREATE INDEX idx_skill_mastery_skill   ON skill_mastery(skill_id);
CREATE INDEX idx_skill_mastery_level   ON skill_mastery(mastery);

-- ----- 3.3 パターン別正答率（より細かい弱点追跡） -----
CREATE TABLE pattern_mastery (
  id              SERIAL PRIMARY KEY,
  user_id         UUID NOT NULL REFERENCES users(id),
  pattern_id      TEXT NOT NULL REFERENCES patterns(id),
  total_attempts  INT NOT NULL DEFAULT 0,
  correct_count   INT NOT NULL DEFAULT 0,
  accuracy        NUMERIC(5,4),
  last_practiced  TIMESTAMPTZ,
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, pattern_id)
);

CREATE INDEX idx_pattern_mastery_user    ON pattern_mastery(user_id);
CREATE INDEX idx_pattern_mastery_pattern ON pattern_mastery(pattern_id);

-- ----- 3.4 弱点診断ログ（AI診断結果の記録） -----
CREATE TABLE weakness_reports (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES users(id),
  generated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  report_json     JSONB NOT NULL,           -- 弱点スキル一覧、推奨学習パス等
  -- report_json 例:
  -- {
  --   "weak_skills": ["poly_expand", "quadratic_formula"],
  --   "root_causes": ["poly_add_sub"],
  --   "recommended_path": ["poly_add_sub", "poly_expand", "quadratic_formula"],
  --   "confidence": 0.85
  -- }
  period_start    DATE,
  period_end      DATE
);

CREATE INDEX idx_weakness_user ON weakness_reports(user_id);


-- =========================
-- 4. 宿題配信
-- =========================

-- ----- 4.1 宿題（課題） -----
CREATE TABLE assignments (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  class_id        UUID NOT NULL REFERENCES classes(id),
  created_by      UUID NOT NULL REFERENCES users(id),  -- 教師
  title           TEXT NOT NULL,
  description     TEXT,
  status          assignment_status NOT NULL DEFAULT 'draft',
  published_at    TIMESTAMPTZ,
  due_at          TIMESTAMPTZ,
  allow_retry     BOOLEAN NOT NULL DEFAULT false,  -- 再回答を許可するか
  max_attempts    INT DEFAULT 1,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_assignments_class   ON assignments(class_id);
CREATE INDEX idx_assignments_teacher ON assignments(created_by);
CREATE INDEX idx_assignments_status  ON assignments(status);

-- answer_logsのFK追加
ALTER TABLE answer_logs
  ADD CONSTRAINT fk_answer_logs_assignment
  FOREIGN KEY (assignment_id) REFERENCES assignments(id);

-- ----- 4.2 宿題に含まれる問題 -----
CREATE TABLE assignment_exercises (
  id              SERIAL PRIMARY KEY,
  assignment_id   UUID NOT NULL REFERENCES assignments(id) ON DELETE CASCADE,
  exercise_id     TEXT NOT NULL REFERENCES exercises(id),
  sort_order      INT NOT NULL DEFAULT 0,
  points          NUMERIC(5,2) DEFAULT 1,   -- 配点
  UNIQUE (assignment_id, exercise_id)
);

CREATE INDEX idx_assign_ex_assignment ON assignment_exercises(assignment_id);

-- ----- 4.3 生徒の提出状況 -----
CREATE TABLE assignment_submissions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  assignment_id   UUID NOT NULL REFERENCES assignments(id),
  student_id      UUID NOT NULL REFERENCES users(id),
  status          submission_status NOT NULL DEFAULT 'not_started',
  started_at      TIMESTAMPTZ,
  submitted_at    TIMESTAMPTZ,
  total_score     NUMERIC(7,2),
  max_score       NUMERIC(7,2),
  attempt_count   INT NOT NULL DEFAULT 0,
  teacher_comment TEXT,                     -- 教師コメント
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (assignment_id, student_id)
);

CREATE INDEX idx_submissions_assignment ON assignment_submissions(assignment_id);
CREATE INDEX idx_submissions_student    ON assignment_submissions(student_id);
CREATE INDEX idx_submissions_status     ON assignment_submissions(status);


-- =========================
-- 5. 分析用ビュー
-- =========================

-- ----- 5.1 スキル別クラス正答率 -----
CREATE VIEW v_class_skill_accuracy AS
SELECT
  cm.class_id,
  s.id AS skill_id,
  s.display_name AS skill_name,
  COUNT(al.id) AS total_attempts,
  SUM(CASE WHEN al.is_correct THEN 1 ELSE 0 END) AS correct_count,
  ROUND(
    SUM(CASE WHEN al.is_correct THEN 1 ELSE 0 END)::NUMERIC / NULLIF(COUNT(al.id), 0),
    4
  ) AS accuracy
FROM answer_logs al
JOIN exercises e ON e.id = al.exercise_id
JOIN patterns p ON p.id = e.pattern_id
JOIN skills s ON s.id = p.skill_id
JOIN class_memberships cm ON cm.user_id = al.user_id AND cm.role = 'student'
GROUP BY cm.class_id, s.id, s.display_name;

-- ----- 5.2 宿題進捗サマリー -----
CREATE VIEW v_assignment_progress AS
SELECT
  a.id AS assignment_id,
  a.title,
  a.class_id,
  COUNT(sub.id) AS total_students,
  SUM(CASE WHEN sub.status = 'submitted' THEN 1
           WHEN sub.status = 'graded'    THEN 1 ELSE 0 END) AS submitted_count,
  SUM(CASE WHEN sub.status = 'graded' THEN 1 ELSE 0 END) AS graded_count,
  ROUND(AVG(sub.total_score), 2) AS avg_score,
  ROUND(AVG(sub.max_score), 2) AS avg_max_score
FROM assignments a
LEFT JOIN assignment_submissions sub ON sub.assignment_id = a.id
GROUP BY a.id, a.title, a.class_id;

-- ----- 5.3 生徒の弱点スキルTOP10 -----
CREATE VIEW v_student_weak_skills AS
SELECT
  sm.user_id,
  sm.skill_id,
  s.display_name,
  s.subject,
  sm.accuracy,
  sm.total_attempts,
  sm.mastery,
  sm.last_practiced
FROM skill_mastery sm
JOIN skills s ON s.id = sm.skill_id
WHERE sm.total_attempts >= 3   -- 最低3回以上回答
  AND sm.mastery IN ('struggling', 'developing')
ORDER BY sm.user_id, sm.accuracy ASC;


-- =========================
-- 6. コスト追跡
-- =========================

-- ----- 6.1 月次コスト集計 -----
CREATE VIEW v_monthly_grading_cost AS
SELECT
  o.id AS organization_id,
  o.name AS organization_name,
  DATE_TRUNC('month', al.answered_at) AS month,
  al.grading_method,
  COUNT(*) AS grading_count,
  SUM(al.grading_cost) AS total_cost
FROM answer_logs al
JOIN users u ON u.id = al.user_id
JOIN organizations o ON o.id = u.organization_id
WHERE al.grading_cost > 0
GROUP BY o.id, o.name, DATE_TRUNC('month', al.answered_at), al.grading_method;


-- =========================
-- 7. updated_at自動更新トリガー
-- =========================

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 主要テーブルにトリガー適用
DO $$
DECLARE
  tbl TEXT;
BEGIN
  FOR tbl IN
    SELECT unnest(ARRAY[
      'skills', 'patterns', 'examples', 'exercises',
      'organizations', 'schools', 'users', 'classes',
      'assignments', 'assignment_submissions',
      'skill_mastery', 'pattern_mastery'
    ])
  LOOP
    EXECUTE format(
      'CREATE TRIGGER trg_%s_updated_at
       BEFORE UPDATE ON %I
       FOR EACH ROW EXECUTE FUNCTION update_updated_at()',
      tbl, tbl
    );
  END LOOP;
END;
$$;
