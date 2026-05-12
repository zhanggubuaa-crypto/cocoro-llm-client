#!/bin/bash
# apply-config.sh — Antigravity / CI 向け: 設定ファイルを直接生成する
#
# 使い方（対話なし・スクリプト不要）:
#   SERVER_IP=192.168.x.x API_KEY=sk-xxx ./scripts/apply-config.sh
#
# オプション:
#   TARGET=opencode        OpenCode用設定を生成（デフォルト）
#   TARGET=claude-code     Claude Code用設定を生成
#   TARGET=both            両方生成

set -e

SERVER_IP="${SERVER_IP:?'SERVER_IP 環境変数が未設定です。例: SERVER_IP=192.168.50.112'}"
API_KEY="${API_KEY:?'API_KEY 環境変数が未設定です。例: API_KEY=sk-xxx'}"
TARGET="${TARGET:-opencode}"

echo "=== apply-config ===" >&2
echo "Server IP : $SERVER_IP" >&2
echo "Target    : $TARGET" >&2
echo "" >&2

# ── OpenCode ──────────────────────────────────────────────────
setup_opencode() {
    local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
    local config_path="$config_dir/opencode.json"
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local sample_path="$script_dir/../opencode.json.sample"

    if [ ! -f "$sample_path" ]; then
        echo "✗ opencode.json.sample が見つかりません: $sample_path" >&2
        exit 1
    fi

    mkdir -p "$config_dir"
    sed \
        -e "s|http://YOUR_SERVER_IP:4000|http://${SERVER_IP}:4000|g" \
        -e "s|YOUR_API_KEY_HERE|${API_KEY}|g" \
        "$sample_path" > "$config_path"

    echo "✓ OpenCode 設定を書き込みました: $config_path" >&2

    # 接続確認
    local response
    response=$(curl -s --max-time 10 "http://${SERVER_IP}:4000/health/liveliness" 2>/dev/null || true)
    if [ -n "$response" ]; then
        echo "✓ サーバー接続成功: $response" >&2
    else
        echo "⚠ サーバーに接続できません: http://${SERVER_IP}:4000" >&2
    fi
}

# ── Claude Code ───────────────────────────────────────────────
setup_claude_code() {
    local claude_dir="$HOME/.claude"
    local settings_path="$claude_dir/settings.json"
    local proxy_url="http://${SERVER_IP}:4001"

    mkdir -p "$claude_dir"

    if [ -f "$settings_path" ]; then
        cp "$settings_path" "${settings_path}.bak"
        echo "  バックアップ: ${settings_path}.bak" >&2
    fi

    python3 - "$settings_path" "$proxy_url" "$API_KEY" <<'PYEOF'
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

    echo "✓ Claude Code 設定を書き込みました: $settings_path" >&2
    echo "  接続先: $proxy_url" >&2
}

# ── メイン ────────────────────────────────────────────────────
case "$TARGET" in
    opencode)
        setup_opencode
        ;;
    claude-code)
        setup_claude_code
        ;;
    both)
        setup_opencode
        setup_claude_code
        ;;
    *)
        echo "✗ 不明な TARGET: $TARGET (opencode / claude-code / both)" >&2
        exit 1
        ;;
esac

echo "" >&2
echo "=== 完了 ===" >&2
