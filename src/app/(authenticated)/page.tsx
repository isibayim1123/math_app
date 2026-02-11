import { supabase } from "@/lib/supabase";
import type { Skill, UnitGroup } from "@/types/database";
import Link from "next/link";
import { UnitAccordion } from "./UnitAccordion";

async function getUnitGroups(): Promise<UnitGroup[]> {
  // スキル一覧取得
  const { data: skills } = await supabase
    .from("skills")
    .select("*")
    .order("sort_order");

  if (!skills || skills.length === 0) return [];

  // パターン数と演習数を集計
  const { data: patternCounts } = await supabase
    .from("patterns")
    .select("skill_id");
  const { data: exercises } = await supabase
    .from("exercises")
    .select("pattern_id");
  const { data: patterns } = await supabase
    .from("patterns")
    .select("id, skill_id");

  // skill_id → パターン数
  const pCountMap = new Map<string, number>();
  patternCounts?.forEach((p: { skill_id: string }) => {
    pCountMap.set(p.skill_id, (pCountMap.get(p.skill_id) ?? 0) + 1);
  });

  // pattern_id → skill_id マッピング
  const patToSkill = new Map<string, string>();
  patterns?.forEach((p: { id: string; skill_id: string }) => {
    patToSkill.set(p.id, p.skill_id);
  });

  // skill_id → 演習数
  const eCountMap = new Map<string, number>();
  exercises?.forEach((e: { pattern_id: string }) => {
    const skillId = patToSkill.get(e.pattern_id);
    if (skillId) eCountMap.set(skillId, (eCountMap.get(skillId) ?? 0) + 1);
  });

  // unit_name でグループ化
  const groupMap = new Map<string, UnitGroup>();
  (skills as Skill[]).forEach((skill) => {
    if (!groupMap.has(skill.unit_name)) {
      groupMap.set(skill.unit_name, {
        unit_name: skill.unit_name,
        subject: skill.subject,
        skills: [],
      });
    }
    groupMap.get(skill.unit_name)!.skills.push({
      ...skill,
      pattern_count: pCountMap.get(skill.id) ?? 0,
      exercise_count: eCountMap.get(skill.id) ?? 0,
    });
  });

  return Array.from(groupMap.values());
}

export const dynamic = "force-dynamic";

export default async function HomePage() {
  const units = await getUnitGroups();

  if (units.length === 0) {
    return (
      <div className="p-6 text-center text-gray-500">
        <p className="text-lg font-medium mb-2">データがありません</p>
        <p className="text-sm">
          Supabaseにスキーマとシードデータを投入してください。
          <br />
          詳しくは README.md をご覧ください。
        </p>
      </div>
    );
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-6">
      <h2 className="text-base font-bold text-gray-700 mb-4">
        単元を選んで学習を始めましょう
      </h2>
      <div className="space-y-4">
        {units.map((unit) => (
          <UnitAccordion key={unit.unit_name} unit={unit} />
        ))}
      </div>
    </div>
  );
}
