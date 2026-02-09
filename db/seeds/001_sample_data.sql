-- ============================================================
-- サンプルデータ: パイロット検証済み2スキル分
-- 高校数学I「整式」単元
-- ============================================================

BEGIN;

-- =========================
-- 1. スキル
-- =========================

INSERT INTO skills (id, subject, unit_name, subunit_name, display_name, description, sort_order) VALUES
('poly_add_sub', 'math_1', '整式', '整式の加法・減法', '整式の加法・減法',
 '多項式の同類項をまとめ、加法・減法を行うスキル。整式計算の基礎となる。', 10),
('poly_expand', 'math_1', '整式', '整式の乗法（展開）', '整式の乗法（展開）',
 '分配法則や乗法公式を用いて整式の積を展開するスキル。', 20);

-- スキル依存関係（展開は加法・減法が前提）
INSERT INTO skill_dependencies (prerequisite_id, dependent_id, dependency_type) VALUES
('poly_add_sub', 'poly_expand', 'required');


-- =========================
-- 2. パターン: 整式の加法・減法（3パターン）
-- =========================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
('poly_add_sub__like_terms',  'poly_add_sub', '同類項の整理',
 '多項式の中から同類項を見つけてまとめる', 1),
('poly_add_sub__addition',    'poly_add_sub', '多項式の加法',
 '2つの多項式の和を求める', 2),
('poly_add_sub__subtraction', 'poly_add_sub', '多項式の減法',
 '2つの多項式の差を求める（符号変換に注意）', 3);

-- =========================
-- 3. 例題: 整式の加法・減法
-- =========================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
('ex_like_terms', 'poly_add_sub__like_terms',
 '次の多項式の同類項をまとめて整理しなさい。',
 '3x^2 + 5x - 2x^2 + 4 - 3x + 1',
 'x^2 + 2x + 5',
 '同じ文字と次数の項（同類項）の係数をまとめる。定数項も忘れずにまとめる。'),

('ex_addition', 'poly_add_sub__addition',
 '次の2つの多項式の和を求めなさい。',
 'A = 2x^2 + 3x - 1, \quad B = x^2 - 5x + 4',
 '3x^2 - 2x + 3',
 '各同類項の係数どうしを加える。A + B = (2+1)x^2 + (3-5)x + (-1+4)'),

('ex_subtraction', 'poly_add_sub__subtraction',
 '次の2つの多項式の差を求めなさい。',
 'A = 3x^2 + 2x - 5, \quad B = x^2 - 4x + 3',
 '2x^2 + 6x - 8',
 '引く多項式の各項の符号を変えてから加える。A - B = A + (-B)');

-- =========================
-- 4. 例題ステップ: 整式の加法・減法
-- =========================

-- 同類項の整理
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_like_terms', 1, 'Step 1: 同類項を見つける',
 '(3x^2 - 2x^2) + (5x - 3x) + (4 + 1)',
 'x²の項、xの項、定数項に分けてグループ化する'),
('ex_like_terms', 2, 'Step 2: 各グループの係数を計算',
 '1 \cdot x^2 + 2x + 5',
 '3-2=1, 5-3=2, 4+1=5'),
('ex_like_terms', 3, 'Step 3: 答え',
 'x^2 + 2x + 5',
 'x²の係数が1の場合は省略できる');

-- 多項式の加法
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_addition', 1, 'Step 1: A + B を書き出す',
 '(2x^2 + 3x - 1) + (x^2 - 5x + 4)',
 'カッコをそのまま並べる'),
('ex_addition', 2, 'Step 2: カッコを外して同類項を整理',
 '(2+1)x^2 + (3-5)x + (-1+4)',
 '加法はカッコを外しても符号が変わらない'),
('ex_addition', 3, 'Step 3: 答え',
 '3x^2 - 2x + 3',
 NULL);

-- 多項式の減法
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_subtraction', 1, 'Step 1: A - B を書き出す',
 '(3x^2 + 2x - 5) - (x^2 - 4x + 3)',
 NULL),
('ex_subtraction', 2, 'Step 2: 引く多項式の符号を変える',
 '3x^2 + 2x - 5 - x^2 + 4x - 3',
 '減法では引く側のカッコを外すとき、各項の符号が反転する（ここが最大のミスポイント）'),
('ex_subtraction', 3, 'Step 3: 同類項をまとめる',
 '(3-1)x^2 + (2+4)x + (-5-3)',
 NULL),
('ex_subtraction', 4, 'Step 4: 答え',
 '2x^2 + 6x - 8',
 NULL);


-- =========================
-- 5. 演習問題: 整式の加法・減法（7問）
-- =========================

-- ===== パターン1: 同類項の整理（3問）=====

-- 問1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_like_terms_01', 'poly_add_sub__like_terms', 1, 'SELECT_BASIC', 1,
 '次の式の同類項をまとめた結果として正しいものを選びなさい。',
 '4x^2 - 3x + 2x^2 + 5x - 1',
 '4x² + 2x² = 6x², -3x + 5x = 2x, 定数項は -1 なので 6x² + 2x - 1');

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
('drill_like_terms_01', 'A', '6x^2 + 2x - 1', true,  NULL, 1),
('drill_like_terms_01', 'B', '6x^2 - 8x - 1', false, 'xの係数を -3-5=-8 と引き算にした誤り', 2),
('drill_like_terms_01', 'C', '2x^2 + 2x - 1', false, 'x²の係数を 4-2=2 と引き算にした誤り', 3),
('drill_like_terms_01', 'D', '6x^2 + 2x + 1', false, '定数項の符号を間違えた誤り', 4);

-- 問2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_like_terms_02', 'poly_add_sub__like_terms', 2, 'TEXT_EXPRESSION', 2,
 '次の式の同類項をまとめて整理しなさい。',
 '5a - 3b + 2a + 7b - 4',
 '5a + 2a = 7a, -3b + 7b = 4b, 定数項 -4 → 7a + 4b - 4');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_like_terms_02', '7a + 4b - 4', '7a+4b-4', true, NULL),
('drill_like_terms_02', '7a + 4b + (-4)', '7a+4b-4', false, 'マイナスを+(-4)と書く表記');

-- 問3: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_like_terms_03', 'poly_add_sub__like_terms', 3, 'TEXT_EXPRESSION', 3,
 '次の式の同類項をまとめて整理しなさい。',
 '2x^2 - 3xy + 5y^2 + 4xy - x^2 + y^2',
 '(2-1)x² = x², (-3+4)xy = xy, (5+1)y² = 6y² → x² + xy + 6y²');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_like_terms_03', 'x^2 + xy + 6y^2', 'x^2+xy+6y^2', true, NULL),
('drill_like_terms_03', 'x^2 + yx + 6y^2', 'x^2+xy+6y^2', false, 'xyとyxは同じ（交換法則）');

-- ===== パターン2: 多項式の加法（2問）=====

-- 問4: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_addition_01', 'poly_add_sub__addition', 1, 'SELECT_BASIC', 1,
 'A + B を計算した結果として正しいものを選びなさい。',
 'A = 3x + 2, \quad B = 5x - 7',
 '(3+5)x + (2-7) = 8x - 5');

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
('drill_addition_01', 'A', '8x - 5',  true,  NULL, 1),
('drill_addition_01', 'B', '8x + 9',  false, '定数項を 2+7=9 とした誤り（-7を+7と読み違い）', 2),
('drill_addition_01', 'C', '-2x - 5', false, 'xの係数を 3-5=-2 とした誤り（加法なのに減法した）', 3),
('drill_addition_01', 'D', '8x - 9',  false, '定数項を 2-7 ではなく -(2+7)=-9 とした誤り', 4);

-- 問5: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_addition_02', 'poly_add_sub__addition', 2, 'TEXT_EXPRESSION', 2,
 'A + B を計算しなさい。',
 'A = x^2 - 4x + 3, \quad B = 2x^2 + x - 5',
 '(1+2)x² + (-4+1)x + (3-5) = 3x² - 3x - 2');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_addition_02', '3x^2 - 3x - 2', '3x^2-3x-2', true, NULL);

-- ===== パターン3: 多項式の減法（2問）=====

-- 問6: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_subtraction_01', 'poly_add_sub__subtraction', 1, 'SELECT_BASIC', 2,
 'A - B を計算した結果として正しいものを選びなさい。',
 'A = 4x^2 + 3x - 1, \quad B = 2x^2 - x + 5',
 'A - B = 4x²+3x-1-2x²+x-5 = 2x²+4x-6');

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
('drill_subtraction_01', 'A', '2x^2 + 4x - 6', true,  NULL, 1),
('drill_subtraction_01', 'B', '2x^2 + 2x + 4',  false, 'Bの符号変換ミス: -(-x)=+xだが3x-x=2x, -(-1)-(+5)を-1+5=4とした', 2),
('drill_subtraction_01', 'C', '6x^2 + 2x + 4',  false, 'x²を加法にした誤り（A-BなのにA+Bをした）', 3),
('drill_subtraction_01', 'D', '2x^2 + 4x + 4',  false, '定数項の符号変換ミス: -1-(+5)=-6 を -1+5=4 とした', 4);

-- 問7: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_subtraction_02', 'poly_add_sub__subtraction', 2, 'TEXT_EXPRESSION', 3,
 'A - B を計算しなさい。',
 'A = 5x^2 - 2x + 3, \quad B = 3x^2 + 4x - 7',
 '5x²-2x+3-3x²-4x+7 = 2x²-6x+10');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_subtraction_02', '2x^2 - 6x + 10', '2x^2-6x+10', true, NULL),
('drill_subtraction_02', '2(x^2 - 3x + 5)', '2x^2-6x+10', false, '因数分解した形');


-- =========================
-- 6. パターン: 整式の乗法（展開）（5パターン）
-- =========================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
('poly_expand__distributive',    'poly_expand', '分配法則',
 '分配法則 a(b+c) = ab + ac を用いた展開', 1),
('poly_expand__square_sum',      'poly_expand', '和の平方公式',
 '(a+b)² = a² + 2ab + b²', 2),
('poly_expand__square_diff',     'poly_expand', '差の平方公式',
 '(a-b)² = a² - 2ab + b²', 3),
('poly_expand__sum_diff_product', 'poly_expand', '和と差の積',
 '(a+b)(a-b) = a² - b²', 4),
('poly_expand__x_plus_a_b',     'poly_expand', '(x+a)(x+b)の展開',
 '(x+a)(x+b) = x² + (a+b)x + ab', 5);

-- =========================
-- 7. 例題: 整式の乗法（展開）
-- =========================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
('ex_distributive', 'poly_expand__distributive',
 '次の式を展開しなさい。',
 '3x(2x - 5)',
 '6x^2 - 15x',
 '分配法則: 各項に掛ける。係数どうしの積と指数の和に注意。'),

('ex_square_sum', 'poly_expand__square_sum',
 '次の式を展開しなさい。',
 '(x + 3)^2',
 'x^2 + 6x + 9',
 '和の平方公式 (a+b)² = a² + 2ab + b² を使う。2ab の「2」を忘れやすい。'),

('ex_square_diff', 'poly_expand__square_diff',
 '次の式を展開しなさい。',
 '(x - 4)^2',
 'x^2 - 8x + 16',
 '差の平方公式 (a-b)² = a² - 2ab + b²。最後の項 b² は常に正。'),

('ex_sum_diff_product', 'poly_expand__sum_diff_product',
 '次の式を展開しなさい。',
 '(x + 6)(x - 6)',
 'x^2 - 36',
 '和と差の積 (a+b)(a-b) = a² - b²。中間項が相殺されて消える。'),

('ex_x_plus_a_b', 'poly_expand__x_plus_a_b',
 '次の式を展開しなさい。',
 '(x + 2)(x + 5)',
 'x^2 + 7x + 10',
 '(x+a)(x+b) = x² + (a+b)x + ab。a+b が x の係数、ab が定数項。');

-- =========================
-- 8. 例題ステップ: 整式の乗法（展開）
-- =========================

-- 分配法則
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_distributive', 1, 'Step 1: 各項に掛ける',
 '3x \cdot 2x + 3x \cdot (-5)',
 '分配法則 a(b+c) = ab + ac を適用'),
('ex_distributive', 2, 'Step 2: 計算',
 '6x^2 - 15x',
 '3×2=6, x·x=x², 3×(-5)=-15');

-- 和の平方公式
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_square_sum', 1, 'Step 1: 公式を適用',
 'a = x, \quad b = 3',
 '(a+b)² = a² + 2ab + b² に当てはめる'),
('ex_square_sum', 2, 'Step 2: 各項を計算',
 'x^2 + 2 \cdot x \cdot 3 + 3^2',
 NULL),
('ex_square_sum', 3, 'Step 3: 答え',
 'x^2 + 6x + 9',
 '2ab = 2·x·3 = 6x, b² = 9');

-- 差の平方公式
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_square_diff', 1, 'Step 1: 公式を適用',
 'a = x, \quad b = 4',
 '(a-b)² = a² - 2ab + b² に当てはめる'),
('ex_square_diff', 2, 'Step 2: 各項を計算',
 'x^2 - 2 \cdot x \cdot 4 + 4^2',
 NULL),
('ex_square_diff', 3, 'Step 3: 答え',
 'x^2 - 8x + 16',
 'b²=16 は「正」になることに注意（よくある誤り: -16）');

-- 和と差の積
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_sum_diff_product', 1, 'Step 1: 公式を適用',
 'a = x, \quad b = 6',
 '(a+b)(a-b) = a² - b²'),
('ex_sum_diff_product', 2, 'Step 2: 答え',
 'x^2 - 36',
 'x²-6²=x²-36。中間項(+6x-6x)が消える');

-- (x+a)(x+b)
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_x_plus_a_b', 1, 'Step 1: 公式を確認',
 '(x+a)(x+b) = x^2 + (a+b)x + ab',
 'a=2, b=5 を代入'),
('ex_x_plus_a_b', 2, 'Step 2: 係数を計算',
 'a + b = 7, \quad ab = 10',
 NULL),
('ex_x_plus_a_b', 3, 'Step 3: 答え',
 'x^2 + 7x + 10',
 NULL);


-- =========================
-- 9. 演習問題: 整式の乗法（展開）（13問）
-- =========================

-- ===== パターン1: 分配法則（2問）=====

-- 問1: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_dist_01', 'poly_expand__distributive', 1, 'TEXT_EXPRESSION', 1,
 '次の式を展開しなさい。',
 '2x(3x + 4)',
 '2x·3x + 2x·4 = 6x² + 8x');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_dist_01', '6x^2 + 8x', '6x^2+8x', true, NULL),
('drill_dist_01', '2x(3x+4)', '6x^2+8x', false, '展開せずそのまま書いた場合は不正解');

-- 問2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_dist_02', 'poly_expand__distributive', 2, 'TEXT_EXPRESSION', 2,
 '次の式を展開しなさい。',
 '-2a(3a^2 - 4a + 1)',
 '-2a·3a²=−6a³, -2a·(-4a)=8a², -2a·1=-2a → -6a³+8a²-2a');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_dist_02', '-6a^3 + 8a^2 - 2a', '-6a^3+8a^2-2a', true, NULL),
('drill_dist_02', '-2a(3a^2-4a+1)', '-6a^3+8a^2-2a', false, '未展開は不正解');

-- ===== パターン2: 和の平方公式（3問）=====

-- 問3: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_sq_sum_01', 'poly_expand__square_sum', 1, 'SELECT_BASIC', 1,
 '(x+5)² を展開した結果として正しいものを選びなさい。',
 '(x + 5)^2',
 '(x+5)² = x² + 2·x·5 + 5² = x² + 10x + 25');

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
('drill_sq_sum_01', 'A', 'x^2 + 10x + 25', true,  NULL, 1),
('drill_sq_sum_01', 'B', 'x^2 + 5x + 25',  false, '2ab の「2」を忘れて ab=5x とした誤り（最頻出ミス）', 2),
('drill_sq_sum_01', 'C', 'x^2 + 25',        false, '中間項 2ab を完全に忘れ (a+b)²=a²+b² とした誤り', 3),
('drill_sq_sum_01', 'D', 'x^2 + 10x + 5',   false, 'b²=5² を 5 とした誤り（二乗し忘れ）', 4);

-- 問4: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_sq_sum_02', 'poly_expand__square_sum', 2, 'TEXT_EXPRESSION', 2,
 '次の式を展開しなさい。',
 '(2x + 3)^2',
 '(2x)²+2·2x·3+3² = 4x²+12x+9');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_sq_sum_02', '4x^2 + 12x + 9', '4x^2+12x+9', true, NULL);

-- 問5: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_sq_sum_03', 'poly_expand__square_sum', 3, 'TEXT_EXPRESSION', 3,
 '次の式を展開しなさい。',
 '(3a + 2b)^2',
 '(3a)²+2·3a·2b+(2b)² = 9a²+12ab+4b²');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_sq_sum_03', '9a^2 + 12ab + 4b^2', '9a^2+12ab+4b^2', true, NULL);

-- ===== パターン3: 差の平方公式（2問）=====

-- 問6: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_sq_diff_01', 'poly_expand__square_diff', 1, 'SELECT_BASIC', 1,
 '(x-4)² を展開した結果として正しいものを選びなさい。',
 '(x - 4)^2',
 '(x-4)² = x² - 2·x·4 + 4² = x² - 8x + 16');

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
('drill_sq_diff_01', 'A', 'x^2 - 8x + 16', true,  NULL, 1),
('drill_sq_diff_01', 'B', 'x^2 - 8x - 16', false, 'b²の符号を負にした誤り（差だから全部マイナスと誤解）', 2),
('drill_sq_diff_01', 'C', 'x^2 + 8x + 16', false, '-2abの符号を正にした誤り（(x+4)²と混同）', 3),
('drill_sq_diff_01', 'D', 'x^2 - 16',      false, '和と差の積 (x+4)(x-4) と混同した誤り', 4);

-- 問7: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_sq_diff_02', 'poly_expand__square_diff', 2, 'TEXT_EXPRESSION', 2,
 '次の式を展開しなさい。',
 '(3x - 2)^2',
 '(3x)²-2·3x·2+2² = 9x²-12x+4');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_sq_diff_02', '9x^2 - 12x + 4', '9x^2-12x+4', true, NULL);

-- ===== パターン4: 和と差の積（3問）=====

-- 問8: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_sum_diff_01', 'poly_expand__sum_diff_product', 1, 'SELECT_BASIC', 1,
 '(x+7)(x-7) を展開した結果として正しいものを選びなさい。',
 '(x + 7)(x - 7)',
 '(x+7)(x-7) = x² - 7² = x² - 49');

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
('drill_sum_diff_01', 'A', 'x^2 - 49', true,  NULL, 1),
('drill_sum_diff_01', 'B', 'x^2 + 49', false, '符号を正にした誤り（a²+b²と誤解）', 2),
('drill_sum_diff_01', 'C', 'x^2 - 14x - 49', false, '(x-7)²と混同し、中間項を入れた誤り', 3),
('drill_sum_diff_01', 'D', 'x^2 - 7',  false, '7²=49 を計算せず 7 のままにした誤り', 4);

-- 問9: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_sum_diff_02', 'poly_expand__sum_diff_product', 2, 'TEXT_EXPRESSION', 2,
 '次の式を展開しなさい。',
 '(2x + 5)(2x - 5)',
 '(2x)²-5² = 4x²-25');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_sum_diff_02', '4x^2 - 25', '4x^2-25', true, NULL);

-- 問10: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_sum_diff_03', 'poly_expand__sum_diff_product', 3, 'TEXT_EXPRESSION', 3,
 '次の式を展開しなさい。',
 '(3a + 4b)(3a - 4b)',
 '(3a)²-(4b)² = 9a²-16b²');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_sum_diff_03', '9a^2 - 16b^2', '9a^2-16b^2', true, NULL);

-- ===== パターン5: (x+a)(x+b)の展開（3問）=====

-- 問11: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_xab_01', 'poly_expand__x_plus_a_b', 1, 'SELECT_BASIC', 1,
 '(x+3)(x+4) を展開した結果として正しいものを選びなさい。',
 '(x + 3)(x + 4)',
 '(x+3)(x+4) = x²+(3+4)x+3·4 = x²+7x+12');

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
('drill_xab_01', 'A', 'x^2 + 7x + 12', true,  NULL, 1),
('drill_xab_01', 'B', 'x^2 + 12x + 7', false, 'a+bとabを逆にした誤り（係数と定数項を取り違え）', 2),
('drill_xab_01', 'C', 'x^2 + 7x + 7',  false, 'ab=3·4=12 を a+b=7 と混同した誤り', 3),
('drill_xab_01', 'D', 'x^2 + 12',       false, '中間項を完全に忘れた誤り', 4);

-- 問12: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_xab_02', 'poly_expand__x_plus_a_b', 2, 'TEXT_EXPRESSION', 2,
 '次の式を展開しなさい。',
 '(x - 2)(x + 6)',
 'a=-2, b=6: a+b=4, ab=-12 → x²+4x-12');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_xab_02', 'x^2 + 4x - 12', 'x^2+4x-12', true, NULL);

-- 問13: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_xab_03', 'poly_expand__x_plus_a_b', 3, 'TEXT_EXPRESSION', 3,
 '次の式を展開しなさい。',
 '(x - 3)(x - 8)',
 'a=-3, b=-8: a+b=-11, ab=24 → x²-11x+24');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_xab_03', 'x^2 - 11x + 24', 'x^2-11x+24', true, NULL);


COMMIT;
