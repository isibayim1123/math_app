-- ============================================================
-- シードデータ: 二次関数ユニット（数学I）
-- 4スキル / 14パターン / 14例題 / 37演習
-- ============================================================

BEGIN;

-- =========================
-- Skills（4スキル）
-- =========================

INSERT INTO skills (id, subject, unit_name, subunit_name, display_name, description, sort_order) VALUES
  ('quad_func_graph',   'math_1', '二次関数', '二次関数のグラフ',       '二次関数のグラフ',       '標準形・平方完成・平行移動・グラフの決定', 10),
  ('quad_func_max_min', 'math_1', '二次関数', '二次関数の最大値・最小値', '二次関数の最大値・最小値', '定義域なし/あり（軸の位置による場合分け）', 11),
  ('quad_equation',     'math_1', '二次関数', '二次方程式',             '二次方程式',             '因数分解・解の公式・判別式',             12),
  ('quad_inequality',   'math_1', '二次関数', '二次不等式',             '二次不等式',             'D>0, D=0, D<0 の場合分け',              13);


-- =========================
-- スキル依存関係
-- =========================

INSERT INTO skill_dependencies (prerequisite_id, dependent_id, dependency_type) VALUES
  ('quad_func_graph',   'quad_func_max_min', 'required'),
  ('quad_func_max_min', 'quad_equation',     'required'),
  ('quad_equation',     'quad_inequality',   'required');


-- =========================================================
-- スキル1: quad_func_graph（二次関数のグラフ）
-- 4パターン / 4例題 / 11演習
-- =========================================================

-- ----- パターン -----
INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('qfg__standard',      'quad_func_graph', '標準形 y=a(x-p)²+q のグラフ', '頂点・軸の読み取り',               0),
  ('qfg__completing_sq',  'quad_func_graph', '一般形→標準形（平方完成）',   '平方完成による頂点の求め方',       1),
  ('qfg__translation',    'quad_func_graph', 'グラフの平行移動',           'x軸方向・y軸方向の平行移動',       2),
  ('qfg__determine',      'quad_func_graph', 'グラフの決定',              '条件から二次関数の式を求める',      3);


-- =============================================
-- パターン: qfg__standard（標準形）
-- =============================================

-- 例題
INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qfg__standard', 'qfg__standard',
   '次の二次関数のグラフの頂点の座標と軸の方程式を求めよ。$$y = 2(x - 3)^2 + 1$$',
   'y = 2(x - 3)^2 + 1',
   '頂点 $(3, 1)$、軸 $x = 3$',
   '$y = a(x-p)^2+q$ の $p$ と $q$ がそのまま頂点座標になる。符号に注意（$x - p$ の $p$ が正なら右方向）。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qfg__standard', 1, '標準形の確認',   'y = a(x - p)^2 + q', '$a = 2$, $p = 3$, $q = 1$'),
  ('ex_qfg__standard', 2, '頂点の特定',     '(p, q) = (3, 1)',    '頂点は $(p, q) = (3, 1)$'),
  ('ex_qfg__standard', 3, '軸の特定',       'x = p = 3',          '軸は $x = p$ より $x = 3$'),
  ('ex_qfg__standard', 4, '開く向きの確認', 'a = 2 > 0',          '$a = 2 > 0$ なので下に凸');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfg_std_01', 'qfg__standard', 0, 'SELECT_BASIC', 1,
   '二次関数 $y = (x - 2)^2 + 5$ のグラフの頂点はどれか。',
   'y = (x - 2)^2 + 5',
   '$y = (x-2)^2 + 5$ は標準形 $y = a(x-p)^2 + q$ で $p=2$, $q=5$。頂点は $(p, q) = (2, 5)$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qfg_std_01', 'A', '(2, 5)',  true,  NULL, 0),
  ('drill_qfg_std_01', 'B', '(-2, 5)', false, '符号ミス: x-2 の 2 を -2 と読む', 1),
  ('drill_qfg_std_01', 'C', '(2, -5)', false, '定数項の符号ミス: +5 を -5 と誤る', 2),
  ('drill_qfg_std_01', 'D', '(5, 2)',  false, 'p,qの取り違え: 頂点のxとyを逆にする', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfg_std_02', 'qfg__standard', 1, 'TEXT_NUMERIC', 2,
   '二次関数 $y = -3(x + 1)^2 - 4$ のグラフの頂点の座標を求めよ。',
   'y = -3(x + 1)^2 - 4',
   '$y = -3(x + 1)^2 - 4 = -3(x - (-1))^2 + (-4)$ より $p = -1$, $q = -4$。頂点は $(-1, -4)$。$x + 1$ を $x - (-1)$ と読み替えるのがポイント。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qfg_std_02', '(-1, -4)',   '(-1,-4)', true,  '模範解答'),
  ('drill_qfg_std_02', '(-1,-4)',    '(-1,-4)', false, 'スペースなし'),
  ('drill_qfg_std_02', '( -1 , -4 )','(-1,-4)', false, 'スペース多め');

-- 演習3: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfg_std_03', 'qfg__standard', 2, 'TEXT_EXPRESSION', 2,
   '二次関数 $y = 2(x - 4)^2 + 3$ のグラフの軸の方程式を求めよ。',
   'y = 2(x - 4)^2 + 3',
   '標準形 $y = a(x-p)^2+q$ の軸は $x = p$。$p = 4$ なので軸は $x = 4$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qfg_std_03', 'x = 4', 'x=4', true,  '模範解答'),
  ('drill_qfg_std_03', 'x=4',   'x=4', false, 'スペースなし');


-- =============================================
-- パターン: qfg__completing_sq（平方完成）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qfg__completing_sq', 'qfg__completing_sq',
   '次の二次関数を $y = a(x-p)^2 + q$ の形に変形し、頂点を求めよ。$$y = x^2 - 6x + 11$$',
   'y = x^2 - 6x + 11',
   '$y = (x - 3)^2 + 2$、頂点 $(3, 2)$',
   '平方完成では $x$ の係数の半分を二乗する。$-6$ の半分は $-3$、$(-3)^2 = 9$ を加減する。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qfg__completing_sq', 1, 'x²の係数を確認', 'a = 1',                              '$a = 1$'),
  ('ex_qfg__completing_sq', 2, '平方完成',       '(x^2 - 6x + 9 - 9) + 11 = (x-3)^2 + 2', '$x$ の係数 $-6$ の半分 $-3$ を二乗して $9$ を加減'),
  ('ex_qfg__completing_sq', 3, '頂点の読み取り', '(3, 2)',                              '頂点 $(3, 2)$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfg_csq_01', 'qfg__completing_sq', 0, 'SELECT_BASIC', 2,
   '$y = x^2 + 4x + 7$ を平方完成した式はどれか。',
   'y = x^2 + 4x + 7',
   '$y = (x^2 + 4x + 4 - 4) + 7 = (x + 2)^2 + 3$',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qfg_csq_01', 'A', 'y = (x + 2)^2 + 3', true,  NULL, 0),
  ('drill_qfg_csq_01', 'B', 'y = (x + 4)^2 + 7', false, '半分にし忘れ: 4xの係数4をそのまま使う', 1),
  ('drill_qfg_csq_01', 'C', 'y = (x - 2)^2 + 3', false, '符号ミス: +4xなのに-2にする', 2),
  ('drill_qfg_csq_01', 'D', 'y = (x + 2)^2 + 7', false, '定数項の調整忘れ: +4を引き忘れる', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfg_csq_02', 'qfg__completing_sq', 1, 'TEXT_EXPRESSION', 3,
   '$y = 2x^2 - 12x + 20$ を標準形に変形せよ。',
   'y = 2x^2 - 12x + 20',
   '$y = 2(x^2 - 6x) + 20 = 2(x^2 - 6x + 9 - 9) + 20 = 2(x - 3)^2 - 18 + 20 = 2(x - 3)^2 + 2$。$a \neq 1$ のときは先にくくり出す。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qfg_csq_02', 'y = 2(x - 3)^2 + 2', 'y=2(x-3)^2+2', true,  '模範解答'),
  ('drill_qfg_csq_02', 'y=2(x-3)^2+2',       'y=2(x-3)^2+2', false, 'スペースなし');

-- 演習3: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfg_csq_03', 'qfg__completing_sq', 2, 'TEXT_NUMERIC', 3,
   '二次関数 $y = -x^2 + 8x - 13$ の頂点の座標を求めよ。',
   'y = -x^2 + 8x - 13',
   '$y = -(x^2 - 8x) - 13 = -(x^2 - 8x + 16 - 16) - 13 = -(x - 4)^2 + 16 - 13 = -(x - 4)^2 + 3$。頂点 $(4, 3)$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qfg_csq_03', '(4, 3)',  '(4,3)', true,  '模範解答'),
  ('drill_qfg_csq_03', '(4,3)',   '(4,3)', false, 'スペースなし');


-- =============================================
-- パターン: qfg__translation（平行移動）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qfg__translation', 'qfg__translation',
   '二次関数 $y = 2x^2$ のグラフを $x$ 軸方向に $3$、$y$ 軸方向に $-1$ だけ平行移動した二次関数を求めよ。',
   'y = 2x^2',
   '$y = 2(x - 3)^2 - 1$',
   'x軸方向に $p$ 移動 → $x$ を $x - p$ に。y軸方向に $q$ 移動 → 定数項に $q$ を加える。移動方向と符号の対応に注意。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qfg__translation', 1, '平行移動の公式', 'x \to x - 3,\; y \to y + 1', '$x$ を $x - 3$ に、$y$ を $y + 1$ に置き換え'),
  ('ex_qfg__translation', 2, '代入',          'y + 1 = 2(x - 3)^2',          NULL),
  ('ex_qfg__translation', 3, '整理',          'y = 2(x - 3)^2 - 1',          NULL);

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfg_trs_01', 'qfg__translation', 0, 'SELECT_BASIC', 2,
   '$y = x^2$ を $x$ 軸方向に $-2$、$y$ 軸方向に $4$ 平行移動した関数はどれか。',
   'y = x^2',
   'x軸方向に $-2$ → $x$ を $x - (-2) = x + 2$ に。y軸方向に $+4$ → $+4$ を加える。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qfg_trs_01', 'A', 'y = (x + 2)^2 + 4', true,  NULL, 0),
  ('drill_qfg_trs_01', 'B', 'y = (x - 2)^2 + 4', false, 'x方向の符号ミス: -2移動なのにx-2にする', 1),
  ('drill_qfg_trs_01', 'C', 'y = (x + 2)^2 - 4', false, 'y方向の符号ミス: +4なのに-4', 2),
  ('drill_qfg_trs_01', 'D', 'y = (x - 4)^2 + 2', false, 'x,yの移動量を逆に適用', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfg_trs_02', 'qfg__translation', 1, 'TEXT_EXPRESSION', 3,
   '二次関数 $y = -3x^2$ のグラフを $x$ 軸方向に $1$、$y$ 軸方向に $5$ だけ平行移動した二次関数を求めよ。',
   'y = -3x^2',
   '$x$ を $x - 1$ に置き換え。$y = -3(x - 1)^2 + 5$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qfg_trs_02', 'y = -3(x - 1)^2 + 5', 'y=-3(x-1)^2+5', true,  '模範解答'),
  ('drill_qfg_trs_02', 'y=-3(x-1)^2+5',       'y=-3(x-1)^2+5', false, 'スペースなし');


-- =============================================
-- パターン: qfg__determine（グラフの決定）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qfg__determine', 'qfg__determine',
   '頂点が $(1, -3)$ で点 $(3, 5)$ を通る二次関数を求めよ。',
   NULL,
   '$y = 2(x - 1)^2 - 3$',
   '頂点がわかっていれば $y = a(x-p)^2 + q$ に当てはめ、もう1点で $a$ を決定する。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qfg__determine', 1, '頂点形式で立式', 'y = a(x - 1)^2 - 3',                  '頂点 $(1, -3)$ を代入'),
  ('ex_qfg__determine', 2, '通過点を代入',  '5 = a(3 - 1)^2 - 3 \Rightarrow a = 2', '$(3, 5)$ を代入して $a$ を求める'),
  ('ex_qfg__determine', 3, '式を確定',      'y = 2(x - 1)^2 - 3',                   NULL);

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfg_det_01', 'qfg__determine', 0, 'SELECT_BASIC', 2,
   '頂点が $(2, 1)$ で点 $(4, 9)$ を通る二次関数はどれか。',
   NULL,
   '$y = a(x - 2)^2 + 1$ に $(4, 9)$ を代入。$9 = a \cdot 4 + 1$ → $a = 2$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qfg_det_01', 'A', 'y = 2(x - 2)^2 + 1', true,  NULL, 0),
  ('drill_qfg_det_01', 'B', 'y = (x - 2)^2 + 1',  false, 'a=1と思い込み: aの計算をせずデフォルト', 1),
  ('drill_qfg_det_01', 'C', 'y = 2(x + 2)^2 + 1',  false, '頂点の符号ミス: (2,1)なのにx+2', 2),
  ('drill_qfg_det_01', 'D', 'y = 4(x - 2)^2 + 1',  false, '代入計算ミス: (4-2)^2=4 を (4-2)=2 と計算', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfg_det_02', 'qfg__determine', 1, 'TEXT_EXPRESSION', 3,
   '頂点が $(-1, 4)$ で点 $(1, -4)$ を通る二次関数を求めよ。',
   NULL,
   '$y = a(x + 1)^2 + 4$ に $(1, -4)$ を代入。$-4 = a(1+1)^2 + 4 = 4a + 4$ → $a = -2$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qfg_det_02', 'y = -2(x + 1)^2 + 4', 'y=-2(x+1)^2+4',  true,  '標準形'),
  ('drill_qfg_det_02', 'y = -2x^2 - 4x + 2',  'y=-2x^2-4x+2',   false, '展開形も正解');

-- 演習3: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfg_det_03', 'qfg__determine', 2, 'TEXT_EXPRESSION', 4,
   '3点 $(0, 3)$, $(1, 0)$, $(3, 0)$ を通る二次関数を求めよ。',
   NULL,
   'x切片が $1$ と $3$ なので $y = a(x-1)(x-3)$ と置ける。$(0, 3)$ を代入して $3 = a(-1)(-3) = 3a$ → $a = 1$。$y = (x-1)(x-3) = x^2 - 4x + 3$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qfg_det_03', 'y = x^2 - 4x + 3',  'y=x^2-4x+3',  true,  '展開形'),
  ('drill_qfg_det_03', 'y = (x - 1)(x - 3)', 'y=(x-1)(x-3)', false, '因数分解形も正解');


-- =========================================================
-- スキル2: quad_func_max_min（最大値・最小値）
-- 4パターン / 4例題 / 10演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('qfmm__no_domain',      'quad_func_max_min', '定義域なし（頂点が最大/最小）',   '頂点の値が極値',                     0),
  ('qfmm__axis_inside',    'quad_func_max_min', '定義域あり（軸が定義域内）',       '頂点＋端点の比較',                   1),
  ('qfmm__axis_outside',   'quad_func_max_min', '定義域あり（軸が定義域外）',       '端点のみで判定',                     2),
  ('qfmm__moving_domain',  'quad_func_max_min', '場合分け（定義域が動く）',         'パラメータによる場合分け',            3);


-- =============================================
-- パターン: qfmm__no_domain（定義域なし）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qfmm__no_domain', 'qfmm__no_domain',
   '二次関数 $y = 2(x - 1)^2 - 3$ の最小値を求めよ。',
   'y = 2(x - 1)^2 - 3',
   '$x = 1$ のとき最小値 $-3$',
   '下に凸（$a > 0$）なら頂点が最小値、上に凸（$a < 0$）なら頂点が最大値。定義域の制限がなければ、反対側の極値は存在しない。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qfmm__no_domain', 1, '開く向きの確認', 'a = 2 > 0',    '$a = 2 > 0$ なので下に凸 → 最小値をもつ'),
  ('ex_qfmm__no_domain', 2, '頂点の読み取り', '(1, -3)',       '頂点 $(1, -3)$'),
  ('ex_qfmm__no_domain', 3, '最小値の特定',   'x = 1, y = -3', '$x = 1$ のとき最小値 $-3$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfmm_nd_01', 'qfmm__no_domain', 0, 'SELECT_BASIC', 1,
   '$y = 3(x + 2)^2 - 5$ の最小値はどれか。',
   'y = 3(x + 2)^2 - 5',
   '$a = 3 > 0$ で下に凸。頂点 $(-2, -5)$ より、$x = -2$ のとき最小値 $-5$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qfmm_nd_01', 'A', '-5',               true,  NULL, 0),
  ('drill_qfmm_nd_01', 'B', '-2',               false, '頂点のx座標と混同', 1),
  ('drill_qfmm_nd_01', 'C', '5',                false, '符号ミス: -5を5と読む', 2),
  ('drill_qfmm_nd_01', 'D', '最小値は存在しない', false, '凸の向きを逆に判断', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfmm_nd_02', 'qfmm__no_domain', 1, 'TEXT_NUMERIC', 2,
   '$y = -x^2 + 6x - 7$ の最大値を求めよ。',
   'y = -x^2 + 6x - 7',
   '$y = -(x^2 - 6x) - 7 = -(x^2 - 6x + 9 - 9) - 7 = -(x - 3)^2 + 9 - 7 = -(x - 3)^2 + 2$。$a = -1 < 0$ で上に凸。頂点 $(3, 2)$ より、$x = 3$ のとき最大値 $2$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qfmm_nd_02', '2', '2', true, '模範解答');


-- =============================================
-- パターン: qfmm__axis_inside（軸が定義域内）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qfmm__axis_inside', 'qfmm__axis_inside',
   '$y = (x - 2)^2 - 1$（$0 \leqq x \leqq 5$）の最大値と最小値を求めよ。',
   'y = (x - 2)^2 - 1',
   '$x = 2$ のとき最小値 $-1$、$x = 5$ のとき最大値 $8$',
   '軸が定義域内のとき、最小値（下に凸の場合）は頂点。最大値は軸から遠い方の端点で取る。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qfmm__axis_inside', 1, '頂点の確認',   '(2, -1)',                       '頂点 $(2, -1)$、軸 $x = 2$ は定義域内'),
  ('ex_qfmm__axis_inside', 2, '最小値',       'f(2) = -1',                     '頂点で最小値 $-1$'),
  ('ex_qfmm__axis_inside', 3, '端点の値',     'f(0) = 3,\; f(5) = 8',          '両端点を計算'),
  ('ex_qfmm__axis_inside', 4, '最大値',       'f(5) = 8',                      '軸から遠い方の端点 $x = 5$ で最大値 $8$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfmm_ai_01', 'qfmm__axis_inside', 0, 'SELECT_BASIC', 2,
   '$y = (x - 3)^2 + 2$（$1 \leqq x \leqq 6$）の最大値はどれか。',
   'y = (x - 3)^2 + 2',
   '軸 $x = 3$ は定義域内。下に凸なので最大値は端点で取る。$f(1) = 6$、$f(6) = 11$。軸から遠い $x = 6$ で最大値 $11$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qfmm_ai_01', 'A', '11', true,  NULL, 0),
  ('drill_qfmm_ai_01', 'B', '6',  false, '近い方の端点を選択: f(1)=6', 1),
  ('drill_qfmm_ai_01', 'C', '2',  false, '最小値と混同: 頂点の値を答える', 2),
  ('drill_qfmm_ai_01', 'D', '38', false, '計算ミス: (6-3)^2を6^2=36と計算', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfmm_ai_02', 'qfmm__axis_inside', 1, 'TEXT_NUMERIC', 3,
   '$y = -2(x + 1)^2 + 10$（$-3 \leqq x \leqq 2$）の最小値を求めよ。',
   'y = -2(x + 1)^2 + 10',
   '$a = -2 < 0$ で上に凸。頂点 $(-1, 10)$、軸 $x = -1$ は定義域内。最小値は軸から遠い端点。$f(-3) = 2$、$f(2) = -8$。$x = 2$ で最小値 $-8$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qfmm_ai_02', '-8', '-8', true, '模範解答');

-- 演習3: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfmm_ai_03', 'qfmm__axis_inside', 2, 'TEXT_NUMERIC', 3,
   '$y = x^2 - 4x + 5$（$0 \leqq x \leqq 5$）の最大値と最小値の差を求めよ。',
   'y = x^2 - 4x + 5',
   '$y = (x - 2)^2 + 1$。軸 $x = 2$ は定義域内。最小値: $f(2) = 1$。端点: $f(0) = 5$、$f(5) = 10$。最大値 $10$。差: $10 - 1 = 9$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qfmm_ai_03', '9', '9', true, '模範解答');


-- =============================================
-- パターン: qfmm__axis_outside（軸が定義域外）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qfmm__axis_outside', 'qfmm__axis_outside',
   '$y = (x - 1)^2 + 3$（$3 \leqq x \leqq 6$）の最小値を求めよ。',
   'y = (x - 1)^2 + 3',
   '$x = 3$ のとき最小値 $7$',
   '軸が定義域外にあるとき、頂点で最小値は取らない。定義域内のグラフが単調増加か単調減少かを判断し、端点で最大・最小を決める。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qfmm__axis_outside', 1, '軸の位置',     'x = 1',       '軸 $x = 1$ は定義域 $[3, 6]$ の左側'),
  ('ex_qfmm__axis_outside', 2, 'グラフの形状', NULL,           '下に凸で、定義域内では単調増加'),
  ('ex_qfmm__axis_outside', 3, '最小値',       'f(3) = 7',    '左端 $f(3) = (3-1)^2 + 3 = 7$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfmm_ao_01', 'qfmm__axis_outside', 0, 'SELECT_BASIC', 2,
   '$y = (x - 5)^2 - 2$（$0 \leqq x \leqq 3$）の最小値はどれか。',
   'y = (x - 5)^2 - 2',
   '軸 $x = 5$ は定義域 $[0, 3]$ の右側。定義域内では単調減少なので、右端 $x = 3$ で最小値。$f(3) = 4 - 2 = 2$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qfmm_ao_01', 'A', '2',  true,  NULL, 0),
  ('drill_qfmm_ao_01', 'B', '-2', false, '頂点が最小と思い込み: 軸x=5は定義域外', 1),
  ('drill_qfmm_ao_01', 'C', '23', false, '逆の端点: f(0)=25-2=23（これは最大値）', 2),
  ('drill_qfmm_ao_01', 'D', '0',  false, '計算ミス: (3-5)^2=4を2と計算', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfmm_ao_02', 'qfmm__axis_outside', 1, 'TEXT_NUMERIC', 3,
   '$y = 2(x + 3)^2 - 4$（$0 \leqq x \leqq 2$）の最大値を求めよ。',
   'y = 2(x + 3)^2 - 4',
   '軸 $x = -3$ は定義域 $[0, 2]$ の左側。下に凸で定義域内は単調増加。右端で最大値。$f(2) = 2(2+3)^2 - 4 = 2 \cdot 25 - 4 = 46$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qfmm_ao_02', '46', '46', true, '模範解答');


-- =============================================
-- パターン: qfmm__moving_domain（場合分け）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qfmm__moving_domain', 'qfmm__moving_domain',
   '$y = x^2 - 2ax + 1$（$0 \leqq x \leqq 2$）の最小値を $a$ を用いて表せ。',
   'y = x^2 - 2ax + 1',
   '$a < 0$ のとき $1$、$0 \leqq a \leqq 2$ のとき $-a^2 + 1$、$a > 2$ のとき $5 - 4a$',
   '軸の位置と定義域の関係で3つに場合分けする。境界値で値が一致することを確認。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qfmm__moving_domain', 1, '平方完成',       'y = (x - a)^2 - a^2 + 1',  '軸 $x = a$'),
  ('ex_qfmm__moving_domain', 2, '場合(i) a<0',    'f(0) = 1',                  '軸が左側 → 左端で最小'),
  ('ex_qfmm__moving_domain', 3, '場合(ii) 0≦a≦2', 'f(a) = -a^2 + 1',           '軸が内側 → 頂点で最小'),
  ('ex_qfmm__moving_domain', 4, '場合(iii) a>2',   'f(2) = 5 - 4a',            '軸が右側 → 右端で最小');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfmm_md_01', 'qfmm__moving_domain', 0, 'SELECT_BASIC', 3,
   '$y = (x - a)^2$（$0 \leqq x \leqq 1$）の最小値が $0$ となる $a$ の範囲はどれか。',
   'y = (x - a)^2',
   '最小値が $0$（＝頂点の値）になるには軸 $x = a$ が定義域 $[0, 1]$ 内にある必要がある。よって $0 \leqq a \leqq 1$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qfmm_md_01', 'A', '0 \leqq a \leqq 1', true,  NULL, 0),
  ('drill_qfmm_md_01', 'B', 'a = 0',              false, '1点だけと思い込み', 1),
  ('drill_qfmm_md_01', 'C', 'a \leqq 1',          false, '左側の条件を忘れ: a<0だと軸が外', 2),
  ('drill_qfmm_md_01', 'D', 'すべての a',          false, '場合分け不要と誤解', 3);

-- 演習2: IMAGE_PROCESS
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qfmm_md_02', 'qfmm__moving_domain', 1, 'IMAGE_PROCESS', 4,
   '$y = x^2 - 4ax + 2$（$0 \leqq x \leqq 3$）の最小値を $a$ の値で場合分けして求めよ。途中の計算過程も書くこと。',
   'y = x^2 - 4ax + 2',
   '$y = (x - 2a)^2 - 4a^2 + 2$。(i) $2a < 0$ すなわち $a < 0$: $f(0) = 2$。(ii) $0 \leqq 2a \leqq 3$ すなわち $0 \leqq a \leqq \frac{3}{2}$: $f(2a) = -4a^2 + 2$。(iii) $2a > 3$ すなわち $a > \frac{3}{2}$: $f(3) = 11 - 12a$。',
   7);

INSERT INTO exercise_rubrics (exercise_id, criterion, max_points, description, sort_order) VALUES
  ('drill_qfmm_md_02', '平方完成が正しい',                          2, '$y = (x - 2a)^2 - 4a^2 + 2$ が導けているか', 0),
  ('drill_qfmm_md_02', '場合分けの境界が正しい',                    3, '$a < 0$, $0 \leqq a \leqq 3/2$, $a > 3/2$ の3場合', 1),
  ('drill_qfmm_md_02', '各場合の最小値が正しい',                    3, '各場合の最小値の式が正しいか', 2),
  ('drill_qfmm_md_02', '記述が論理的',                              2, '場合分けの理由が述べられているか', 3);


-- =========================================================
-- スキル3: quad_equation（二次方程式）
-- 3パターン / 3例題 / 8演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('qeq__factoring',     'quad_equation', '因数分解による解法',     '因数分解で解く',                   0),
  ('qeq__formula',       'quad_equation', '解の公式',              '解の公式を適用',                   1),
  ('qeq__discriminant',  'quad_equation', '判別式と解の個数',       'Dの符号で解の個数を判定',           2);


-- =============================================
-- パターン: qeq__factoring（因数分解）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qeq__factoring', 'qeq__factoring',
   '二次方程式 $x^2 - 5x + 6 = 0$ を解け。',
   'x^2 - 5x + 6 = 0',
   '$x = 2, 3$',
   '$x^2 + bx + c = 0$ で、和が $b$、積が $c$ となる2数を見つける。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qeq__factoring', 1, '因数分解',   '(x - 2)(x - 3) = 0', '和が $-5$、積が $6$ → $-2$ と $-3$'),
  ('ex_qeq__factoring', 2, '解の導出',   'x = 2, 3',           '各因数 $= 0$ とおく');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qeq_fct_01', 'qeq__factoring', 0, 'SELECT_BASIC', 1,
   '$x^2 + 3x - 10 = 0$ の解はどれか。',
   'x^2 + 3x - 10 = 0',
   '和が $3$、積が $-10$ → $5$ と $-2$。$(x + 5)(x - 2) = 0$ より $x = -5, 2$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qeq_fct_01', 'A', 'x = 2, -5',  true,  NULL, 0),
  ('drill_qeq_fct_01', 'B', 'x = -2, 5',  false, '符号が逆: 因数分解の符号を間違える', 1),
  ('drill_qeq_fct_01', 'C', 'x = 2, 5',   false, '積の符号無視: -10が負なのに両方正', 2),
  ('drill_qeq_fct_01', 'D', 'x = 1, -10', false, '和と積の取り違え', 3);

-- 演習2: TEXT_SET
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qeq_fct_02', 'qeq__factoring', 1, 'TEXT_SET', 2,
   '$2x^2 - 7x + 3 = 0$ を解け。',
   '2x^2 - 7x + 3 = 0',
   '$(2x - 1)(x - 3) = 0$ より $x = \frac{1}{2}, 3$。$a \neq 1$ のときは「たすきがけ」で因数分解する。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qeq_fct_02', 'x = \frac{1}{2}, 3', 'x=1/2,3', true,  '分数表記'),
  ('drill_qeq_fct_02', 'x = 3, 1/2',         'x=1/2,3', false, '順序逆'),
  ('drill_qeq_fct_02', 'x = 0.5, 3',         'x=0.5,3', false, '小数表記');


-- =============================================
-- パターン: qeq__formula（解の公式）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qeq__formula', 'qeq__formula',
   '$x^2 + 3x - 1 = 0$ を解の公式を用いて解け。',
   'x^2 + 3x - 1 = 0',
   '$x = \frac{-3 \pm \sqrt{13}}{2}$',
   '$x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$。判別式 $D > 0$ なら異なる2つの実数解。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qeq__formula', 1, '係数の確認', 'a = 1,\; b = 3,\; c = -1',                '$a = 1$, $b = 3$, $c = -1$'),
  ('ex_qeq__formula', 2, '判別式',    'D = 9 + 4 = 13',                           '$D = b^2 - 4ac = 9 - 4 \cdot 1 \cdot (-1) = 13$'),
  ('ex_qeq__formula', 3, '解の公式',  'x = \frac{-3 \pm \sqrt{13}}{2}',           NULL);

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qeq_frm_01', 'qeq__formula', 0, 'SELECT_BASIC', 2,
   '$x^2 - 4x + 1 = 0$ の解はどれか。',
   'x^2 - 4x + 1 = 0',
   '$a=1, b=-4, c=1$。$D = 16 - 4 = 12$。$x = \frac{4 \pm \sqrt{12}}{2} = \frac{4 \pm 2\sqrt{3}}{2} = 2 \pm \sqrt{3}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qeq_frm_01', 'A', 'x = 2 \pm \sqrt{3}',    true,  NULL, 0),
  ('drill_qeq_frm_01', 'B', 'x = 4 \pm \sqrt{3}',    false, '2aで割り忘れ: 分母の2を忘れる', 1),
  ('drill_qeq_frm_01', 'C', 'x = -2 \pm \sqrt{3}',   false, '-bの符号ミス: b=-4なのに-b=-4とする', 2),
  ('drill_qeq_frm_01', 'D', 'x = 2 \pm \sqrt{12}',   false, 'ルートの簡略化忘れ', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qeq_frm_02', 'qeq__formula', 1, 'TEXT_EXPRESSION', 3,
   '$2x^2 + 5x - 1 = 0$ を解け。',
   '2x^2 + 5x - 1 = 0',
   '$a=2, b=5, c=-1$。$D = 25 + 8 = 33$。$x = \frac{-5 \pm \sqrt{33}}{4}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qeq_frm_02', 'x = \frac{-5 \pm \sqrt{33}}{4}', 'x=\frac{-5\pm\sqrt{33}}{4}', true, '模範解答');


-- =============================================
-- パターン: qeq__discriminant（判別式）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qeq__discriminant', 'qeq__discriminant',
   '二次方程式 $x^2 - 6x + k = 0$ が異なる2つの実数解をもつとき、定数 $k$ の値の範囲を求めよ。',
   'x^2 - 6x + k = 0',
   '$k < 9$',
   '$D > 0$: 異なる2実数解、$D = 0$: 重解、$D < 0$: 実数解なし。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qeq__discriminant', 1, '判別式の計算', 'D = 36 - 4k',    '$D = (-6)^2 - 4 \cdot 1 \cdot k = 36 - 4k$'),
  ('ex_qeq__discriminant', 2, '条件',        'D > 0',           '異なる2つの実数解 → $D > 0$'),
  ('ex_qeq__discriminant', 3, '不等式を解く', '36 - 4k > 0',     '$k < 9$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qeq_dsc_01', 'qeq__discriminant', 0, 'SELECT_BASIC', 2,
   '$x^2 + 4x + k = 0$ が重解をもつとき、$k$ の値はどれか。',
   'x^2 + 4x + k = 0',
   '重解の条件: $D = 0$。$D = 4^2 - 4 \cdot 1 \cdot k = 16 - 4k = 0$ → $k = 4$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qeq_dsc_01', 'A', 'k = 4',  true,  NULL, 0),
  ('drill_qeq_dsc_01', 'B', 'k = 16', false, '4acの計算ミス: b^2=16をそのまま答える', 1),
  ('drill_qeq_dsc_01', 'C', 'k = -4', false, '符号ミス: D=0を16+4k=0と立式', 2),
  ('drill_qeq_dsc_01', 'D', 'k = 2',  false, '半分にしてしまう: b/2=2を答える', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qeq_dsc_02', 'qeq__discriminant', 1, 'TEXT_EXPRESSION', 3,
   '$2x^2 - 3x + k = 0$ が実数解をもたないとき、$k$ の値の範囲を求めよ。',
   '2x^2 - 3x + k = 0',
   '実数解なし → $D < 0$。$D = 9 - 8k < 0$ → $k > \frac{9}{8}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qeq_dsc_02', 'k > \frac{9}{8}', 'k>\frac{9}{8}', true,  '分数表記'),
  ('drill_qeq_dsc_02', 'k > 9/8',         'k>9/8',         false, 'スラッシュ表記');

-- 演習3: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qeq_dsc_03', 'qeq__discriminant', 2, 'TEXT_EXPRESSION', 3,
   '$x^2 + (k-2)x + k + 1 = 0$ が異なる2つの実数解をもつとき、$k$ の範囲を求めよ。',
   'x^2 + (k-2)x + k + 1 = 0',
   '$D = (k-2)^2 - 4(k+1) = k^2 - 4k + 4 - 4k - 4 = k^2 - 8k > 0$。$k(k - 8) > 0$ より $k < 0$ または $k > 8$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qeq_dsc_03', 'k < 0, k > 8',           'k<0,k>8', true,  '不等号表記'),
  ('drill_qeq_dsc_03', 'k < 0 または k > 8',      'k<0,k>8', false, '日本語表記');


-- =========================================================
-- スキル4: quad_inequality（二次不等式）
-- 3パターン / 3例題 / 8演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('qiq__d_positive',  'quad_inequality', '基本の二次不等式（D>0）',   '因数分解して符号を判定',              0),
  ('qiq__d_zero',      'quad_inequality', 'D=0 の場合（重解）',       '完全平方式の性質を利用',              1),
  ('qiq__d_negative',  'quad_inequality', 'D<0 の場合（実数解なし）',  '常に正/常に負の判定',                 2);


-- =============================================
-- パターン: qiq__d_positive（D>0）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qiq__d_positive', 'qiq__d_positive',
   '不等式 $x^2 - 5x + 4 > 0$ を解け。',
   'x^2 - 5x + 4 > 0',
   '$x < 1, x > 4$',
   '$a > 0$ のとき、$(x - \alpha)(x - \beta) > 0$（$\alpha < \beta$）の解は $x < \alpha, x > \beta$。グラフがx軸より上の部分。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qiq__d_positive', 1, '因数分解',      '(x - 1)(x - 4) > 0',  NULL),
  ('ex_qiq__d_positive', 2, '方程式の解',    'x = 1, 4',             '対応する方程式の解'),
  ('ex_qiq__d_positive', 3, '符号を調べる',  'x < 1, x > 4',         '$> 0$ なので外側');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qiq_dp_01', 'qiq__d_positive', 0, 'SELECT_BASIC', 1,
   '$x^2 - 3x - 10 < 0$ の解はどれか。',
   'x^2 - 3x - 10 < 0',
   '$(x + 2)(x - 5) < 0$。$\alpha = -2, \beta = 5$。$< 0$ なので内側: $-2 < x < 5$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qiq_dp_01', 'A', '-2 < x < 5',    true,  NULL, 0),
  ('drill_qiq_dp_01', 'B', 'x < -2, x > 5', false, '不等号の向きを逆: <0なのに外側を選ぶ', 1),
  ('drill_qiq_dp_01', 'C', '2 < x < 5',     false, '因数分解の符号ミス: x+2=0をx=2とする', 2),
  ('drill_qiq_dp_01', 'D', '-5 < x < 2',    false, '解の順序を逆: αとβを入れ替え', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qiq_dp_02', 'qiq__d_positive', 1, 'TEXT_EXPRESSION', 2,
   '$x^2 + 2x - 8 \geqq 0$ を解け。',
   'x^2 + 2x - 8 \geqq 0',
   '$(x + 4)(x - 2) \geqq 0$。$\geqq 0$ なので外側（等号含む）: $x \leqq -4$ または $x \geqq 2$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qiq_dp_02', 'x \leqq -4, x \geqq 2', 'x\leqq-4,x\geqq2', true,  'LaTeX表記'),
  ('drill_qiq_dp_02', 'x ≦ -4, x ≧ 2',         'x\leqq-4,x\geqq2', false, 'Unicode表記');

-- 演習3: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qiq_dp_03', 'qiq__d_positive', 2, 'TEXT_EXPRESSION', 3,
   '$2x^2 - 3x - 2 > 0$ を解け。',
   '2x^2 - 3x - 2 > 0',
   '$(2x + 1)(x - 2) > 0$。解は $x = -\frac{1}{2}, 2$。$> 0$ で外側: $x < -\frac{1}{2}$ または $x > 2$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qiq_dp_03', 'x < -\frac{1}{2}, x > 2', 'x<-\frac{1}{2},x>2', true,  '分数表記'),
  ('drill_qiq_dp_03', 'x < -0.5, x > 2',         'x<-0.5,x>2',         false, '小数表記');


-- =============================================
-- パターン: qiq__d_zero（D=0 重解）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qiq__d_zero', 'qiq__d_zero',
   '不等式 $x^2 - 6x + 9 \leqq 0$ を解け。',
   'x^2 - 6x + 9 \leqq 0',
   '$x = 3$',
   '完全平方式 $(x - \alpha)^2$ は常に $\geqq 0$。$\leqq 0$ なら $x = \alpha$ のみ、$< 0$ なら解なし。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qiq__d_zero', 1, '因数分解', '(x - 3)^2 \leqq 0',                NULL),
  ('ex_qiq__d_zero', 2, '考察',    '(x - 3)^2 \geqq 0 \text{ は常に成立}', '$(x-3)^2 = 0$ となるのは $x = 3$ のみ'),
  ('ex_qiq__d_zero', 3, '解',      'x = 3',                              NULL);

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qiq_dz_01', 'qiq__d_zero', 0, 'SELECT_BASIC', 2,
   '$x^2 + 4x + 4 > 0$ の解はどれか。',
   'x^2 + 4x + 4 > 0',
   '$(x + 2)^2 > 0$。$(x + 2)^2 = 0$ となる $x = -2$ を除き、すべての実数で成立。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qiq_dz_01', 'A', 'x \neq -2 であるすべての実数', true,  NULL, 0),
  ('drill_qiq_dz_01', 'B', 'すべての実数',                  false, '等号を見落とし: x=-2で0になることを忘れる', 1),
  ('drill_qiq_dz_01', 'C', 'x > -2',                        false, '一次不等式と混同: 二次なのに片側だけ', 2),
  ('drill_qiq_dz_01', 'D', '解なし',                         false, '≦と>の混同: 逆の不等式の結果', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qiq_dz_02', 'qiq__d_zero', 1, 'TEXT_EXPRESSION', 3,
   '$4x^2 - 12x + 9 \leqq 0$ を解け。',
   '4x^2 - 12x + 9 \leqq 0',
   '$(2x - 3)^2 \leqq 0$。$(2x - 3)^2 \geqq 0$ は常に成立。$= 0$ は $x = \frac{3}{2}$ のみ。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qiq_dz_02', 'x = \frac{3}{2}', 'x=\frac{3}{2}', true,  '分数表記'),
  ('drill_qiq_dz_02', 'x = 3/2',         'x=3/2',         false, 'スラッシュ表記'),
  ('drill_qiq_dz_02', 'x = 1.5',         'x=1.5',         false, '小数表記');


-- =============================================
-- パターン: qiq__d_negative（D<0）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_qiq__d_negative', 'qiq__d_negative',
   '不等式 $x^2 + 2x + 5 > 0$ を解け。',
   'x^2 + 2x + 5 > 0',
   'すべての実数',
   '$D < 0$ かつ $a > 0$ なら常に正。$D < 0$ かつ $a < 0$ なら常に負。不等式の向きと $a$ の符号で解が「すべての実数」か「解なし」かが決まる。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_qiq__d_negative', 1, '判別式',       'D = 4 - 20 = -16 < 0', '$D < 0$'),
  ('ex_qiq__d_negative', 2, 'グラフの位置', 'a = 1 > 0',            '下に凸で $x$ 軸と交わらない → 常にグラフは $x$ 軸の上'),
  ('ex_qiq__d_negative', 3, '解',          '\text{すべての実数}',    NULL);

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qiq_dn_01', 'qiq__d_negative', 0, 'SELECT_BASIC', 2,
   '$x^2 - 3x + 4 < 0$ の解はどれか。',
   'x^2 - 3x + 4 < 0',
   '$D = (-3)^2 - 4 \cdot 4 = 9 - 16 = -7 < 0$。$a = 1 > 0$ で常に正。$< 0$ を満たす $x$ はない。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_qiq_dn_01', 'A', '解なし',        true,  NULL, 0),
  ('drill_qiq_dn_01', 'B', 'すべての実数',   false, '不等号の向き: >0ならすべての実数だが<0は解なし', 1),
  ('drill_qiq_dn_01', 'C', '\frac{3 - \sqrt{7}}{2} < x < \frac{3 + \sqrt{7}}{2}', false, 'D<0に気づかず解の公式を適用', 2),
  ('drill_qiq_dn_01', 'D', 'x = \frac{3}{2}', false, '頂点のみと混同: D=0の場合の解', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_qiq_dn_02', 'qiq__d_negative', 1, 'TEXT_EXPRESSION', 3,
   '$-x^2 + 2x - 3 \leqq 0$ を解け。',
   '-x^2 + 2x - 3 \leqq 0',
   '両辺に $-1$ をかけて $x^2 - 2x + 3 \geqq 0$。$D = 4 - 12 = -8 < 0$、$a = 1 > 0$ で常に正。よって $\geqq 0$ はすべての実数で成立。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_qiq_dn_02', 'すべての実数', 'すべての実数', true,  '模範解答'),
  ('drill_qiq_dn_02', '全ての実数',   'すべての実数', false, '漢字表記'),
  ('drill_qiq_dn_02', '任意の実数',   'すべての実数', false, '別表現');


COMMIT;
