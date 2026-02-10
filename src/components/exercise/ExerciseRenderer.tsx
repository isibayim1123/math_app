"use client";

import type { ExerciseWithDetails } from "@/types/database";
import { SelectBasic } from "./SelectBasic";
import { SelectMulti } from "./SelectMulti";
import { ImageProcess } from "./ImageProcess";

/**
 * input_template に応じてコンポーネントを切り替え
 * - SELECT_BASIC → SelectBasic
 * - SELECT_MULTI → SelectMulti
 * - それ以外 → ImageProcess（TEXT系もIMAGE扱い）
 */
export function ExerciseRenderer({
  exercise,
  onComplete,
}: {
  exercise: ExerciseWithDetails;
  onComplete: (correct: boolean) => void;
}) {
  switch (exercise.input_template) {
    case "SELECT_BASIC":
      return <SelectBasic exercise={exercise} onComplete={onComplete} />;
    case "SELECT_MULTI":
      return <SelectMulti exercise={exercise} onComplete={onComplete} />;
    default:
      return <ImageProcess exercise={exercise} onComplete={onComplete} />;
  }
}
