# トラブルシューティング

## よくある問題と解決策

### 1. 接続エラー (curl code 7)

**エラー内容**:
```
curl: (7) Failed to connect to <SERVER_IP> port 4000: Connection refused
```

**原因**:
- cocoro-llm-server が起動していない
- ポート 4000 が開いていない
- ファイアウォールでブロックされている

**解決策**:

1. cocoro-llm-server の状態を確認:

```bash
# cocoro-llm-server に SSH で接続
ssh user@<SERVER_IP>

# Docker コンテナの状態
docker compose ps

# LiteLLM のログ
docker compose logs litellm
```

2. ポートを確認:

```bash
# Linux/WSL
netstat -tuln | grep 4000

# Windows
netstat -ano | findstr :4000
```

3. ファイアウォールの設定:

```bash
# cocoro-llm-server 側でポートを開く
sudo ufw allow 4000
```

---

### 2. 認証エラー (HTTP 401)

**エラー内容**:
```json
{
  "error": {
    "message": "Incorrect API key provided",
    "code": 401
  }
}
```

**原因**:
- API キーが正しくない
- API キーの形式が間違っている

**解決策**:

1. API キーを確認:

```bash
# cocoro-llm-server の .env ファイル
cat ~/.cocoro-llm-server/.env

# または、LITELLM_MASTER_KEY を確認
grep LITELLM_MASTER_KEY ~/.cocoro-llm-server/.env
```

2. クライアント側の設定を更新:

```bash
# opencode.json の apiKey を正しい値に
# .env の LITELLM_API_KEY も正しい値に
```

3. curl でテスト:

```bash
curl http://<SERVER_IP>:4000/v1/chat/completions \
  -H "Authorization: Bearer YOUR_CORRECT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"coco-local","messages":[{"role":"user","content":"test"}]}'
```

---

### 3. WSL からの接続問題

**エラー内容**:
```
curl: (7) Failed to connect to <SERVER_IP> port 4000: No route to host
```

**原因**:
- WSL から Windows ホストへのアクセス方法が異なる
- WSL の DNS 設定が正しくない

**解決策**:

1. WSL から Windows ホストへの接続:

```bash
# WSL で Windows の IP アドレスを確認
cat /etc/resolv.conf | grep nameserver | awk '{print $2}'

# または、/etc/hosts に追加
echo "<SERVER_IP> host.docker.internal" | sudo tee -a /etc/hosts
```

2. Alternative: `host.docker.internal` を使用:

```bash
# opencode.json を修正
"baseURL": "http://host.docker.internal:4000/v1"
```

3. Windows ファイアウォールの設定:

```powershell
# Windows PowerShell で実行
New-NetFirewallRule -DisplayName "LiteLLM" -Direction Inbound -LocalPort 4000 -Protocol TCP -Action Allow
```

---

### 4. DNS 解決失敗

**エラー内容**:
```
curl: (6) Could not resolve host: <SERVER_IP>
```

**原因**:
- WSL の DNS 設定が不正
- ネットワーク構成に問題がある

**解決策**:

1. WSL の DNS 設定を再構成:

```bash
sudo rm /etc/resolv.conf
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

2. `/etc/hosts` を確認:

```bash
cat /etc/hosts | grep <SERVER_IP>
```

3. 正式な IP アドレスを使用:

```bash
# ping で疎通確認
ping <SERVER_IP>
```

---

### 5. モデルが見つからない (HTTP 404)

**エラー内容**:
```json
{
  "error": {
    "message": "The model coco-local does not exist",
    "code": 404
  }
}
```

**原因**:
- モデル名が間違っている
- vLLM がモデルをロードしていない

**解決策**:

1. 利用可能なモデルを確認:

```bash
curl http://<SERVER_IP>:8000/v1/models | jq '.data[].id'
```

2. vLLM のログを確認:

```bash
docker compose logs vllm-primary
```

3. opencode.json のモデル名を修正:

```json
{
  "model": "coco-local"  // サーバー側 SERVED_MODEL_NAME と一致するモデル名
}
```

---

## テスト手順

### 1. 基本的なメンテナンスモード

```bash
# cocoro-llm-server で実行
docker compose stop litellm
docker compose logs vllm-primary -f
```

### 2. 疎通テスト

```bash
# Windows 側で
Test-NetConnection -ComputerName <SERVER_IP> -Port 4000

# WSL/Linux 側で
nc -zv <SERVER_IP> 4000
```

### 3. API テスト

```bash
# curl で直接テスト
curl -v http://<SERVER_IP>:4000/health/liveliness
curl -v http://<SERVER_IP>:4000/v1/models
```

---

## それでも解決しない場合

1. cocoro-llm-server の full restart:

```bash
docker compose down && docker compose up -d
```

2. サポートに連絡:

- GitHub Issue: https://github.com/mdl-systems/cocoro-llm-client/issues
- Discord: #cocoro-support
