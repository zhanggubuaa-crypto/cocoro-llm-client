# AntGravity 縺ｨ縺ｮ謗･邯夊ｨｭ螳・
## 讎りｦ・
cocoro-llm-server 繧・AntGravity 縺ｧ菴ｿ逕ｨ縺吶ｋ險ｭ螳壹〒縺吶・
## 迺ｰ蠅・､画焚

`.env` 繝輔ぃ繧､繝ｫ縺ｫ莉･荳九・險ｭ螳壹ｒ霑ｽ蜉:

```env
# cocoro-llm-server (LiteLLM)
LITELLM_API_KEY=your_master_key_here
SERVER_IP=<SERVER_IP>
SERVER_PORT=4000

# AntGravity 逕ｨ縺ｮ迺ｰ蠅・､画焚
ANTHROPIC_API_KEY=your_anthropic_api_key   # Claude 菴ｿ逕ｨ譎・ANTHROPIC_BASE_URL=http://<SERVER_IP>:4000/v1
ANTHROPIC_API_KEY=litellm                           # LiteLLM 邨檎罰譎ゅ・蝗ｺ螳壼､
```

## 險ｭ螳壽婿豕・
### 1. cocoro-llm-client 縺ｮ繧ｻ繝・ヨ繧｢繝・・

```bash
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
./scripts/setup-client.sh
```

### 2. opencode.json 縺ｮ遒ｺ隱・
`opencode.json` 縺梧ｭ｣縺励￥險ｭ螳壹＆繧後※縺・ｋ縺薙→繧堤｢ｺ隱・

```json
{
  "provider": {
    "litellm": {
      "options": {
        "baseURL": "http://<SERVER_IP>:4000/v1",
        "apiKey": "YOUR_API_KEY"
      }
    }
  }
}
```

### 3. AntGravity 縺ｧ縺ｮ菴ｿ逕ｨ

AntGravity 縺ｧ譁ｰ縺励＞繧ｨ繝ｼ繧ｸ繧ｧ繝ｳ繝医ｒ菴懈・:

- **LLM Provider**: OpenAI莠呈鋤 (LiteLLM)
- **Base URL**: `http://<SERVER_IP>:4000/v1`
- **API Key**: `litellm` (縺ｾ縺溘・ `LITELLM_MASTER_KEY`)
- **Model**: `qwen3-coder` 縺ｾ縺溘・ `claude-sonnet`

## 謗ｨ螂ｨ險ｭ螳・
| 險ｭ螳夐・岼 | 蛟､ | 逕ｨ騾・|
|---------|-----|------|
| Temperature | `0.7` | 騾壼ｸｸ縺ｮ繧ｳ繝ｼ繝・ぅ繝ｳ繧ｰ |
| Temperature | `0.2` | 險ｭ險医・隕∫ｴ・|
| Max Tokens | `32768` | 髟ｷ縺・さ繝ｳ繝・く繧ｹ繝亥ｯｾ蠢・|
| Model | `qwen3-coder` | 譎ｮ谿ｵ菴ｿ縺・|
| Model | `claude-sonnet` | 髮｣隗｣繧ｿ繧ｹ繧ｯ |

## 繝医Λ繝悶Ν繧ｷ繝･繝ｼ繝・ぅ繝ｳ繧ｰ

隧ｳ邏ｰ縺ｯ [TROUBLESHOOTING.md](../TROUBLESHOOTING.md) 繧貞盾辣ｧ縲・
- **謗･邯壹お繝ｩ繝ｼ**: cocoro-llm-server 縺後・繝ｼ繝・4000 縺ｧ襍ｷ蜍輔＠縺ｦ縺・ｋ縺狗｢ｺ隱・- **隱崎ｨｼ繧ｨ繝ｩ繝ｼ**: `ANTHROPIC_API_KEY` 縺ｫ豁｣縺励＞ API 繧ｭ繝ｼ縺瑚ｨｭ螳壹＆繧後※縺・ｋ縺狗｢ｺ隱・