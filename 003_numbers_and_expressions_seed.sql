-- ============================================================
-- シードデータ: 数と式ユニット（数学I）
-- 5スキル / 20パターン / 20例題 / 55演習
-- ============================================================

BEGIN;

-- =========================
-- Skills（5スキル）
-- =========================

INSERT INTO skills (id, subject, unit_name, subunit_name, display_name, description, sort_order) VALUES
  ('poly_add_sub',   'math_1', '数と式', '整式の加法・減法',   '整式の加法・減法',   '同類項の整理、多項式の加法・減法',           1),
  ('poly_expand',    'math_1', '数と式', '整式の乗法（展開）', '整式の乗法（展開）', '分配法則、乗法公式による展開',               2),
  ('factoring',      'math_1', '数と式', '因数分解',          '因数分解',          '共通因数・公式・たすきがけによる因数分解',     3),
  ('real_numbers',   'math_1', '数と式', '実数と根号',        '実数と根号',        '根号の計算、有理化、実数の分類',             4),
  ('linear_ineq',    'math_1', '数と式', '1次不等式',         '1次不等式',         '1次不等式・連立不等式の解法',                5);

-- =========================
-- スキル依存関係
-- =========================

INSERT INTO skill_dependencies (prerequisite_id, dependent_id, dependency_type) VALUES
  ('poly_add_sub',  'poly_expand',   'required'),
  ('poly_expand',   'factoring',     'required'),
  ('real_numbers',  'factoring',     'recommended'),
  ('poly_add_sub',  'linear_ineq',   'required');


-- =========================================================
-- スキル1: poly_add_sub（整式の加法・減法）
-- 3パターン / 3例題 / 7演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('pas__like_terms',  'poly_add_sub', '同類項の整理',   '同類項をまとめて整理する',     0),
  ('pas__addition',    'poly_add_sub', '多項式の加法',   '2つの多項式の和',             1),
  ('pas__subtraction', 'poly_add_sub', '多項式の減法',   '2つの多項式の差（符号反転）',  2);

-- ----- pas__like_terms -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_pas__like_terms', 'pas__like_terms',
   '次の式を同類項をまとめて整理せよ。$$3x^2 + 5x - 2x^2 + 4 - 3x + 1$$',
   '3x^2 + 5x - 2x^2 + 4 - 3x + 1',
   '$x^2 + 2x + 5$',
   '同じ文字の同じ次数の項（同類項）をまとめる。係数だけを計算する。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_pas__like_terms', 1, 'x²の項をまとめる', '3x^2 - 2x^2 = x^2',   '係数: $3 - 2 = 1$'),
  ('ex_pas__like_terms', 2, 'xの項をまとめる',  '5x - 3x = 2x',         '係数: $5 - 3 = 2$'),
  ('ex_pas__like_terms', 3, '定数項をまとめる',  '4 + 1 = 5',            NULL),
  ('ex_pas__like_terms', 4, '結果',            'x^2 + 2x + 5',         '次数の高い順に並べる');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pas_lt_01', 'pas__like_terms', 0, 'SELECT_BASIC', 1,
   '$4a + 3b - 2a + b$ を整理するとどれか。',
   '4a + 3b - 2a + b',
   '$a$ の項: $4a - 2a = 2a$。$b$ の項: $3b + b = 4b$。答え: $2a + 4b$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_pas_lt_01', 'A', '2a + 4b', true,  NULL, 0),
  ('drill_pas_lt_01', 'B', '6a + 4b', false, '減法を加法と間違え: 4a+2a=6a', 1),
  ('drill_pas_lt_01', 'C', '2a + 2b', false, 'bの係数でも引き算: 3b-b=2b', 2),
  ('drill_pas_lt_01', 'D', '6ab',     false, '異なる文字の項を掛け算で結合', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pas_lt_02', 'pas__like_terms', 1, 'TEXT_EXPRESSION', 2,
   '次の式を整理せよ。$$5x^2 - 3x + 2 - 2x^2 + 7x - 4$$',
   '5x^2 - 3x + 2 - 2x^2 + 7x - 4',
   '$x^2$ の項: $5 - 2 = 3$。$x$ の項: $-3 + 7 = 4$。定数項: $2 - 4 = -2$。答え: $3x^2 + 4x - 2$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pas_lt_02', '3x^2 + 4x - 2', '3x^2+4x-2', true,  '模範解答'),
  ('drill_pas_lt_02', '3x^2+4x-2',     '3x^2+4x-2', false, 'スペースなし');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pas_lt_03', 'pas__like_terms', 2, 'TEXT_EXPRESSION', 2,
   '次の式を整理せよ。$$2xy - 3x^2 + 5xy + x^2 - 4$$',
   '2xy - 3x^2 + 5xy + x^2 - 4',
   '$x^2$ の項: $-3 + 1 = -2$。$xy$ の項: $2 + 5 = 7$。答え: $-2x^2 + 7xy - 4$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pas_lt_03', '-2x^2 + 7xy - 4', '-2x^2+7xy-4', true,  '模範解答');

-- ----- pas__addition -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_pas__addition', 'pas__addition',
   '$(2x^2 + 3x - 1) + (x^2 - 5x + 4)$ を計算せよ。',
   '(2x^2 + 3x - 1) + (x^2 - 5x + 4)',
   '$3x^2 - 2x + 3$',
   '加法ではそのまま括弧を外して同類項をまとめる。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_pas__addition', 1, '括弧を外す', '2x^2 + 3x - 1 + x^2 - 5x + 4', '加法なので符号はそのまま'),
  ('ex_pas__addition', 2, '同類項をまとめる', '3x^2 - 2x + 3', NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pas_add_01', 'pas__addition', 0, 'SELECT_BASIC', 1,
   '$(3a + 2b) + (a - 4b)$ はどれか。',
   '(3a + 2b) + (a - 4b)',
   '括弧を外して $3a + 2b + a - 4b = 4a - 2b$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_pas_add_01', 'A', '4a - 2b', true,  NULL, 0),
  ('drill_pas_add_01', 'B', '4a + 6b', false, '引き算を忘れ: 2b+4b=6b', 1),
  ('drill_pas_add_01', 'C', '2a - 2b', false, 'aの計算ミス: 3a-a=2a', 2),
  ('drill_pas_add_01', 'D', '4a - 6b', false, 'bの符号ミス: 2b-4b の計算を -6b', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pas_add_02', 'pas__addition', 1, 'TEXT_EXPRESSION', 2,
   '$(x^2 - 4x + 3) + (2x^2 + x - 7)$ を計算せよ。',
   '(x^2 - 4x + 3) + (2x^2 + x - 7)',
   '$x^2 + 2x^2 = 3x^2$、$-4x + x = -3x$、$3 - 7 = -4$。答え: $3x^2 - 3x - 4$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pas_add_02', '3x^2 - 3x - 4', '3x^2-3x-4', true, '模範解答');

-- ----- pas__subtraction -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_pas__subtraction', 'pas__subtraction',
   '$(3x^2 + 2x - 5) - (x^2 - 4x + 1)$ を計算せよ。',
   '(3x^2 + 2x - 5) - (x^2 - 4x + 1)',
   '$2x^2 + 6x - 6$',
   '減法では引く方の括弧内の各項の符号を反転させてから同類項をまとめる。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_pas__subtraction', 1, '符号を反転して括弧を外す', '3x^2 + 2x - 5 - x^2 + 4x - 1', '引く多項式の各項の符号が変わる'),
  ('ex_pas__subtraction', 2, '同類項をまとめる', '2x^2 + 6x - 6', NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pas_sub_01', 'pas__subtraction', 0, 'SELECT_BASIC', 1,
   '$(5a - 3b) - (2a - b)$ はどれか。',
   '(5a - 3b) - (2a - b)',
   '符号反転: $5a - 3b - 2a + b = 3a - 2b$。$-(-b) = +b$ に注意。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_pas_sub_01', 'A', '3a - 2b', true,  NULL, 0),
  ('drill_pas_sub_01', 'B', '3a - 4b', false, '符号反転忘れ: -3b-b=-4b', 1),
  ('drill_pas_sub_01', 'C', '7a - 4b', false, '加法と混同: 5a+2a=7a', 2),
  ('drill_pas_sub_01', 'D', '3a + 2b', false, 'b項の符号をすべて逆に', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pas_sub_02', 'pas__subtraction', 1, 'TEXT_EXPRESSION', 2,
   '$(4x^2 - x + 6) - (x^2 + 3x - 2)$ を計算せよ。',
   '(4x^2 - x + 6) - (x^2 + 3x - 2)',
   '$4x^2 - x + 6 - x^2 - 3x + 2 = 3x^2 - 4x + 8$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pas_sub_02', '3x^2 - 4x + 8', '3x^2-4x+8', true, '模範解答');


-- =========================================================
-- スキル2: poly_expand（整式の乗法・展開）
-- 5パターン / 5例題 / 13演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('pex__distributive',  'poly_expand', '分配法則',            '単項式×多項式、多項式×多項式',  0),
  ('pex__sq_sum',        'poly_expand', '和の平方公式',        '$(a+b)^2 = a^2 + 2ab + b^2$',  1),
  ('pex__sq_diff',       'poly_expand', '差の平方公式',        '$(a-b)^2 = a^2 - 2ab + b^2$',  2),
  ('pex__sum_diff',      'poly_expand', '和と差の積',          '$(a+b)(a-b) = a^2 - b^2$',      3),
  ('pex__xab',           'poly_expand', '$(x+a)(x+b)$ の展開', '$x^2 + (a+b)x + ab$',          4);

-- ----- pex__distributive -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_pex__distributive', 'pex__distributive',
   '$(2x + 3)(x - 4)$ を展開せよ。',
   '(2x + 3)(x - 4)',
   '$2x^2 - 5x - 12$',
   '各項同士を掛けて同類項をまとめる。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_pex__distributive', 1, '分配法則',      '2x \cdot x + 2x \cdot (-4) + 3 \cdot x + 3 \cdot (-4)', '各項同士を掛ける'),
  ('ex_pex__distributive', 2, '各項を計算',    '2x^2 - 8x + 3x - 12', NULL),
  ('ex_pex__distributive', 3, '同類項をまとめ', '2x^2 - 5x - 12', NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_dist_01', 'pex__distributive', 0, 'SELECT_BASIC', 1,
   '$3x(2x - 5)$ を展開するとどれか。',
   '3x(2x - 5)',
   '$3x \cdot 2x = 6x^2$、$3x \cdot (-5) = -15x$。答え: $6x^2 - 15x$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_pex_dist_01', 'A', '6x^2 - 15x', true,  NULL, 0),
  ('drill_pex_dist_01', 'B', '6x^2 - 5x',  false, '係数を掛け忘れ: 3×5=15なのに5のまま', 1),
  ('drill_pex_dist_01', 'C', '5x^2 - 15x',  false, '次数ミス: 3x·2x で係数を足す', 2),
  ('drill_pex_dist_01', 'D', '6x - 15',     false, 'xの次数を忘れ: x·xをxのまま', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_dist_02', 'pex__distributive', 1, 'TEXT_EXPRESSION', 2,
   '$(x + 2)(3x - 1)$ を展開せよ。',
   '(x + 2)(3x - 1)',
   '$3x^2 - x + 6x - 2 = 3x^2 + 5x - 2$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pex_dist_02', '3x^2 + 5x - 2', '3x^2+5x-2', true, '模範解答');

-- ----- pex__sq_sum -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_pex__sq_sum', 'pex__sq_sum',
   '$(x + 5)^2$ を展開せよ。',
   '(x + 5)^2',
   '$x^2 + 10x + 25$',
   '$(a+b)^2 = a^2 + 2ab + b^2$。中央の $2ab$ を忘れやすい。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_pex__sq_sum', 1, '公式適用', 'a = x,\; b = 5', '$a = x$, $b = 5$'),
  ('ex_pex__sq_sum', 2, '展開',    'x^2 + 2 \cdot x \cdot 5 + 5^2 = x^2 + 10x + 25', NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_ss_01', 'pex__sq_sum', 0, 'SELECT_BASIC', 1,
   '$(x + 3)^2$ を展開するとどれか。',
   '(x + 3)^2',
   '$(x+3)^2 = x^2 + 2 \cdot 3 \cdot x + 9 = x^2 + 6x + 9$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_pex_ss_01', 'A', 'x^2 + 6x + 9', true,  NULL, 0),
  ('drill_pex_ss_01', 'B', 'x^2 + 9',       false, '2abの項を忘れる（最頻出ミス）', 1),
  ('drill_pex_ss_01', 'C', 'x^2 + 3x + 9',  false, '2abの2を忘れ: 2·3=6なのに3', 2),
  ('drill_pex_ss_01', 'D', 'x^2 + 6x + 6',  false, 'b²の計算ミス: 3²=9なのに3+3=6', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_ss_02', 'pex__sq_sum', 1, 'TEXT_EXPRESSION', 2,
   '$(2x + 3)^2$ を展開せよ。',
   '(2x + 3)^2',
   '$(2x)^2 + 2 \cdot 2x \cdot 3 + 3^2 = 4x^2 + 12x + 9$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pex_ss_02', '4x^2 + 12x + 9', '4x^2+12x+9', true, '模範解答');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_ss_03', 'pex__sq_sum', 2, 'TEXT_EXPRESSION', 3,
   '$(3a + 2b)^2$ を展開せよ。',
   '(3a + 2b)^2',
   '$(3a)^2 + 2 \cdot 3a \cdot 2b + (2b)^2 = 9a^2 + 12ab + 4b^2$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pex_ss_03', '9a^2 + 12ab + 4b^2', '9a^2+12ab+4b^2', true, '模範解答');

-- ----- pex__sq_diff -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_pex__sq_diff', 'pex__sq_diff',
   '$(x - 4)^2$ を展開せよ。',
   '(x - 4)^2',
   '$x^2 - 8x + 16$',
   '$(a-b)^2 = a^2 - 2ab + b^2$。最後の $b^2$ は常に正。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_pex__sq_diff', 1, '公式適用', 'a = x,\; b = 4', NULL),
  ('ex_pex__sq_diff', 2, '展開',    'x^2 - 2 \cdot 4 \cdot x + 16 = x^2 - 8x + 16', '$b^2 = 16$ は正');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_sd_01', 'pex__sq_diff', 0, 'SELECT_BASIC', 1,
   '$(x - 6)^2$ を展開するとどれか。',
   '(x - 6)^2',
   '$x^2 - 12x + 36$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_pex_sd_01', 'A', 'x^2 - 12x + 36', true,  NULL, 0),
  ('drill_pex_sd_01', 'B', 'x^2 - 12x - 36', false, 'b²の符号ミス: +36を-36にする', 1),
  ('drill_pex_sd_01', 'C', 'x^2 + 36',        false, '2abの項を忘れる', 2),
  ('drill_pex_sd_01', 'D', 'x^2 - 6x + 36',   false, '2abの2を忘れ', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_sd_02', 'pex__sq_diff', 1, 'TEXT_EXPRESSION', 2,
   '$(3x - 2)^2$ を展開せよ。',
   '(3x - 2)^2',
   '$(3x)^2 - 2 \cdot 3x \cdot 2 + 2^2 = 9x^2 - 12x + 4$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pex_sd_02', '9x^2 - 12x + 4', '9x^2-12x+4', true, '模範解答');

-- ----- pex__sum_diff -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_pex__sum_diff', 'pex__sum_diff',
   '$(x + 7)(x - 7)$ を展開せよ。',
   '(x + 7)(x - 7)',
   '$x^2 - 49$',
   '$(a+b)(a-b) = a^2 - b^2$。結果は2項だけになる。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_pex__sum_diff', 1, '公式適用', 'a = x,\; b = 7', NULL),
  ('ex_pex__sum_diff', 2, '展開',    'x^2 - 49',        '$x$ の項は打ち消し合う');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_sdp_01', 'pex__sum_diff', 0, 'SELECT_BASIC', 1,
   '$(x + 4)(x - 4)$ を展開するとどれか。',
   '(x + 4)(x - 4)',
   '$x^2 - 16$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_pex_sdp_01', 'A', 'x^2 - 16',      true,  NULL, 0),
  ('drill_pex_sdp_01', 'B', 'x^2 + 16',      false, '符号ミス: a²-b²なのにa²+b²', 1),
  ('drill_pex_sdp_01', 'C', 'x^2 - 8x - 16', false, '和と差の積ではなく差の平方と混同', 2),
  ('drill_pex_sdp_01', 'D', 'x^2 - 8',        false, 'b²の計算ミス: 4²=16なのに4·2=8', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_sdp_02', 'pex__sum_diff', 1, 'TEXT_EXPRESSION', 2,
   '$(3a + 5b)(3a - 5b)$ を展開せよ。',
   '(3a + 5b)(3a - 5b)',
   '$(3a)^2 - (5b)^2 = 9a^2 - 25b^2$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pex_sdp_02', '9a^2 - 25b^2', '9a^2-25b^2', true, '模範解答');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_sdp_03', 'pex__sum_diff', 2, 'TEXT_NUMERIC', 2,
   '$(x + 3)(x - 3) - (x - 1)^2$ を計算し、$x = 5$ のときの値を求めよ。',
   '(x + 3)(x - 3) - (x - 1)^2',
   '$(x^2 - 9) - (x^2 - 2x + 1) = 2x - 10$。$x = 5$ のとき $2 \cdot 5 - 10 = 0$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pex_sdp_03', '0', '0', true, '模範解答');

-- ----- pex__xab -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_pex__xab', 'pex__xab',
   '$(x + 3)(x + 5)$ を展開せよ。',
   '(x + 3)(x + 5)',
   '$x^2 + 8x + 15$',
   '$(x+a)(x+b) = x^2 + (a+b)x + ab$。$x$ の係数は和、定数項は積。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_pex__xab', 1, '公式適用', 'a = 3,\; b = 5',              NULL),
  ('ex_pex__xab', 2, '和と積',  'a + b = 8,\; ab = 15',         NULL),
  ('ex_pex__xab', 3, '展開',    'x^2 + 8x + 15',                NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_xab_01', 'pex__xab', 0, 'SELECT_BASIC', 1,
   '$(x + 2)(x + 6)$ を展開するとどれか。',
   '(x + 2)(x + 6)',
   '和 $2 + 6 = 8$、積 $2 \times 6 = 12$。答え: $x^2 + 8x + 12$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_pex_xab_01', 'A', 'x^2 + 8x + 12', true,  NULL, 0),
  ('drill_pex_xab_01', 'B', 'x^2 + 8x + 8',  false, '積ではなく和を定数項に: 2+6=8', 1),
  ('drill_pex_xab_01', 'C', 'x^2 + 12x + 8',  false, '和と積を逆にした', 2),
  ('drill_pex_xab_01', 'D', 'x^2 + 2x + 12',  false, 'xの係数にaだけ使用', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_xab_02', 'pex__xab', 1, 'TEXT_EXPRESSION', 2,
   '$(x - 3)(x + 7)$ を展開せよ。',
   '(x - 3)(x + 7)',
   '$a = -3, b = 7$。和: $-3 + 7 = 4$。積: $(-3) \times 7 = -21$。答え: $x^2 + 4x - 21$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pex_xab_02', 'x^2 + 4x - 21', 'x^2+4x-21', true, '模範解答');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_pex_xab_03', 'pex__xab', 2, 'TEXT_EXPRESSION', 2,
   '$(x - 4)(x - 9)$ を展開せよ。',
   '(x - 4)(x - 9)',
   '和: $-4 + (-9) = -13$。積: $(-4)(-9) = 36$。答え: $x^2 - 13x + 36$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_pex_xab_03', 'x^2 - 13x + 36', 'x^2-13x+36', true, '模範解答');


-- =========================================================
-- スキル3: factoring（因数分解）
-- 5パターン / 5例題 / 13演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('fct__common',     'factoring', '共通因数のくくり出し',         'まず共通因数を探す',                  0),
  ('fct__xab_type',   'factoring', '$x^2+(a+b)x+ab$ 型',         '和と積から因数分解',                  1),
  ('fct__perfect_sq',  'factoring', '平方の公式の逆',             '$a^2 \pm 2ab + b^2$ の因数分解',      2),
  ('fct__diff_sq',     'factoring', '$a^2 - b^2$ 型',            '和と差の積の逆',                      3),
  ('fct__cross',       'factoring', 'たすきがけ',                '$ax^2 + bx + c$ の因数分解',           4);

-- ----- fct__common -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_fct__common', 'fct__common',
   '$6x^2y - 9xy^2 + 3xy$ を因数分解せよ。',
   '6x^2y - 9xy^2 + 3xy',
   '$3xy(2x - 3y + 1)$',
   '因数分解の第一歩は共通因数のくくり出し。係数の最大公約数と共通する文字の最低次をくくる。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_fct__common', 1, '共通因数を見つける', '\gcd(6, 9, 3) = 3,\; \text{共通文字} = xy', '係数のGCDは3、文字はxyが共通'),
  ('ex_fct__common', 2, 'くくり出す',        '3xy(2x - 3y + 1)',                           NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_com_01', 'fct__common', 0, 'SELECT_BASIC', 1,
   '$4a^2b + 8ab^2$ を因数分解するとどれか。',
   '4a^2b + 8ab^2',
   '共通因数: $4ab$。$4ab(a + 2b)$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_fct_com_01', 'A', '4ab(a + 2b)',  true,  NULL, 0),
  ('drill_fct_com_01', 'B', '4ab(a + 8b)',  false, '8÷4=2を忘れて8bのまま', 1),
  ('drill_fct_com_01', 'C', '2ab(2a + 4b)', false, '共通因数を最大限くくれていない', 2),
  ('drill_fct_com_01', 'D', '4a^2b^2(1 + 2)', false, '文字のくくり方を間違い', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_com_02', 'fct__common', 1, 'TEXT_EXPRESSION', 2,
   '$12x^3 - 8x^2 + 4x$ を因数分解せよ。',
   '12x^3 - 8x^2 + 4x',
   '共通因数: $4x$。$4x(3x^2 - 2x + 1)$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_fct_com_02', '4x(3x^2 - 2x + 1)', '4x(3x^2-2x+1)', true, '模範解答');

-- ----- fct__xab_type -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_fct__xab_type', 'fct__xab_type',
   '$x^2 + 7x + 12$ を因数分解せよ。',
   'x^2 + 7x + 12',
   '$(x + 3)(x + 4)$',
   '和が $7$、積が $12$ となる2数を探す → $3$ と $4$。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_fct__xab_type', 1, '2数を探す', 'a + b = 7,\; ab = 12', '$3 + 4 = 7$、$3 \times 4 = 12$'),
  ('ex_fct__xab_type', 2, '因数分解',  '(x + 3)(x + 4)',       NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_xab_01', 'fct__xab_type', 0, 'SELECT_BASIC', 1,
   '$x^2 + 5x + 6$ を因数分解するとどれか。',
   'x^2 + 5x + 6',
   '和が $5$、積が $6$ → $2$ と $3$。$(x+2)(x+3)$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_fct_xab_01', 'A', '(x + 2)(x + 3)', true,  NULL, 0),
  ('drill_fct_xab_01', 'B', '(x + 1)(x + 6)', false, '1と6も積は6だが和が7で不一致', 1),
  ('drill_fct_xab_01', 'C', '(x - 2)(x - 3)', false, '符号ミス: 和が+5なのに両方負', 2),
  ('drill_fct_xab_01', 'D', '(x + 2)(x + 6)', false, '積を5+6=11にしてしまう', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_xab_02', 'fct__xab_type', 1, 'TEXT_EXPRESSION', 2,
   '$x^2 - 3x - 18$ を因数分解せよ。',
   'x^2 - 3x - 18',
   '和が $-3$、積が $-18$ → $3$ と $-6$。$(x + 3)(x - 6)$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_fct_xab_02', '(x + 3)(x - 6)', '(x+3)(x-6)', true,  '模範解答'),
  ('drill_fct_xab_02', '(x - 6)(x + 3)', '(x-6)(x+3)', false, '順序逆も正解');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_xab_03', 'fct__xab_type', 2, 'TEXT_EXPRESSION', 2,
   '$x^2 - 11x + 24$ を因数分解せよ。',
   'x^2 - 11x + 24',
   '和が $-11$、積が $24$ → $-3$ と $-8$。$(x - 3)(x - 8)$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_fct_xab_03', '(x - 3)(x - 8)', '(x-3)(x-8)', true,  '模範解答'),
  ('drill_fct_xab_03', '(x - 8)(x - 3)', '(x-8)(x-3)', false, '順序逆');

-- ----- fct__perfect_sq -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_fct__perfect_sq', 'fct__perfect_sq',
   '$x^2 + 10x + 25$ を因数分解せよ。',
   'x^2 + 10x + 25',
   '$(x + 5)^2$',
   '$a^2 + 2ab + b^2 = (a+b)^2$。$25 = 5^2$ かつ $10 = 2 \cdot 5$ を確認する。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_fct__perfect_sq', 1, '完全平方の確認', '25 = 5^2,\; 10 = 2 \cdot 1 \cdot 5', '定数項が平方数で、中央の項が $2ab$'),
  ('ex_fct__perfect_sq', 2, '因数分解',      '(x + 5)^2',                           NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_psq_01', 'fct__perfect_sq', 0, 'SELECT_BASIC', 1,
   '$x^2 - 8x + 16$ を因数分解するとどれか。',
   'x^2 - 8x + 16',
   '$16 = 4^2$、$8 = 2 \cdot 4$。$(x - 4)^2$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_fct_psq_01', 'A', '(x - 4)^2',       true,  NULL, 0),
  ('drill_fct_psq_01', 'B', '(x + 4)^2',       false, '符号ミス: -8xなのに+4', 1),
  ('drill_fct_psq_01', 'C', '(x - 4)(x + 4)',  false, '和と差の積と混同', 2),
  ('drill_fct_psq_01', 'D', '(x - 2)(x - 8)',  false, 'xab型と混同: 2+8=10≠8', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_psq_02', 'fct__perfect_sq', 1, 'TEXT_EXPRESSION', 2,
   '$9x^2 + 12x + 4$ を因数分解せよ。',
   '9x^2 + 12x + 4',
   '$9x^2 = (3x)^2$、$4 = 2^2$、$12x = 2 \cdot 3x \cdot 2$。$(3x + 2)^2$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_fct_psq_02', '(3x + 2)^2', '(3x+2)^2', true, '模範解答');

-- ----- fct__diff_sq -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_fct__diff_sq', 'fct__diff_sq',
   '$x^2 - 25$ を因数分解せよ。',
   'x^2 - 25',
   '$(x + 5)(x - 5)$',
   '$a^2 - b^2 = (a+b)(a-b)$。2つの平方の差を見つける。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_fct__diff_sq', 1, '平方の差を確認', 'x^2 = x^2,\; 25 = 5^2', '両方とも平方数'),
  ('ex_fct__diff_sq', 2, '因数分解',      '(x + 5)(x - 5)',         NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_dsq_01', 'fct__diff_sq', 0, 'SELECT_BASIC', 1,
   '$4x^2 - 9$ を因数分解するとどれか。',
   '4x^2 - 9',
   '$4x^2 = (2x)^2$、$9 = 3^2$。$(2x + 3)(2x - 3)$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_fct_dsq_01', 'A', '(2x + 3)(2x - 3)', true,  NULL, 0),
  ('drill_fct_dsq_01', 'B', '(4x + 9)(4x - 9)', false, '平方根を取り忘れ', 1),
  ('drill_fct_dsq_01', 'C', '(2x - 3)^2',        false, '差の平方と混同', 2),
  ('drill_fct_dsq_01', 'D', '(2x + 3)^2',        false, '和の平方と混同', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_dsq_02', 'fct__diff_sq', 1, 'TEXT_EXPRESSION', 2,
   '$x^4 - 16$ を因数分解せよ。',
   'x^4 - 16',
   '$x^4 = (x^2)^2$、$16 = 4^2$。$(x^2 + 4)(x^2 - 4) = (x^2 + 4)(x + 2)(x - 2)$。さらに因数分解できないか常に確認する。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_fct_dsq_02', '(x^2 + 4)(x + 2)(x - 2)', '(x^2+4)(x+2)(x-2)', true,  '完全に因数分解'),
  ('drill_fct_dsq_02', '(x^2 + 4)(x^2 - 4)',       '(x^2+4)(x^2-4)',    false, '途中段階（部分点対象）');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_dsq_03', 'fct__diff_sq', 2, 'TEXT_EXPRESSION', 3,
   '$25a^2 - 36b^2$ を因数分解せよ。',
   '25a^2 - 36b^2',
   '$(5a)^2 - (6b)^2 = (5a + 6b)(5a - 6b)$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_fct_dsq_03', '(5a + 6b)(5a - 6b)', '(5a+6b)(5a-6b)', true, '模範解答');

-- ----- fct__cross -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_fct__cross', 'fct__cross',
   '$2x^2 + 7x + 3$ を因数分解せよ。',
   '2x^2 + 7x + 3',
   '$(2x + 1)(x + 3)$',
   '$ax^2 + bx + c$ で $a \neq 1$ のとき、たすきがけで因数分解する。$a$ と $c$ の因数の組を試す。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_fct__cross', 1, 'aとcの因数', '2 = 2 \times 1,\; 3 = 3 \times 1', NULL),
  ('ex_fct__cross', 2, 'たすきがけ',  '2 \times 3 + 1 \times 1 = 7',      'クロスの和が $b = 7$ に一致'),
  ('ex_fct__cross', 3, '因数分解',   '(2x + 1)(x + 3)',                   NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_crs_01', 'fct__cross', 0, 'SELECT_BASIC', 2,
   '$3x^2 + 10x + 3$ を因数分解するとどれか。',
   '3x^2 + 10x + 3',
   '$3 = 3 \times 1$、$3 = 3 \times 1$。たすきがけ: $3 \times 3 + 1 \times 1 = 10$。$(3x + 1)(x + 3)$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_fct_crs_01', 'A', '(3x + 1)(x + 3)', true,  NULL, 0),
  ('drill_fct_crs_01', 'B', '(3x + 3)(x + 1)', false, 'たすきがけの組み合わせ違い: 3·1+3·1=6≠10', 1),
  ('drill_fct_crs_01', 'C', '(x + 1)(x + 3)',   false, '係数3を無視', 2),
  ('drill_fct_crs_01', 'D', '3(x + 1)(x + 3)',  false, '共通因数くくり出しと混同: 展開すると3x²+12x+9', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_fct_crs_02', 'fct__cross', 1, 'TEXT_EXPRESSION', 3,
   '$6x^2 - 7x - 3$ を因数分解せよ。',
   '6x^2 - 7x - 3',
   '$6 = 2 \times 3$、$-3 = 1 \times (-3)$。たすきがけ: $2 \times (-3) + 3 \times 1 = -3$…不一致。$2 \times 1 + 3 \times (-3) = -7$。$(2x - 3)(3x + 1)$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_fct_crs_02', '(2x - 3)(3x + 1)', '(2x-3)(3x+1)', true,  '模範解答'),
  ('drill_fct_crs_02', '(3x + 1)(2x - 3)', '(3x+1)(2x-3)', false, '順序逆');


-- =========================================================
-- スキル4: real_numbers（実数と根号）
-- 4パターン / 4例題 / 11演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('rn__simplify',     'real_numbers', '根号の簡略化',         '$\sqrt{a}$ の簡略化',              0),
  ('rn__rationalize',  'real_numbers', '分母の有理化',         '分母の根号を消す',                  1),
  ('rn__expand',       'real_numbers', '根号を含む式の展開',    '乗法公式の適用',                   2),
  ('rn__classify',     'real_numbers', '実数の分類',           '有理数・無理数の判定',              3);

-- ----- rn__simplify -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_rn__simplify', 'rn__simplify',
   '$\sqrt{48}$ を簡略化せよ。',
   '\sqrt{48}',
   '$4\sqrt{3}$',
   '$\sqrt{a^2 b} = a\sqrt{b}$。根号の中の平方因数をくくり出す。$48 = 16 \times 3 = 4^2 \times 3$。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_rn__simplify', 1, '素因数分解',   '48 = 2^4 \times 3',                   NULL),
  ('ex_rn__simplify', 2, '平方因数を出す', '\sqrt{48} = \sqrt{16 \times 3} = 4\sqrt{3}', NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_rn_simp_01', 'rn__simplify', 0, 'SELECT_BASIC', 1,
   '$\sqrt{72}$ を簡略化するとどれか。',
   '\sqrt{72}',
   '$72 = 36 \times 2 = 6^2 \times 2$。$\sqrt{72} = 6\sqrt{2}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_rn_simp_01', 'A', '6\sqrt{2}', true,  NULL, 0),
  ('drill_rn_simp_01', 'B', '8\sqrt{2}', false, '計算ミス: √72≠8√2（8²·2=128）', 1),
  ('drill_rn_simp_01', 'C', '3\sqrt{8}', false, '不完全な簡略化: √8=2√2なのでさらに簡略化可能', 2),
  ('drill_rn_simp_01', 'D', '36\sqrt{2}', false, '√を外す際に二乗のまま', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_rn_simp_02', 'rn__simplify', 1, 'TEXT_EXPRESSION', 2,
   '$\sqrt{50} + \sqrt{18}$ を計算せよ。',
   '\sqrt{50} + \sqrt{18}',
   '$\sqrt{50} = 5\sqrt{2}$、$\sqrt{18} = 3\sqrt{2}$。$5\sqrt{2} + 3\sqrt{2} = 8\sqrt{2}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_rn_simp_02', '8\sqrt{2}', '8\sqrt{2}', true, '模範解答');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_rn_simp_03', 'rn__simplify', 2, 'TEXT_EXPRESSION', 2,
   '$3\sqrt{12} - \sqrt{27}$ を計算せよ。',
   '3\sqrt{12} - \sqrt{27}',
   '$3\sqrt{12} = 3 \cdot 2\sqrt{3} = 6\sqrt{3}$。$\sqrt{27} = 3\sqrt{3}$。$6\sqrt{3} - 3\sqrt{3} = 3\sqrt{3}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_rn_simp_03', '3\sqrt{3}', '3\sqrt{3}', true, '模範解答');

-- ----- rn__rationalize -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_rn__rationalize', 'rn__rationalize',
   '$\frac{6}{\sqrt{3}}$ の分母を有理化せよ。',
   '\frac{6}{\sqrt{3}}',
   '$2\sqrt{3}$',
   '分母・分子に $\sqrt{3}$ を掛ける。$\frac{a}{\sqrt{b}} = \frac{a\sqrt{b}}{b}$。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_rn__rationalize', 1, '分母分子に√3を掛ける', '\frac{6}{\sqrt{3}} \cdot \frac{\sqrt{3}}{\sqrt{3}} = \frac{6\sqrt{3}}{3}', NULL),
  ('ex_rn__rationalize', 2, '約分',                '2\sqrt{3}',                                                                 NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_rn_rat_01', 'rn__rationalize', 0, 'SELECT_BASIC', 1,
   '$\frac{10}{\sqrt{5}}$ を有理化するとどれか。',
   '\frac{10}{\sqrt{5}}',
   '$\frac{10\sqrt{5}}{5} = 2\sqrt{5}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_rn_rat_01', 'A', '2\sqrt{5}',  true,  NULL, 0),
  ('drill_rn_rat_01', 'B', '10\sqrt{5}', false, '約分忘れ: 10/5=2なのに10のまま', 1),
  ('drill_rn_rat_01', 'C', '\sqrt{50}',  false, '有理化せず: 10/√5 を √(100/5) と変形', 2),
  ('drill_rn_rat_01', 'D', '5\sqrt{2}',  false, '計算ミス', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_rn_rat_02', 'rn__rationalize', 1, 'TEXT_EXPRESSION', 3,
   '$\frac{1}{\sqrt{5} - \sqrt{3}}$ の分母を有理化せよ。',
   '\frac{1}{\sqrt{5} - \sqrt{3}}',
   '分母分子に $\sqrt{5} + \sqrt{3}$ を掛ける。$\frac{\sqrt{5} + \sqrt{3}}{(\sqrt{5})^2 - (\sqrt{3})^2} = \frac{\sqrt{5} + \sqrt{3}}{2}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_rn_rat_02', '\frac{\sqrt{5} + \sqrt{3}}{2}', '\frac{\sqrt{5}+\sqrt{3}}{2}', true, '模範解答');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_rn_rat_03', 'rn__rationalize', 2, 'TEXT_EXPRESSION', 3,
   '$\frac{3}{2 + \sqrt{7}}$ の分母を有理化せよ。',
   '\frac{3}{2 + \sqrt{7}}',
   '分母分子に $2 - \sqrt{7}$ を掛ける。$\frac{3(2 - \sqrt{7})}{4 - 7} = \frac{3(2 - \sqrt{7})}{-3} = -(2 - \sqrt{7}) = \sqrt{7} - 2$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_rn_rat_03', '\sqrt{7} - 2',  '\sqrt{7}-2',  true,  '模範解答'),
  ('drill_rn_rat_03', '-2 + \sqrt{7}', '-2+\sqrt{7}', false, '項の順序違い');

-- ----- rn__expand -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_rn__expand', 'rn__expand',
   '$(\sqrt{3} + \sqrt{2})^2$ を展開せよ。',
   '(\sqrt{3} + \sqrt{2})^2',
   '$5 + 2\sqrt{6}$',
   '$(a+b)^2 = a^2 + 2ab + b^2$ を根号に適用。$\sqrt{3} \cdot \sqrt{2} = \sqrt{6}$。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_rn__expand', 1, '公式適用', '(\sqrt{3})^2 + 2\sqrt{3}\sqrt{2} + (\sqrt{2})^2', NULL),
  ('ex_rn__expand', 2, '計算',    '3 + 2\sqrt{6} + 2 = 5 + 2\sqrt{6}',              NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_rn_exp_01', 'rn__expand', 0, 'SELECT_BASIC', 2,
   '$(\sqrt{5} + 1)(\sqrt{5} - 1)$ の値はどれか。',
   '(\sqrt{5} + 1)(\sqrt{5} - 1)',
   '和と差の積: $(\sqrt{5})^2 - 1^2 = 5 - 1 = 4$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_rn_exp_01', 'A', '4',           true,  NULL, 0),
  ('drill_rn_exp_01', 'B', '6',           false, '5+1=6と加算', 1),
  ('drill_rn_exp_01', 'C', '2\sqrt{5}',   false, '展開を間違え', 2),
  ('drill_rn_exp_01', 'D', '\sqrt{5} - 1', false, '計算せずそのまま', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_rn_exp_02', 'rn__expand', 1, 'TEXT_EXPRESSION', 3,
   '$(2\sqrt{3} - 1)^2$ を展開せよ。',
   '(2\sqrt{3} - 1)^2',
   '$(2\sqrt{3})^2 - 2 \cdot 2\sqrt{3} \cdot 1 + 1^2 = 12 - 4\sqrt{3} + 1 = 13 - 4\sqrt{3}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_rn_exp_02', '13 - 4\sqrt{3}', '13-4\sqrt{3}', true, '模範解答');

-- ----- rn__classify -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_rn__classify', 'rn__classify',
   '次の数を有理数と無理数に分類せよ。$$\sqrt{4},\; \frac{3}{7},\; \sqrt{5},\; 0.333\ldots,\; \pi$$',
   NULL,
   '有理数: $\sqrt{4} = 2$, $\frac{3}{7}$, $0.333\ldots = \frac{1}{3}$。無理数: $\sqrt{5}$, $\pi$。',
   '有理数は $\frac{p}{q}$（$q \neq 0$）の形に表せる数。$\sqrt{n}$ は $n$ が完全平方数でなければ無理数。循環小数は有理数。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_rn__classify', 1, '各数を確認', NULL, '$\sqrt{4} = 2$（整数）、$\sqrt{5}$（完全平方数でない → 無理数）、$0.333\ldots = \frac{1}{3}$（循環小数 → 有理数）');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_rn_cls_01', 'rn__classify', 0, 'SELECT_BASIC', 1,
   '次のうち無理数はどれか。',
   NULL,
   '$\sqrt{9} = 3$（有理数）、$\sqrt{7}$（無理数）、$-\frac{2}{5}$（有理数）、$0.25$（有理数）。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_rn_cls_01', 'A', '\sqrt{7}',        true,  NULL, 0),
  ('drill_rn_cls_01', 'B', '\sqrt{9}',        false, '√がついていれば無理数と思い込み: √9=3', 1),
  ('drill_rn_cls_01', 'C', '-\frac{2}{5}',    false, '負の分数を無理数と混同', 2),
  ('drill_rn_cls_01', 'D', '0.25',            false, '小数を無理数と混同: 0.25=1/4', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_rn_cls_02', 'rn__classify', 1, 'SELECT_BASIC', 2,
   '次のうち有理数であるものをすべて選べ。(1) $\sqrt{16}$　(2) $\sqrt{2}$　(3) $0.\overline{6}$　(4) $\pi$',
   NULL,
   '$\sqrt{16} = 4$（有理数）。$0.\overline{6} = \frac{2}{3}$（有理数）。$\sqrt{2}$, $\pi$ は無理数。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_rn_cls_02', 'A', '(1) と (3)',           true,  NULL, 0),
  ('drill_rn_cls_02', 'B', '(1) のみ',             false, '循環小数が有理数であることを知らない', 1),
  ('drill_rn_cls_02', 'C', '(1) と (2) と (3)',    false, '√2を有理数と誤判定', 2),
  ('drill_rn_cls_02', 'D', '(3) のみ',             false, '√16=4が有理数であることに気づかない', 3);


-- =========================================================
-- スキル5: linear_ineq（1次不等式）
-- 3パターン / 3例題 / 11演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('liq__basic',       'linear_ineq', '基本の1次不等式',     '移項と両辺の除法',                 0),
  ('liq__compound',    'linear_ineq', '連立不等式',          '2つの不等式の共通範囲',             1),
  ('liq__abs_value',   'linear_ineq', '絶対値を含む方程式・不等式', '場合分けまたは定義に基づく解法', 2);

-- ----- liq__basic -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_liq__basic', 'liq__basic',
   '不等式 $3x - 7 > 2x + 5$ を解け。',
   '3x - 7 > 2x + 5',
   '$x > 12$',
   '等式と同様に移項する。ただし負の数で両辺を割ると不等号の向きが逆転する。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_liq__basic', 1, '移項',     '3x - 2x > 5 + 7',  '$x$ の項を左辺、定数項を右辺に'),
  ('ex_liq__basic', 2, '整理',     'x > 12',            NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_liq_bas_01', 'liq__basic', 0, 'SELECT_BASIC', 1,
   '$2x + 3 \leqq 11$ の解はどれか。',
   '2x + 3 \leqq 11',
   '$2x \leqq 8$ → $x \leqq 4$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_liq_bas_01', 'A', 'x \leqq 4',  true,  NULL, 0),
  ('drill_liq_bas_01', 'B', 'x \geqq 4',  false, '不等号の向きを逆に', 1),
  ('drill_liq_bas_01', 'C', 'x \leqq 7',  false, '移項ミス: 11-3ではなく11+3÷2', 2),
  ('drill_liq_bas_01', 'D', 'x < 4',      false, '等号の有無: ≦なのに<', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_liq_bas_02', 'liq__basic', 1, 'TEXT_EXPRESSION', 2,
   '$-3x + 6 < 0$ を解け。',
   '-3x + 6 < 0',
   '$-3x < -6$。$-3$ で割ると不等号が逆転: $x > 2$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_liq_bas_02', 'x > 2', 'x>2', true, '模範解答');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_liq_bas_03', 'liq__basic', 2, 'TEXT_EXPRESSION', 2,
   '$5(x - 2) \geqq 3x + 4$ を解け。',
   '5(x - 2) \geqq 3x + 4',
   '$5x - 10 \geqq 3x + 4$ → $2x \geqq 14$ → $x \geqq 7$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_liq_bas_03', 'x \geqq 7', 'x\geqq7', true, '模範解答');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_liq_bas_04', 'liq__basic', 3, 'TEXT_EXPRESSION', 3,
   '$\frac{2x - 1}{3} > \frac{x + 2}{2}$ を解け。',
   '\frac{2x - 1}{3} > \frac{x + 2}{2}',
   '両辺に $6$ を掛けて $2(2x - 1) > 3(x + 2)$ → $4x - 2 > 3x + 6$ → $x > 8$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_liq_bas_04', 'x > 8', 'x>8', true, '模範解答');

-- ----- liq__compound -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_liq__compound', 'liq__compound',
   '連立不等式 $\begin{cases} x + 3 > 1 \\ 2x - 1 < 5 \end{cases}$ を解け。',
   NULL,
   '$-2 < x < 3$',
   '各不等式を個別に解いてから、共通範囲（数直線上の重なり）を求める。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_liq__compound', 1, '①を解く', 'x > -2',       '$x + 3 > 1$ → $x > -2$'),
  ('ex_liq__compound', 2, '②を解く', 'x < 3',        '$2x - 1 < 5$ → $2x < 6$ → $x < 3$'),
  ('ex_liq__compound', 3, '共通範囲', '-2 < x < 3',   '数直線で重なる部分');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_liq_cmp_01', 'liq__compound', 0, 'SELECT_BASIC', 2,
   '連立不等式 $\begin{cases} 2x - 1 \geqq 3 \\ x + 4 < 9 \end{cases}$ の解はどれか。',
   NULL,
   '①: $x \geqq 2$。②: $x < 5$。共通範囲: $2 \leqq x < 5$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_liq_cmp_01', 'A', '2 \leqq x < 5',   true,  NULL, 0),
  ('drill_liq_cmp_01', 'B', '2 < x < 5',        false, '等号の見落とし: ≧なのに>に', 1),
  ('drill_liq_cmp_01', 'C', 'x \geqq 2',        false, '②の条件を無視', 2),
  ('drill_liq_cmp_01', 'D', '2 \leqq x \leqq 5', false, '②の等号: <なのに≦に', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_liq_cmp_02', 'liq__compound', 1, 'TEXT_EXPRESSION', 3,
   '連立不等式 $\begin{cases} 3x + 2 > -4 \\ 5 - 2x \geqq -3 \end{cases}$ を解け。',
   NULL,
   '①: $3x > -6$ → $x > -2$。②: $-2x \geqq -8$ → $x \leqq 4$。共通範囲: $-2 < x \leqq 4$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_liq_cmp_02', '-2 < x \leqq 4', '-2<x\leqq4', true, '模範解答');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_liq_cmp_03', 'liq__compound', 2, 'TEXT_EXPRESSION', 3,
   '不等式 $-1 \leqq 2x + 3 < 9$ を解け。',
   '-1 \leqq 2x + 3 < 9',
   '各辺から $3$ を引く: $-4 \leqq 2x < 6$。$2$ で割る: $-2 \leqq x < 3$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_liq_cmp_03', '-2 \leqq x < 3', '-2\leqqx<3', true, '模範解答');

-- ----- liq__abs_value -----

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_liq__abs_value', 'liq__abs_value',
   '$\lvert 2x - 3 \rvert < 5$ を解け。',
   '\lvert 2x - 3 \rvert < 5',
   '$-1 < x < 4$',
   '$\lvert A \rvert < k$ ⟺ $-k < A < k$。$\lvert A \rvert > k$ ⟺ $A < -k$ または $A > k$。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_liq__abs_value', 1, '絶対値を外す', '-5 < 2x - 3 < 5',      '$\lvert A \rvert < k$ → $-k < A < k$'),
  ('ex_liq__abs_value', 2, '各辺に3を足す', '-2 < 2x < 8',          NULL),
  ('ex_liq__abs_value', 3, '2で割る',      '-1 < x < 4',            NULL);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_liq_abs_01', 'liq__abs_value', 0, 'SELECT_BASIC', 2,
   '$\lvert x - 1 \rvert \leqq 3$ の解はどれか。',
   '\lvert x - 1 \rvert \leqq 3',
   '$-3 \leqq x - 1 \leqq 3$ → $-2 \leqq x \leqq 4$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_liq_abs_01', 'A', '-2 \leqq x \leqq 4',             true,  NULL, 0),
  ('drill_liq_abs_01', 'B', 'x \leqq -2, x \geqq 4',          false, '<と>の使い分けを逆に: |A|≦kなのに外側', 1),
  ('drill_liq_abs_01', 'C', '-3 \leqq x \leqq 3',             false, '移項忘れ: -1を足さずそのまま', 2),
  ('drill_liq_abs_01', 'D', '-4 \leqq x \leqq 2',             false, '符号ミス: x-1の処理を逆に', 3);

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_liq_abs_02', 'liq__abs_value', 1, 'TEXT_EXPRESSION', 3,
   '$\lvert 3x + 2 \rvert > 7$ を解け。',
   '\lvert 3x + 2 \rvert > 7',
   '$3x + 2 < -7$ または $3x + 2 > 7$。$3x < -9$ または $3x > 5$。$x < -3$ または $x > \frac{5}{3}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_liq_abs_02', 'x < -3, x > \frac{5}{3}',  'x<-3,x>\frac{5}{3}',  true,  '分数表記'),
  ('drill_liq_abs_02', 'x < -3 または x > 5/3',     'x<-3,x>5/3',          false, '日本語表記');

INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_liq_abs_03', 'liq__abs_value', 2, 'TEXT_NUMERIC', 3,
   '方程式 $\lvert x - 4 \rvert = 2x + 1$ の解をすべて求めよ。',
   '\lvert x - 4 \rvert = 2x + 1',
   '場合分け。(i) $x \geqq 4$: $x - 4 = 2x + 1$ → $x = -5$。$x \geqq 4$ を満たさないので不適。(ii) $x < 4$: $-(x - 4) = 2x + 1$ → $-x + 4 = 2x + 1$ → $3 = 3x$ → $x = 1$。$x < 4$ を満たすので適。答え: $x = 1$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_liq_abs_03', 'x = 1', 'x=1', true,  '模範解答'),
  ('drill_liq_abs_03', '1',     '1',   false, '値のみ');


COMMIT;
