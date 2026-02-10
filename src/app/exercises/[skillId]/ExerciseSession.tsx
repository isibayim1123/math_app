"use client";

import { useState } from "react";
import Link from "next/link";
import type { Skill, ExerciseWithDetails } from "@/types/database";
import { MathText } from "@/components/ui/MathText";
import { ExerciseRenderer } from "@/components/exercise/ExerciseRenderer";

const TEMPLATE_ICON: Record<string, string> = {
  SELECT_BASIC: "🔘",
  SELECT_MULTI: "☑️",
  TEXT_NUMERIC: "📸",
  TEXT_EXPRESSION: "📸",
  TEXT_SET: "📸",
  IMAGE_PROCESS: "📸",
  IMAGE_PROOF: "📸",
};

function difficultyStars(d: number) {
  return "★".repeat(d) + "☆".repeat(5 - d);
}

export function ExerciseSession({
  skill,
  exercises,
}: {
  skill: Skill;
  exercises: ExerciseWithDetails[];
}) {
  const total = exercises.length;
  const [current, setCurrent] = useState(0);
  const [results, setResults] = useState<(boolean | null)[]>(
    new Array(total).fill(null)
  );
  const [answered, setAnswered] = useState(false);
  const [showExplanation, setShowExplanation] = useState(false);
  const [finished, setFinished] = useState(false);

  const ex = exercises[current];
  const pct = Math.round(((current + (answered ? 1 : 0)) / total) * 100);

  function handleComplete(correct: boolean) {
    const next = [...results];
    next[current] = correct;
    setResults(next);
    setAnswered(true);
  }

  function handleNext() {
    if (current + 1 >= total) {
      setFinished(true);
      return;
    }
    setCurrent(current + 1);
    setAnswered(false);
    setShowExplanation(false);
  }

  // 結果画面
  if (finished) {
    const correctCount = results.filter((r) => r === true).length;
    const answeredCount = results.filter((r) => r !== null).length;
    const accuracy =
      answeredCount > 0 ? Math.round((correctCount / answeredCount) * 100) : 0;
    const wrongIndices = results
      .map((r, i) => (r === false ? i : -1))
      .filter((i) => i >= 0);

    return (
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="bg-white rounded-2xl border border-gray-200 shadow-sm p-6 text-center">
          <div className="text-4xl mb-3">🎉</div>
          <h2 className="text-xl font-bold text-gray-800 mb-1">
            演習完了！
          </h2>
          <p className="text-sm text-gray-500 mb-6">{skill.display_name}</p>

          <div className="grid grid-cols-3 gap-4 mb-6">
            <div className="bg-blue-50 rounded-xl p-3">
              <p className="text-2xl font-bold text-blue-600">
                {answeredCount}
              </p>
              <p className="text-xs text-blue-500">解答数</p>
            </div>
            <div className="bg-green-50 rounded-xl p-3">
              <p className="text-2xl font-bold text-green-600">
                {correctCount}
              </p>
              <p className="text-xs text-green-500">正解数</p>
            </div>
            <div className="bg-purple-50 rounded-xl p-3">
              <p className="text-2xl font-bold text-purple-600">{accuracy}%</p>
              <p className="text-xs text-purple-500">正答率</p>
            </div>
          </div>

          {wrongIndices.length > 0 && (
            <div className="text-left mb-6">
              <p className="text-sm font-semibold text-gray-600 mb-2">
                間違えた問題:
              </p>
              <div className="space-y-2">
                {wrongIndices.map((i) => (
                  <div
                    key={i}
                    className="text-sm bg-red-50 border border-red-100 rounded-lg px-3 py-2"
                  >
                    <span className="text-red-500 font-medium">
                      問{i + 1}.{" "}
                    </span>
                    <MathText text={exercises[i].question_text} />
                  </div>
                ))}
              </div>
            </div>
          )}

          <div className="flex gap-3 justify-center">
            <Link
              href={`/skills/${skill.id}`}
              className="px-5 py-2.5 text-sm font-semibold border border-gray-300 rounded-xl hover:bg-gray-50 transition-colors"
            >
              スキルに戻る
            </Link>
            <Link
              href="/"
              className="px-5 py-2.5 text-sm font-semibold bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors"
            >
              単元一覧へ
            </Link>
          </div>
        </div>
      </div>
    );
  }

  // 演習画面
  return (
    <div className="max-w-2xl mx-auto px-4 py-4">
      {/* 進捗バー */}
      <div className="flex items-center gap-3 mb-4">
        <Link
          href={`/skills/${skill.id}`}
          className="text-sm text-blue-600 hover:underline flex-shrink-0"
        >
          ← 戻る
        </Link>
        <div className="flex-1 h-2 bg-gray-200 rounded-full overflow-hidden">
          <div
            className="h-full bg-gradient-to-r from-blue-500 to-indigo-500 rounded-full transition-all duration-300"
            style={{ width: `${pct}%` }}
          />
        </div>
        <span className="text-xs font-medium text-gray-500 flex-shrink-0">
          {current + 1} / {total}
        </span>
      </div>

      {/* 問題カード */}
      <div className="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        {/* カードヘッダー */}
        <div className="flex items-center gap-2 px-5 py-3 border-b border-gray-100 bg-gray-50/50">
          <span className="text-xs font-semibold px-2 py-0.5 rounded-full bg-purple-50 text-purple-700">
            {skill.display_name}
          </span>
          <span className="text-xs font-medium px-2 py-0.5 rounded-full bg-sky-50 text-sky-700">
            {TEMPLATE_ICON[ex.input_template] ?? "📸"}{" "}
            {ex.input_template.startsWith("SELECT") ? "選択" : "記述"}
          </span>
          <span className="ml-auto text-xs text-amber-500">
            {difficultyStars(ex.difficulty)}
          </span>
        </div>

        {/* 問題文 */}
        <div className="px-5 pt-4 pb-2">
          <div className="text-[15px] leading-relaxed">
            <MathText text={ex.question_text} />
          </div>
        </div>

        {/* 解答UI */}
        <div className="px-5 py-4">
          <ExerciseRenderer
            key={ex.id}
            exercise={ex}
            onComplete={handleComplete}
          />
        </div>

        {/* 解説 */}
        {answered && ex.explanation && (
          <div className="px-5 pb-4">
            <button
              onClick={() => setShowExplanation(!showExplanation)}
              className="text-sm font-medium text-blue-600 hover:underline"
            >
              {showExplanation ? "▼ 解説を非表示" : "▶ 解説を表示"}
            </button>
            {showExplanation && (
              <div className="mt-2 p-3 bg-gray-50 rounded-xl border border-gray-100 text-sm leading-relaxed">
                <MathText text={ex.explanation} />
              </div>
            )}
          </div>
        )}

        {/* 次の問題ボタン */}
        {answered && (
          <div className="px-5 pb-5">
            <button
              onClick={handleNext}
              className="w-full py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl transition-colors text-sm"
            >
              {current + 1 >= total ? "結果を見る" : "次の問題へ"}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
