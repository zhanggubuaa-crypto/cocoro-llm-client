# cocoro-core 縺ｨ縺ｮ謗･邯夊ｨｭ螳・
## 讎りｦ・
cocoro-core 縺九ｉ cocoro-llm-server 繧剃ｽｿ縺・ｨｭ螳壹〒縺吶・
## 迺ｰ蠅・､画焚

cocoro-core 縺ｮ `.env` 繝輔ぃ繧､繝ｫ縺ｫ霑ｽ蜉:

```env
# cocoro-llm-server (LiteLLM)
LLM_PROVIDER=openai
OPENAI_API_BASE=http://<SERVER_IP>:4000/v1
OPENAI_API_KEY=your_litellm_master_key
OPENAI_MODEL=gpt-4o
```

## 險ｭ螳壽焔鬆・
### 1. cocoro-llm-client 縺ｮ繧ｻ繝・ヨ繧｢繝・・

```bash
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
./scripts/setup-client.sh
```

### 2. cocoro-core 縺ｸ縺ｮ謗･邯・
cocoro-core 繝・ぅ繝ｬ繧ｯ繝医Μ縺ｧ `.env` 繧堤ｷｨ髮・

```env
# cocoro-llm-server 謗･邯夊ｨｭ螳・LLM_PROVIDER=openai
OPENAI_API_BASE=http://<SERVER_IP>:4000/v1
OPENAI_API_KEY=your_litellm_master_key
OPENAI_MODEL=gpt-4o

# 蜍穂ｽ懆ｨｭ螳・LLM_TEMPERATURE=0.7
LLM_MAX_TOKENS=32768
```

### 3. cocoro-core 縺ｮ襍ｷ蜍・
```bash
cd /path/to/cocoro-core
docker compose up -d
```

## 繧ｨ繝ｼ繧ｸ繧ｧ繝ｳ繝亥挨縺ｮ險ｭ螳・
### chat 繧ｨ繝ｼ繧ｸ繧ｧ繝ｳ繝・
```env
LLM_PROVIDER=openai
OPENAI_API_BASE=http://<SERVER_IP>:4000/v1
OPENAI_API_KEY=your_litellm_master_key
OPENAI_MODEL=qwen3-coder
```

### build 繧ｨ繝ｼ繧ｸ繧ｧ繝ｳ繝・
```env
LLM_PROVIDER=openai
OPENAI_API_BASE=http://<SERVER_IP>:4000/v1
OPENAI_API_KEY=your_litellm_master_key
OPENAI_MODEL=qwen3-coder
LLM_TEMPERATURE=0.2
```

## 蠢懃ｭ泌ｽ｢蠑上・險ｭ螳・
cocoro-core 縺ｧ譛溷ｾ・＆繧後ｋ蠢懃ｭ泌ｽ｢蠑・

```json
{
  "choices": [
    {
      "message": {
        "content": "蠢懃ｭ斐Γ繝・そ繝ｼ繧ｸ",
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

## 繝医Λ繝悶Ν繧ｷ繝･繝ｼ繝・ぅ繝ｳ繧ｰ

隧ｳ邏ｰ縺ｯ [TROUBLESHOOTING.md](../TROUBLESHOOTING.md) 繧貞盾辣ｧ縲・
- **JSON 繝代・繧ｹ繧ｨ繝ｩ繝ｼ**: `--tool-call-parser qwen3_coder` 繧ｪ繝励す繝ｧ繝ｳ繧堤｢ｺ隱・- **謗･邯壹お繝ｩ繝ｼ**: cocoro-llm-server 縺ｮ繝昴・繝・4000 繧堤｢ｺ隱・