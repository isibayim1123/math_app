import { supabase } from "@/lib/supabase";
import type {
  Skill,
  Pattern,
  Example,
  ExampleStep,
  PatternWithDetails,
} from "@/types/database";
import Link from "next/link";
import { PatternCard } from "./PatternCard";

async function getSkillWithPatterns(skillId: string) {
  // スキル取得
  const { data: skill } = await supabase
    .from("skills")
    .select("*")
    .eq("id", skillId)
    .single();

  if (!skill) return null;

  // パターン一覧
  const { data: patterns } = await supabase
    .from("patterns")
    .select("*")
    .eq("skill_id", skillId)
    .order("sort_order");

  if (!patterns || patterns.length === 0) {
    return { skill: skill as Skill, patterns: [] as PatternWithDetails[] };
  }

  const patternIds = patterns.map((p: Pattern) => p.id);

  // 例題（パターンごとに1つ）
  const { data: examples } = await supabase
    .from("examples")
    .select("*")
    .in("pattern_id", patternIds);

  // 例題ステップ
  const exampleIds = (examples ?? []).map((e: Example) => e.id);
  const { data: steps } = exampleIds.length
    ? await supabase
        .from("example_steps")
        .select("*")
        .in("example_id", exampleIds)
        .order("step_number")
    : { data: [] };

  // 演習数
  const { data: exercises } = await supabase
    .from("exercises")
    .select("pattern_id")
    .in("pattern_id", patternIds);

  // 組み立て
  const stepsMap = new Map<string, ExampleStep[]>();
  (steps ?? []).forEach((s: ExampleStep) => {
    if (!stepsMap.has(s.example_id)) stepsMap.set(s.example_id, []);
    stepsMap.get(s.example_id)!.push(s);
  });

  const exMap = new Map<string, (Example & { steps: ExampleStep[] })[]>();
  (examples ?? []).forEach((ex: Example) => {
    if (!exMap.has(ex.pattern_id)) exMap.set(ex.pattern_id, []);
    exMap.get(ex.pattern_id)!.push({
      ...ex,
      steps: stepsMap.get(ex.id) ?? [],
    });
  });

  const eCountMap = new Map<string, number>();
  (exercises ?? []).forEach((e: { pattern_id: string }) => {
    eCountMap.set(e.pattern_id, (eCountMap.get(e.pattern_id) ?? 0) + 1);
  });

  const patternsWithDetails: PatternWithDetails[] = patterns.map(
    (p: Pattern) => ({
      ...p,
      examples: exMap.get(p.id) ?? [],
      exercise_count: eCountMap.get(p.id) ?? 0,
    })
  );

  return { skill: skill as Skill, patterns: patternsWithDetails };
}

export const dynamic = "force-dynamic";

export default async function SkillPage({
  params,
}: {
  params: Promise<{ skillId: string }>;
}) {
  const { skillId } = await params;
  const data = await getSkillWithPatterns(skillId);

  if (!data) {
    return (
      <div className="p-6 text-center text-gray-500">
        スキルが見つかりません
      </div>
    );
  }

  const { skill, patterns } = data;
  const totalExercises = patterns.reduce((s, p) => s + p.exercise_count, 0);

  return (
    <div className="max-w-2xl mx-auto px-4 py-6">
      {/* ヘッダー */}
      <div className="mb-6">
        <Link
          href="/"
          className="text-sm text-blue-600 hover:underline mb-2 inline-block"
        >
          ← 単元一覧に戻る
        </Link>
        <h2 className="text-xl font-bold text-gray-800">
          {skill.display_name}
        </h2>
        {skill.description && (
          <p className="text-sm text-gray-500 mt-1">{skill.description}</p>
        )}
        <div className="flex items-center gap-3 mt-3">
          <span className="text-xs font-medium px-2.5 py-1 rounded-full bg-purple-50 text-purple-700">
            {patterns.length}パターン
          </span>
          <span className="text-xs font-medium px-2.5 py-1 rounded-full bg-blue-50 text-blue-700">
            {totalExercises}問
          </span>
        </div>
      </div>

      {/* パターン一覧 */}
      <div className="space-y-4 mb-8">
        {patterns.map((pattern) => (
          <PatternCard key={pattern.id} pattern={pattern} />
        ))}
      </div>

      {/* 演習開始ボタン */}
      {totalExercises > 0 && (
        <div className="sticky bottom-4">
          <Link
            href={`/exercises/${skill.id}`}
            className="block w-full text-center bg-blue-600 hover:bg-blue-700 text-white font-bold py-3.5 rounded-xl shadow-lg transition-colors"
          >
            演習を始める（{totalExercises}問）
          </Link>
        </div>
      )}
    </div>
  );
}
