#!/bin/bash
# cocoro-llm-client Setup Script (Linux/WSL)
# cocoro-llm-server との接続設定を行います

set -e

echo "=== cocoro-llm-client Setup ===" >&2
echo "Connecting to cocoro-llm-server at 192.168.50.112:4000" >&2

# 設定ファイルのコピー
echo "Copying opencode.json.sample to opencode.json..." >&2
cp opencode.json.sample opencode.json
if [ $? -eq 0 ]; then
    echo "✓ opencode.json created" >&2
else
    echo "✗ Failed to copy opencode.json" >&2
    exit 1
fi

# APIキーの入力
echo
echo "Please enter your LITELLM API Key:" >&2
read -p "API Key (LITELLM_MASTER_KEY): " apiKey

if [ -z "$apiKey" ]; then
    echo "✗ API Key is required" >&2
    exit 1
fi

# APIキーの置換
echo "Updating opencode.json with API key..." >&2
sed -i "s/YOUR_API_KEY_HERE/$apiKey/g" opencode.json
if [ $? -eq 0 ]; then
    echo "✓ API key configured" >&2
else
    echo "✗ Failed to update API key" >&2
    exit 1
fi

# ヘルスチェック
echo
echo "Checking connection to cocoro-llm-server..." >&2
server_url="http://192.168.50.112:4000/health/liveliness"
if command -v curl &> /dev/null; then
    response=$(curl -s --max-time 10 "$server_url" 2>/dev/null || true)
    if [ "$response" = "ok" ]; then
        echo "✓ Server connection verified" >&2
    else
        echo "✗ Unexpected response: $response" >&2
        exit 1
    fi
else
    echo "⚠ curl not found, skipping health check" >&2
fi

echo
echo "=== Setup Complete ===" >&2
echo "Next steps:" >&2
echo "  1. Review opencode.json settings" >&2
echo "  2. Run \`opencode init\` to initialize" >&2
