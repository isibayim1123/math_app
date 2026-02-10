-- ============================================================
-- プロトタイプ用: 匿名ユーザー＋RLSポリシー設定
-- Supabase SQL Editor で実行してください
-- ============================================================

BEGIN;

-- =========================
-- 1. デモ用組織
-- =========================
INSERT INTO organizations (id, name, slug, plan, max_students)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'プロトタイプ用',
  'prototype-demo',
  'trial',
  999
)
ON CONFLICT (id) DO NOTHING;

-- =========================
-- 2. 匿名ユーザー（プロトタイプ用）
-- =========================
INSERT INTO users (id, organization_id, role, display_name, email)
VALUES (
  '00000000-0000-0000-0000-000000000000',
  '00000000-0000-0000-0000-000000000001',
  'student',
  'プロトタイプユーザー',
  'prototype@demo.local'
)
ON CONFLICT (id) DO NOTHING;

-- =========================
-- 3. RLSポリシー: answer_logs
-- =========================
ALTER TABLE answer_logs ENABLE ROW LEVEL SECURITY;

-- SELECT: 全員読み取り可
DROP POLICY IF EXISTS "answer_logs_select_all" ON answer_logs;
CREATE POLICY "answer_logs_select_all" ON answer_logs
  FOR SELECT USING (true);

-- INSERT: 全員挿入可（プロトタイプ用、本番では認証ユーザーに限定）
DROP POLICY IF EXISTS "answer_logs_insert_all" ON answer_logs;
CREATE POLICY "answer_logs_insert_all" ON answer_logs
  FOR INSERT WITH CHECK (true);

-- =========================
-- 4. RLSポリシー: skill_mastery
-- =========================
ALTER TABLE skill_mastery ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "skill_mastery_select_all" ON skill_mastery;
CREATE POLICY "skill_mastery_select_all" ON skill_mastery
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "skill_mastery_insert_all" ON skill_mastery;
CREATE POLICY "skill_mastery_insert_all" ON skill_mastery
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "skill_mastery_update_all" ON skill_mastery;
CREATE POLICY "skill_mastery_update_all" ON skill_mastery
  FOR UPDATE USING (true);

-- =========================
-- 5. RLSポリシー: pattern_mastery（将来用）
-- =========================
ALTER TABLE pattern_mastery ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "pattern_mastery_select_all" ON pattern_mastery;
CREATE POLICY "pattern_mastery_select_all" ON pattern_mastery
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "pattern_mastery_insert_all" ON pattern_mastery;
CREATE POLICY "pattern_mastery_insert_all" ON pattern_mastery
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "pattern_mastery_update_all" ON pattern_mastery;
CREATE POLICY "pattern_mastery_update_all" ON pattern_mastery
  FOR UPDATE USING (true);

COMMIT;
