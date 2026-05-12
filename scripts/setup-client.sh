#!/bin/bash
# cocoro-llm-client Setup Script (Linux/macOS/WSL)
# OpenCodeのインストール + cocoro-llm-serverへの接続設定を行います
#
# 非対話モード（Antigravity / CI 向け）:
#   SERVER_IP=192.168.x.x API_KEY=sk-xxx ./scripts/setup-client.sh

set -e

echo "=== cocoro-llm-client Setup ===" >&2

# ──────────────────────────────────────────────────────────────
# Step 1: OpenCode のインストール確認・自動インストール
# ──────────────────────────────────────────────────────────────
echo "" >&2
echo "Step 1: OpenCode の確認..." >&2

if command -v opencode &>/dev/null; then
    ver=$(opencode --version 2>/dev/null || echo "バージョン不明")
    echo "✓ OpenCode はインストール済みです: $ver" >&2
else
    echo "OpenCode が見つかりません。インストールします..." >&2
    echo "  公式インストーラーを実行中..." >&2

    curl -fsSL https://opencode.ai/install | bash

    # PATHを更新（インストーラーが ~/.local/bin に入れる場合が多い）
    export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

    if command -v opencode &>/dev/null; then
        echo "✓ OpenCode をインストールしました" >&2
    else
        echo "⚠ インストールは完了しましたが、PATH に opencode が見つかりません" >&2
        echo "  ターミナルを再起動するか、以下を実行してください:" >&2
        echo "  source ~/.bashrc  または  source ~/.zshrc" >&2
    fi
fi

# ──────────────────────────────────────────────────────────────
# Step 2: サーバーIPの入力（環境変数 SERVER_IP があればスキップ）
# ──────────────────────────────────────────────────────────────
echo "" >&2
echo "Step 2: サーバー接続設定" >&2

if [ -n "${SERVER_IP:-}" ]; then
    server_ip="$SERVER_IP"
    echo "✓ Server IP (環境変数): $server_ip" >&2
else
    echo "cocoro-llm-server のIPアドレスを入力してください:" >&2
    echo "  (サーバーPCで show_connection_info.sh を実行して確認できます)" >&2
    read -p "Server IP: " server_ip
    if [ -z "$server_ip" ]; then
        echo "✗ Server IP は必須です" >&2
        exit 1
    fi
fi
server_url="http://${server_ip}:4000"
echo "✓ Server URL: $server_url" >&2

# ──────────────────────────────────────────────────────────────
# Step 3: APIキーの入力（環境変数 API_KEY があればスキップ）
# ──────────────────────────────────────────────────────────────
echo "" >&2

if [ -n "${API_KEY:-}" ]; then
    api_key="$API_KEY"
    echo "✓ API Key (環境変数): ****${api_key: -4}" >&2
else
    echo "LiteLLM APIキーを入力してください:" >&2
    read -p "API Key (LITELLM_MASTER_KEY): " api_key
    if [ -z "$api_key" ]; then
        echo "✗ API Key は必須です" >&2
        exit 1
    fi
fi

# ──────────────────────────────────────────────────────────────
# Step 4: グローバル設定ファイルを書き込む
# ──────────────────────────────────────────────────────────────
echo "" >&2
echo "Step 3: OpenCode 設定ファイルを書き込んでいます..." >&2

# 公式ドキュメント準拠のパス: ~/.config/opencode/opencode.json
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
config_path="$config_dir/opencode.json"

mkdir -p "$config_dir"
echo "✓ 設定ディレクトリ: $config_dir" >&2

# opencode.json.sample を読み込んでIPとキーを置換
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sample_path="$script_dir/../opencode.json.sample"

if [ ! -f "$sample_path" ]; then
    echo "✗ opencode.json.sample が見つかりません: $sample_path" >&2
    exit 1
fi

sed \
    -e "s|http://YOUR_SERVER_IP:4000|$server_url|g" \
    -e "s|YOUR_API_KEY_HERE|$api_key|g" \
    "$sample_path" > "$config_path"

echo "✓ 設定ファイルを書き込みました: $config_path" >&2

# ──────────────────────────────────────────────────────────────
# Step 5: サーバーへの接続確認
# ──────────────────────────────────────────────────────────────
echo "" >&2
echo "Step 4: サーバーへの接続を確認しています..." >&2
if command -v curl &>/dev/null; then
    response=$(curl -s --max-time 10 "$server_url/health/liveliness" 2>/dev/null || true)
    if [ -n "$response" ]; then
        echo "✓ サーバー接続成功: $response" >&2
    else
        echo "⚠ サーバーに接続できませんでした" >&2
        echo "  サーバーが起動しているか確認してください: $server_url" >&2
    fi
fi

# ──────────────────────────────────────────────────────────────
# 完了
# ──────────────────────────────────────────────────────────────
echo "" >&2
echo "=== セットアップ完了 ===" >&2
echo "opencode をどのフォルダでも起動できます:" >&2
echo "  opencode" >&2
echo "" >&2
echo "設定ファイル: $config_path" >&2
