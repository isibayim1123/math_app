-- ============================================================
-- RLSポリシー: コンテンツは全員読み取り可、ユーザーデータは自分のみ
-- Supabase SQL Editor で実行してください
-- ============================================================

-- コンテンツテーブルは全員読み取り可
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read skills" ON skills FOR SELECT USING (true);
ALTER TABLE patterns ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read patterns" ON patterns FOR SELECT USING (true);
ALTER TABLE examples ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read examples" ON examples FOR SELECT USING (true);
ALTER TABLE example_steps ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read example_steps" ON example_steps FOR SELECT USING (true);
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read exercises" ON exercises FOR SELECT USING (true);
ALTER TABLE exercise_choices ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read exercise_choices" ON exercise_choices FOR SELECT USING (true);
ALTER TABLE exercise_answers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read exercise_answers" ON exercise_answers FOR SELECT USING (true);
ALTER TABLE exercise_rubrics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read exercise_rubrics" ON exercise_rubrics FOR SELECT USING (true);
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read organizations" ON organizations FOR SELECT USING (true);

-- ユーザーデータは自分のみ
ALTER TABLE answer_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own answer_logs" ON answer_logs
  FOR SELECT USING (user_id = (SELECT id FROM users WHERE auth_uid = auth.uid()::text));
CREATE POLICY "Users can insert own answer_logs" ON answer_logs
  FOR INSERT WITH CHECK (user_id = (SELECT id FROM users WHERE auth_uid = auth.uid()::text));

ALTER TABLE skill_mastery ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own skill_mastery" ON skill_mastery
  FOR ALL USING (user_id = (SELECT id FROM users WHERE auth_uid = auth.uid()::text));

ALTER TABLE pattern_mastery ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own pattern_mastery" ON pattern_mastery
  FOR ALL USING (user_id = (SELECT id FROM users WHERE auth_uid = auth.uid()::text));
