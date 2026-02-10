// OpenAI 採点プロキシ API
// クライアントに API キーを露出させず、サーバー側で OpenAI を呼び出す
export async function POST(request: Request) {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    return Response.json(
      { error: "OPENAI_API_KEY が設定されていません" },
      { status: 503 }
    );
  }

  const { image, systemPrompt, userText } = await request.json();
  if (!image) {
    return Response.json({ error: "画像が必要です" }, { status: 400 });
  }

  const startTime = Date.now();

  try {
    const response = await fetch("https://api.openai.com/v1/responses", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model: "gpt-4o-mini",
        input: [
          { role: "developer", content: systemPrompt || "" },
          {
            role: "user",
            content: [
              { type: "input_image", image_url: image },
              {
                type: "input_text",
                text: userText || "この答案を採点してください。",
              },
            ],
          },
        ],
      }),
    });

    if (!response.ok) {
      const errData = await response.json().catch(() => null);
      return Response.json(
        { error: errData?.error?.message || `HTTP ${response.status}` },
        { status: response.status }
      );
    }

    const data = await response.json();
    const processingTime = Date.now() - startTime;

    // output テキストを抽出
    let rawText = "";
    if (data.output) {
      for (const item of data.output) {
        if (item.type === "message" && item.content) {
          for (const c of item.content) {
            if (c.type === "output_text") rawText += c.text;
          }
        }
      }
    }

    const tokens = data.usage
      ? {
          input: data.usage.input_tokens,
          output: data.usage.output_tokens,
          total: data.usage.total_tokens,
        }
      : null;

    return Response.json({ rawText, processingTime, tokens });
  } catch (err) {
    return Response.json(
      { error: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 }
    );
  }
}
