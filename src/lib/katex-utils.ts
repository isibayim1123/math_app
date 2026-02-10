import katex from "katex";

/**
 * テキスト内の $...$ と $$...$$ をKaTeX HTMLに変換する。
 * CLAUDE.md の数式表記ルールに準拠。
 */
export function renderMathInText(text: string): string {
  // $$...$$ （ディスプレイ数式）を先に処理
  let result = text.replace(/\$\$(.+?)\$\$/gs, (_, expr) => {
    try {
      return katex.renderToString(expr.trim(), {
        displayMode: true,
        throwOnError: false,
      });
    } catch {
      return `$$${expr}$$`;
    }
  });

  // $...$ （インライン数式）を処理
  result = result.replace(/\$(.+?)\$/g, (_, expr) => {
    try {
      return katex.renderToString(expr.trim(), {
        displayMode: false,
        throwOnError: false,
      });
    } catch {
      return `$${expr}$`;
    }
  });

  return result;
}

/**
 * 生LaTeX式をKaTeX HTMLに変換（choice_expr, answer_expr 用）
 */
export function renderLatex(
  expr: string,
  displayMode = false
): string {
  try {
    return katex.renderToString(expr, { displayMode, throwOnError: false });
  } catch {
    return expr;
  }
}
