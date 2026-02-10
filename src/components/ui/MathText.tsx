"use client";

import { renderMathInText, renderLatex } from "@/lib/katex-utils";

/** テキスト中の $...$ / $$...$$ をKaTeXレンダリングして表示 */
export function MathText({
  text,
  className = "",
}: {
  text: string;
  className?: string;
}) {
  const html = renderMathInText(text);
  return (
    <span
      className={className}
      dangerouslySetInnerHTML={{ __html: html }}
    />
  );
}

/** 生LaTeX式をレンダリングして表示（choice_expr 等） */
export function MathExpr({
  expr,
  display = false,
  className = "",
}: {
  expr: string;
  display?: boolean;
  className?: string;
}) {
  const html = renderLatex(expr, display);
  return (
    <span
      className={className}
      dangerouslySetInnerHTML={{ __html: html }}
    />
  );
}
