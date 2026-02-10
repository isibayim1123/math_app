import { supabase } from "./supabase";

// 認証未実装のため固定ユーザーID（プロトタイプと共通）
const ANONYMOUS_USER_ID = "00000000-0000-0000-0000-000000000000";

/**
 * 回答ログを保存
 */
export async function saveAnswerLog(params: {
  exerciseId: string;
  isCorrect: boolean | null;
  score?: number | null;
  mode?: "self_study" | "free_grading" | "homework";
  answerRaw?: string | null;
  timeSpentSec?: number | null;
}) {
  const { error } = await supabase.from("answer_logs").insert({
    user_id: ANONYMOUS_USER_ID,
    exercise_id: params.exerciseId,
    mode: params.mode ?? "self_study",
    answer_raw: params.answerRaw ?? null,
    is_correct: params.isCorrect,
    score: params.score ?? null,
    grading_method: params.score != null ? "llm_gpt4" : "local",
    grading_cost: 0,
    time_spent_sec: params.timeSpentSec ?? null,
    attempt_number: 1,
    answered_at: new Date().toISOString(),
  });
  if (error) {
    console.error("answer_log INSERT失敗:", error.message, error.details);
  }
}

/**
 * スキル習熟度を更新
 */
export async function updateSkillMastery(
  skillId: string,
  correctCount: number,
  totalCount: number
) {
  const accuracy = totalCount > 0 ? correctCount / totalCount : 0;

  // 習熟度レベル自動判定
  let mastery: string = "not_started";
  if (totalCount >= 3 && accuracy >= 0.9) mastery = "mastered";
  else if (totalCount >= 2 && accuracy >= 0.7) mastery = "proficient";
  else if (totalCount >= 2 && accuracy >= 0.4) mastery = "developing";
  else if (totalCount >= 1) mastery = "struggling";

  const now = new Date().toISOString();

  // 既存レコード取得
  const { data: existing } = await supabase
    .from("skill_mastery")
    .select("*")
    .eq("user_id", ANONYMOUS_USER_ID)
    .eq("skill_id", skillId)
    .limit(1);

  if (existing && existing.length > 0) {
    const row = existing[0];
    const newTotal = row.total_attempts + totalCount;
    const newCorrect = row.correct_count + correctCount;
    const newAccuracy = newTotal > 0 ? newCorrect / newTotal : 0;

    // 累積で再判定
    let newMastery: string = "not_started";
    if (newTotal >= 3 && newAccuracy >= 0.9) newMastery = "mastered";
    else if (newTotal >= 2 && newAccuracy >= 0.7) newMastery = "proficient";
    else if (newTotal >= 2 && newAccuracy >= 0.4) newMastery = "developing";
    else if (newTotal >= 1) newMastery = "struggling";

    const { error } = await supabase
      .from("skill_mastery")
      .update({
        total_attempts: newTotal,
        correct_count: newCorrect,
        accuracy: newAccuracy,
        mastery: newMastery,
        last_practiced: now,
        updated_at: now,
      })
      .eq("id", row.id);
    if (error) console.error("skill_mastery UPDATE失敗:", error.message);
  } else {
    const { error } = await supabase.from("skill_mastery").insert({
      user_id: ANONYMOUS_USER_ID,
      skill_id: skillId,
      mastery,
      total_attempts: totalCount,
      correct_count: correctCount,
      accuracy,
      last_practiced: now,
      streak: 0,
      best_streak: 0,
      updated_at: now,
    });
    if (error) console.error("skill_mastery INSERT失敗:", error.message);
  }
}
