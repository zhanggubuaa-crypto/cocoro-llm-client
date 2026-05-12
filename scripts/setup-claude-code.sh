#!/bin/bash
# cocoro-llm-client Setup Script - Claude Code (Linux/macOS/WSL)
# Claude Code を cocoro-llm-server (ローカルLLM) に接続します。
# ~/.claude/settings.json に env を書き込むため、どのフォルダでも有効になります。
#
# 非対話モード（Antigravity / CI 向け）:
#   SERVER_IP=192.168.x.x API_KEY=sk-xxx ./scripts/setup-claude-code.sh

set -e

echo "=== Claude Code Setup ===" >&2

# ──────────────────────────────────────────────────────────────
# Step 1: Claude Code のインストール確認
# ──────────────────────────────────────────────────────────────
echo "" >&2
echo "Step 1: Claude Code の確認..." >&2

if command -v claude &>/dev/null; then
    echo "  Claude Code はインストール済みです: $(command -v claude)" >&2
else
    echo "  Claude Code が見つかりません。" >&2
    echo "  以下を実行してインストールしてください (Node.js 必要):" >&2
    echo "    npm install -g @anthropic-ai/claude-code" >&2
    echo "  その後、もう一度このスクリプトを実行してください。" >&2
    exit 1
fi

# ──────────────────────────────────────────────────────────────
# Step 2: サーバーIPの入力（環境変数 SERVER_IP があればスキップ）
# ──────────────────────────────────────────────────────────────
echo "" >&2
echo "Step 2: サーバー接続設定" >&2

if [ -n "${SERVER_IP:-}" ]; then
    server_ip="$SERVER_IP"
    echo "  ✓ Server IP (環境変数): $server_ip" >&2
else
    echo "  cocoro-llm-server のIPアドレスを入力してください" >&2
    echo "  - 同じLAN: サーバーPCのLAN IP (例: 192.168.x.x)" >&2
    echo "  - Tailscale 経由: サーバーPCの Tailscale IP (例: 100.x.x.x)" >&2
    echo "  サーバーPCで scripts/show_connection_info.sh を実行すれば一覧表示されます" >&2
    read -p "  Server IP: " server_ip
    if [ -z "$server_ip" ]; then
        echo "  Server IP は必須です" >&2
        exit 1
    fi
fi

proxy_url="http://${server_ip}:4001"
health_url="http://${server_ip}:4000/health/liveliness"

# ──────────────────────────────────────────────────────────────
# Step 3: APIキーの入力（環境変数 API_KEY があればスキップ）
# ──────────────────────────────────────────────────────────────
echo "" >&2

if [ -n "${API_KEY:-}" ]; then
    api_key="$API_KEY"
    echo "  ✓ API Key (環境変数): ****${api_key: -4}" >&2
else
    read -p "  API Key (LITELLM_MASTER_KEY): " api_key
    if [ -z "$api_key" ]; then
        echo "  API Key は必須です" >&2
        exit 1
    fi
fi

# ──────────────────────────────────────────────────────────────
# Step 4: ~/.claude/settings.json を生成・マージ
# ──────────────────────────────────────────────────────────────
echo "" >&2
echo "Step 3: Claude Code 設定ファイルを書き込んでいます..." >&2

claude_dir="$HOME/.claude"
settings_path="$claude_dir/settings.json"
mkdir -p "$claude_dir"

# python があれば既存設定を保ってマージ、なければ素で書き出し
if command -v python3 &>/dev/null; then
    PYBIN=python3
elif command -v python &>/dev/null; then
    PYBIN=python
else
    PYBIN=""
fi

if [ -n "$PYBIN" ]; then
    if [ -f "$settings_path" ]; then
        cp "$settings_path" "${settings_path}.bak"
        echo "  バックアップ: ${settings_path}.bak" >&2
    fi
    "$PYBIN" - "$settings_path" "$proxy_url" "$api_key" <<'PYEOF'
import json, os, sys
path, proxy_url, api_key = sys.argv[1], sys.argv[2], sys.argv[3]
data = {}
if os.path.exists(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception:
        data = {}
env = data.get("env", {}) or {}
env["ANTHROPIC_BASE_URL"] = proxy_url
env["ANTHROPIC_API_KEY"] = api_key
data["env"] = env
data.setdefault("model", "claude-sonnet-4-6")
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
PYEOF
else
    # python が無い: 既存設定があれば警告して上書きしない
    if [ -f "$settings_path" ]; then
        echo "  python が見つかりません。既存の settings.json を上書きしないよう中止します。" >&2
        echo "  手動で以下を $settings_path に追加してください:" >&2
        echo "    \"env\": {" >&2
        echo "      \"ANTHROPIC_BASE_URL\": \"$proxy_url\"," >&2
        echo "      \"ANTHROPIC_API_KEY\": \"$api_key\"" >&2
        echo "    }" >&2
        exit 1
    fi
    cat > "$settings_path" <<EOF
{
  "model": "claude-sonnet-4-6",
  "env": {
    "ANTHROPIC_BASE_URL": "$proxy_url",
    "ANTHROPIC_API_KEY": "$api_key"
  }
}
EOF
fi

echo "  設定ファイルを書き込みました: $settings_path" >&2

# ──────────────────────────────────────────────────────────────
# Step 5: サーバーへの接続確認
# ──────────────────────────────────────────────────────────────
echo "" >&2
echo "Step 4: サーバーへの接続を確認しています..." >&2
if command -v curl &>/dev/null; then
    response=$(curl -s --max-time 10 "$health_url" 2>/dev/null || true)
    if [ -n "$response" ]; then
        echo "  サーバー接続成功: $response" >&2
    else
        echo "  サーバーに接続できませんでした" >&2
        echo "  サーバーが起動しているか確認してください: $health_url" >&2
    fi
fi

# ──────────────────────────────────────────────────────────────
# 完了
# ──────────────────────────────────────────────────────────────
echo "" >&2
echo "=== セットアップ完了 ===" >&2
echo "新しいターミナルを開いて、どのフォルダでも以下を実行できます:" >&2
echo "  claude" >&2
echo "" >&2
echo "設定ファイル: $settings_path" >&2
echo "接続先: $proxy_url (ローカルLLM)" >&2
