"use client";

import { useState, useRef } from "react";
import type { ExerciseWithDetails } from "@/types/database";
import { MathText, MathExpr } from "@/components/ui/MathText";

export function ImageProcess({
  exercise,
  onComplete,
}: {
  exercise: ExerciseWithDetails;
  onComplete: (correct: boolean) => void;
}) {
  const [preview, setPreview] = useState<string | null>(null);
  const [grading, setGrading] = useState(false);
  const [done, setDone] = useState(false);
  const cameraRef = useRef<HTMLInputElement>(null);
  const fileRef = useRef<HTMLInputElement>(null);

  function handleFile(file: File | undefined) {
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (e) => setPreview(e.target?.result as string);
    reader.readAsDataURL(file);
  }

  function handleGrade() {
    if (grading || done) return;
    setGrading(true);
    setTimeout(() => {
      setGrading(false);
      setDone(true);
      onComplete(false); // モック: 採点結果なし
    }, 1200);
  }

  const primaryAnswer = exercise.answers.find((a) => a.is_primary);

  return (
    <div>
      {/* アップロードゾーン */}
      {!done && (
        <div
          className={`border-2 border-dashed rounded-xl p-6 text-center transition-all ${
            preview
              ? "border-blue-400 bg-blue-50"
              : "border-gray-300 bg-gray-50"
          }`}
        >
          {preview ? (
            <img
              src={preview}
              alt="解答画像"
              className="max-h-48 mx-auto rounded-lg mb-3 object-contain"
            />
          ) : (
            <div className="text-3xl mb-2">📝</div>
          )}
          <p className="text-sm text-gray-500 mb-3">
            {preview ? "画像をアップロード済み" : "解答を撮影またはファイルで提出"}
          </p>
          <div className="flex gap-3 justify-center flex-wrap">
            <button
              onClick={() => cameraRef.current?.click()}
              className="px-4 py-2 text-sm font-medium border border-gray-300 rounded-xl bg-white hover:border-blue-400 transition-colors"
            >
              📷 カメラで撮影
            </button>
            <button
              onClick={() => fileRef.current?.click()}
              className="px-4 py-2 text-sm font-medium border border-gray-300 rounded-xl bg-white hover:border-blue-400 transition-colors"
            >
              📁 画像を選択
            </button>
          </div>
          <input
            ref={cameraRef}
            type="file"
            accept="image/*"
            capture="environment"
            className="hidden"
            onChange={(e) => handleFile(e.target.files?.[0])}
          />
          <input
            ref={fileRef}
            type="file"
            accept="image/*"
            className="hidden"
            onChange={(e) => handleFile(e.target.files?.[0])}
          />
        </div>
      )}

      {/* 採点ボタン */}
      {preview && !done && (
        <div className="flex justify-end mt-4">
          <button
            onClick={handleGrade}
            disabled={grading}
            className="px-6 py-2.5 bg-blue-600 text-white font-semibold rounded-xl disabled:opacity-50 hover:bg-blue-700 transition-colors text-sm"
          >
            {grading ? (
              <span className="flex items-center gap-2">
                <span className="inline-block w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                AI採点中…
              </span>
            ) : (
              "採点する"
            )}
          </button>
        </div>
      )}

      {/* 採点結果（モック） */}
      {done && (
        <div className="mt-4 space-y-3">
          <div className="p-3 rounded-xl bg-sky-50 border border-sky-200 text-sm">
            <p className="text-sky-700 font-medium mb-1">
              AI採点機能は準備中です
              <span className="ml-2 text-xs font-normal px-2 py-0.5 rounded-full bg-yellow-100 text-yellow-700">
                推定コスト: ¥{exercise.grading_cost || 5}
              </span>
            </p>
            <p className="text-sky-600 text-xs">
              デモモードのため模範解答を表示します。
            </p>
          </div>

          {/* 模範解答 */}
          {(primaryAnswer || exercise.explanation) && (
            <div className="p-3 rounded-xl bg-green-50 border border-green-200">
              <p className="text-xs font-semibold text-green-700 mb-1">
                模範解答
              </p>
              <div className="text-sm leading-relaxed text-green-900">
                {primaryAnswer ? (
                  <MathExpr expr={primaryAnswer.answer_expr} />
                ) : (
                  <MathText text={exercise.explanation ?? ""} />
                )}
              </div>
            </div>
          )}

          {/* ルーブリック */}
          {exercise.rubrics.length > 0 && (
            <div className="rounded-xl border border-gray-200 overflow-hidden">
              <table className="w-full text-sm">
                <thead>
                  <tr className="bg-gray-50">
                    <th className="text-left px-3 py-2 font-semibold text-gray-600">
                      評価基準
                    </th>
                    <th className="text-center px-3 py-2 font-semibold text-gray-600 w-16">
                      配点
                    </th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {exercise.rubrics
                    .sort((a, b) => a.sort_order - b.sort_order)
                    .map((r) => (
                      <tr key={r.id}>
                        <td className="px-3 py-2 text-gray-700">
                          {r.criterion}
                          {r.description && (
                            <p className="text-xs text-gray-400 mt-0.5">
                              {r.description}
                            </p>
                          )}
                        </td>
                        <td className="px-3 py-2 text-center font-medium">
                          {r.max_points}点
                        </td>
                      </tr>
                    ))}
                  <tr className="bg-gray-50 font-semibold">
                    <td className="px-3 py-2">合計</td>
                    <td className="px-3 py-2 text-center">
                      {exercise.rubrics.reduce((s, r) => s + r.max_points, 0)}点
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
