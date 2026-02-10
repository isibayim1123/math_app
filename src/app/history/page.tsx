import { supabase } from "@/lib/supabase";
import type { SkillMastery, AnswerLog, MasteryLevel } from "@/types/database";
import Link from "next/link";

export const dynamic = "force-dynamic";

// 習熟度バッジの色定義
const masteryConfig: Record<MasteryLevel, { label: string; bg: string; text: string }> = {
  not_started: { label: "未着手", bg: "bg-gray-100", text: "text-gray-500" },
  struggling:  { label: "苦手",   bg: "bg-red-100",  text: "text-red-700" },
  developing:  { label: "学習中", bg: "bg-yellow-100", text: "text-yellow-700" },
  proficient:  { label: "習得",   bg: "bg-blue-100", text: "text-blue-700" },
  mastered:    { label: "完璧",   bg: "bg-green-100", text: "text-green-700" },
};

// 概要統計を取得
async function getOverview() {
  const { data: logs } = await supabase
    .from("answer_logs")
    .select("is_correct, score, answered_at");

  if (!logs || logs.length === 0) return null;

  const total = logs.length;
  // SELECT/TEXT は is_correct、IMAGE は score >= 7 を正解とする
  const correct = logs.filter(
    (l: { is_correct: boolean | null; score: number | null }) =>
      l.is_correct === true || (l.is_correct === null && l.score !== null && l.score >= 7)
  ).length;

  const now = new Date();
  const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate()).toISOString();
  const weekStart = new Date(now.getFullYear(), now.getMonth(), now.getDate() - now.getDay()).toISOString();
  const monthStart = new Date(now.getFullYear(), now.getMonth(), 1).toISOString();

  const todayCount = logs.filter((l: { answered_at: string }) => l.answered_at >= todayStart).length;
  const weekCount = logs.filter((l: { answered_at: string }) => l.answered_at >= weekStart).length;
  const monthCount = logs.filter((l: { answered_at: string }) => l.answered_at >= monthStart).length;

  return {
    total,
    correct,
    accuracy: total > 0 ? Math.round((correct / total) * 100) : 0,
    todayCount,
    weekCount,
    monthCount,
  };
}

// スキル別習熟度を取得（スキル名つき）
async function getSkillMasteries() {
  const { data: masteries } = await supabase
    .from("skill_mastery")
    .select("*")
    .order("updated_at", { ascending: false });

  if (!masteries || masteries.length === 0) return [];

  // スキル情報を取得
  const skillIds = [...new Set((masteries as SkillMastery[]).map((m) => m.skill_id))];
  const { data: skills } = await supabase
    .from("skills")
    .select("id, display_name, unit_name, sort_order")
    .in("id", skillIds);

  type SkillInfo = { id: string; display_name: string; unit_name: string; sort_order: number };
  const skillMap = new Map<string, SkillInfo>();
  skills?.forEach((s: SkillInfo) => skillMap.set(s.id, s));

  return (masteries as SkillMastery[]).map((m) => ({
    ...m,
    skill: skillMap.get(m.skill_id),
  }));
}

// 最近の解答履歴を取得（問題文つき）
async function getRecentLogs() {
  const { data: logs } = await supabase
    .from("answer_logs")
    .select("*")
    .order("answered_at", { ascending: false })
    .limit(20);

  if (!logs || logs.length === 0) return [];

  // 演習の問題文を取得
  const exerciseIds = [...new Set((logs as AnswerLog[]).map((l) => l.exercise_id))];
  const { data: exercises } = await supabase
    .from("exercises")
    .select("id, question_text, input_template")
    .in("id", exerciseIds);

  const exMap = new Map<string, { question_text: string; input_template: string }>();
  exercises?.forEach((e: { id: string; question_text: string; input_template: string }) =>
    exMap.set(e.id, e)
  );

  return (logs as AnswerLog[]).map((l) => ({
    ...l,
    exercise: exMap.get(l.exercise_id),
  }));
}

function formatDate(dateStr: string | null) {
  if (!dateStr) return "-";
  const d = new Date(dateStr);
  return `${d.getMonth() + 1}/${d.getDate()} ${d.getHours().toString().padStart(2, "0")}:${d.getMinutes().toString().padStart(2, "0")}`;
}

export default async function HistoryPage() {
  const [overview, masteries, recentLogs] = await Promise.all([
    getOverview(),
    getSkillMasteries(),
    getRecentLogs(),
  ]);

  // データなし
  if (!overview && masteries.length === 0 && recentLogs.length === 0) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-12 text-center">
        <div className="text-5xl mb-4">📊</div>
        <h2 className="text-lg font-bold text-gray-700 mb-2">まだ学習履歴がありません</h2>
        <p className="text-sm text-gray-500 mb-6">
          演習を解くと、ここに学習の記録が表示されます。
        </p>
        <Link
          href="/"
          className="inline-block bg-blue-600 text-white px-5 py-2 rounded-lg text-sm font-medium hover:bg-blue-700 transition"
        >
          学習を始める
        </Link>
      </div>
    );
  }

  // unit_name でグループ化
  const groupedMasteries = new Map<string, typeof masteries>();
  masteries.forEach((m) => {
    const unit = m.skill?.unit_name ?? "その他";
    if (!groupedMasteries.has(unit)) groupedMasteries.set(unit, []);
    groupedMasteries.get(unit)!.push(m);
  });

  return (
    <div className="max-w-2xl mx-auto px-4 py-6 space-y-8">
      <h2 className="text-base font-bold text-gray-700">📊 学習履歴</h2>

      {/* 概要セクション */}
      {overview && (
        <section>
          <h3 className="text-sm font-bold text-gray-600 mb-3">概要</h3>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
            <StatCard label="総解答数" value={overview.total} />
            <StatCard label="正答率" value={`${overview.accuracy}%`} />
            <StatCard label="今日" value={overview.todayCount} />
            <StatCard label="今週" value={overview.weekCount} />
          </div>
        </section>
      )}

      {/* スキル別習熟度 */}
      {masteries.length > 0 && (
        <section>
          <h3 className="text-sm font-bold text-gray-600 mb-3">スキル別習熟度</h3>
          <div className="space-y-5">
            {[...groupedMasteries.entries()].map(([unitName, items]) => (
              <div key={unitName}>
                <h4 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">
                  {unitName}
                </h4>
                <div className="space-y-2">
                  {items.map((m) => {
                    const cfg = masteryConfig[m.mastery];
                    const pct = Math.round(m.accuracy * 100);
                    return (
                      <div
                        key={m.id}
                        className="bg-white rounded-lg border border-gray-200 p-3 flex items-center gap-3"
                      >
                        {/* 習熟度バッジ */}
                        <span
                          className={`shrink-0 text-xs font-bold px-2 py-0.5 rounded ${cfg.bg} ${cfg.text}`}
                        >
                          {cfg.label}
                        </span>

                        {/* スキル名 + プログレスバー */}
                        <div className="flex-1 min-w-0">
                          <p className="text-sm font-medium text-gray-800 truncate">
                            {m.skill?.display_name ?? m.skill_id}
                          </p>
                          <div className="mt-1 flex items-center gap-2">
                            <div className="flex-1 h-1.5 bg-gray-100 rounded-full overflow-hidden">
                              <div
                                className="h-full bg-blue-500 rounded-full transition-all"
                                style={{ width: `${pct}%` }}
                              />
                            </div>
                            <span className="text-xs text-gray-400 tabular-nums w-8 text-right">
                              {pct}%
                            </span>
                          </div>
                        </div>

                        {/* 最終学習日 */}
                        <span className="shrink-0 text-xs text-gray-400">
                          {formatDate(m.last_practiced)}
                        </span>

                        {/* 復習ボタン */}
                        <Link
                          href={`/exercises/${m.skill_id}`}
                          className="shrink-0 text-xs bg-blue-50 text-blue-600 px-2.5 py-1 rounded font-medium hover:bg-blue-100 transition"
                        >
                          復習
                        </Link>
                      </div>
                    );
                  })}
                </div>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* 最近の解答履歴 */}
      {recentLogs.length > 0 && (
        <section>
          <h3 className="text-sm font-bold text-gray-600 mb-3">最近の解答（直近20件）</h3>
          <div className="bg-white rounded-lg border border-gray-200 divide-y divide-gray-100">
            {recentLogs.map((log) => {
              // 正誤判定
              let mark: string;
              if (log.is_correct === true) mark = "◯";
              else if (log.is_correct === false) mark = "✕";
              else if (log.score !== null) mark = `${log.score}点`;
              else mark = "-";

              const markColor =
                log.is_correct === true || (log.score !== null && log.score >= 7)
                  ? "text-green-600"
                  : log.is_correct === false || (log.score !== null && log.score < 7)
                    ? "text-red-500"
                    : "text-gray-400";

              // 問題文を短縮
              const questionText = log.exercise?.question_text ?? log.exercise_id;
              const shortQuestion =
                questionText.length > 40 ? questionText.slice(0, 40) + "..." : questionText;

              return (
                <div key={log.id} className="px-3 py-2.5 flex items-center gap-3 text-sm">
                  <span className={`shrink-0 font-bold text-base w-8 text-center ${markColor}`}>
                    {mark}
                  </span>
                  <p className="flex-1 min-w-0 text-gray-700 truncate">{shortQuestion}</p>
                  {log.time_spent_sec && (
                    <span className="shrink-0 text-xs text-gray-400">{log.time_spent_sec}秒</span>
                  )}
                  <span className="shrink-0 text-xs text-gray-400">{formatDate(log.answered_at)}</span>
                </div>
              );
            })}
          </div>
        </section>
      )}
    </div>
  );
}

function StatCard({ label, value }: { label: string; value: string | number }) {
  return (
    <div className="bg-white rounded-lg border border-gray-200 p-3 text-center">
      <p className="text-2xl font-bold text-gray-800">{value}</p>
      <p className="text-xs text-gray-500 mt-0.5">{label}</p>
    </div>
  );
}
