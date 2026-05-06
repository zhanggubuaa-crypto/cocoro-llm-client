# OpenHands との接続設定

## 概要

OpenHands から cocoro-llm-server を使う設定です。

## 環境変数

OpenHands の環境変数設定:

```bash
# cocoro-llm-server (LiteLLM)
export OPENAI_API_BASE=http://192.168.50.112:4000/v1
export OPENAI_API_KEY=your_litellm_master_key
export OPENAI_MODEL=qwen3-coder
```

## 設定方法

### 1. cocoro-llm-client のセットアップ

```bash
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
./scripts/setup-client.sh
```

### 2. OpenHands の起動

```bash
# 任意のディレクトリで
mkdir -p ~/.opencode/openhands
cd ~/.opencode/openhands

# 環境変数を設定
export OPENAI_API_BASE=http://192.168.50.112:4000/v1
export OPENAI_API_KEY=your_litellm_master_key
export OPENAI_MODEL=qwen3-coder

# OpenHands を起動
opencode init
opencode build "タスクを入力"
```

## OpenHands の設定ファイル

`opencode.json` における設定:

```json
{
  "models": {
    "default": "litellm/qwen3-coder",
    "providers": {
      "litellm": {
        "baseURL": "http://192.168.50.112:4000/v1",
        "apiKey": "your_api_key"
      }
    }
  },
  "agents": {
    "build": {
      "model": "litellm/qwen3-coder"
    }
  }
}
```

## 複数モデルの切り替え

OpenHands では環境変数でモデルを切り替え:

```bash
# Qwen3 Coder (普段使い)
export OPENAI_MODEL=qwen3-coder

# Claude Sonnet (難解タスク)
export OPENAI_MODEL=claude-sonnet
```

## トラブルシューティング

詳細は [TROUBLESHOOTING.md](../TROUBLESHOOTING.md) を参照。

- **接続エラー**: `SERVER_IP` と `SERVER_PORT` を確認
- **認証エラー**: `OPENAI_API_KEY` に正しい値が設定されているか確認
