"use client";

import { useState } from "react";
import type { PatternWithDetails } from "@/types/database";
import { MathText } from "@/components/ui/MathText";

export function PatternCard({ pattern }: { pattern: PatternWithDetails }) {
  const [open, setOpen] = useState(false);
  const example = pattern.examples[0];

  return (
    <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
      <button
        onClick={() => setOpen(!open)}
        className="w-full flex items-center justify-between px-5 py-4 text-left hover:bg-gray-50 transition-colors"
      >
        <div>
          <h4 className="text-sm font-bold text-gray-800">
            {pattern.display_name}
          </h4>
          <p className="text-xs text-gray-500 mt-0.5">
            {pattern.exercise_count}問の演習
          </p>
        </div>
        <span
          className={`text-gray-400 text-sm transition-transform ${open ? "rotate-180" : ""}`}
        >
          ▼
        </span>
      </button>

      {open && example && (
        <div className="border-t border-gray-100 px-5 py-4 bg-gray-50/50">
          <p className="text-xs font-semibold text-blue-600 mb-2">
            例題
          </p>

          {/* 問題文 */}
          <div className="text-sm leading-relaxed mb-3">
            <MathText text={example.question_text} />
          </div>

          {/* 解法ステップ */}
          {example.steps.length > 0 && (
            <div className="space-y-2 mb-3">
              {example.steps.map((step) => (
                <div
                  key={step.id}
                  className="flex gap-3 text-sm bg-white rounded-lg px-3 py-2 border border-gray-100"
                >
                  <span className="text-xs font-bold text-blue-500 flex-shrink-0 mt-0.5">
                    {step.step_number}
                  </span>
                  <div>
                    <p className="font-medium text-gray-700">{step.label}</p>
                    {step.expr && (
                      <div className="mt-1 text-gray-600">
                        <MathText text={`$${step.expr}$`} />
                      </div>
                    )}
                    {step.explanation && (
                      <p className="text-xs text-gray-500 mt-1">
                        <MathText text={step.explanation} />
                      </p>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}

          {/* 答え */}
          <div className="text-sm bg-green-50 border border-green-200 rounded-lg px-3 py-2 mb-2">
            <span className="text-xs font-semibold text-green-700">答え: </span>
            <MathText text={example.answer_text} />
          </div>

          {/* 学習ポイント */}
          {example.learning_point && (
            <div className="text-xs text-gray-600 bg-yellow-50 border border-yellow-200 rounded-lg px-3 py-2">
              <span className="font-semibold text-yellow-700">Point: </span>
              <MathText text={example.learning_point} />
            </div>
          )}
        </div>
      )}
    </div>
  );
}
