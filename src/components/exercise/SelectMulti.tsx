"use client";

import { useState } from "react";
import type { ExerciseWithDetails } from "@/types/database";
import { MathExpr } from "@/components/ui/MathText";

export function SelectMulti({
  exercise,
  onComplete,
}: {
  exercise: ExerciseWithDetails;
  onComplete: (correct: boolean) => void;
}) {
  const [checked, setChecked] = useState<Set<number>>(new Set());
  const [submitted, setSubmitted] = useState(false);

  const choices = [...exercise.choices].sort((a, b) => a.sort_order - b.sort_order);
  const correctSet = new Set(
    choices.map((c, i) => (c.is_correct ? i : -1)).filter((i) => i >= 0)
  );

  function toggle(i: number) {
    if (submitted) return;
    const next = new Set(checked);
    if (next.has(i)) next.delete(i);
    else next.add(i);
    setChecked(next);
  }

  function handleSubmit() {
    if (submitted) return;
    setSubmitted(true);

    // 完全一致判定
    const perfect =
      checked.size === correctSet.size &&
      [...checked].every((i) => correctSet.has(i));
    const anyCorrect = [...checked].some((i) => correctSet.has(i));

    onComplete(perfect);
  }

  // 判定結果
  let resultType: "ok" | "partial" | "ng" | null = null;
  if (submitted) {
    const perfect =
      checked.size === correctSet.size &&
      [...checked].every((i) => correctSet.has(i));
    const anyCorrect = [...checked].some((i) => correctSet.has(i));
    resultType = perfect ? "ok" : anyCorrect ? "partial" : "ng";
  }

  return (
    <div>
      <div className="space-y-2">
        {choices.map((ch, i) => {
          let borderClass = "border-gray-200 hover:border-blue-400";
          if (submitted) {
            if (ch.is_correct && checked.has(i))
              borderClass = "border-green-500 bg-green-50";
            else if (ch.is_correct && !checked.has(i))
              borderClass = "border-green-400 bg-green-50/50 opacity-70";
            else if (!ch.is_correct && checked.has(i))
              borderClass = "border-red-500 bg-red-50";
            else borderClass = "border-gray-200 opacity-60";
          } else if (checked.has(i)) {
            borderClass = "border-blue-500 bg-blue-50";
          }

          return (
            <label
              key={ch.id}
              className={`flex items-center gap-3 p-3 rounded-xl border-2 transition-all cursor-pointer ${borderClass} ${submitted ? "pointer-events-none" : ""}`}
            >
              <input
                type="checkbox"
                checked={checked.has(i)}
                onChange={() => toggle(i)}
                className="w-4.5 h-4.5 accent-blue-600 rounded flex-shrink-0"
                disabled={submitted}
              />
              <span className="font-semibold text-sm text-gray-500 flex-shrink-0">
                {ch.choice_label}.
              </span>
              <span className="text-sm">
                <MathExpr expr={ch.choice_expr} />
              </span>
            </label>
          );
        })}
      </div>

      {!submitted && (
        <div className="flex justify-end mt-4">
          <button
            onClick={handleSubmit}
            className="px-6 py-2.5 bg-blue-600 text-white font-semibold rounded-xl hover:bg-blue-700 transition-colors text-sm"
          >
            解答する
          </button>
        </div>
      )}

      {submitted && resultType && (
        <div
          className={`mt-4 p-3 rounded-xl text-sm font-medium border ${
            resultType === "ok"
              ? "bg-green-50 text-green-700 border-green-200"
              : resultType === "partial"
                ? "bg-yellow-50 text-yellow-700 border-yellow-200"
                : "bg-red-50 text-red-700 border-red-200"
          }`}
        >
          {resultType === "ok"
            ? "⭕ 正解！"
            : resultType === "partial"
              ? "△ 部分正解"
              : "❌ 不正解"}
        </div>
      )}
    </div>
  );
}
