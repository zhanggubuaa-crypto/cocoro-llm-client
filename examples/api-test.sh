#!/bin/bash
# API Test Script for cocoro-llm-client
# cocoro-llm-server との接続テストを行います。

set -e

API_KEY="${LITELLM_API_KEY:-litellm}"
BASE_URL="http://<SERVER_IP>:4000/v1"

echo "=== Testing cocoro-llm-server Connection ===" >&2

# 1. ヘルスチェック
echo
echo "1. Health Check..." >&2
response=$(curl -s "${BASE_URL}/health/liveliness")
if [ "$response" = "ok" ]; then
    echo "✓ Health check passed" >&2
else
    echo "✗ Health check failed: $response" >&2
fi

# 2. モデル一覧
echo
echo "2. List Models..." >&2
models=$(curl -s "${BASE_URL}/models" | jq -r '.data[].id' 2>/dev/null || echo "Failed")
echo "$models" >&2

# 3. 推論テスト (ローカルモデル直結)
echo
echo "3. Test local model (coco-local)..." >&2
response=$(curl -s -X POST "${BASE_URL}/chat/completions" \
    -H "Authorization: Bearer ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "coco-local",
        "messages": [{"role": "user", "content": "Hello, world!"}],
        "max_tokens": 10
    }' 2>/dev/null || echo "Failed")

if [[ "$response" == *"error"* ]]; then
    echo "✗ Local model test failed: $response" >&2
else
    echo "✓ Local model test passed" >&2
fi

# 4. 推論テスト (Claude Sonnet)
echo
echo "4. Test Claude Sonnet..." >&2
response=$(curl -s -X POST "${BASE_URL}/chat/completions" \
    -H "Authorization: Bearer ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "claude-sonnet",
        "messages": [{"role": "user", "content": "Hello, world!"}],
        "max_tokens": 10
    }' 2>/dev/null || echo "Failed")

if [[ "$response" == *"error"* ]]; then
    echo "✗ Claude Sonnet test failed: $response" >&2
else
    echo "✓ Claude Sonnet test passed" >&2
fi

echo
echo "=== Test Complete ===" >&2
