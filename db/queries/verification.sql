-- ============================================================
-- サンプルデータ検証クエリ
-- 実行: psql -d math_learning_db -f db/queries/verification.sql
-- ============================================================

-- =========================
-- 1. 階層構造の検証（skills → patterns → exercises）
-- =========================

\echo '=== 1.1 スキル → パターン → 演習 階層一覧 ==='
SELECT
  s.id AS skill_id,
  s.display_name AS skill,
  p.id AS pattern_id,
  p.display_name AS pattern,
  COUNT(e.id) AS exercise_count
FROM skills s
LEFT JOIN patterns p ON p.skill_id = s.id
LEFT JOIN exercises e ON e.pattern_id = p.id
GROUP BY s.id, s.display_name, s.sort_order, p.id, p.display_name, p.sort_order
ORDER BY s.sort_order, p.sort_order;

\echo '=== 1.2 スキルごとの集計（パターン数・演習数） ==='
SELECT
  s.id,
  s.display_name,
  COUNT(DISTINCT p.id) AS pattern_count,
  COUNT(DISTINCT e.id) AS exercise_count
FROM skills s
LEFT JOIN patterns p ON p.skill_id = s.id
LEFT JOIN exercises e ON e.pattern_id = p.id
GROUP BY s.id, s.display_name, s.sort_order
ORDER BY s.sort_order;

\echo '=== 1.3 孤立パターン（スキルに紐づかない） ==='
SELECT p.id, p.display_name
FROM patterns p
LEFT JOIN skills s ON s.id = p.skill_id
WHERE s.id IS NULL;

\echo '=== 1.4 孤立演習（パターンに紐づかない） ==='
SELECT e.id, e.question_text
FROM exercises e
LEFT JOIN patterns p ON p.id = e.pattern_id
WHERE p.id IS NULL;

\echo '=== 1.5 例題の1:1関係（パターンごとに1例題） ==='
SELECT
  p.id AS pattern_id,
  p.display_name,
  COUNT(ex.id) AS example_count,
  CASE WHEN COUNT(ex.id) = 1 THEN 'OK' ELSE 'NG' END AS status
FROM patterns p
LEFT JOIN examples ex ON ex.pattern_id = p.id
GROUP BY p.id, p.display_name, p.sort_order
ORDER BY p.sort_order;

\echo '=== 1.6 例題ステップの有無 ==='
SELECT
  ex.id AS example_id,
  p.display_name AS pattern,
  COUNT(es.id) AS step_count
FROM examples ex
JOIN patterns p ON p.id = ex.pattern_id
LEFT JOIN example_steps es ON es.example_id = ex.id
GROUP BY ex.id, p.display_name, p.sort_order
ORDER BY p.sort_order;

\echo '=== 1.7 スキル依存関係 ==='
SELECT
  sd.prerequisite_id,
  s1.display_name AS prerequisite,
  sd.dependent_id,
  s2.display_name AS dependent,
  sd.dependency_type
FROM skill_dependencies sd
JOIN skills s1 ON s1.id = sd.prerequisite_id
JOIN skills s2 ON s2.id = sd.dependent_id;


-- =========================
-- 2. テンプレート別子テーブルの整合性
-- =========================

\echo '=== 2.1 SELECT系演習 → choices の有無 ==='
SELECT
  e.id,
  e.input_template,
  COUNT(c.id) AS choice_count,
  SUM(CASE WHEN c.is_correct THEN 1 ELSE 0 END) AS correct_count,
  CASE
    WHEN COUNT(c.id) >= 2 AND SUM(CASE WHEN c.is_correct THEN 1 ELSE 0 END) >= 1
    THEN 'OK'
    ELSE 'NG'
  END AS status
FROM exercises e
LEFT JOIN exercise_choices c ON c.exercise_id = e.id
WHERE e.input_template IN ('SELECT_BASIC', 'SELECT_MULTI')
GROUP BY e.id, e.input_template, e.sort_order
ORDER BY e.id;

\echo '=== 2.2 TEXT系演習 → answers の有無 ==='
SELECT
  e.id,
  e.input_template,
  COUNT(a.id) AS answer_count,
  SUM(CASE WHEN a.is_primary THEN 1 ELSE 0 END) AS primary_count,
  CASE
    WHEN COUNT(a.id) >= 1 AND SUM(CASE WHEN a.is_primary THEN 1 ELSE 0 END) >= 1
    THEN 'OK'
    ELSE 'NG'
  END AS status
FROM exercises e
LEFT JOIN exercise_answers a ON a.exercise_id = e.id
WHERE e.input_template IN ('TEXT_NUMERIC', 'TEXT_EXPRESSION', 'TEXT_SET')
GROUP BY e.id, e.input_template, e.sort_order
ORDER BY e.id;

\echo '=== 2.3 SELECT系にanswersが混入していないか ==='
SELECT e.id, e.input_template, 'answers混入' AS problem
FROM exercises e
JOIN exercise_answers a ON a.exercise_id = e.id
WHERE e.input_template IN ('SELECT_BASIC', 'SELECT_MULTI');

\echo '=== 2.4 TEXT系にchoicesが混入していないか ==='
SELECT e.id, e.input_template, 'choices混入' AS problem
FROM exercises e
JOIN exercise_choices c ON c.exercise_id = e.id
WHERE e.input_template IN ('TEXT_NUMERIC', 'TEXT_EXPRESSION', 'TEXT_SET');

\echo '=== 2.5 ディストラクター設計意図（SELECT系の不正解選択肢） ==='
SELECT
  e.id AS exercise_id,
  c.choice_label,
  c.choice_expr,
  c.is_correct,
  COALESCE(c.distractor_note, '(正解)') AS distractor_note
FROM exercise_choices c
JOIN exercises e ON e.id = c.exercise_id
ORDER BY e.id, c.sort_order;


-- =========================
-- 3. ビューの動作検証
-- =========================

\echo '=== 3.1 v_class_skill_accuracy（データなし→空が正常） ==='
SELECT * FROM v_class_skill_accuracy LIMIT 5;

\echo '=== 3.2 v_assignment_progress（データなし→空が正常） ==='
SELECT * FROM v_assignment_progress LIMIT 5;

\echo '=== 3.3 v_student_weak_skills（データなし→空が正常） ==='
SELECT * FROM v_student_weak_skills LIMIT 5;

\echo '=== 3.4 v_monthly_grading_cost（データなし→空が正常） ==='
SELECT * FROM v_monthly_grading_cost LIMIT 5;


-- =========================
-- 4. 総合サマリー
-- =========================

\echo '=== 4. 総合レコード数サマリー ==='
SELECT
  (SELECT COUNT(*) FROM skills) AS skills,
  (SELECT COUNT(*) FROM skill_dependencies) AS dependencies,
  (SELECT COUNT(*) FROM patterns) AS patterns,
  (SELECT COUNT(*) FROM examples) AS examples,
  (SELECT COUNT(*) FROM example_steps) AS example_steps,
  (SELECT COUNT(*) FROM exercises) AS exercises,
  (SELECT COUNT(*) FROM exercise_choices) AS choices,
  (SELECT COUNT(*) FROM exercise_answers) AS answers,
  (SELECT COUNT(*) FROM exercise_rubrics) AS rubrics;
