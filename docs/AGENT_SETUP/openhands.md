# OpenHands 縺ｨ縺ｮ謗･邯夊ｨｭ螳・
## 讎りｦ・
OpenHands 縺九ｉ cocoro-llm-server 繧剃ｽｿ縺・ｨｭ螳壹〒縺吶・
## 迺ｰ蠅・､画焚

OpenHands 縺ｮ迺ｰ蠅・､画焚險ｭ螳・

```bash
# cocoro-llm-server (LiteLLM)
export OPENAI_API_BASE=http://<SERVER_IP>:4000/v1
export OPENAI_API_KEY=your_litellm_master_key
export OPENAI_MODEL=qwen3-coder
```

## 險ｭ螳壽婿豕・
### 1. cocoro-llm-client 縺ｮ繧ｻ繝・ヨ繧｢繝・・

```bash
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
./scripts/setup-client.sh
```

### 2. OpenHands 縺ｮ襍ｷ蜍・
```bash
# 莉ｻ諢上・繝・ぅ繝ｬ繧ｯ繝医Μ縺ｧ
mkdir -p ~/.opencode/openhands
cd ~/.opencode/openhands

# 迺ｰ蠅・､画焚繧定ｨｭ螳・export OPENAI_API_BASE=http://<SERVER_IP>:4000/v1
export OPENAI_API_KEY=your_litellm_master_key
export OPENAI_MODEL=qwen3-coder

# OpenHands 繧定ｵｷ蜍・opencode init
opencode build "繧ｿ繧ｹ繧ｯ繧貞・蜉・
```

## OpenHands 縺ｮ險ｭ螳壹ヵ繧｡繧､繝ｫ

`opencode.json` 縺ｫ縺翫￠繧玖ｨｭ螳・

```json
{
  "models": {
    "default": "litellm/qwen3-coder",
    "providers": {
      "litellm": {
        "baseURL": "http://<SERVER_IP>:4000/v1",
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

## 隍・焚繝｢繝・Ν縺ｮ蛻・ｊ譖ｿ縺・
OpenHands 縺ｧ縺ｯ迺ｰ蠅・､画焚縺ｧ繝｢繝・Ν繧貞・繧頑崛縺・

```bash
# Qwen3 Coder (譎ｮ谿ｵ菴ｿ縺・
export OPENAI_MODEL=qwen3-coder

# Claude Sonnet (髮｣隗｣繧ｿ繧ｹ繧ｯ)
export OPENAI_MODEL=claude-sonnet
```

## 繝医Λ繝悶Ν繧ｷ繝･繝ｼ繝・ぅ繝ｳ繧ｰ

隧ｳ邏ｰ縺ｯ [TROUBLESHOOTING.md](../TROUBLESHOOTING.md) 繧貞盾辣ｧ縲・
- **謗･邯壹お繝ｩ繝ｼ**: `SERVER_IP` 縺ｨ `SERVER_PORT` 繧堤｢ｺ隱・- **隱崎ｨｼ繧ｨ繝ｩ繝ｼ**: `OPENAI_API_KEY` 縺ｫ豁｣縺励＞蛟､縺瑚ｨｭ螳壹＆繧後※縺・ｋ縺狗｢ｺ隱・