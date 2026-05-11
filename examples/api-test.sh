#!/bin/bash
# API Test Script for cocoro-llm-client
# cocoro-llm-server 縺ｨ縺ｮ謗･邯壹ユ繧ｹ繝医ｒ陦後＞縺ｾ縺・
set -e

API_KEY="${LITELLM_API_KEY:-litellm}"
BASE_URL="http://<SERVER_IP>:4000/v1"

echo "=== Testing cocoro-llm-server Connection ===" >&2

# 1. 繝倥Ν繧ｹ繝√ぉ繝・け
echo
echo "1. Health Check..." >&2
response=$(curl -s "${BASE_URL}/health/liveliness")
if [ "$response" = "ok" ]; then
    echo "笨・Health check passed" >&2
else
    echo "笨・Health check failed: $response" >&2
fi

# 2. 繝｢繝・Ν荳隕ｧ
echo
echo "2. List Models..." >&2
models=$(curl -s "${BASE_URL}/models" | jq -r '.data[].id' 2>/dev/null || echo "Failed")
echo "$models" >&2

# 3. 謗ｨ隲悶ユ繧ｹ繝・(Qwen3 Coder)
echo
echo "3. Test Qwen3 Coder..." >&2
response=$(curl -s -X POST "${BASE_URL}/chat/completions" \
    -H "Authorization: Bearer ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "qwen3-coder",
        "messages": [{"role": "user", "content": "Hello, world!"}],
        "max_tokens": 10
    }' 2>/dev/null || echo "Failed")

if [[ "$response" == *"error"* ]]; then
    echo "笨・Qwen3 Coder test failed: $response" >&2
else
    echo "笨・Qwen3 Coder test passed" >&2
fi

# 4. 謗ｨ隲悶ユ繧ｹ繝・(Claude Sonnet)
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
    echo "笨・Claude Sonnet test failed: $response" >&2
else
    echo "笨・Claude Sonnet test passed" >&2
fi

echo
echo "=== Test Complete ===" >&2
