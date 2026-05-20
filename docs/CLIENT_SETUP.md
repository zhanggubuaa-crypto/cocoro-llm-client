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

設定は `%USERPROFILE%\.config\opencode\opencode.json` に書き込まれます。  
**OpenCode をどのフォルダで起動しても自動的にサーバーに繋がります。**

---

### Linux / macOS

```bash
# 実行権限付与（初回のみ）
chmod +x scripts/setup-client.sh

# セットアップ実行
./scripts/setup-client.sh
```

設定は `~/.config/opencode/opencode.json` に書き込まれます。

---

## 手動セットアップ

自動スクリプトを使わずに手動で設定する場合：

### 1. グローバル設定ディレクトリを作成

```powershell
# Windows
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config\opencode" -Force
```

```bash
# Linux / macOS
mkdir -p ~/.config/opencode
```

### 2. サンプルをコピーして編集

```powershell
# Windows
Copy-Item opencode.json.sample "$env:USERPROFILE\.config\opencode\opencode.json"
notepad "$env:USERPROFILE\.config\opencode\opencode.json"
```

```bash
# Linux / macOS
cp opencode.json.sample ~/.config/opencode/opencode.json
nano ~/.config/opencode/opencode.json
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
  -d '{"model":"coco-local","messages":[{"role":"user","content":"こんにちは"}]}'
```

### OpenCode 起動確認

```bash
opencode
```

OpenCode を任意のフォルダで起動すると、自動的にサーバーに接続されます。  
モデル選択肢に `coco-local`・`claude-sonnet`・`smart-coder` が表示されれば成功です。

---

## 画像・ドキュメントURL参照

サーバーのモデル（Qwen3.6、マルチモーダル）は画像入力に対応しています。クライアント側で以下のとおり扱えます（実機検証済み）。

### OpenCode（設定済み・そのまま使える）

`opencode.json.sample` のモデル定義に画像/ツール能力（`attachment` / `modalities.input:["text","image"]` / `tool_call`）と `webfetch` を有効化済みです。セットアップスクリプトで生成した設定ならそのまま：

- **画像**: 画像ファイルを添付して質問 → ローカルモデルが画像を読んで回答
- **ドキュメントURL**: URL を貼って「これ読んで」→ 内蔵 `webfetch` が取得してモデルに渡す

> 既存の古い `opencode.json` を使い回している場合、モデルに `attachment` と `modalities` が無いと画像が送られません。`opencode.json.sample` の最新形に合わせてください。

### Claude Code（Windows の注意点）

- **画像**: Windows では `Ctrl+V` での画像貼り付けは Claude Code 側の既知制限で**動作しません**。`@C:\path\to\image.png` のように**ファイルパス指定**するか、エクスプローラーからドラッグしてください。
- **URL参照**: Claude Code 内蔵の WebFetch は Anthropic サーバー側で実行される機能のため、**自前サーバー接続時は動きません**。ドキュメントURLを読ませる用途は OpenCode を使うのが確実です（または fetch 系 MCP サーバーを別途追加）。

---

## モデルの選び方

| モデル名 | 用途 | 特徴 |
|---|---|---|
| `smart-coder` | **推奨** — 普段使い | ローカル優先、失敗時はClaudeに自動切替 |
| `coco-local` | 高速・プライバシー重視 | ローカルのみ、128K context（サーバー設定で変更可） |
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
Test-Path "$env:USERPROFILE\.config\opencode\opencode.json"
Get-Content "$env:USERPROFILE\.config\opencode\opencode.json"
```

```bash
# Linux / macOS
cat ~/.config/opencode/opencode.json
```

---

## 関連ドキュメント

| ドキュメント | 説明 |
|---|---|
| [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) | 詳細なトラブルシューティング |
| [CLIENT_GUIDE.md](./CLIENT_GUIDE.md) | OpenCode の使い方ガイド |
