"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { supabase } from "@/lib/supabase";
import { useUser } from "@/contexts/UserContext";
import type { SkillMastery, AnswerLog, MasteryLevel } from "@/types/database";

// 習熟度バッジの色定義
const masteryConfig: Record<
  MasteryLevel,
  { label: string; bg: string; text: string }
> = {
  not_started: { label: "未着手", bg: "bg-gray-100", text: "text-gray-500" },
  struggling: { label: "苦手", bg: "bg-red-100", text: "text-red-700" },
  developing: {
    label: "学習中",
    bg: "bg-yellow-100",
    text: "text-yellow-700",
  },
  proficient: { label: "習得", bg: "bg-blue-100", text: "text-blue-700" },
  mastered: { label: "完璧", bg: "bg-green-100", text: "text-green-700" },
};

type SkillInfo = {
  id: string;
  display_name: string;
  unit_name: string;
  sort_order: number;
};
type MasteryWithSkill = SkillMastery & { skill?: SkillInfo };
type LogWithExercise = AnswerLog & {
  exercise?: { question_text: string; input_template: string };
};

interface Overview {
  total: number;
  correct: number;
  accuracy: number;
  todayCount: number;
  weekCount: number;
  monthCount: number;
}

function formatDate(dateStr: string | null) {
  if (!dateStr) return "-";
  const d = new Date(dateStr);
  return `${d.getMonth() + 1}/${d.getDate()} ${d.getHours().toString().padStart(2, "0")}:${d.getMinutes().toString().padStart(2, "0")}`;
}

export default function HistoryPage() {
  const { userId } = useUser();
  const [overview, setOverview] = useState<Overview | null>(null);
  const [masteries, setMasteries] = useState<MasteryWithSkill[]>([]);
  const [recentLogs, setRecentLogs] = useState<LogWithExercise[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchData() {
      // 概要統計
      const { data: logs } = await supabase
        .from("answer_logs")
        .select("is_correct, score, answered_at")
        .eq("user_id", userId);

      if (logs && logs.length > 0) {
        const total = logs.length;
        const correct = logs.filter(
          (l: { is_correct: boolean | null; score: number | null }) =>
            l.is_correct === true ||
            (l.is_correct === null && l.score !== null && l.score >= 7)
        ).length;

        const now = new Date();
        const todayStart = new Date(
          now.getFullYear(),
          now.getMonth(),
          now.getDate()
        ).toISOString();
        const weekStart = new Date(
          now.getFullYear(),
          now.getMonth(),
          now.getDate() - now.getDay()
        ).toISOString();
        const monthStart = new Date(
          now.getFullYear(),
          now.getMonth(),
          1
        ).toISOString();

        setOverview({
          total,
          correct,
          accuracy: Math.round((correct / total) * 100),
          todayCount: logs.filter(
            (l: { answered_at: string }) => l.answered_at >= todayStart
          ).length,
          weekCount: logs.filter(
            (l: { answered_at: string }) => l.answered_at >= weekStart
          ).length,
          monthCount: logs.filter(
            (l: { answered_at: string }) => l.answered_at >= monthStart
          ).length,
        });
      }

      // スキル別習熟度
      const { data: masteryData } = await supabase
        .from("skill_mastery")
        .select("*")
        .eq("user_id", userId)
        .order("updated_at", { ascending: false });

      if (masteryData && masteryData.length > 0) {
        const skillIds = [
          ...new Set(
            (masteryData as SkillMastery[]).map((m) => m.skill_id)
          ),
        ];
        const { data: skills } = await supabase
          .from("skills")
          .select("id, display_name, unit_name, sort_order")
          .in("id", skillIds);

        const skillMap = new Map<string, SkillInfo>();
        skills?.forEach((s: SkillInfo) => skillMap.set(s.id, s));

        setMasteries(
          (masteryData as SkillMastery[]).map((m) => ({
            ...m,
            skill: skillMap.get(m.skill_id),
          }))
        );
      }

      // 最近の解答履歴
      const { data: recentData } = await supabase
        .from("answer_logs")
        .select("*")
        .eq("user_id", userId)
        .order("answered_at", { ascending: false })
        .limit(20);

      if (recentData && recentData.length > 0) {
        const exerciseIds = [
          ...new Set(
            (recentData as AnswerLog[]).map((l) => l.exercise_id)
          ),
        ];
        const { data: exercises } = await supabase
          .from("exercises")
          .select("id, question_text, input_template")
          .in("id", exerciseIds);

        const exMap = new Map<
          string,
          { question_text: string; input_template: string }
        >();
        exercises?.forEach(
          (e: { id: string; question_text: string; input_template: string }) =>
            exMap.set(e.id, e)
        );

        setRecentLogs(
          (recentData as AnswerLog[]).map((l) => ({
            ...l,
            exercise: exMap.get(l.exercise_id),
          }))
        );
      }

      setLoading(false);
    }

    fetchData();
  }, [userId]);

  if (loading) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-12 text-center">
        <p className="text-gray-500 text-sm">読み込み中...</p>
      </div>
    );
  }

  // データなし
  if (!overview && masteries.length === 0 && recentLogs.length === 0) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-12 text-center">
        <div className="text-5xl mb-4">📊</div>
        <h2 className="text-lg font-bold text-gray-700 mb-2">
          まだ学習履歴がありません
        </h2>
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
  const groupedMasteries = new Map<string, MasteryWithSkill[]>();
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
          <h3 className="text-sm font-bold text-gray-600 mb-3">
            スキル別習熟度
          </h3>
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
                        <span
                          className={`shrink-0 text-xs font-bold px-2 py-0.5 rounded ${cfg.bg} ${cfg.text}`}
                        >
                          {cfg.label}
                        </span>
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
                        <span className="shrink-0 text-xs text-gray-400">
                          {formatDate(m.last_practiced)}
                        </span>
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
          <h3 className="text-sm font-bold text-gray-600 mb-3">
            最近の解答（直近20件）
          </h3>
          <div className="bg-white rounded-lg border border-gray-200 divide-y divide-gray-100">
            {recentLogs.map((log) => {
              let mark: string;
              if (log.is_correct === true) mark = "◯";
              else if (log.is_correct === false) mark = "✕";
              else if (log.score !== null) mark = `${log.score}点`;
              else mark = "-";

              const markColor =
                log.is_correct === true ||
                (log.score !== null && log.score >= 7)
                  ? "text-green-600"
                  : log.is_correct === false ||
                      (log.score !== null && log.score < 7)
                    ? "text-red-500"
                    : "text-gray-400";

              const questionText =
                log.exercise?.question_text ?? log.exercise_id;
              const shortQuestion =
                questionText.length > 40
                  ? questionText.slice(0, 40) + "..."
                  : questionText;

              return (
                <div
                  key={log.id}
                  className="px-3 py-2.5 flex items-center gap-3 text-sm"
                >
                  <span
                    className={`shrink-0 font-bold text-base w-8 text-center ${markColor}`}
                  >
                    {mark}
                  </span>
                  <p className="flex-1 min-w-0 text-gray-700 truncate">
                    {shortQuestion}
                  </p>
                  {log.time_spent_sec && (
                    <span className="shrink-0 text-xs text-gray-400">
                      {log.time_spent_sec}秒
                    </span>
                  )}
                  <span className="shrink-0 text-xs text-gray-400">
                    {formatDate(log.answered_at)}
                  </span>
                </div>
              );
            })}
          </div>
        </section>
      )}
    </div>
  );
}

function StatCard({
  label,
  value,
}: {
  label: string;
  value: string | number;
}) {
  return (
    <div className="bg-white rounded-lg border border-gray-200 p-3 text-center">
      <p className="text-2xl font-bold text-gray-800">{value}</p>
      <p className="text-xs text-gray-500 mt-0.5">{label}</p>
    </div>
  );
}
