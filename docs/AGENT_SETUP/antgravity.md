# AntGravity との接続設定

## 概要

cocoro-llm-server を AntGravity で使用する設定です。

## 環境変数

`.env` ファイルに以下の設定を追加:

```env
# cocoro-llm-server (LiteLLM)
LITELLM_API_KEY=your_master_key_here
SERVER_IP=192.168.50.112
SERVER_PORT=4000

# AntGravity 用の環境変数
ANTHROPIC_API_KEY=your_anthropic_api_key   # Claude 使用時
ANTHROPIC_BASE_URL=http://192.168.50.112:4000/v1
ANTHROPIC_API_KEY=litellm                           # LiteLLM 経由時の固定値
```

## 設定方法

### 1. cocoro-llm-client のセットアップ

```bash
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
./scripts/setup-client.sh
```

### 2. opencode.json の確認

`opencode.json` が正しく設定されていることを確認:

```json
{
  "provider": {
    "litellm": {
      "options": {
        "baseURL": "http://192.168.50.112:4000/v1",
        "apiKey": "YOUR_API_KEY"
      }
    }
  }
}
```

### 3. AntGravity での使用

AntGravity で新しいエージェントを作成:

- **LLM Provider**: OpenAI互換 (LiteLLM)
- **Base URL**: `http://192.168.50.112:4000/v1`
- **API Key**: `litellm` (または `LITELLM_MASTER_KEY`)
- **Model**: `qwen3-coder` または `claude-sonnet`

## 推奨設定

| 設定項目 | 値 | 用途 |
|---------|-----|------|
| Temperature | `0.7` | 通常のコーディング |
| Temperature | `0.2` | 設計・要約 |
| Max Tokens | `32768` | 長いコンテキスト対応 |
| Model | `qwen3-coder` | 普段使い |
| Model | `claude-sonnet` | 難解タスク |

## トラブルシューティング

詳細は [TROUBLESHOOTING.md](../TROUBLESHOOTING.md) を参照。

- **接続エラー**: cocoro-llm-server がポート 4000 で起動しているか確認
- **認証エラー**: `ANTHROPIC_API_KEY` に正しい API キーが設定されているか確認
