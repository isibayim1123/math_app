-- ============================================================
-- サンプルデータ: 二次関数のグラフ（数学I）
-- 4パターン、演習11問
-- 数式は LaTeX 形式（CLAUDE.md 数式表記ルール準拠）
-- ============================================================

BEGIN;

-- =========================
-- 1. スキル
-- =========================

INSERT INTO skills (id, subject, unit_name, subunit_name, display_name, description, sort_order) VALUES
('quad_graph', 'math_1', '二次関数', '二次関数のグラフ', '二次関数のグラフ',
 '二次関数 $y = ax^2 + bx + c$ のグラフの頂点・軸・形状を求め、平行移動やグラフの決定を行うスキル。', 30);

-- スキル依存関係（展開が前提）
INSERT INTO skill_dependencies (prerequisite_id, dependent_id, dependency_type) VALUES
('poly_expand', 'quad_graph', 'required');


-- =========================
-- 2. パターン（4パターン）
-- =========================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
('quad_graph__standard_form',  'quad_graph', '標準形のグラフ',
 '$y = a(x - p)^2 + q$ から頂点 $(p, q)$ と軸 $x = p$ を読み取る', 1),
('quad_graph__completing_sq',  'quad_graph', '平方完成',
 '$y = ax^2 + bx + c$ を $y = a(x - p)^2 + q$ に変形する', 2),
('quad_graph__translation',   'quad_graph', '平行移動',
 '$x$ 軸方向・$y$ 軸方向の平行移動による式の変化を理解する', 3),
('quad_graph__determine',     'quad_graph', 'グラフの決定',
 '頂点や通過点の条件からグラフの式を求める', 4);


-- =========================
-- 3. 例題
-- =========================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
('ex_quad_standard', 'quad_graph__standard_form',
 '二次関数 $y = 2(x - 3)^2 + 1$ のグラフの頂点の座標と軸の方程式を求めなさい。',
 'y = 2(x - 3)^2 + 1',
 '頂点 $(3, 1)$、軸 $x = 3$',
 '$y = a(x - p)^2 + q$ の形から、頂点は $(p, q)$、軸は $x = p$ と直接読み取れる。$a > 0$ なので下に凸。'),

('ex_quad_completing', 'quad_graph__completing_sq',
 '二次関数 $y = x^2 - 6x + 11$ を $y = a(x - p)^2 + q$ の形に変形し、頂点の座標を求めなさい。',
 'y = x^2 - 6x + 11',
 '$y = (x - 3)^2 + 2$、頂点 $(3, 2)$',
 '$x$ の係数の半分を二乗して足し引きする。$-6$ の半分は $-3$、$(-3)^2 = 9$ を足し引きする。'),

('ex_quad_translation', 'quad_graph__translation',
 '二次関数 $y = x^2$ のグラフを $x$ 軸方向に $2$、$y$ 軸方向に $-3$ だけ平行移動した放物線の式を求めなさい。',
 'y = x^2',
 '$y = (x - 2)^2 - 3$',
 '$x$ 軸方向に $p$ 移動 → $x$ を $(x - p)$ に置き換え。$y$ 軸方向に $q$ 移動 → $q$ を加える。符号の向きに注意。'),

('ex_quad_determine', 'quad_graph__determine',
 '頂点が $(1, -4)$ で、点 $(3, 0)$ を通る二次関数の式を求めなさい。',
 NULL,
 '$y = (x - 1)^2 - 4$',
 '頂点 $(p, q)$ から $y = a(x - p)^2 + q$ に代入し、通過点で $a$ を決定する。');


-- =========================
-- 4. 例題ステップ
-- =========================

-- 標準形のグラフ
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_quad_standard', 1, 'Step 1: 標準形を確認',
 'y = 2(x - 3)^2 + 1',
 '$y = a(x - p)^2 + q$ の形になっている。$a = 2$, $p = 3$, $q = 1$'),
('ex_quad_standard', 2, 'Step 2: 頂点を読み取る',
 '(p, q) = (3, 1)',
 '$(x - 3)$ の $3$ が頂点の $x$ 座標、$+1$ が $y$ 座標'),
('ex_quad_standard', 3, 'Step 3: 軸の方程式',
 'x = 3',
 '軸は頂点を通る $y$ 軸に平行な直線'),
('ex_quad_standard', 4, 'Step 4: 凸の向き',
 'a = 2 > 0',
 '$a > 0$ なので下に凸（グラフは上に開く）');

-- 平方完成
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_quad_completing', 1, 'Step 1: x の係数の半分を求める',
 '\frac{-6}{2} = -3',
 '$x$ の係数 $-6$ の半分は $-3$'),
('ex_quad_completing', 2, 'Step 2: その二乗を足し引き',
 'y = (x^2 - 6x + 9) - 9 + 11',
 '$(-3)^2 = 9$ を足して引く'),
('ex_quad_completing', 3, 'Step 3: 完全平方式に整理',
 'y = (x - 3)^2 + 2',
 '$x^2 - 6x + 9 = (x - 3)^2$、$-9 + 11 = 2$'),
('ex_quad_completing', 4, 'Step 4: 頂点を読み取る',
 '(3, 2)',
 NULL);

-- 平行移動
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_quad_translation', 1, 'Step 1: x 軸方向の移動',
 'y = x^2 \to y = (x - 2)^2',
 '$x$ を $(x - 2)$ に置き換え（右に $2$ 移動なので引く）'),
('ex_quad_translation', 2, 'Step 2: y 軸方向の移動',
 'y = (x - 2)^2 \to y = (x - 2)^2 - 3',
 '全体に $-3$ を加える（下に $3$ 移動）'),
('ex_quad_translation', 3, 'Step 3: 答え',
 'y = (x - 2)^2 - 3',
 '頂点は原点 $(0, 0)$ から $(2, -3)$ に移動');

-- グラフの決定
INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
('ex_quad_determine', 1, 'Step 1: 頂点を代入',
 'y = a(x - 1)^2 + (-4) = a(x - 1)^2 - 4',
 '頂点 $(1, -4)$ から $p = 1$, $q = -4$'),
('ex_quad_determine', 2, 'Step 2: 通過点を代入して a を求める',
 '0 = a(3 - 1)^2 - 4',
 '点 $(3, 0)$ を代入'),
('ex_quad_determine', 3, 'Step 3: a を計算',
 '0 = 4a - 4 \quad \Rightarrow \quad a = 1',
 '$4a = 4$ より $a = 1$'),
('ex_quad_determine', 4, 'Step 4: 答え',
 'y = (x - 1)^2 - 4',
 '展開すると $y = x^2 - 2x - 3$');


-- =========================
-- 5. 演習問題（11問）
-- =========================

-- ===== パターン1: 標準形のグラフ（3問）=====

-- 問1: SELECT_BASIC（頂点を読み取る）
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_quad_std_01', 'quad_graph__standard_form', 1, 'SELECT_BASIC', 1,
 '二次関数 $y = 3(x - 2)^2 + 5$ のグラフの頂点の座標として正しいものを選びなさい。',
 'y = 3(x - 2)^2 + 5',
 '$y = a(x - p)^2 + q$ より、頂点は $(p, q) = (2, 5)$');

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
('drill_quad_std_01', 'A', '(2, 5)',   true,  NULL, 1),
('drill_quad_std_01', 'B', '(-2, 5)',  false, '$(x - 2)$ の符号を逆にして $x = -2$ とした誤り（最頻出ミス）', 2),
('drill_quad_std_01', 'C', '(2, 3)',   false, '$a = 3$ を $y$ 座標と取り違えた誤り', 3),
('drill_quad_std_01', 'D', '(3, 5)',   false, '$a = 3$ を $x$ 座標と取り違えた誤り', 4);

-- 問2: TEXT_NUMERIC（軸の方程式）
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_quad_std_02', 'quad_graph__standard_form', 2, 'TEXT_EXPRESSION', 2,
 '二次関数 $y = -(x + 4)^2 + 7$ のグラフの軸の方程式を求めなさい。',
 'y = -(x + 4)^2 + 7',
 '$(x + 4) = (x - (-4))$ なので頂点は $(-4, 7)$、軸は $x = -4$。$a = -1 < 0$ なので上に凸。');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_quad_std_02', 'x = -4', 'x=-4', true, NULL);

-- 問3: TEXT_EXPRESSION（頂点＋凸の向き）
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_quad_std_03', 'quad_graph__standard_form', 3, 'TEXT_EXPRESSION', 2,
 '二次関数 $y = -2(x - 1)^2 + 3$ のグラフの頂点の座標を求めなさい。',
 'y = -2(x - 1)^2 + 3',
 '頂点は $(1, 3)$。$a = -2 < 0$ より上に凸。');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_quad_std_03', '(1, 3)', '(1,3)', true, NULL),
('drill_quad_std_03', '(1,3)',  '(1,3)', false, 'スペースなし表記');


-- ===== パターン2: 平方完成（3問）=====

-- 問4: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_quad_comp_01', 'quad_graph__completing_sq', 1, 'SELECT_BASIC', 2,
 '$y = x^2 + 4x + 7$ を平方完成した結果として正しいものを選びなさい。',
 'y = x^2 + 4x + 7',
 '$x$ の係数 $4$ の半分 $2$ を二乗して $4$ を足し引き。$y = (x^2 + 4x + 4) - 4 + 7 = (x + 2)^2 + 3$');

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
('drill_quad_comp_01', 'A', 'y = (x + 2)^2 + 3', true,  NULL, 1),
('drill_quad_comp_01', 'B', 'y = (x + 4)^2 + 3', false, '半分にせず $x$ の係数をそのまま使った誤り', 2),
('drill_quad_comp_01', 'C', 'y = (x + 2)^2 + 7', false, '足した $4$ を引き忘れて定数項がそのまま残った誤り', 3),
('drill_quad_comp_01', 'D', 'y = (x - 2)^2 + 3', false, '$(x + 2)$ を $(x - 2)$ と符号を間違えた誤り', 4);

-- 問5: TEXT_EXPRESSION（係数1）
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_quad_comp_02', 'quad_graph__completing_sq', 2, 'TEXT_EXPRESSION', 2,
 '$y = x^2 - 8x + 18$ を $y = (x - p)^2 + q$ の形に変形しなさい。',
 'y = x^2 - 8x + 18',
 '$-8$ の半分 $-4$、$(-4)^2 = 16$ を足し引き。$y = (x^2 - 8x + 16) - 16 + 18 = (x - 4)^2 + 2$');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_quad_comp_02', 'y = (x - 4)^2 + 2', 'y=(x-4)^2+2', true, NULL);

-- 問6: TEXT_EXPRESSION（係数が1でない）
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_quad_comp_03', 'quad_graph__completing_sq', 3, 'TEXT_EXPRESSION', 3,
 '$y = 2x^2 - 12x + 20$ を $y = a(x - p)^2 + q$ の形に変形し、頂点の座標を求めなさい。',
 'y = 2x^2 - 12x + 20',
 '$2$ でくくって $y = 2(x^2 - 6x) + 20$。$-6$ の半分 $-3$、$(-3)^2 = 9$。$y = 2(x^2 - 6x + 9 - 9) + 20 = 2(x - 3)^2 - 18 + 20 = 2(x - 3)^2 + 2$。頂点 $(3, 2)$。');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_quad_comp_03', 'y = 2(x - 3)^2 + 2', 'y=2(x-3)^2+2', true, NULL);


-- ===== パターン3: 平行移動（2問）=====

-- 問7: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_quad_trans_01', 'quad_graph__translation', 1, 'SELECT_BASIC', 2,
 '二次関数 $y = 2x^2$ のグラフを $x$ 軸方向に $-3$、$y$ 軸方向に $4$ だけ平行移動した式として正しいものを選びなさい。',
 'y = 2x^2',
 '$x$ を $(x - (-3)) = (x + 3)$ に置き換え、$+4$ を加える。$y = 2(x + 3)^2 + 4$');

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
('drill_quad_trans_01', 'A', 'y = 2(x + 3)^2 + 4', true,  NULL, 1),
('drill_quad_trans_01', 'B', 'y = 2(x - 3)^2 + 4', false, '左に $3$ 移動なのに $(x - 3)$ とした符号ミス（移動方向と符号の関係を誤解）', 2),
('drill_quad_trans_01', 'C', 'y = 2(x + 3)^2 - 4', false, '$y$ 方向の移動の符号を逆にした誤り', 3),
('drill_quad_trans_01', 'D', 'y = 2(x - 3)^2 - 4', false, '$x$ 方向・$y$ 方向とも符号を逆にした誤り', 4);

-- 問8: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_quad_trans_02', 'quad_graph__translation', 2, 'TEXT_EXPRESSION', 3,
 '二次関数 $y = -x^2 + 4x - 1$ のグラフを $x$ 軸方向に $2$、$y$ 軸方向に $-5$ だけ平行移動した式を求めなさい。',
 'y = -x^2 + 4x - 1',
 'まず平方完成: $y = -(x^2 - 4x) - 1 = -(x^2 - 4x + 4 - 4) - 1 = -(x - 2)^2 + 4 - 1 = -(x - 2)^2 + 3$。頂点 $(2, 3)$ を $(2+2, 3-5) = (4, -2)$ に移動。$y = -(x - 4)^2 - 2$。');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_quad_trans_02', 'y = -(x - 4)^2 - 2', 'y=-(x-4)^2-2', true, NULL),
('drill_quad_trans_02', 'y = -x^2 + 8x - 18',  'y=-x^2+8x-18', false, '展開形でも正解');


-- ===== パターン4: グラフの決定（3問）=====

-- 問9: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_quad_det_01', 'quad_graph__determine', 1, 'SELECT_BASIC', 2,
 '頂点が $(-1, 3)$ で点 $(1, 7)$ を通る二次関数の式として正しいものを選びなさい。',
 NULL,
 '$y = a(x + 1)^2 + 3$ に $(1, 7)$ を代入。$7 = a(1+1)^2 + 3 = 4a + 3$。$4a = 4$ より $a = 1$。$y = (x + 1)^2 + 3$。');

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
('drill_quad_det_01', 'A', 'y = (x + 1)^2 + 3',  true,  NULL, 1),
('drill_quad_det_01', 'B', 'y = (x - 1)^2 + 3',  false, '頂点 $(-1, 3)$ の $x$ 座標の符号ミス（$(x-(-1))=(x+1)$ を $(x-1)$ とした）', 2),
('drill_quad_det_01', 'C', 'y = 2(x + 1)^2 + 3', false, '$a$ の計算ミス: $4a = 4$ を $a = 2$ とした（$4$ で割り忘れ）', 3),
('drill_quad_det_01', 'D', 'y = (x + 1)^2 - 3',  false, '頂点の $y$ 座標の符号を間違えた誤り', 4);

-- 問10: TEXT_EXPRESSION（頂点＋通過点）
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_quad_det_02', 'quad_graph__determine', 2, 'TEXT_EXPRESSION', 3,
 '頂点が $(2, -1)$ で点 $(0, 7)$ を通る二次関数の式を求めなさい。',
 NULL,
 '$y = a(x - 2)^2 - 1$ に $(0, 7)$ を代入。$7 = a(0-2)^2 - 1 = 4a - 1$。$4a = 8$ より $a = 2$。$y = 2(x - 2)^2 - 1$。');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_quad_det_02', 'y = 2(x - 2)^2 - 1', 'y=2(x-2)^2-1', true, NULL),
('drill_quad_det_02', 'y = 2x^2 - 8x + 7',  'y=2x^2-8x+7', false, '展開形でも正解');

-- 問11: TEXT_EXPRESSION（軸の方程式＋通過2点）
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation) VALUES
('drill_quad_det_03', 'quad_graph__determine', 3, 'TEXT_EXPRESSION', 4,
 '軸が直線 $x = 1$ で、2点 $(0, 5)$, $(3, 8)$ を通る二次関数の式を求めなさい。',
 NULL,
 '軸 $x = 1$ より $y = a(x - 1)^2 + q$。$(0, 5)$: $5 = a + q$ …(1)。$(3, 8)$: $8 = 4a + q$ …(2)。(2)-(1): $3a = 3$ より $a = 1$。(1)に代入: $q = 4$。$y = (x - 1)^2 + 4$。');

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
('drill_quad_det_03', 'y = (x - 1)^2 + 4', 'y=(x-1)^2+4', true, NULL),
('drill_quad_det_03', 'y = x^2 - 2x + 5',  'y=x^2-2x+5', false, '展開形でも正解');


COMMIT;
