# cocoro-llm-client ガイド

## 目次
- [手動セットアップ](#手動セットアップ)
- [自動セットアップスクリプト](#自動セットアップスクリプト)
- [OSごとの違い](#osごとの違い)
- [接続確認](#接続確認)
- [トラブルシューティング](#トラブルシューティング)

## 手動セットアップ

### 1. リポジトリの clone

```bash
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
```

### 2. 設定ファイルのコピー

```bash
cp opencode.json.sample opencode.json
cp .env.example .env
```

### 3. APIキーの設定

`opencode.json` を編集:

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

`.env` ファイルも同様に編集:

```env
LITELLM_API_KEY=YOUR_LITELLM_MASTER_KEY_HERE
SERVER_IP=<SERVER_IP>
SERVER_PORT=4000
```

### 4. 確認

```bash
opencode init
opencode chat "こんにちは"
```

## 自動セットアップスクリプト

### Windows

```powershell
.\scripts\setup-client.ps1
```

### Linux / WSL

```bash
chmod +x scripts/setup-client.sh
./scripts/setup-client.sh
```

## OSごとの違い

| 項目 | Windows | WSL | Linux |
|------|---------|-----|-------|
| スクリプト拡張子 | `.ps1` | `.sh` | `.sh` |
| 実行方法 | `.\script.ps1` | `./script.sh` | `./script.sh` |
| APIキー入力 | PowerShell `Read-Host` | Bash `read` | Bash `read` |
| HTTPクライアント | `Invoke-RestMethod` | `curl` | `curl` |

## 接続確認

### ヘルスチェック

```bash
curl http://<SERVER_IP>:4000/health/liveliness
# Expected: "ok"
```

### 推論テスト

```bash
curl http://<SERVER_IP>:4000/v1/chat/completions \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"qwen3-coder","messages":[{"role":"user","content":"test"}]}'
```

## トラブルシューティング

詳細なトラブルシューティングは [docs/TROUBLESHOOTING.md](./TROUBLESHOOTING.md) を参照してください。

### 起きやすい問題

1. **接続エラー (code 7)**: cocoro-llm-server が起動していない
2. **認証エラー (401)**: APIキーが間違っている
3. **DNS解決失敗**: `<SERVER_IP>` にアクセスできない
