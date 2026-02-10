-- ============================================================
-- シードデータ: 三角比ユニット（数学I）
-- 7スキル / 20パターン / 20例題 / 56演習
-- ============================================================

BEGIN;

-- =========================
-- Skills（7スキル）
-- =========================

INSERT INTO skills (id, subject, unit_name, subunit_name, display_name, description, sort_order) VALUES
  ('trig_ratio_basic',   'math_1', '三角比', '三角比の定義',       '三角比の定義',       '直角三角形におけるsinθ, cosθ, tanθの定義と辺の長さの計算', 20),
  ('trig_ratio_special', 'math_1', '三角比', '特殊角の三角比',     '特殊角の三角比',     '30°, 45°, 60°の三角比の値と計算',                          21),
  ('trig_identity',      'math_1', '三角比', '三角比の相互関係',   '三角比の相互関係',   'sin²θ+cos²θ=1, tanθ=sinθ/cosθ 等の公式利用',               22),
  ('trig_obtuse',        'math_1', '三角比', '鈍角の三角比',       '鈍角の三角比',       '0°〜180°への拡張・単位円・補角の関係',                      23),
  ('trig_sine_rule',     'math_1', '三角比', '正弦定理',           '正弦定理',           'a/sinA = b/sinB = c/sinC = 2R の利用',                     24),
  ('trig_cosine_rule',   'math_1', '三角比', '余弦定理',           '余弦定理',           'a² = b² + c² - 2bc cosA の利用',                           25),
  ('trig_area',          'math_1', '三角比', '三角形の面積',       '三角形の面積',       'S = (1/2)ab sinC, ヘロンの公式',                            26);


-- =========================
-- スキル依存関係
-- =========================

INSERT INTO skill_dependencies (prerequisite_id, dependent_id, dependency_type) VALUES
  ('trig_ratio_basic',   'trig_ratio_special', 'required'),
  ('trig_ratio_special', 'trig_identity',      'required'),
  ('trig_identity',      'trig_obtuse',        'required'),
  ('trig_obtuse',        'trig_sine_rule',     'required'),
  ('trig_obtuse',        'trig_cosine_rule',   'required'),
  ('trig_sine_rule',     'trig_area',          'required'),
  ('trig_cosine_rule',   'trig_area',          'required'),
  -- cross-unit: 余弦定理で二次方程式を使う
  ('quad_equation',      'trig_cosine_rule',   'recommended');


-- =========================================================
-- スキル1: trig_ratio_basic（三角比の定義）
-- 3パターン / 3例題 / 8演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('trb__definition', 'trig_ratio_basic', '直角三角形からsin/cos/tanを求める', '辺の比から三角比を読み取る',                       0),
  ('trb__find_side',  'trig_ratio_basic', '三角比から辺の長さを求める',         'sin/cos/tanの値と1辺から他の辺を計算',             1),
  ('trb__find_ratio', 'trig_ratio_basic', '三平方の定理との組合せ',             '2辺既知→第3辺を求めてから三角比を計算',            2);


-- =============================================
-- パターン: trb__definition（定義）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_trb__definition', 'trb__definition',
   '直角三角形ABCで、$\angle C = 90°$、$AB = 5$、$BC = 3$、$CA = 4$ のとき、$\sin A$、$\cos A$、$\tan A$ の値を求めよ。',
   NULL,
   '$\sin A = \frac{3}{5}$、$\cos A = \frac{4}{5}$、$\tan A = \frac{3}{4}$',
   '$\sin A = \frac{\text{対辺}}{\text{斜辺}}$、$\cos A = \frac{\text{隣辺}}{\text{斜辺}}$、$\tan A = \frac{\text{対辺}}{\text{隣辺}}$。どの辺が「対辺」「隣辺」「斜辺」かを角に対して正しく判断することが重要。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_trb__definition', 1, '辺の確認',     'AB = 5,\; BC = 3,\; CA = 4', '$\angle C = 90°$ なので斜辺は $AB = 5$。$\angle A$ に対して対辺は $BC = 3$、隣辺は $CA = 4$。'),
  ('ex_trb__definition', 2, 'sinAの計算',   '\sin A = \frac{BC}{AB} = \frac{3}{5}', '$\sin A = \frac{\text{対辺}}{\text{斜辺}}$'),
  ('ex_trb__definition', 3, 'cosAの計算',   '\cos A = \frac{CA}{AB} = \frac{4}{5}', '$\cos A = \frac{\text{隣辺}}{\text{斜辺}}$'),
  ('ex_trb__definition', 4, 'tanAの計算',   '\tan A = \frac{BC}{CA} = \frac{3}{4}', '$\tan A = \frac{\text{対辺}}{\text{隣辺}}$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trb_def_01', 'trb__definition', 0, 'SELECT_BASIC', 1,
   '直角三角形ABCで $\angle C = 90°$、$AB = 13$、$BC = 5$、$CA = 12$ のとき、$\sin A$ はどれか。',
   NULL,
   '$\angle A$ の対辺は $BC = 5$、斜辺は $AB = 13$。$\sin A = \frac{\text{対辺}}{\text{斜辺}} = \frac{5}{13}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_trb_def_01', 'A', '\frac{5}{13}',  true,  NULL, 0),
  ('drill_trb_def_01', 'B', '\frac{12}{13}', false, 'cosAと混同: 隣辺/斜辺を計算', 1),
  ('drill_trb_def_01', 'C', '\frac{5}{12}',  false, 'tanAと混同: 対辺/隣辺を計算', 2),
  ('drill_trb_def_01', 'D', '\frac{13}{5}',  false, '逆数: 斜辺/対辺を計算', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trb_def_02', 'trb__definition', 1, 'TEXT_NUMERIC', 2,
   '直角三角形ABCで $\angle C = 90°$、$AB = 10$、$BC = 6$、$CA = 8$ のとき、$\tan A$ の値を求めよ。',
   NULL,
   '$\angle A$ の対辺は $BC = 6$、隣辺は $CA = 8$。$\tan A = \frac{6}{8} = \frac{3}{4}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_trb_def_02', '\frac{3}{4}', '3/4', true,  '約分済み分数'),
  ('drill_trb_def_02', '0.75',        '0.75', false, '小数表記'),
  ('drill_trb_def_02', '\frac{6}{8}', '3/4',  false, '約分前');

-- 演習3: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trb_def_03', 'trb__definition', 2, 'TEXT_NUMERIC', 3,
   '直角三角形ABCで $\angle C = 90°$、$AB = 17$、$BC = 8$、$CA = 15$ のとき、$\cos A$ の値を求めよ。',
   NULL,
   '$\angle A$ の隣辺は $CA = 15$、斜辺は $AB = 17$。$\cos A = \frac{15}{17}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_trb_def_03', '\frac{15}{17}', '15/17', true,  '分数'),
  ('drill_trb_def_03', '0.882',         '0.882', false, '小数近似（3桁）');


-- =============================================
-- パターン: trb__find_side（辺の長さを求める）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_trb__find_side', 'trb__find_side',
   '直角三角形ABCで $\angle C = 90°$、$\angle A = \theta$、$AB = 10$、$\sin \theta = \frac{3}{5}$ のとき、$BC$ の長さを求めよ。',
   NULL,
   '$BC = 6$',
   '$\sin \theta = \frac{BC}{AB}$ の関係式から $BC = AB \times \sin \theta$ と変形する。三角比の定義式を「辺を求める式」に読み替えるのがポイント。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_trb__find_side', 1, '関係式の立式',   '\sin \theta = \frac{BC}{AB}', '$\sin \theta = \frac{\text{対辺}}{\text{斜辺}} = \frac{BC}{AB}$'),
  ('ex_trb__find_side', 2, '値の代入',       '\frac{3}{5} = \frac{BC}{10}', '$\sin \theta = \frac{3}{5}$、$AB = 10$ を代入'),
  ('ex_trb__find_side', 3, '辺の計算',       'BC = 10 \times \frac{3}{5} = 6', '両辺に $10$ をかけて $BC = 6$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trb_fs_01', 'trb__find_side', 0, 'SELECT_BASIC', 1,
   '直角三角形ABCで $\angle C = 90°$、$AB = 20$、$\cos A = \frac{4}{5}$ のとき、$CA$ の長さはどれか。',
   NULL,
   '$\cos A = \frac{CA}{AB}$ より $\frac{4}{5} = \frac{CA}{20}$。$CA = 20 \times \frac{4}{5} = 16$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_trb_fs_01', 'A', '16', true,  NULL, 0),
  ('drill_trb_fs_01', 'B', '12', false, 'sinAで計算: 対辺と隣辺を取り違え', 1),
  ('drill_trb_fs_01', 'C', '25', false, '20÷(4/5)と逆に計算', 2),
  ('drill_trb_fs_01', 'D', '15', false, 'tanAと混同して計算', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trb_fs_02', 'trb__find_side', 1, 'TEXT_NUMERIC', 2,
   '直角三角形ABCで $\angle C = 90°$、$BC = 9$、$\tan A = \frac{3}{4}$ のとき、$CA$ の長さを求めよ。',
   NULL,
   '$\tan A = \frac{BC}{CA}$ より $\frac{3}{4} = \frac{9}{CA}$。$CA = 9 \times \frac{4}{3} = 12$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_trb_fs_02', '12', '12', true, '整数');


-- =============================================
-- パターン: trb__find_ratio（三平方の定理との組合せ）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_trb__find_ratio', 'trb__find_ratio',
   '直角三角形ABCで $\angle C = 90°$、$AB = 5$、$BC = 3$ のとき、$\cos A$ の値を求めよ。',
   NULL,
   '$\cos A = \frac{4}{5}$',
   '3辺のうち2辺しか分からないとき、まず三平方の定理 $AB^2 = BC^2 + CA^2$ で残りの辺を求めてから三角比を計算する。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_trb__find_ratio', 1, '不足辺の特定',   'CA = ?', '$CA$ が不明。三平方の定理で求める。'),
  ('ex_trb__find_ratio', 2, '三平方の定理',   'CA^2 = AB^2 - BC^2 = 25 - 9 = 16', '$CA^2 = 5^2 - 3^2 = 16$'),
  ('ex_trb__find_ratio', 3, '辺の計算',       'CA = 4', '$CA = \sqrt{16} = 4$'),
  ('ex_trb__find_ratio', 4, 'cosAの計算',     '\cos A = \frac{CA}{AB} = \frac{4}{5}', '$\cos A = \frac{\text{隣辺}}{\text{斜辺}} = \frac{4}{5}$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trb_fr_01', 'trb__find_ratio', 0, 'SELECT_BASIC', 2,
   '直角三角形ABCで $\angle C = 90°$、$AB = 10$、$CA = 6$ のとき、$\sin A$ はどれか。',
   NULL,
   '$BC^2 = AB^2 - CA^2 = 100 - 36 = 64$ より $BC = 8$。$\sin A = \frac{BC}{AB} = \frac{8}{10} = \frac{4}{5}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_trb_fr_01', 'A', '\frac{4}{5}',  true,  NULL, 0),
  ('drill_trb_fr_01', 'B', '\frac{3}{5}',  false, 'CA/ABを計算: cosAと混同', 1),
  ('drill_trb_fr_01', 'C', '\frac{4}{3}',  false, 'BC/CAを計算: tanAと混同', 2),
  ('drill_trb_fr_01', 'D', '\frac{8}{6}',  false, '約分忘れ', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trb_fr_02', 'trb__find_ratio', 1, 'TEXT_NUMERIC', 3,
   '直角三角形ABCで $\angle C = 90°$、$BC = 7$、$CA = 24$ のとき、$\sin A$ の値を求めよ。',
   NULL,
   '$AB^2 = BC^2 + CA^2 = 49 + 576 = 625$ より $AB = 25$。$\sin A = \frac{BC}{AB} = \frac{7}{25}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_trb_fr_02', '\frac{7}{25}', '7/25', true,  '分数'),
  ('drill_trb_fr_02', '0.28',         '0.28', false, '小数');

-- 演習3: IMAGE_PROCESS
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trb_fr_03', 'trb__find_ratio', 2, 'IMAGE_PROCESS', 4,
   '直角三角形ABCで $\angle C = 90°$、$AB = \sqrt{13}$、$BC = 2$ のとき、$\sin A$、$\cos A$、$\tan A$ の値をすべて求めよ。途中式も書くこと。',
   NULL,
   '$CA^2 = AB^2 - BC^2 = 13 - 4 = 9$ より $CA = 3$。$\sin A = \frac{2}{\sqrt{13}} = \frac{2\sqrt{13}}{13}$、$\cos A = \frac{3}{\sqrt{13}} = \frac{3\sqrt{13}}{13}$、$\tan A = \frac{2}{3}$。',
   5);

INSERT INTO exercise_rubrics (exercise_id, criterion, max_points, description, sort_order) VALUES
  ('drill_trb_fr_03', '三平方の定理でCAを求める',       2, 'CA² = 13 - 4 = 9 → CA = 3 の計算が正しい', 0),
  ('drill_trb_fr_03', 'sinA, cosA, tanAの立式',          2, '対辺/斜辺, 隣辺/斜辺, 対辺/隣辺の各立式が正しい', 1),
  ('drill_trb_fr_03', '分母の有理化',                    1, '√13を含む分数を有理化している（有理化なしでも部分点）', 2);


-- =========================================================
-- スキル2: trig_ratio_special（特殊角の三角比）
-- 2パターン / 2例題 / 6演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('trs__value',     'trig_ratio_special', '30°/45°/60°の三角比の値',   '特殊角の三角比を即答する',                    0),
  ('trs__calculate', 'trig_ratio_special', '特殊角を含む式の計算',       'sin30°+cos60° のような複合式を計算する',       1);


-- =============================================
-- パターン: trs__value（特殊角の値）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_trs__value', 'trs__value',
   '$\sin 30°$、$\cos 30°$、$\tan 30°$ の値をそれぞれ求めよ。',
   NULL,
   '$\sin 30° = \frac{1}{2}$、$\cos 30° = \frac{\sqrt{3}}{2}$、$\tan 30° = \frac{1}{\sqrt{3}} = \frac{\sqrt{3}}{3}$',
   '30°-60°-90°の直角三角形は辺の比が $1 : 2 : \sqrt{3}$（短辺:斜辺:長辺）。この比を覚えれば全ての三角比を導ける。45°-45°-90°は $1 : \sqrt{2} : 1$。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_trs__value', 1, '直角三角形の辺の比', '1 : 2 : \sqrt{3}', '30°-60°-90°の三角形：30°の対辺が1、斜辺が2、60°の対辺が$\sqrt{3}$'),
  ('ex_trs__value', 2, 'sin30°',             '\sin 30° = \frac{1}{2}', '対辺/斜辺 = $\frac{1}{2}$'),
  ('ex_trs__value', 3, 'cos30°',             '\cos 30° = \frac{\sqrt{3}}{2}', '隣辺/斜辺 = $\frac{\sqrt{3}}{2}$'),
  ('ex_trs__value', 4, 'tan30°',             '\tan 30° = \frac{1}{\sqrt{3}} = \frac{\sqrt{3}}{3}', '対辺/隣辺。分母を有理化すると $\frac{\sqrt{3}}{3}$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trs_val_01', 'trs__value', 0, 'SELECT_BASIC', 1,
   '$\cos 60°$ の値はどれか。',
   '\cos 60°',
   '30°-60°-90°の直角三角形で、60°の隣辺は1、斜辺は2。$\cos 60° = \frac{1}{2}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_trs_val_01', 'A', '\frac{1}{2}',         true,  NULL, 0),
  ('drill_trs_val_01', 'B', '\frac{\sqrt{3}}{2}',  false, 'sin60°と混同', 1),
  ('drill_trs_val_01', 'C', '1',                    false, 'cos0°と混同', 2),
  ('drill_trs_val_01', 'D', '\frac{\sqrt{2}}{2}',  false, 'cos45°と混同', 3);

-- 演習2: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trs_val_02', 'trs__value', 1, 'SELECT_BASIC', 1,
   '$\tan 45°$ の値はどれか。',
   '\tan 45°',
   '45°-45°-90°の直角三角形は辺の比が $1 : 1 : \sqrt{2}$。$\tan 45° = \frac{1}{1} = 1$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_trs_val_02', 'A', '1',                   true,  NULL, 0),
  ('drill_trs_val_02', 'B', '\frac{\sqrt{2}}{2}',  false, 'sin45°と混同', 1),
  ('drill_trs_val_02', 'C', '\sqrt{2}',            false, '1/sin45°を計算', 2),
  ('drill_trs_val_02', 'D', '0',                   false, 'tan0°と混同', 3);

-- 演習3: SELECT_MULTI
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trs_val_03', 'trs__value', 2, 'SELECT_MULTI', 2,
   '次のうち、値が $\frac{\sqrt{3}}{2}$ であるものをすべて選べ。',
   '\frac{\sqrt{3}}{2}',
   '$\sin 60° = \frac{\sqrt{3}}{2}$、$\cos 30° = \frac{\sqrt{3}}{2}$。$\sin 30° = \frac{1}{2}$、$\cos 45° = \frac{\sqrt{2}}{2}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_trs_val_03', 'A', '\sin 60°',  true,  NULL, 0),
  ('drill_trs_val_03', 'B', '\cos 30°',  true,  NULL, 1),
  ('drill_trs_val_03', 'C', '\sin 30°',  false, '値は1/2: sin30°=√3/2 と誤記憶', 2),
  ('drill_trs_val_03', 'D', '\cos 45°',  false, '値は√2/2: 45°と30°/60°を混同', 3);


-- =============================================
-- パターン: trs__calculate（式の計算）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_trs__calculate', 'trs__calculate',
   '$\sin^2 60° + \cos^2 60°$ の値を求めよ。',
   '\sin^2 60° + \cos^2 60°',
   '$1$',
   '各値を代入して計算しても $\left(\frac{\sqrt{3}}{2}\right)^2 + \left(\frac{1}{2}\right)^2 = \frac{3}{4} + \frac{1}{4} = 1$ と求まるが、$\sin^2\theta + \cos^2\theta = 1$ を使えば即答できる。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_trs__calculate', 1, '各値の確認',   '\sin 60° = \frac{\sqrt{3}}{2},\; \cos 60° = \frac{1}{2}', '特殊角の値を代入'),
  ('ex_trs__calculate', 2, '二乗の計算',   '\left(\frac{\sqrt{3}}{2}\right)^2 + \left(\frac{1}{2}\right)^2 = \frac{3}{4} + \frac{1}{4}', '各項を二乗'),
  ('ex_trs__calculate', 3, '合計',         '= 1', '$\sin^2\theta + \cos^2\theta = 1$ が成り立つ');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trs_calc_01', 'trs__calculate', 0, 'SELECT_BASIC', 2,
   '$\sin 30° + \cos 60°$ の値はどれか。',
   '\sin 30° + \cos 60°',
   '$\sin 30° = \frac{1}{2}$、$\cos 60° = \frac{1}{2}$。よって $\frac{1}{2} + \frac{1}{2} = 1$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_trs_calc_01', 'A', '1',                   true,  NULL, 0),
  ('drill_trs_calc_01', 'B', '\frac{1}{2}',         false, '一方しか足していない', 1),
  ('drill_trs_calc_01', 'C', '\sqrt{3}',            false, 'sin60°+cos30°と混同', 2),
  ('drill_trs_calc_01', 'D', '\frac{1+\sqrt{3}}{2}', false, 'sin30°=1/2, cos60°=√3/2 と誤認', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trs_calc_02', 'trs__calculate', 1, 'TEXT_NUMERIC', 2,
   '$2\sin 45° \cos 45°$ の値を求めよ。',
   '2\sin 45° \cos 45°',
   '$\sin 45° = \cos 45° = \frac{\sqrt{2}}{2}$。$2 \times \frac{\sqrt{2}}{2} \times \frac{\sqrt{2}}{2} = 2 \times \frac{2}{4} = 1$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_trs_calc_02', '1', '1', true, '整数');

-- 演習3: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_trs_calc_03', 'trs__calculate', 2, 'TEXT_NUMERIC', 3,
   '$\tan 60° - \tan 30°$ の値を求めよ。',
   '\tan 60° - \tan 30°',
   '$\tan 60° = \sqrt{3}$、$\tan 30° = \frac{\sqrt{3}}{3}$。$\sqrt{3} - \frac{\sqrt{3}}{3} = \frac{3\sqrt{3} - \sqrt{3}}{3} = \frac{2\sqrt{3}}{3}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_trs_calc_03', '\frac{2\sqrt{3}}{3}', '2sqrt(3)/3', true, '有理化済み分数'),
  ('drill_trs_calc_03', '\frac{2}{\sqrt{3}}',  '2sqrt(3)/3', false, '有理化前');


-- =========================================================
-- スキル3: trig_identity（三角比の相互関係）
-- 3パターン / 3例題 / 9演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('tri__pythagorean',   'trig_identity', 'sin²θ+cos²θ=1の利用',   'sinθまたはcosθの一方から他方を求める',         0),
  ('tri__tan_relation',  'trig_identity', 'tanθ=sinθ/cosθの利用',  'tanθとsin/cosの相互変換',                      1),
  ('tri__transform',     'trig_identity', '式の値を求める',         'sinθの値等が与えられ、三角比を含む式を計算',    2);


-- =============================================
-- パターン: tri__pythagorean（ピタゴラス恒等式）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tri__pythagorean', 'tri__pythagorean',
   '$0° < \theta < 90°$ で $\sin \theta = \frac{3}{5}$ のとき、$\cos \theta$ の値を求めよ。',
   '\sin \theta = \frac{3}{5}',
   '$\cos \theta = \frac{4}{5}$',
   '$\sin^2\theta + \cos^2\theta = 1$ に代入すれば $\cos^2\theta$ が求まる。鋭角なら $\cos\theta > 0$ なので正の平方根をとる。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tri__pythagorean', 1, '公式に代入',     '\left(\frac{3}{5}\right)^2 + \cos^2\theta = 1', '$\sin^2\theta + \cos^2\theta = 1$ に $\sin\theta = \frac{3}{5}$ を代入'),
  ('ex_tri__pythagorean', 2, 'cos²θの計算',    '\cos^2\theta = 1 - \frac{9}{25} = \frac{16}{25}', '移項して計算'),
  ('ex_tri__pythagorean', 3, '符号の決定',     '\cos\theta = \frac{4}{5}', '$0° < \theta < 90°$ より $\cos\theta > 0$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tri_pyth_01', 'tri__pythagorean', 0, 'SELECT_BASIC', 2,
   '$0° < \theta < 90°$ で $\cos \theta = \frac{5}{13}$ のとき、$\sin \theta$ はどれか。',
   '\cos \theta = \frac{5}{13}',
   '$\sin^2\theta = 1 - \left(\frac{5}{13}\right)^2 = 1 - \frac{25}{169} = \frac{144}{169}$。$\sin\theta > 0$ より $\sin\theta = \frac{12}{13}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tri_pyth_01', 'A', '\frac{12}{13}', true,  NULL, 0),
  ('drill_tri_pyth_01', 'B', '\frac{8}{13}',  false, '分子を√(169-25)=√144=12ではなく13-5=8と計算', 1),
  ('drill_tri_pyth_01', 'C', '\frac{5}{12}',  false, 'tanθと混同', 2),
  ('drill_tri_pyth_01', 'D', '\frac{12}{5}',  false, 'tanθの値: sinθ/cosθ を誤ってsinθとした', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tri_pyth_02', 'tri__pythagorean', 1, 'TEXT_NUMERIC', 2,
   '$0° < \theta < 90°$ で $\sin \theta = \frac{1}{3}$ のとき、$\cos \theta$ の値を求めよ。',
   '\sin \theta = \frac{1}{3}',
   '$\cos^2\theta = 1 - \frac{1}{9} = \frac{8}{9}$。$\cos\theta > 0$ より $\cos\theta = \frac{2\sqrt{2}}{3}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tri_pyth_02', '\frac{2\sqrt{2}}{3}', '2sqrt(2)/3', true,  '有理化済み'),
  ('drill_tri_pyth_02', '\frac{\sqrt{8}}{3}',  '2sqrt(2)/3', false, '√8を簡約化前');

-- 演習3: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tri_pyth_03', 'tri__pythagorean', 2, 'TEXT_NUMERIC', 3,
   '$90° < \theta < 180°$ で $\sin \theta = \frac{5}{13}$ のとき、$\cos \theta$ の値を求めよ。',
   '\sin \theta = \frac{5}{13}',
   '$\cos^2\theta = 1 - \frac{25}{169} = \frac{144}{169}$。$90° < \theta < 180°$ より $\cos\theta < 0$。$\cos\theta = -\frac{12}{13}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tri_pyth_03', '-\frac{12}{13}', '-12/13', true, '負の値（鈍角）');


-- =============================================
-- パターン: tri__tan_relation（tanθ=sinθ/cosθ）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tri__tan_relation', 'tri__tan_relation',
   '$\sin \theta = \frac{4}{5}$、$\cos \theta = \frac{3}{5}$ のとき、$\tan \theta$ の値を求めよ。',
   NULL,
   '$\tan \theta = \frac{4}{3}$',
   '$\tan\theta = \frac{\sin\theta}{\cos\theta}$ に代入するだけ。sinθとcosθが既知のときにtanθを求める基本パターン。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tri__tan_relation', 1, '公式',     '\tan\theta = \frac{\sin\theta}{\cos\theta}', '$\tan\theta$ の定義式'),
  ('ex_tri__tan_relation', 2, '代入',     '\tan\theta = \frac{\frac{4}{5}}{\frac{3}{5}} = \frac{4}{3}', '分数の割り算で計算');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tri_tan_01', 'tri__tan_relation', 0, 'SELECT_BASIC', 1,
   '$\sin \theta = \frac{5}{13}$、$\cos \theta = \frac{12}{13}$ のとき、$\tan \theta$ はどれか。',
   NULL,
   '$\tan\theta = \frac{\sin\theta}{\cos\theta} = \frac{5/13}{12/13} = \frac{5}{12}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tri_tan_01', 'A', '\frac{5}{12}',  true,  NULL, 0),
  ('drill_tri_tan_01', 'B', '\frac{12}{5}',  false, '逆数: cosθ/sinθを計算', 1),
  ('drill_tri_tan_01', 'C', '\frac{5}{13}',  false, 'sinθをそのまま答えた', 2),
  ('drill_tri_tan_01', 'D', '\frac{7}{13}',  false, 'sinθ+cosθ的な計算ミス', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tri_tan_02', 'tri__tan_relation', 1, 'TEXT_NUMERIC', 2,
   '$0° < \theta < 90°$ で $\tan \theta = 2$ のとき、$\sin \theta$ の値を求めよ。',
   '\tan \theta = 2',
   '$\tan\theta = 2$ より $\sin\theta = 2\cos\theta$。$\sin^2\theta + \cos^2\theta = 1$ に代入すると $4\cos^2\theta + \cos^2\theta = 1$ → $\cos^2\theta = \frac{1}{5}$。$\cos\theta = \frac{1}{\sqrt{5}}$、$\sin\theta = \frac{2}{\sqrt{5}} = \frac{2\sqrt{5}}{5}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tri_tan_02', '\frac{2\sqrt{5}}{5}', '2sqrt(5)/5', true,  '有理化済み'),
  ('drill_tri_tan_02', '\frac{2}{\sqrt{5}}',  '2sqrt(5)/5', false, '有理化前');

-- 演習3: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tri_tan_03', 'tri__tan_relation', 2, 'TEXT_NUMERIC', 3,
   '$0° < \theta < 90°$ で $\tan \theta = \frac{3}{4}$ のとき、$\cos \theta$ の値を求めよ。',
   '\tan \theta = \frac{3}{4}',
   '$\sin\theta = \frac{3}{4}\cos\theta$。$\frac{9}{16}\cos^2\theta + \cos^2\theta = 1$ → $\frac{25}{16}\cos^2\theta = 1$ → $\cos^2\theta = \frac{16}{25}$。$\cos\theta = \frac{4}{5}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tri_tan_03', '\frac{4}{5}', '4/5', true,  '分数'),
  ('drill_tri_tan_03', '0.8',         '0.8', false, '小数');


-- =============================================
-- パターン: tri__transform（式の値を求める）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tri__transform', 'tri__transform',
   '$\sin \theta = \frac{2}{3}$（$0° < \theta < 90°$）のとき、$\cos^2\theta + 3\sin\theta$ の値を求めよ。',
   '\cos^2\theta + 3\sin\theta',
   '$\frac{23}{9}$',
   '$\cos^2\theta$ を $1 - \sin^2\theta$ に置き換えれば、すべて $\sin\theta$ で表せる。複数の三角比が混在する式は、1種類に統一するのが鉄則。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tri__transform', 1, 'cos²θの変換',   '\cos^2\theta = 1 - \sin^2\theta = 1 - \frac{4}{9} = \frac{5}{9}', '$\sin^2\theta + \cos^2\theta = 1$ を利用'),
  ('ex_tri__transform', 2, '式に代入',       '\frac{5}{9} + 3 \times \frac{2}{3}', '$\cos^2\theta$ と $\sin\theta$ に値を代入'),
  ('ex_tri__transform', 3, '計算',           '\frac{5}{9} + 2 = \frac{5}{9} + \frac{18}{9} = \frac{23}{9}', '通分して計算');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tri_tf_01', 'tri__transform', 0, 'SELECT_BASIC', 2,
   '$\sin \theta = \frac{1}{2}$（$0° < \theta < 90°$）のとき、$2\cos^2\theta - 1$ の値はどれか。',
   '2\cos^2\theta - 1',
   '$\cos^2\theta = 1 - \frac{1}{4} = \frac{3}{4}$。$2 \times \frac{3}{4} - 1 = \frac{3}{2} - 1 = \frac{1}{2}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tri_tf_01', 'A', '\frac{1}{2}',  true,  NULL, 0),
  ('drill_tri_tf_01', 'B', '\frac{3}{2}',  false, '2cos²θまでしか計算せず -1 を忘れた', 1),
  ('drill_tri_tf_01', 'C', '0',            false, 'cos²θ=1/2 と誤計算', 2),
  ('drill_tri_tf_01', 'D', '-\frac{1}{2}', false, '符号ミス', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tri_tf_02', 'tri__transform', 1, 'TEXT_NUMERIC', 3,
   '$\sin \theta = \frac{3}{5}$（$0° < \theta < 90°$）のとき、$\sin\theta \cos\theta$ の値を求めよ。',
   '\sin\theta \cos\theta',
   '$\cos\theta = \frac{4}{5}$（$\cos^2\theta = 1 - \frac{9}{25} = \frac{16}{25}$）。$\sin\theta \cos\theta = \frac{3}{5} \times \frac{4}{5} = \frac{12}{25}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tri_tf_02', '\frac{12}{25}', '12/25', true,  '分数'),
  ('drill_tri_tf_02', '0.48',          '0.48',  false, '小数');

-- 演習3: IMAGE_PROCESS
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tri_tf_03', 'tri__transform', 2, 'IMAGE_PROCESS', 4,
   '$\cos \theta = \frac{1}{4}$（$0° < \theta < 90°$）のとき、$\frac{\sin^2\theta}{1 + \cos\theta}$ の値を求めよ。途中式も書くこと。',
   '\frac{\sin^2\theta}{1 + \cos\theta}',
   '$\sin^2\theta = 1 - \cos^2\theta = (1 - \cos\theta)(1 + \cos\theta)$ と因数分解。$\frac{(1-\cos\theta)(1+\cos\theta)}{1+\cos\theta} = 1 - \cos\theta = 1 - \frac{1}{4} = \frac{3}{4}$。',
   5);

INSERT INTO exercise_rubrics (exercise_id, criterion, max_points, description, sort_order) VALUES
  ('drill_tri_tf_03', 'sin²θの変換',                 2, 'sin²θ = 1 - cos²θ または (1-cosθ)(1+cosθ) への変換が正しい', 0),
  ('drill_tri_tf_03', '約分',                         2, '(1+cosθ) で約分する処理が正しい', 1),
  ('drill_tri_tf_03', '最終値',                       1, '3/4 が正しい', 2);


-- =========================================================
-- スキル4: trig_obtuse（鈍角の三角比）
-- 3パターン / 3例題 / 8演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('tro__unit_circle',   'trig_obtuse', '単位円とsin/cos/tanの符号',   '0°〜180°での三角比の符号を判定する',             0),
  ('tro__supplementary', 'trig_obtuse', '補角の関係（180°−θ）',        'sin(180°−θ)=sinθ, cos(180°−θ)=−cosθ の利用',   1),
  ('tro__find_angle',    'trig_obtuse', 'sinθ/cosθの値から角度を求める', '方程式を解いて鋭角・鈍角を判定する',              2);


-- =============================================
-- パターン: tro__unit_circle（符号）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tro__unit_circle', 'tro__unit_circle',
   '$\theta = 120°$ のとき、$\sin\theta$、$\cos\theta$、$\tan\theta$ の符号をそれぞれ答えよ。',
   NULL,
   '$\sin 120° > 0$、$\cos 120° < 0$、$\tan 120° < 0$',
   '単位円上で $0° < \theta < 180°$ のとき、$\sin\theta$ は常に正（$y$ 座標が正）。$\cos\theta$ は $90°$ を境に正→負に変わる（$x$ 座標）。$\tan\theta = \sin\theta / \cos\theta$ なので $90° < \theta < 180°$ では負。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tro__unit_circle', 1, '角の位置',     '90° < 120° < 180°', '第2象限の角'),
  ('ex_tro__unit_circle', 2, 'sinの符号',    '\sin 120° > 0', '$y$ 座標は正'),
  ('ex_tro__unit_circle', 3, 'cosの符号',    '\cos 120° < 0', '$x$ 座標は負'),
  ('ex_tro__unit_circle', 4, 'tanの符号',    '\tan 120° = \frac{\sin 120°}{\cos 120°} < 0', '正÷負 = 負');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tro_uc_01', 'tro__unit_circle', 0, 'SELECT_BASIC', 1,
   '$\theta = 150°$ のとき、$\cos\theta$ の符号はどれか。',
   '\cos 150°',
   '$150°$ は $90° < 150° < 180°$ なので第2象限。$x$ 座標は負。$\cos 150° < 0$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tro_uc_01', 'A', '負',       true,  NULL, 0),
  ('drill_tro_uc_01', 'B', '正',       false, '鈍角でcosが正と誤解', 1),
  ('drill_tro_uc_01', 'C', '0',        false, 'cos90°=0 と混同', 2),
  ('drill_tro_uc_01', 'D', '不定',     false, '符号が決まらないと誤解', 3);

-- 演習2: SELECT_MULTI
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tro_uc_02', 'tro__unit_circle', 1, 'SELECT_MULTI', 2,
   '$0° < \theta < 180°$ において、$\theta$ が鈍角のとき負の値をとるものをすべて選べ。',
   NULL,
   '鈍角（$90° < \theta < 180°$）のとき $\cos\theta < 0$、$\tan\theta < 0$。$\sin\theta > 0$ は常に正。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tro_uc_02', 'A', '\cos\theta', true,  NULL, 0),
  ('drill_tro_uc_02', 'B', '\tan\theta', true,  NULL, 1),
  ('drill_tro_uc_02', 'C', '\sin\theta', false, '0°〜180°ではsinθは常に0以上', 2),
  ('drill_tro_uc_02', 'D', '\sin\theta \cos\theta', true, NULL, 3);


-- =============================================
-- パターン: tro__supplementary（補角の関係）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tro__supplementary', 'tro__supplementary',
   '$\sin 120°$、$\cos 120°$、$\tan 120°$ の値を求めよ。',
   NULL,
   '$\sin 120° = \frac{\sqrt{3}}{2}$、$\cos 120° = -\frac{1}{2}$、$\tan 120° = -\sqrt{3}$',
   '$\sin(180°-\theta) = \sin\theta$、$\cos(180°-\theta) = -\cos\theta$ を使えば、鈍角の三角比を鋭角に帰着できる。$120° = 180° - 60°$ なので $60°$ の値を利用。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tro__supplementary', 1, '補角への変換',  '120° = 180° - 60°', '$60°$ の三角比に帰着'),
  ('ex_tro__supplementary', 2, 'sin120°',        '\sin 120° = \sin 60° = \frac{\sqrt{3}}{2}', '$\sin(180°-\theta) = \sin\theta$'),
  ('ex_tro__supplementary', 3, 'cos120°',        '\cos 120° = -\cos 60° = -\frac{1}{2}', '$\cos(180°-\theta) = -\cos\theta$'),
  ('ex_tro__supplementary', 4, 'tan120°',        '\tan 120° = \frac{\sin 120°}{\cos 120°} = \frac{\frac{\sqrt{3}}{2}}{-\frac{1}{2}} = -\sqrt{3}', '符号に注意');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tro_sup_01', 'tro__supplementary', 0, 'SELECT_BASIC', 2,
   '$\cos 150°$ の値はどれか。',
   '\cos 150°',
   '$\cos 150° = -\cos 30° = -\frac{\sqrt{3}}{2}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tro_sup_01', 'A', '-\frac{\sqrt{3}}{2}', true,  NULL, 0),
  ('drill_tro_sup_01', 'B', '\frac{\sqrt{3}}{2}',  false, '符号を忘れ: cos(180°-θ)=-cosθ の負号を落とした', 1),
  ('drill_tro_sup_01', 'C', '-\frac{1}{2}',        false, 'cos120°と混同', 2),
  ('drill_tro_sup_01', 'D', '\frac{1}{2}',         false, 'sin30°の値', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tro_sup_02', 'tro__supplementary', 1, 'TEXT_NUMERIC', 2,
   '$\sin 135°$ の値を求めよ。',
   '\sin 135°',
   '$\sin 135° = \sin(180° - 45°) = \sin 45° = \frac{\sqrt{2}}{2}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tro_sup_02', '\frac{\sqrt{2}}{2}', 'sqrt(2)/2', true,  '有理化済み'),
  ('drill_tro_sup_02', '\frac{1}{\sqrt{2}}', 'sqrt(2)/2', false, '有理化前');

-- 演習3: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tro_sup_03', 'tro__supplementary', 2, 'TEXT_NUMERIC', 3,
   '$\tan 150°$ の値を求めよ。',
   '\tan 150°',
   '$\tan 150° = \frac{\sin 150°}{\cos 150°} = \frac{1/2}{-\sqrt{3}/2} = -\frac{1}{\sqrt{3}} = -\frac{\sqrt{3}}{3}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tro_sup_03', '-\frac{\sqrt{3}}{3}', '-sqrt(3)/3', true,  '有理化済み'),
  ('drill_tro_sup_03', '-\frac{1}{\sqrt{3}}', '-sqrt(3)/3', false, '有理化前');


-- =============================================
-- パターン: tro__find_angle（角度を求める）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tro__find_angle', 'tro__find_angle',
   '$0° \leqq \theta \leqq 180°$ で $\sin \theta = \frac{1}{2}$ を満たす $\theta$ をすべて求めよ。',
   '\sin \theta = \frac{1}{2}',
   '$\theta = 30°, 150°$',
   '$\sin\theta = k$（$0 < k \leqq 1$）のとき、$0°〜180°$ の範囲では鋭角と鈍角の2つの解がある（$\theta$ と $180°-\theta$）。$k = 1$ のときのみ $\theta = 90°$ の1つ。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tro__find_angle', 1, '鋭角の解',     '\theta = 30°', '$\sin 30° = \frac{1}{2}$ より'),
  ('ex_tro__find_angle', 2, '鈍角の解',     '\theta = 180° - 30° = 150°', '$\sin(180°-\theta) = \sin\theta$ より $\sin 150° = \frac{1}{2}$'),
  ('ex_tro__find_angle', 3, '解のまとめ',   '\theta = 30°,\; 150°', '2つの解');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tro_fa_01', 'tro__find_angle', 0, 'SELECT_BASIC', 2,
   '$0° \leqq \theta \leqq 180°$ で $\cos \theta = -\frac{1}{2}$ を満たす $\theta$ はどれか。',
   '\cos \theta = -\frac{1}{2}',
   '$\cos 60° = \frac{1}{2}$ なので、$\cos\theta = -\frac{1}{2}$ を満たすのは $\theta = 180° - 60° = 120°$。$\cos\theta$ は $0°〜180°$ で単調減少なので解は1つ。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tro_fa_01', 'A', '120°',          true,  NULL, 0),
  ('drill_tro_fa_01', 'B', '60°',           false, '符号を無視: cos60°=1/2 であって -1/2 ではない', 1),
  ('drill_tro_fa_01', 'C', '150°',          false, 'cos150°=-√3/2 と混同', 2),
  ('drill_tro_fa_01', 'D', '60°,\; 120°',   false, 'sinθのように2解あると誤解（cosは単調減少で1解）', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tro_fa_02', 'tro__find_angle', 1, 'TEXT_EXPRESSION', 3,
   '$0° \leqq \theta \leqq 180°$ で $\sin \theta = \frac{\sqrt{3}}{2}$ を満たす $\theta$ をすべて求めよ。',
   '\sin \theta = \frac{\sqrt{3}}{2}',
   '$\sin 60° = \frac{\sqrt{3}}{2}$ より $\theta = 60°$。$\sin(180°-60°) = \sin 120° = \frac{\sqrt{3}}{2}$ より $\theta = 120°$ も解。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tro_fa_02', '\theta = 60°,\; 120°', 'θ=60°,120°', true,  '模範解答'),
  ('drill_tro_fa_02', '60°, 120°',            'θ=60°,120°', false, 'θ=省略');


-- =========================================================
-- スキル5: trig_sine_rule（正弦定理）
-- 3パターン / 3例題 / 8演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('tsr__find_side',    'trig_sine_rule', '辺の長さを求める',   '角と対辺の比から未知の辺を計算する',     0),
  ('tsr__find_angle',   'trig_sine_rule', '角の大きさを求める', '辺の比から未知の角を求める',             1),
  ('tsr__circumradius', 'trig_sine_rule', '外接円の半径',       '$a / \sin A = 2R$ から外接円の半径を求める', 2);


-- =============================================
-- パターン: tsr__find_side（辺を求める）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tsr__find_side', 'tsr__find_side',
   '△ABCで $A = 30°$、$B = 45°$、$a = 4$ のとき、$b$ の長さを求めよ。',
   NULL,
   '$b = 4\sqrt{2}$',
   '正弦定理 $\frac{a}{\sin A} = \frac{b}{\sin B}$ を使う。求めたい辺を含む比と、既知の対辺・角の比を等号で結ぶ。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tsr__find_side', 1, '正弦定理の立式', '\frac{a}{\sin A} = \frac{b}{\sin B}', '正弦定理を使う比を選ぶ'),
  ('ex_tsr__find_side', 2, '値の代入',       '\frac{4}{\sin 30°} = \frac{b}{\sin 45°}', '$a=4$, $A=30°$, $B=45°$ を代入'),
  ('ex_tsr__find_side', 3, '計算',           '\frac{4}{\frac{1}{2}} = \frac{b}{\frac{\sqrt{2}}{2}}', '特殊角の値を代入'),
  ('ex_tsr__find_side', 4, '求解',           'b = 8 \times \frac{\sqrt{2}}{2} = 4\sqrt{2}', '$b = \frac{a \sin B}{\sin A}$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tsr_fs_01', 'tsr__find_side', 0, 'SELECT_BASIC', 2,
   '△ABCで $A = 60°$、$B = 30°$、$a = 6$ のとき、$b$ はどれか。',
   NULL,
   '$\frac{6}{\sin 60°} = \frac{b}{\sin 30°}$ → $\frac{6}{\frac{\sqrt{3}}{2}} = \frac{b}{\frac{1}{2}}$ → $\frac{12}{\sqrt{3}} = 2b$ → $b = \frac{6}{\sqrt{3}} = 2\sqrt{3}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tsr_fs_01', 'A', '2\sqrt{3}',  true,  NULL, 0),
  ('drill_tsr_fs_01', 'B', '3\sqrt{3}',  false, '計算途中で2で割り忘れ', 1),
  ('drill_tsr_fs_01', 'C', '6\sqrt{3}',  false, 'sin30°とsin60°を逆に使用', 2),
  ('drill_tsr_fs_01', 'D', '3',           false, '6÷2=3 と単純に半分にした', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tsr_fs_02', 'tsr__find_side', 1, 'TEXT_EXPRESSION', 3,
   '△ABCで $A = 45°$、$C = 60°$、$c = 3\sqrt{2}$ のとき、$a$ の長さを求めよ。',
   NULL,
   '$\frac{a}{\sin 45°} = \frac{3\sqrt{2}}{\sin 60°}$ → $a = \frac{3\sqrt{2} \cdot \frac{\sqrt{2}}{2}}{\frac{\sqrt{3}}{2}} = \frac{3}{\frac{\sqrt{3}}{2}} = \frac{6}{\sqrt{3}} = 2\sqrt{3}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tsr_fs_02', '2\sqrt{3}', '2sqrt(3)', true, '有理化済み');


-- =============================================
-- パターン: tsr__find_angle（角を求める）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tsr__find_angle', 'tsr__find_angle',
   '△ABCで $a = 4$、$b = 4\sqrt{2}$、$A = 30°$ のとき、$B$ の大きさを求めよ。ただし $B$ は鋭角とする。',
   NULL,
   '$B = 45°$',
   '正弦定理から $\sin B$ を求め、そこから角を特定する。$\sin B$ の値に対して鋭角と鈍角の2つの可能性があるので、条件で絞り込む。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tsr__find_angle', 1, '正弦定理',    '\frac{4}{\sin 30°} = \frac{4\sqrt{2}}{\sin B}', '$a, b, A$ を代入'),
  ('ex_tsr__find_angle', 2, 'sinBの計算',   '\sin B = \frac{4\sqrt{2} \cdot \sin 30°}{4} = \frac{4\sqrt{2} \cdot \frac{1}{2}}{4} = \frac{\sqrt{2}}{2}', '比例式を解く'),
  ('ex_tsr__find_angle', 3, '角の特定',     'B = 45°', '$\sin B = \frac{\sqrt{2}}{2}$ で $B$ が鋭角なので $B = 45°$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tsr_fa_01', 'tsr__find_angle', 0, 'SELECT_BASIC', 2,
   '△ABCで $a = 6$、$b = 3$、$A = 60°$ のとき、$\sin B$ はどれか。',
   NULL,
   '$\frac{6}{\sin 60°} = \frac{3}{\sin B}$ → $\sin B = \frac{3 \sin 60°}{6} = \frac{3 \cdot \frac{\sqrt{3}}{2}}{6} = \frac{\sqrt{3}}{4}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tsr_fa_01', 'A', '\frac{\sqrt{3}}{4}', true,  NULL, 0),
  ('drill_tsr_fa_01', 'B', '\frac{\sqrt{3}}{2}', false, '3/6の約分を忘れ、sin60°そのまま', 1),
  ('drill_tsr_fa_01', 'C', '\frac{1}{2}',        false, 'sinB=a·sinA/bと逆の比で計算', 2),
  ('drill_tsr_fa_01', 'D', '\frac{3\sqrt{3}}{4}', false, '分母で6ではなく4を使用', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tsr_fa_02', 'tsr__find_angle', 1, 'TEXT_EXPRESSION', 3,
   '△ABCで $a = 10$、$c = 5\sqrt{2}$、$A = 90°$（ただし $C$ は鋭角）のとき、$C$ を求めよ。',
   NULL,
   '$\frac{10}{\sin 90°} = \frac{5\sqrt{2}}{\sin C}$ → $\sin C = \frac{5\sqrt{2}}{10} = \frac{\sqrt{2}}{2}$。$C$ は鋭角なので $C = 45°$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tsr_fa_02', 'C = 45°',  'C=45°', true,  '模範解答'),
  ('drill_tsr_fa_02', '45°',      'C=45°', false, '角の記号省略'),
  ('drill_tsr_fa_02', '45',       'C=45°', false, '度記号も省略');


-- =============================================
-- パターン: tsr__circumradius（外接円の半径）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tsr__circumradius', 'tsr__circumradius',
   '△ABCで $a = 6$、$A = 30°$ のとき、外接円の半径 $R$ を求めよ。',
   NULL,
   '$R = 6$',
   '正弦定理 $\frac{a}{\sin A} = 2R$ から $R = \frac{a}{2\sin A}$。この形を使えば1組の対辺・角から直接 $R$ が求まる。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tsr__circumradius', 1, '公式',   '\frac{a}{\sin A} = 2R', '正弦定理の外接円バージョン'),
  ('ex_tsr__circumradius', 2, '代入',   '\frac{6}{\sin 30°} = 2R', '$a = 6$、$A = 30°$ を代入'),
  ('ex_tsr__circumradius', 3, '計算',   '\frac{6}{\frac{1}{2}} = 2R \;\Rightarrow\; 12 = 2R', '$\sin 30° = \frac{1}{2}$'),
  ('ex_tsr__circumradius', 4, '求解',   'R = 6', '両辺を2で割る');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tsr_cr_01', 'tsr__circumradius', 0, 'SELECT_BASIC', 2,
   '△ABCで $b = 4\sqrt{3}$、$B = 60°$ のとき、外接円の半径 $R$ はどれか。',
   NULL,
   '$2R = \frac{4\sqrt{3}}{\sin 60°} = \frac{4\sqrt{3}}{\frac{\sqrt{3}}{2}} = 8$。$R = 4$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tsr_cr_01', 'A', '4',          true,  NULL, 0),
  ('drill_tsr_cr_01', 'B', '8',          false, '2Rの値をRと回答', 1),
  ('drill_tsr_cr_01', 'C', '4\sqrt{3}',  false, 'b/sinB を求めて2で割り忘れ', 2),
  ('drill_tsr_cr_01', 'D', '2\sqrt{3}',  false, 'b/2 = 2√3 と単純に半分にした', 3);

-- 演習2: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tsr_cr_02', 'tsr__circumradius', 1, 'TEXT_NUMERIC', 2,
   '△ABCで $c = 5$、$C = 90°$ のとき、外接円の半径 $R$ を求めよ。',
   NULL,
   '$2R = \frac{5}{\sin 90°} = \frac{5}{1} = 5$。$R = \frac{5}{2}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tsr_cr_02', '\frac{5}{2}', '5/2', true,  '分数'),
  ('drill_tsr_cr_02', '2.5',         '2.5', false, '小数');

-- 演習3: TEXT_NUMERIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tsr_cr_03', 'tsr__circumradius', 2, 'TEXT_NUMERIC', 3,
   '△ABCで $a = 3\sqrt{2}$、$A = 45°$ のとき、外接円の半径 $R$ を求めよ。',
   NULL,
   '$2R = \frac{3\sqrt{2}}{\sin 45°} = \frac{3\sqrt{2}}{\frac{\sqrt{2}}{2}} = \frac{3\sqrt{2} \times 2}{\sqrt{2}} = 6$。$R = 3$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tsr_cr_03', '3', '3', true, '整数');


-- =========================================================
-- スキル6: trig_cosine_rule（余弦定理）
-- 3パターン / 3例題 / 9演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('tcr__find_side',      'trig_cosine_rule', '辺の長さを求める',     '2辺と挟角から第3辺を計算する',         0),
  ('tcr__find_angle',     'trig_cosine_rule', '角の大きさを求める',   '3辺から角を求める',                   1),
  ('tcr__triangle_type',  'trig_cosine_rule', '三角形の形状判定',     '鋭角三角形・直角三角形・鈍角三角形の判定', 2);


-- =============================================
-- パターン: tcr__find_side（辺を求める）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tcr__find_side', 'tcr__find_side',
   '△ABCで $b = 5$、$c = 8$、$A = 60°$ のとき、$a$ の長さを求めよ。',
   NULL,
   '$a = 7$',
   '余弦定理 $a^2 = b^2 + c^2 - 2bc\cos A$ は、2辺と挟角から対辺を求める公式。三平方の定理の一般化。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tcr__find_side', 1, '余弦定理の立式',  'a^2 = b^2 + c^2 - 2bc\cos A', '余弦定理'),
  ('ex_tcr__find_side', 2, '値の代入',        'a^2 = 25 + 64 - 2 \cdot 5 \cdot 8 \cdot \cos 60°', '$b=5, c=8, A=60°$ を代入'),
  ('ex_tcr__find_side', 3, '計算',            'a^2 = 89 - 80 \cdot \frac{1}{2} = 89 - 40 = 49', '$\cos 60° = \frac{1}{2}$'),
  ('ex_tcr__find_side', 4, '求解',            'a = 7', '$a > 0$ より $a = \sqrt{49} = 7$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tcr_fs_01', 'tcr__find_side', 0, 'SELECT_BASIC', 2,
   '△ABCで $b = 3$、$c = 5$、$A = 60°$ のとき、$a$ はどれか。',
   NULL,
   '$a^2 = 9 + 25 - 2 \cdot 3 \cdot 5 \cdot \frac{1}{2} = 34 - 15 = 19$。$a = \sqrt{19}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tcr_fs_01', 'A', '\sqrt{19}', true,  NULL, 0),
  ('drill_tcr_fs_01', 'B', '\sqrt{34}', false, '-2bc·cosAの項を忘れ（三平方の定理と混同）', 1),
  ('drill_tcr_fs_01', 'C', '\sqrt{49}', false, 'cos60°=1/2ではなく0を代入', 2),
  ('drill_tcr_fs_01', 'D', '19',        false, 'a²=19 の平方根を取り忘れ', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tcr_fs_02', 'tcr__find_side', 1, 'TEXT_EXPRESSION', 3,
   '△ABCで $a = 4$、$b = 6$、$C = 120°$ のとき、$c$ の長さを求めよ。',
   NULL,
   '$c^2 = 16 + 36 - 2 \cdot 4 \cdot 6 \cdot \cos 120° = 52 - 48 \cdot (-\frac{1}{2}) = 52 + 24 = 76$。$c = \sqrt{76} = 2\sqrt{19}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tcr_fs_02', '2\sqrt{19}', '2sqrt(19)', true,  '簡約化済み'),
  ('drill_tcr_fs_02', '\sqrt{76}',  '2sqrt(19)', false, '簡約化前');

-- 演習3: IMAGE_PROCESS
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tcr_fs_03', 'tcr__find_side', 2, 'IMAGE_PROCESS', 4,
   '△ABCで $b = 2\sqrt{3}$、$c = 4$、$A = 150°$ のとき、$a$ の長さを求めよ。途中式も書くこと。',
   NULL,
   '$a^2 = 12 + 16 - 2 \cdot 2\sqrt{3} \cdot 4 \cdot \cos 150° = 28 - 16\sqrt{3} \cdot (-\frac{\sqrt{3}}{2}) = 28 + 24 = 52$。$a = 2\sqrt{13}$。',
   5);

INSERT INTO exercise_rubrics (exercise_id, criterion, max_points, description, sort_order) VALUES
  ('drill_tcr_fs_03', '余弦定理の立式',           2, 'a² = b² + c² - 2bc·cosA の立式が正しい', 0),
  ('drill_tcr_fs_03', 'cos150°の値と計算',         2, 'cos150° = -√3/2 を正しく代入し計算', 1),
  ('drill_tcr_fs_03', '最終値',                    1, 'a = 2√13 が正しい', 2);


-- =============================================
-- パターン: tcr__find_angle（角を求める）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tcr__find_angle', 'tcr__find_angle',
   '△ABCで $a = 7$、$b = 5$、$c = 8$ のとき、$A$ の大きさを求めよ。',
   NULL,
   '$A = 60°$',
   '余弦定理を $\cos A = \frac{b^2 + c^2 - a^2}{2bc}$ と変形して使う。3辺が分かっていれば任意の角が求まる。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tcr__find_angle', 1, '余弦定理の変形',  '\cos A = \frac{b^2 + c^2 - a^2}{2bc}', '角を求める形に変形'),
  ('ex_tcr__find_angle', 2, '代入',            '\cos A = \frac{25 + 64 - 49}{2 \cdot 5 \cdot 8} = \frac{40}{80} = \frac{1}{2}', '値を代入して計算'),
  ('ex_tcr__find_angle', 3, '角の特定',        'A = 60°', '$\cos A = \frac{1}{2}$ より $A = 60°$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tcr_fa_01', 'tcr__find_angle', 0, 'SELECT_BASIC', 2,
   '△ABCで $a = 5$、$b = 6$、$c = 7$ のとき、$\cos C$ はどれか。',
   NULL,
   '$\cos C = \frac{a^2 + b^2 - c^2}{2ab} = \frac{25 + 36 - 49}{2 \cdot 5 \cdot 6} = \frac{12}{60} = \frac{1}{5}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tcr_fa_01', 'A', '\frac{1}{5}',  true,  NULL, 0),
  ('drill_tcr_fa_01', 'B', '\frac{1}{7}',  false, '分母を2·5·7と誤って計算', 1),
  ('drill_tcr_fa_01', 'C', '\frac{12}{70}', false, '分母2abのaを7と取り違え', 2),
  ('drill_tcr_fa_01', 'D', '-\frac{1}{5}',  false, '分子の符号ミス: a²+b²-c²の符号を逆にした', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tcr_fa_02', 'tcr__find_angle', 1, 'TEXT_EXPRESSION', 3,
   '△ABCで $a = 3$、$b = 4$、$c = 6$ のとき、$C$ の大きさを求めよ。',
   NULL,
   '$\cos C = \frac{9 + 16 - 36}{2 \cdot 3 \cdot 4} = \frac{-11}{24}$。$\cos C < 0$ なので $C$ は鈍角。$C = \arccos\left(-\frac{11}{24}\right)$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tcr_fa_02', '\cos C = -\frac{11}{24}', 'cosC=-11/24', true,  'cosの値で回答（角度は特殊角でない）');

-- 演習3: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tcr_fa_03', 'tcr__find_angle', 2, 'TEXT_EXPRESSION', 3,
   '△ABCで $a = 2$、$b = \sqrt{6}$、$c = \sqrt{3} - 1$ のとき、$A$ の大きさを求めよ。',
   NULL,
   '$\cos A = \frac{(\sqrt{6})^2 + (\sqrt{3}-1)^2 - 4}{2 \cdot \sqrt{6} \cdot (\sqrt{3}-1)} = \frac{6 + 4 - 2\sqrt{3} - 4}{2\sqrt{6}(\sqrt{3}-1)} = \frac{6 - 2\sqrt{3}}{2\sqrt{6}(\sqrt{3}-1)} = \frac{2(3-\sqrt{3})}{2\sqrt{6}(\sqrt{3}-1)}$。分子 $= 2\sqrt{3}(\sqrt{3}-1)$、分母 $= 2\sqrt{6}(\sqrt{3}-1)$。約分して $\frac{\sqrt{3}}{\sqrt{6}} = \frac{1}{\sqrt{2}} = \frac{\sqrt{2}}{2}$。$A = 45°$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tcr_fa_03', 'A = 45°', 'A=45°', true,  '模範解答'),
  ('drill_tcr_fa_03', '45°',     'A=45°', false, '角の記号省略');


-- =============================================
-- パターン: tcr__triangle_type（形状判定）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tcr__triangle_type', 'tcr__triangle_type',
   '3辺の長さが $a = 3$、$b = 5$、$c = 7$ の三角形は、鋭角三角形、直角三角形、鈍角三角形のどれか。',
   NULL,
   '鈍角三角形',
   '最長辺を $c$ として、$a^2 + b^2$ と $c^2$ を比較する。$a^2 + b^2 > c^2$ なら鋭角、$= c^2$ なら直角、$< c^2$ なら鈍角。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tcr__triangle_type', 1, '最長辺の確認',   'c = 7 \;\text{（最大）}', '最長辺の対角が最大角'),
  ('ex_tcr__triangle_type', 2, '各二乗の計算',   'a^2 + b^2 = 9 + 25 = 34,\quad c^2 = 49', '比較する値を計算'),
  ('ex_tcr__triangle_type', 3, '比較・判定',     '34 < 49 \;\Rightarrow\; a^2 + b^2 < c^2', '鈍角三角形');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tcr_tt_01', 'tcr__triangle_type', 0, 'SELECT_BASIC', 2,
   '3辺が $a = 5$、$b = 12$、$c = 13$ の三角形はどれか。',
   NULL,
   '$a^2 + b^2 = 25 + 144 = 169 = c^2$。$a^2 + b^2 = c^2$ なので直角三角形。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tcr_tt_01', 'A', '直角三角形',  true,  NULL, 0),
  ('drill_tcr_tt_01', 'B', '鋭角三角形',  false, 'a²+b²>c²と誤判定', 1),
  ('drill_tcr_tt_01', 'C', '鈍角三角形',  false, 'a²+b²<c²と誤判定', 2),
  ('drill_tcr_tt_01', 'D', '判定できない', false, '3辺があれば判定可能', 3);

-- 演習2: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tcr_tt_02', 'tcr__triangle_type', 1, 'SELECT_BASIC', 2,
   '3辺が $a = 4$、$b = 5$、$c = 6$ の三角形はどれか。',
   NULL,
   '$a^2 + b^2 = 16 + 25 = 41$、$c^2 = 36$。$41 > 36$ なので鋭角三角形。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tcr_tt_02', 'A', '鋭角三角形',  true,  NULL, 0),
  ('drill_tcr_tt_02', 'B', '直角三角形',  false, '辺の比がほぼ3:4:5に見えるため', 1),
  ('drill_tcr_tt_02', 'C', '鈍角三角形',  false, '不等号の向きを逆に判定', 2),
  ('drill_tcr_tt_02', 'D', '正三角形',    false, '辺が近い値だが等しくはない', 3);

-- 演習3: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tcr_tt_03', 'tcr__triangle_type', 2, 'TEXT_EXPRESSION', 3,
   '3辺が $a = 2$、$b = 3$、$c = 4$ の三角形について、最大角の余弦を求め、鋭角三角形・直角三角形・鈍角三角形のいずれかを答えよ。',
   NULL,
   '最長辺は $c = 4$。$\cos C = \frac{4 + 9 - 16}{2 \cdot 2 \cdot 3} = \frac{-3}{12} = -\frac{1}{4}$。$\cos C < 0$ なので $C$ は鈍角。よって鈍角三角形。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tcr_tt_03', '鈍角三角形', '鈍角三角形', true,  '模範解答'),
  ('drill_tcr_tt_03', '鈍角',       '鈍角三角形', false, '略称');


-- =========================================================
-- スキル7: trig_area（三角形の面積）
-- 3パターン / 3例題 / 8演習
-- =========================================================

INSERT INTO patterns (id, skill_id, display_name, description, sort_order) VALUES
  ('tar__two_sides_angle', 'trig_area', '2辺と挟角から面積',     '$S = \frac{1}{2}ab\sin C$ の利用',          0),
  ('tar__with_sine_rule',  'trig_area', '正弦定理との組合せ',     '辺・角が不足→正弦定理で補って面積を求める', 1),
  ('tar__heron',           'trig_area', 'ヘロンの公式',           '3辺から面積を求める（発展）',               2);


-- =============================================
-- パターン: tar__two_sides_angle（2辺と挟角）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tar__two_sides_angle', 'tar__two_sides_angle',
   '△ABCで $b = 6$、$c = 8$、$A = 30°$ のとき、面積 $S$ を求めよ。',
   NULL,
   '$S = 12$',
   '$S = \frac{1}{2}bc\sin A$ に代入するだけ。2辺とその挟角が分かっていれば直ちに面積が求まる。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tar__two_sides_angle', 1, '公式',   'S = \frac{1}{2}bc\sin A', '面積公式'),
  ('ex_tar__two_sides_angle', 2, '代入',   'S = \frac{1}{2} \cdot 6 \cdot 8 \cdot \sin 30°', '$b=6, c=8, A=30°$ を代入'),
  ('ex_tar__two_sides_angle', 3, '計算',   'S = 24 \cdot \frac{1}{2} = 12', '$\sin 30° = \frac{1}{2}$');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tar_tsa_01', 'tar__two_sides_angle', 0, 'SELECT_BASIC', 2,
   '△ABCで $a = 5$、$b = 8$、$C = 60°$ のとき、面積 $S$ はどれか。',
   NULL,
   '$S = \frac{1}{2} \cdot 5 \cdot 8 \cdot \sin 60° = 20 \cdot \frac{\sqrt{3}}{2} = 10\sqrt{3}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tar_tsa_01', 'A', '10\sqrt{3}',  true,  NULL, 0),
  ('drill_tar_tsa_01', 'B', '20\sqrt{3}',  false, '1/2 をかけ忘れ', 1),
  ('drill_tar_tsa_01', 'C', '20',           false, 'sin60°=1 と誤認（またはcos60°を使用）', 2),
  ('drill_tar_tsa_01', 'D', '10',           false, 'sin60°=1/2 と誤認（sin30°と混同）', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tar_tsa_02', 'tar__two_sides_angle', 1, 'TEXT_EXPRESSION', 2,
   '△ABCで $b = 10$、$c = 6$、$A = 90°$ のとき、面積 $S$ を求めよ。',
   NULL,
   '$S = \frac{1}{2} \cdot 10 \cdot 6 \cdot \sin 90° = \frac{1}{2} \cdot 60 \cdot 1 = 30$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tar_tsa_02', '30', '30', true, '整数');

-- 演習3: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tar_tsa_03', 'tar__two_sides_angle', 2, 'TEXT_EXPRESSION', 3,
   '△ABCで $a = 4\sqrt{2}$、$c = 6$、$B = 135°$ のとき、面積 $S$ を求めよ。',
   NULL,
   '$S = \frac{1}{2} \cdot 4\sqrt{2} \cdot 6 \cdot \sin 135° = 12\sqrt{2} \cdot \frac{\sqrt{2}}{2} = 12$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tar_tsa_03', '12', '12', true, '整数');


-- =============================================
-- パターン: tar__with_sine_rule（正弦定理との組合せ）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tar__with_sine_rule', 'tar__with_sine_rule',
   '△ABCで $a = 6$、$A = 60°$、$B = 45°$ のとき、面積 $S$ を求めよ。',
   NULL,
   '$S = 9(\sqrt{3} - 1)$',
   '面積公式 $S = \frac{1}{2}ab\sin C$ を使うには2辺と挟角が必要。辺が1つしかない場合、正弦定理で不足辺を補う。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tar__with_sine_rule', 1, 'Cの計算',        'C = 180° - 60° - 45° = 75°', '角の和は $180°$'),
  ('ex_tar__with_sine_rule', 2, '正弦定理でbを求める', '\frac{6}{\sin 60°} = \frac{b}{\sin 45°}', '正弦定理'),
  ('ex_tar__with_sine_rule', 3, 'bの計算',         'b = \frac{6\sin 45°}{\sin 60°} = \frac{6 \cdot \frac{\sqrt{2}}{2}}{\frac{\sqrt{3}}{2}} = \frac{3\sqrt{2}}{\frac{\sqrt{3}}{2}} = \frac{6\sqrt{2}}{\sqrt{3}} = 2\sqrt{6}', '特殊角の値を代入'),
  ('ex_tar__with_sine_rule', 4, '面積の計算',      'S = \frac{1}{2} \cdot 6 \cdot 2\sqrt{6} \cdot \sin 75°', '$\sin 75° = \sin(45°+30°) = \frac{\sqrt{6}+\sqrt{2}}{4}$ を利用'),
  ('ex_tar__with_sine_rule', 5, '最終計算',        'S = 6\sqrt{6} \cdot \frac{\sqrt{6}+\sqrt{2}}{4} = \frac{6(6+\sqrt{12})}{4} = \frac{36+12\sqrt{3}}{4} = 9 + 3\sqrt{3}', '計算を整理');

-- 演習1: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tar_wsr_01', 'tar__with_sine_rule', 0, 'TEXT_EXPRESSION', 3,
   '△ABCで $a = 4$、$A = 30°$、$B = 60°$ のとき、面積 $S$ を求めよ。',
   NULL,
   '$C = 90°$。正弦定理で $b = \frac{4\sin 60°}{\sin 30°} = \frac{4 \cdot \frac{\sqrt{3}}{2}}{\frac{1}{2}} = 4\sqrt{3}$。$S = \frac{1}{2} \cdot 4 \cdot 4\sqrt{3} \cdot \sin 90° = 8\sqrt{3}$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tar_wsr_01', '8\sqrt{3}', '8sqrt(3)', true, '模範解答');

-- 演習2: IMAGE_PROCESS
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tar_wsr_02', 'tar__with_sine_rule', 1, 'IMAGE_PROCESS', 4,
   '△ABCで $b = 3\sqrt{2}$、$B = 45°$、$C = 60°$ のとき、面積 $S$ を求めよ。途中式も書くこと。',
   NULL,
   '$A = 75°$。正弦定理で $c = \frac{3\sqrt{2} \cdot \sin 60°}{\sin 45°} = \frac{3\sqrt{2} \cdot \frac{\sqrt{3}}{2}}{\frac{\sqrt{2}}{2}} = 3\sqrt{3}$。$S = \frac{1}{2} \cdot 3\sqrt{2} \cdot 3\sqrt{3} \cdot \sin 75° = \frac{9\sqrt{6}}{2} \cdot \frac{\sqrt{6}+\sqrt{2}}{4} = \frac{9(6+\sqrt{12})}{8} = \frac{9(6+2\sqrt{3})}{8} = \frac{54+18\sqrt{3}}{8} = \frac{27+9\sqrt{3}}{4}$。',
   5);

INSERT INTO exercise_rubrics (exercise_id, criterion, max_points, description, sort_order) VALUES
  ('drill_tar_wsr_02', '角Aの計算',               1, 'A = 180° - 45° - 60° = 75° が正しい', 0),
  ('drill_tar_wsr_02', '正弦定理で辺を求める',     2, '正弦定理の立式と計算が正しい', 1),
  ('drill_tar_wsr_02', '面積公式の適用',           1, 'S = (1/2)bc sinA の立式が正しい', 2),
  ('drill_tar_wsr_02', '最終値',                   1, '最終値が正しい', 3);


-- =============================================
-- パターン: tar__heron（ヘロンの公式）
-- =============================================

INSERT INTO examples (id, pattern_id, question_text, question_expr, answer_text, learning_point) VALUES
  ('ex_tar__heron', 'tar__heron',
   '△ABCで $a = 3$、$b = 4$、$c = 5$ のとき、ヘロンの公式を用いて面積 $S$ を求めよ。',
   NULL,
   '$S = 6$',
   'ヘロンの公式: $S = \sqrt{s(s-a)(s-b)(s-c)}$（$s = \frac{a+b+c}{2}$）。3辺だけで面積が求まる。余弦定理で角を求めてから面積公式を使う方法もあるが、ヘロンの公式の方が直接的。');

INSERT INTO example_steps (example_id, step_number, label, expr, explanation) VALUES
  ('ex_tar__heron', 1, 'sの計算',   's = \frac{3+4+5}{2} = 6', '半周長'),
  ('ex_tar__heron', 2, '各因子',    's-a=3,\; s-b=2,\; s-c=1', '各因子を計算'),
  ('ex_tar__heron', 3, '公式適用',  'S = \sqrt{6 \cdot 3 \cdot 2 \cdot 1} = \sqrt{36} = 6', 'ヘロンの公式');

-- 演習1: SELECT_BASIC
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tar_her_01', 'tar__heron', 0, 'SELECT_BASIC', 2,
   '3辺が $a = 5$、$b = 6$、$c = 7$ の三角形の面積 $S$ はどれか（ヘロンの公式を使え）。',
   NULL,
   '$s = \frac{5+6+7}{2} = 9$。$S = \sqrt{9 \cdot 4 \cdot 3 \cdot 2} = \sqrt{216} = 6\sqrt{6}$。',
   0);

INSERT INTO exercise_choices (exercise_id, choice_label, choice_expr, is_correct, distractor_note, sort_order) VALUES
  ('drill_tar_her_01', 'A', '6\sqrt{6}',   true,  NULL, 0),
  ('drill_tar_her_01', 'B', '6\sqrt{3}',   false, 's-c=2ではなく3と計算（cをbと取り違え）', 1),
  ('drill_tar_her_01', 'C', '\sqrt{216}',   false, '√216を簡約化し忘れ', 2),
  ('drill_tar_her_01', 'D', '216',           false, '平方根を取り忘れ', 3);

-- 演習2: TEXT_EXPRESSION
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tar_her_02', 'tar__heron', 1, 'TEXT_EXPRESSION', 3,
   '3辺が $a = 8$、$b = 5$、$c = 5$ の二等辺三角形の面積 $S$ を求めよ。',
   NULL,
   '$s = \frac{8+5+5}{2} = 9$。$S = \sqrt{9 \cdot 1 \cdot 4 \cdot 4} = \sqrt{144} = 12$。',
   0);

INSERT INTO exercise_answers (exercise_id, answer_expr, normalized_form, is_primary, note) VALUES
  ('drill_tar_her_02', '12', '12', true, '整数');

-- 演習3: IMAGE_PROCESS
INSERT INTO exercises (id, pattern_id, sort_order, input_template, difficulty, question_text, question_expr, explanation, grading_cost) VALUES
  ('drill_tar_her_03', 'tar__heron', 2, 'IMAGE_PROCESS', 4,
   '3辺が $a = 7$、$b = 8$、$c = 9$ の三角形について、ヘロンの公式を用いて面積 $S$ を求めよ。途中式も書くこと。',
   NULL,
   '$s = \frac{7+8+9}{2} = 12$。$S = \sqrt{12 \cdot 5 \cdot 4 \cdot 3} = \sqrt{720} = \sqrt{144 \cdot 5} = 12\sqrt{5}$。',
   5);

INSERT INTO exercise_rubrics (exercise_id, criterion, max_points, description, sort_order) VALUES
  ('drill_tar_her_03', '半周長sの計算',     1, 's = 12 が正しい', 0),
  ('drill_tar_her_03', '各因子の計算',       2, 's-a=5, s-b=4, s-c=3 が正しい', 1),
  ('drill_tar_her_03', '公式適用と簡約化',   2, '√720 = 12√5 まで正しく計算', 2);


COMMIT;
