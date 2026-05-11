# CLIENT_SETUP.md — cocoro-llm-client セットアップガイド

> cocoro-llm-server（LLM推論サーバー）へ OpenCode から接続するためのセットアップ手順です。  
> Windows と Linux/macOS の両方をサポートします。

---

## 目次

1. [前提条件](#前提条件)
2. [リポジトリクローン](#リポジトリクローン)
3. [自動セットアップスクリプト](#自動セットアップスクリプト)
4. [手動セットアップ](#手動セットアップ)
5. [接続確認](#接続確認)
6. [トラブルシューティング](#トラブルシューティング)

---

## 前提条件

| 品目 | 要件 |
|------|------|
| OpenCode CLI | インストール済み |
| サーバーIPアドレス | 購入時に配布されるサーバーのLAN内IP |
| LITELLM_MASTER_KEY | 購入時に配布されるAPIキー |

---

## リポジトリクローン

```bash
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
```

---

## 自動セットアップスクリプト

**これが最も簡単な方法です。** スクリプトが対話形式でIPとAPIキーを聞いてきます。

### Windows (PowerShell)

```powershell
# 実行ポリシーを設定（初回のみ）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# セットアップ実行
.\scripts\setup-client.ps1
```

**実行すると以下を聞かれます:**

```
cocoro-llm-server のIPアドレスを入力してください:
  (Enterでデフォルトを使用)
Server IP: 192.168.x.x

LiteLLM APIキーを入力してください:
API Key (LITELLM_MASTER_KEY): your-master-key-here
```

設定は `%APPDATA%\opencode\config.json` に書き込まれます。  
**OpenCode をどのフォルダで起動しても自動的にサーバーに繋がります。**

---

### Linux / macOS

```bash
# 実行権限付与（初回のみ）
chmod +x scripts/setup-client.sh

# セットアップ実行
./scripts/setup-client.sh
```

設定は `~/.config/opencode/config.json` に書き込まれます。

---

## 手動セットアップ

自動スクリプトを使わずに手動で設定する場合：

### 1. グローバル設定ディレクトリを作成

```powershell
# Windows
New-Item -ItemType Directory -Path "$env:APPDATA\opencode" -Force
```

```bash
# Linux / macOS
mkdir -p ~/.config/opencode
```

### 2. サンプルをコピーして編集

```powershell
# Windows
Copy-Item opencode.json.sample "$env:APPDATA\opencode\config.json"
notepad "$env:APPDATA\opencode\config.json"
```

```bash
# Linux / macOS
cp opencode.json.sample ~/.config/opencode/config.json
nano ~/.config/opencode/config.json
```

### 3. 設定ファイルの編集

以下の2箇所を実際の値に書き換えます：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "litellm": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LiteLLM",
      "options": {
        "baseURL": "http://<SERVER_IP>:4000/v1",   ← ここをサーバーIPに変更
        "apiKey": "<LITELLM_MASTER_KEY>"            ← ここをAPIキーに変更
      },
      ...
    }
  }
}
```

---

## 接続確認

セットアップ後、以下でサーバーへの接続を確認できます。

### ヘルスチェック

```powershell
# Windows
Invoke-RestMethod -Uri "http://<SERVER_IP>:4000/health/liveliness"
```

```bash
# Linux / macOS
curl http://<SERVER_IP>:4000/health/liveliness
```

**正常なレスポンス:**
```json
{"status": "ok"}
```

### 推論テスト

```bash
curl http://<SERVER_IP>:4000/v1/chat/completions \
  -H "Authorization: Bearer <LITELLM_MASTER_KEY>" \
  -H "Content-Type: application/json" \
  -d '{"model":"qwen3-coder","messages":[{"role":"user","content":"こんにちは"}]}'
```

### OpenCode 起動確認

```bash
opencode
```

OpenCode を任意のフォルダで起動すると、自動的にサーバーに接続されます。  
モデル選択肢に `qwen3-coder`・`claude-sonnet`・`smart-coder` が表示されれば成功です。

---

## モデルの選び方

| モデル名 | 用途 | 特徴 |
|---|---|---|
| `smart-coder` | **推奨** — 普段使い | ローカル優先、失敗時はClaudeに自動切替 |
| `qwen3-coder` | 高速・プライバシー重視 | ローカルのみ、256K context |
| `claude-sonnet` | 難しいタスク | Anthropic API直接、品質最優先 |

---

## トラブルシューティング

### サーバーに繋がらない

```bash
# pingで疎通確認
ping <SERVER_IP>

# ポート確認
# Windows
Test-NetConnection -ComputerName <SERVER_IP> -Port 4000

# Linux
nc -zv <SERVER_IP> 4000
```

**原因として多いもの:**
- サーバーPCの電源が入っていない
- `docker compose up -d` が実行されていない
- 同じLAN（ネットワーク）に接続されていない

### 認証エラー（401 Unauthorized）

APIキーが間違っています。サーバー管理者に正しい `LITELLM_MASTER_KEY` を確認してください。

### OpenCode にモデルが表示されない

設定ファイルのパスが正しいか確認してください：

```powershell
# Windows — ファイルの存在確認
Test-Path "$env:APPDATA\opencode\config.json"
Get-Content "$env:APPDATA\opencode\config.json"
```

```bash
# Linux / macOS
cat ~/.config/opencode/config.json
```

---

## 関連ドキュメント

| ドキュメント | 説明 |
|---|---|
| [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) | 詳細なトラブルシューティング |
| [CLIENT_GUIDE.md](./CLIENT_GUIDE.md) | OpenCode の使い方ガイド |
