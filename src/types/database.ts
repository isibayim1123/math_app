// docs/schema.sql に対応する TypeScript 型定義

export type Subject = "math_1" | "math_A" | "math_2" | "math_B" | "math_3" | "math_C";

export type InputTemplate =
  | "SELECT_BASIC"
  | "SELECT_MULTI"
  | "TEXT_NUMERIC"
  | "TEXT_EXPRESSION"
  | "TEXT_SET"
  | "IMAGE_PROCESS"
  | "IMAGE_PROOF";

// ─── コア問題データ ───

export interface Skill {
  id: string;
  subject: Subject;
  unit_name: string;
  subunit_name: string;
  display_name: string;
  description: string | null;
  sort_order: number;
  created_at: string;
  updated_at: string;
}

export interface SkillDependency {
  id: number;
  prerequisite_id: string;
  dependent_id: string;
  dependency_type: string;
}

export interface Pattern {
  id: string;
  skill_id: string;
  display_name: string;
  description: string | null;
  sort_order: number;
  created_at: string;
  updated_at: string;
}

export interface Example {
  id: string;
  pattern_id: string;
  question_text: string;
  question_expr: string | null;
  answer_text: string;
  learning_point: string | null;
  created_at: string;
  updated_at: string;
}

export interface ExampleStep {
  id: number;
  example_id: string;
  step_number: number;
  label: string;
  expr: string | null;
  explanation: string | null;
}

export interface Exercise {
  id: string;
  pattern_id: string;
  sort_order: number;
  input_template: InputTemplate;
  difficulty: number;
  question_text: string;
  question_expr: string | null;
  explanation: string | null;
  grading_cost: number;
  created_at: string;
  updated_at: string;
}

export interface ExerciseChoice {
  id: number;
  exercise_id: string;
  choice_label: string;
  choice_expr: string;
  is_correct: boolean;
  distractor_note: string | null;
  sort_order: number;
}

export interface ExerciseAnswer {
  id: number;
  exercise_id: string;
  answer_expr: string;
  normalized_form: string;
  is_primary: boolean;
  note: string | null;
}

export interface ExerciseRubric {
  id: number;
  exercise_id: string;
  criterion: string;
  max_points: number;
  description: string | null;
  sort_order: number;
}

// ─── 拡張型（JOIN結果用）───

export interface PatternWithDetails extends Pattern {
  examples: (Example & { steps: ExampleStep[] })[];
  exercise_count: number;
}

export interface ExerciseWithDetails extends Exercise {
  choices: ExerciseChoice[];
  answers: ExerciseAnswer[];
  rubrics: ExerciseRubric[];
}

export interface SkillWithPatterns extends Skill {
  patterns: PatternWithDetails[];
}

/** トップページ用: 単元ごとのスキルグループ */
export interface UnitGroup {
  unit_name: string;
  subject: Subject;
  skills: (Skill & { pattern_count: number; exercise_count: number })[];
}

// ─── 学習履歴 ───

export type MasteryLevel = "not_started" | "struggling" | "developing" | "proficient" | "mastered";
export type LearningMode = "self_study" | "free_grading" | "homework";

export interface SkillMastery {
  id: number;
  user_id: string;
  skill_id: string;
  mastery: MasteryLevel;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
  last_practiced: string | null;
  streak: number;
  best_streak: number;
  updated_at: string;
}

export interface AnswerLog {
  id: number;
  user_id: string;
  exercise_id: string;
  assignment_id: string | null;
  mode: LearningMode;
  answer_raw: string | null;
  answer_image_url: string | null;
  is_correct: boolean | null;
  score: number | null;
  grading_method: string | null;
  grading_cost: number | null;
  llm_feedback: Record<string, unknown> | null;
  time_spent_sec: number | null;
  attempt_number: number;
  answered_at: string;
}
