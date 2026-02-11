"use client";

import { useState } from "react";
import Link from "next/link";
import type { UnitGroup } from "@/types/database";

const SUBJECT_LABEL: Record<string, string> = {
  math_1: "数学I",
  math_A: "数学A",
  math_2: "数学II",
  math_B: "数学B",
  math_3: "数学III",
  math_C: "数学C",
};

export function UnitAccordion({ unit }: { unit: UnitGroup }) {
  const [open, setOpen] = useState(false);
  const totalExercises = unit.skills.reduce(
    (s, sk) => s + sk.exercise_count,
    0
  );

  return (
    <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
      <button
        onClick={() => setOpen(!open)}
        className="w-full flex items-center justify-between px-5 py-4 text-left hover:bg-gray-50 transition-colors"
      >
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="text-xs font-semibold px-2 py-0.5 rounded-full bg-blue-50 text-blue-700">
              {SUBJECT_LABEL[unit.subject] ?? unit.subject}
            </span>
          </div>
          <h3 className="text-base font-bold text-gray-800">
            {unit.unit_name}
          </h3>
          <p className="text-xs text-gray-500 mt-0.5">
            {unit.skills.length}スキル・{totalExercises}問
          </p>
        </div>
        <span
          className={`text-gray-400 transition-transform ${open ? "rotate-180" : ""}`}
        >
          ▼
        </span>
      </button>

      {open && (
        <div className="border-t border-gray-100 divide-y divide-gray-100">
          {unit.skills.map((skill) => (
            <Link
              key={skill.id}
              href={`/skills/${skill.id}`}
              className="flex items-center justify-between px-5 py-3 hover:bg-blue-50 transition-colors"
            >
              <div className="min-w-0">
                <p className="text-sm font-medium text-gray-800 truncate">
                  {skill.display_name}
                </p>
                {skill.description && (
                  <p className="text-xs text-gray-500 mt-0.5 line-clamp-1">
                    {skill.description}
                  </p>
                )}
              </div>
              <div className="flex items-center gap-3 flex-shrink-0 ml-3">
                <span className="text-xs text-gray-400">
                  {skill.pattern_count}型・{skill.exercise_count}問
                </span>
                <span className="text-gray-300">›</span>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
