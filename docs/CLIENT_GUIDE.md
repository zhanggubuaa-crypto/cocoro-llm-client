# cocoro-llm-client 繧ｬ繧､繝・
## 逶ｮ谺｡
- [謇句虚繧ｻ繝・ヨ繧｢繝・・](#謇句虚繧ｻ繝・ヨ繧｢繝・・)
- [閾ｪ蜍輔そ繝・ヨ繧｢繝・・繧ｹ繧ｯ繝ｪ繝励ヨ](#閾ｪ蜍輔そ繝・ヨ繧｢繝・・繧ｹ繧ｯ繝ｪ繝励ヨ)
- [OS縺斐→縺ｮ驕輔＞](#os縺斐→縺ｮ驕輔＞)
- [謗･邯夂｢ｺ隱江(#謗･邯夂｢ｺ隱・
- [繝医Λ繝悶Ν繧ｷ繝･繝ｼ繝・ぅ繝ｳ繧ｰ](#繝医Λ繝悶Ν繧ｷ繝･繝ｼ繝・ぅ繝ｳ繧ｰ)

## 謇句虚繧ｻ繝・ヨ繧｢繝・・

### 1. 繝ｪ繝昴ず繝医Μ縺ｮ clone

```bash
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
```

### 2. 險ｭ螳壹ヵ繧｡繧､繝ｫ縺ｮ繧ｳ繝斐・

```bash
cp opencode.json.sample opencode.json
cp .env.example .env
```

### 3. API繧ｭ繝ｼ縺ｮ險ｭ螳・
`opencode.json` 繧堤ｷｨ髮・

```json
{
  "provider": {
    "litellm": {
      "options": {
        "apiKey": "YOUR_LITELLM_MASTER_KEY_HERE"
      }
    }
  }
}
```

`.env` 繝輔ぃ繧､繝ｫ繧ょ酔讒倥↓邱ｨ髮・

```env
LITELLM_API_KEY=YOUR_LITELLM_MASTER_KEY_HERE
SERVER_IP=<SERVER_IP>
SERVER_PORT=4000
```

### 4. 遒ｺ隱・
```bash
opencode init
opencode chat "縺薙ｓ縺ｫ縺｡縺ｯ"
```

## 閾ｪ蜍輔そ繝・ヨ繧｢繝・・繧ｹ繧ｯ繝ｪ繝励ヨ

### Windows

```powershell
.\scripts\setup-client.ps1
```

### Linux / WSL

```bash
chmod +x scripts/setup-client.sh
./scripts/setup-client.sh
```

## OS縺斐→縺ｮ驕輔＞

| 鬆・岼 | Windows | WSL | Linux |
|------|---------|-----|-------|
| 繧ｹ繧ｯ繝ｪ繝励ヨ諡｡蠑ｵ蟄・| `.ps1` | `.sh` | `.sh` |
| 螳溯｡梧婿豕・| `.\script.ps1` | `./script.sh` | `./script.sh` |
| API繧ｭ繝ｼ蜈･蜉・| PowerShell `Read-Host` | Bash `read` | Bash `read` |
| HTTP繧ｯ繝ｩ繧､繧｢繝ｳ繝・| `Invoke-RestMethod` | `curl` | `curl` |

## 謗･邯夂｢ｺ隱・
### 繝倥Ν繧ｹ繝√ぉ繝・け

```bash
curl http://<SERVER_IP>:4000/health/liveliness
# Expected: "ok"
```

### 謗ｨ隲悶ユ繧ｹ繝・
```bash
curl http://<SERVER_IP>:4000/v1/chat/completions \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"qwen3-coder","messages":[{"role":"user","content":"test"}]}'
```

## 繝医Λ繝悶Ν繧ｷ繝･繝ｼ繝・ぅ繝ｳ繧ｰ

隧ｳ邏ｰ縺ｪ繝医Λ繝悶Ν繧ｷ繝･繝ｼ繝・ぅ繝ｳ繧ｰ縺ｯ [docs/TROUBLESHOOTING.md](./TROUBLESHOOTING.md) 繧貞盾辣ｧ縲・
### 襍ｷ縺阪ｄ縺吶＞蝠城｡・
1. **謗･邯壹お繝ｩ繝ｼ (code 7)**: cocoro-llm-server 縺瑚ｵｷ蜍輔＠縺ｦ縺・↑縺・2. **隱崎ｨｼ繧ｨ繝ｩ繝ｼ (401)**: API繧ｭ繝ｼ縺碁俣驕輔▲縺ｦ縺・ｋ
3. **DNS隗｣豎ｺ螟ｱ謨・*: `<SERVER_IP>` 縺ｫ繧｢繧ｯ繧ｻ繧ｹ縺ｧ縺阪↑縺・