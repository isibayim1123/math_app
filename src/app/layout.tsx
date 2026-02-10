import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "数学学習サービス",
  description: "高校数学の学習サービス — スキルツリーベースの弱点診断",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="ja">
      <head>
        <link
          rel="preconnect"
          href="https://fonts.googleapis.com"
        />
        <link
          rel="preconnect"
          href="https://fonts.gstatic.com"
          crossOrigin="anonymous"
        />
        <link
          href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className="bg-gray-50 text-gray-900 antialiased" style={{ fontFamily: "'Noto Sans JP', sans-serif" }}>
        <div className="min-h-dvh flex flex-col">
          <header className="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-5 py-4">
            <a href="/" className="block">
              <h1 className="text-lg font-bold tracking-tight">📐 数学学習サービス</h1>
            </a>
          </header>
          <main className="flex-1">{children}</main>
        </div>
      </body>
    </html>
  );
}
