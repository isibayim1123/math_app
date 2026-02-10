import { supabase } from "@/lib/supabase";
import type {
  Skill,
  Exercise,
  ExerciseChoice,
  ExerciseAnswer,
  ExerciseRubric,
  ExerciseWithDetails,
} from "@/types/database";
import { ExerciseSession } from "./ExerciseSession";

async function getExercises(skillId: string) {
  // スキル情報
  const { data: skill } = await supabase
    .from("skills")
    .select("*")
    .eq("id", skillId)
    .single();

  if (!skill) return null;

  // パターンID一覧
  const { data: patterns } = await supabase
    .from("patterns")
    .select("id")
    .eq("skill_id", skillId);

  if (!patterns || patterns.length === 0) {
    return { skill: skill as Skill, exercises: [] as ExerciseWithDetails[] };
  }

  const patternIds = patterns.map((p: { id: string }) => p.id);

  // 演習一覧（input_template を明示的に取得）
  const { data: exercises, error: exercisesError } = await supabase
    .from("exercises")
    .select("id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost, created_at, updated_at")
    .in("pattern_id", patternIds)
    .order("sort_order");

  if (exercisesError) {
    console.error("[exercises] Supabase error:", exercisesError);
  }

  if (!exercises || exercises.length === 0) {
    return { skill: skill as Skill, exercises: [] as ExerciseWithDetails[] };
  }

  // デバッグ: input_template の値をサーバーログに出力
  console.log(
    "[exercises] input_template values:",
    exercises.map((e: Exercise) => ({ id: e.id, input_template: e.input_template }))
  );

  const exerciseIds = exercises.map((e: Exercise) => e.id);

  // 選択肢・正解・ルーブリックを並列取得
  const [choicesRes, answersRes, rubricsRes] = await Promise.all([
    supabase
      .from("exercise_choices")
      .select("*")
      .in("exercise_id", exerciseIds)
      .order("sort_order"),
    supabase
      .from("exercise_answers")
      .select("*")
      .in("exercise_id", exerciseIds),
    supabase
      .from("exercise_rubrics")
      .select("*")
      .in("exercise_id", exerciseIds)
      .order("sort_order"),
  ]);

  // デバッグ: 子テーブルのエラー確認
  if (choicesRes.error) console.error("[exercise_choices] error:", choicesRes.error);
  if (answersRes.error) console.error("[exercise_answers] error:", answersRes.error);
  if (rubricsRes.error) console.error("[exercise_rubrics] error:", rubricsRes.error);
  console.log("[exercise_choices] count:", (choicesRes.data ?? []).length);

  // exercise_id → 子データ マッピング
  const choicesMap = new Map<string, ExerciseChoice[]>();
  (choicesRes.data ?? []).forEach((c: ExerciseChoice) => {
    if (!choicesMap.has(c.exercise_id)) choicesMap.set(c.exercise_id, []);
    choicesMap.get(c.exercise_id)!.push(c);
  });

  const answersMap = new Map<string, ExerciseAnswer[]>();
  (answersRes.data ?? []).forEach((a: ExerciseAnswer) => {
    if (!answersMap.has(a.exercise_id)) answersMap.set(a.exercise_id, []);
    answersMap.get(a.exercise_id)!.push(a);
  });

  const rubricsMap = new Map<string, ExerciseRubric[]>();
  (rubricsRes.data ?? []).forEach((r: ExerciseRubric) => {
    if (!rubricsMap.has(r.exercise_id)) rubricsMap.set(r.exercise_id, []);
    rubricsMap.get(r.exercise_id)!.push(r);
  });

  const exercisesWithDetails: ExerciseWithDetails[] = (
    exercises as Exercise[]
  ).map((ex) => ({
    ...ex,
    choices: choicesMap.get(ex.id) ?? [],
    answers: answersMap.get(ex.id) ?? [],
    rubrics: rubricsMap.get(ex.id) ?? [],
  }));

  return { skill: skill as Skill, exercises: exercisesWithDetails };
}

export const dynamic = "force-dynamic";

export default async function ExercisePage({
  params,
}: {
  params: Promise<{ skillId: string }>;
}) {
  const { skillId } = await params;
  const data = await getExercises(skillId);

  if (!data) {
    return (
      <div className="p-6 text-center text-gray-500">
        スキルが見つかりません
      </div>
    );
  }

  if (data.exercises.length === 0) {
    return (
      <div className="p-6 text-center text-gray-500">
        演習問題がありません
      </div>
    );
  }

  return (
    <ExerciseSession skill={data.skill} exercises={data.exercises} />
  );
}
