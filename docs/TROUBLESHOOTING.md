# 繝医Λ繝悶Ν繧ｷ繝･繝ｼ繝・ぅ繝ｳ繧ｰ

## 繧医￥縺ゅｋ蝠城｡後→隗｣豎ｺ遲・
### 1. 謗･邯壹お繝ｩ繝ｼ (curl code 7)

**繧ｨ繝ｩ繝ｼ蜀・ｮｹ**:
```
curl: (7) Failed to connect to <SERVER_IP> port 4000: Connection refused
```

**蜴溷屏**:
- cocoro-llm-server 縺瑚ｵｷ蜍輔＠縺ｦ縺・↑縺・- 繝昴・繝・4000 縺碁幕縺・※縺・↑縺・- 繝輔ぃ繧､繧｢繧ｦ繧ｩ繝ｼ繝ｫ縺ｧ繝悶Ο繝・け縺輔ｌ縺ｦ縺・ｋ

**隗｣豎ｺ遲・*:

1. cocoro-llm-server 縺ｮ迥ｶ諷九ｒ遒ｺ隱・

```bash
# cocoro-llm-server 縺ｫ SSH 縺ｧ謗･邯・ssh user@<SERVER_IP>

# Docker 繧ｳ繝ｳ繝・リ縺ｮ迥ｶ諷・docker compose ps

# LiteLLM 縺ｮ繝ｭ繧ｰ
docker compose logs litellm
```

2. 繝昴・繝医ｒ遒ｺ隱・

```bash
# Linux/WSL
netstat -tuln | grep 4000

# Windows
netstat -ano | findstr :4000
```

3. 繝輔ぃ繧､繧｢繧ｦ繧ｩ繝ｼ繝ｫ縺ｮ險ｭ螳・

```bash
# cocoro-llm-server 蛛ｴ縺ｧ繝昴・繝医ｒ髢九￥
sudo ufw allow 4000
```

---

### 2. 隱崎ｨｼ繧ｨ繝ｩ繝ｼ (HTTP 401)

**繧ｨ繝ｩ繝ｼ蜀・ｮｹ**:
```json
{
  "error": {
    "message": "Incorrect API key provided",
    "code": 401
  }
}
```

**蜴溷屏**:
- API 繧ｭ繝ｼ縺梧ｭ｣縺励￥縺ｪ縺・- API 繧ｭ繝ｼ縺ｮ蠖｢蠑上′髢馴＆縺｣縺ｦ縺・ｋ

**隗｣豎ｺ遲・*:

1. API 繧ｭ繝ｼ繧堤｢ｺ隱・

```bash
# cocoro-llm-server 縺ｮ .env 繝輔ぃ繧､繝ｫ
cat ~/.cocoro-llm-server/.env

# 縺ｾ縺溘・縲´ITELLM_MASTER_KEY 繧堤｢ｺ隱・grep LITELLM_MASTER_KEY ~/.cocoro-llm-server/.env
```

2. 繧ｯ繝ｩ繧､繧｢繝ｳ繝亥・縺ｮ險ｭ螳壹ｒ譖ｴ譁ｰ:

```bash
# opencode.json 縺ｮ apiKey 繧呈ｭ｣縺励＞蛟､縺ｫ
# .env 縺ｮ LITELLM_API_KEY 繧よｭ｣縺励＞蛟､縺ｫ
```

3. curl 縺ｧ繝・せ繝・

```bash
curl http://<SERVER_IP>:4000/v1/chat/completions \
  -H "Authorization: Bearer YOUR_CORRECT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"qwen3-coder","messages":[{"role":"user","content":"test"}]}'
```

---

### 3. WSL 縺九ｉ縺ｮ謗･邯壼撫鬘・
**繧ｨ繝ｩ繝ｼ蜀・ｮｹ**:
```
curl: (7) Failed to connect to <SERVER_IP> port 4000: No route to host
```

**蜴溷屏**:
- WSL 縺九ｉ Windows 繝帙せ繝医∈縺ｮ繧｢繧ｯ繧ｻ繧ｹ譁ｹ豕輔′逡ｰ縺ｪ繧・- WSL 縺ｮ DNS 險ｭ螳壹′豁｣縺励￥縺ｪ縺・
**隗｣豎ｺ遲・*:

1. WSL 縺九ｉ Windows 繝帙せ繝医∈縺ｮ謗･邯・

```bash
# WSL 縺ｧWindows縺ｮIP繧｢繝峨Ξ繧ｹ繧堤｢ｺ隱・cat /etc/resolv.conf | grep nameserver | awk '{print $2}'

# 縺ｾ縺溘・縲・etc/hosts 縺ｫ霑ｽ蜉
echo "<SERVER_IP> host.docker.internal" | sudo tee -a /etc/hosts
```

2. Alternative: `host.docker.internal` 繧剃ｽｿ逕ｨ:

```bash
# opencode.json 繧剃ｿｮ豁｣
"baseURL": "http://host.docker.internal:4000/v1"
```

3. Windows 繝輔ぃ繧､繧｢繧ｦ繧ｩ繝ｼ繝ｫ縺ｮ險ｭ螳・

```powershell
# Windows PowerShell 縺ｧ螳溯｡・New-NetFirewallRule -DisplayName "LiteLLM" -Direction Inbound -LocalPort 4000 -Protocol TCP -Action Allow
```

---

### 4. DNS 隗｣豎ｺ螟ｱ謨・
**繧ｨ繝ｩ繝ｼ蜀・ｮｹ**:
```
curl: (6) Could not resolve host: <SERVER_IP>
```

**蜴溷屏**:
- WSL 縺ｮ DNS 險ｭ螳壹′荳肴ｭ｣
- 繝阪ャ繝医Ρ繝ｼ繧ｯ讒区・縺ｫ蝠城｡後′縺ゅｋ

**隗｣豎ｺ遲・*:

1. WSL 縺ｮ DNS 險ｭ螳壹ｒ蜀肴ｧ区・:

```bash
sudo rm /etc/resolv.conf
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

2. `/etc/hosts` 繧堤｢ｺ隱・

```bash
cat /etc/hosts | grep <SERVER_IP>
```

3. 豁｣蠑上↑ IP 繧｢繝峨Ξ繧ｹ繧剃ｽｿ逕ｨ:

```bash
# ping 縺ｧ逍朱夂｢ｺ隱・ping <SERVER_IP>
```

---

### 5. 繝｢繝・Ν縺瑚ｦ九▽縺九ｉ縺ｪ縺・(HTTP 404)

**繧ｨ繝ｩ繝ｼ蜀・ｮｹ**:
```json
{
  "error": {
    "message": "The model qwen3-coder does not exist",
    "code": 404
  }
}
```

**蜴溷屏**:
- 繝｢繝・Ν蜷阪′髢馴＆縺｣縺ｦ縺・ｋ
- vLLM 縺後Δ繝・Ν繧偵Ο繝ｼ繝峨＠縺ｦ縺・↑縺・
**隗｣豎ｺ遲・*:

1. 蛻ｩ逕ｨ蜿ｯ閭ｽ縺ｪ繝｢繝・Ν繧堤｢ｺ隱・

```bash
curl http://<SERVER_IP>:8000/v1/models | jq '.data[].id'
```

2. vLLM 縺ｮ繝ｭ繧ｰ繧堤｢ｺ隱・

```bash
docker compose logs vllm-primary
```

3. opencode.json 縺ｮ繝｢繝・Ν蜷阪ｒ菫ｮ豁｣:

```json
{
  "model": "qwen3-coder"  // 豁｣縺励＞繝｢繝・Ν蜷阪↓螟画峩
}
```

---

## 繝・ヰ繝・げ謇矩・
### 1. 蝓ｺ譛ｬ逧・Γ繝ｳ繝・リ繝ｳ繧ｹ繝｢繝ｼ繝・
```bash
# cocoro-llm-server 縺ｧ螳溯｡・docker compose stop litellm
docker compose logs vllm-primary -f
```

### 2. 逍朱壹ユ繧ｹ繝・
```bash
# Windows 蛛ｴ縺ｧ
Test-NetConnection -ComputerName 0.0.0.0 -Port 4000

# WSL/Linux 蛛ｴ縺ｧ
nc -zv <SERVER_IP> 4000
```

### 3. API 繝・せ繝・
```bash
# curl 縺ｧ逶ｴ謗･繝・せ繝・curl -v http://<SERVER_IP>:4000/health/liveliness
curl -v http://<SERVER_IP>:4000/v1/models
```

---

## 縺昴ｌ縺ｧ繧りｧ｣豎ｺ縺励↑縺・ｴ蜷・
1. cocoro-llm-server 縺ｮ full restart:

```bash
docker compose down && docker compose up -d
```

2. 繧ｵ繝昴・繝医↓騾｣邨｡:

- GitHub Issue: https://github.com/mdl-systems/cocoro-llm-client/issues
- Discord: #cocoro-support
