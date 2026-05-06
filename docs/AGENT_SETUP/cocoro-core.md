# cocoro-core との接続設定

## 概要

cocoro-core から cocoro-llm-server を使う設定です。

## 環境変数

cocoro-core の `.env` ファイルに追加:

```env
# cocoro-llm-server (LiteLLM)
LLM_PROVIDER=openai
OPENAI_API_BASE=http://192.168.50.112:4000/v1
OPENAI_API_KEY=your_litellm_master_key
OPENAI_MODEL=gpt-4o
```

## 設定手順

### 1. cocoro-llm-client のセットアップ

```bash
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
./scripts/setup-client.sh
```

### 2. cocoro-core への接続

cocoro-core ディレクトリで `.env` を編集:

```env
# cocoro-llm-server 接続設定
LLM_PROVIDER=openai
OPENAI_API_BASE=http://192.168.50.112:4000/v1
OPENAI_API_KEY=your_litellm_master_key
OPENAI_MODEL=gpt-4o

# 動作設定
LLM_TEMPERATURE=0.7
LLM_MAX_TOKENS=32768
```

### 3. cocoro-core の起動

```bash
cd /path/to/cocoro-core
docker compose up -d
```

## エージェント別の設定

### chat エージェント

```env
LLM_PROVIDER=openai
OPENAI_API_BASE=http://192.168.50.112:4000/v1
OPENAI_API_KEY=your_litellm_master_key
OPENAI_MODEL=qwen3-coder
```

### build エージェント

```env
LLM_PROVIDER=openai
OPENAI_API_BASE=http://192.168.50.112:4000/v1
OPENAI_API_KEY=your_litellm_master_key
OPENAI_MODEL=qwen3-coder
LLM_TEMPERATURE=0.2
```

## 応答形式の設定

cocoro-core で期待される応答形式:

```json
{
  "choices": [
    {
      "message": {
        "content": "応答メッセージ",
        "role": "assistant"
      }
    }
  ],
  "model": "qwen3-coder",
  "usage": {
    "prompt_tokens": 10,
    "completion_tokens": 20,
    "total_tokens": 30
  }
}
```

## トラブルシューティング

詳細は [TROUBLESHOOTING.md](../TROUBLESHOOTING.md) を参照。

- **JSON パースエラー**: `--tool-call-parser qwen3_coder` オプションを確認
- **接続エラー**: cocoro-llm-server のポート 4000 を確認
