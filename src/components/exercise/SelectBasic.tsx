"use client";

import { useState } from "react";
import type { ExerciseWithDetails } from "@/types/database";
import { MathText, MathExpr } from "@/components/ui/MathText";

export function SelectBasic({
  exercise,
  onComplete,
}: {
  exercise: ExerciseWithDetails;
  onComplete: (correct: boolean) => void;
}) {
  const [selected, setSelected] = useState<number | null>(null);
  const [submitted, setSubmitted] = useState(false);

  const choices = [...exercise.choices].sort((a, b) => a.sort_order - b.sort_order);

  function handleSubmit() {
    if (selected === null || submitted) return;
    setSubmitted(true);
    const isCorrect = choices[selected].is_correct;
    onComplete(isCorrect);
  }

  return (
    <div>
      {/* 選択肢 */}
      <div className="space-y-2">
        {choices.map((ch, i) => {
          let borderClass = "border-gray-200 hover:border-blue-400";
          if (submitted) {
            if (ch.is_correct) borderClass = "border-green-500 bg-green-50";
            else if (i === selected) borderClass = "border-red-500 bg-red-50";
            else borderClass = "border-gray-200 opacity-60";
          } else if (i === selected) {
            borderClass = "border-blue-500 bg-blue-50";
          }

          return (
            <label
              key={ch.id}
              className={`flex items-center gap-3 p-3 rounded-xl border-2 transition-all cursor-pointer ${borderClass} ${submitted ? "pointer-events-none" : ""}`}
            >
              <input
                type="radio"
                name={`select_${exercise.id}`}
                checked={i === selected}
                onChange={() => !submitted && setSelected(i)}
                className="w-4.5 h-4.5 accent-blue-600 flex-shrink-0"
                disabled={submitted}
              />
              <span className="font-semibold text-sm text-gray-500 flex-shrink-0">
                {ch.choice_label}.
              </span>
              <span className="text-sm">
                <MathExpr expr={ch.choice_expr} />
              </span>
              {submitted && ch.is_correct && (
                <span className="ml-auto text-green-600 font-bold text-sm">✓</span>
              )}
              {submitted && i === selected && !ch.is_correct && (
                <span className="ml-auto text-red-600 font-bold text-sm">✗</span>
              )}
            </label>
          );
        })}
      </div>

      {/* 解答ボタン */}
      {!submitted && (
        <div className="flex justify-end mt-4">
          <button
            onClick={handleSubmit}
            disabled={selected === null}
            className="px-6 py-2.5 bg-blue-600 text-white font-semibold rounded-xl disabled:opacity-40 hover:bg-blue-700 transition-colors text-sm"
          >
            解答する
          </button>
        </div>
      )}

      {/* 正誤バナー */}
      {submitted && (
        <div
          className={`mt-4 p-3 rounded-xl text-sm font-medium ${
            choices[selected!].is_correct
              ? "bg-green-50 text-green-700 border border-green-200"
              : "bg-red-50 text-red-700 border border-red-200"
          }`}
        >
          {choices[selected!].is_correct ? "⭕ 正解！" : "❌ 不正解"}
        </div>
      )}
    </div>
  );
}
