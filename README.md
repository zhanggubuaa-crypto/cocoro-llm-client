# cocoro-llm-client

> [cocoro-llm-server](https://github.com/mdl-systems/cocoro-llm-server)（ローカルLLM推論サーバー）に接続するためのセットアップリポジトリです。
> **OpenCode** または **Claude Code** から使えます。スクリプト1本で設定が完了し、PC全体・どのフォルダでもローカルLLMが呼び出せるようになります。

---

## どちらのクライアントを使う？

| クライアント | 特徴 |
|---|---|
| **OpenCode** | OSS。シンプルで軽量。普段使い向け |
| **Claude Code** | Anthropic公式CLI。エージェント機能・MCP・スラッシュコマンド等が豊富 |

両方並行してインストール・利用も可能です。

---

## 前提条件：ネットワーク接続

クライアントPCがサーバーPCに**ネットワーク的に到達できる**必要があります。以下のいずれかの方法で接続してください。

### 推奨：Tailscale 経由（場所を問わず使える）

[Tailscale](https://tailscale.com/) をクライアントPCとサーバーPCの両方にインストールし、**同じアカウントでログイン**します。これだけで両PCが仮想的に同じネットワーク上に置かれ、外出先や別のWiFiからでも接続可能になります。

```powershell
# Windows: https://tailscale.com/download からインストール
# Linux/macOS:
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

サーバー側でサブネットルーターを有効にしているか、サーバーPCの **Tailscale IP**（`100.x.x.x`、`tailscale ip -4` で確認）を使います。

### 代替：同じLAN（家庭・社内ネットワーク）

クライアントPCとサーバーPCが**同じWiFi/同じルーター下**にある場合は、追加設定なしで接続できます。サーバーPCのLAN IP（例: `192.168.x.x`）をそのまま使ってください。

---

## 必要なもの（共通）

| 品目 | 内容 |
|---|---|
| サーバーIPアドレス | Tailscale IP（`100.x.x.x`）または LAN IP（`192.168.x.x`） |
| APIキー | サーバーPCで `bash scripts/show_connection_info.sh` を実行して確認（LITELLM_MASTER_KEY の値） |

---

## A. OpenCode を使う

### Windows

```powershell
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser  # 初回のみ
.\scripts\setup-client.ps1
```

### Linux / macOS

```bash
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
chmod +x scripts/setup-client.sh
./scripts/setup-client.sh
```

スクリプトが OpenCode のインストール → サーバーIP・APIキー入力 → 設定ファイル書き込み → 接続確認 まで自動で行います。
完了後はどのフォルダでも `opencode` で起動できます。

**設定ファイル**: `~/.config/opencode/opencode.json`（Windows: `%USERPROFILE%\.config\opencode\opencode.json`）

---

## B. Claude Code を使う

事前に Claude Code をインストールしてください（Node.js 必要）:

```bash
npm install -g @anthropic-ai/claude-code
```

### Windows

```powershell
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser  # 初回のみ
.\scripts\setup-claude-code.ps1
```

### Linux / macOS

```bash
git clone https://github.com/mdl-systems/cocoro-llm-client.git
cd cocoro-llm-client
chmod +x scripts/setup-claude-code.sh
./scripts/setup-claude-code.sh
```

スクリプトが `~/.claude/settings.json` の `env` ブロックに `ANTHROPIC_BASE_URL` と `ANTHROPIC_API_KEY` を書き込みます。
完了後は新しいターミナルを開いて、どのフォルダでも `claude` で起動できます。

> **仕組み**: Claude Code は本来 `api.anthropic.com` に接続しますが、`ANTHROPIC_BASE_URL` でサーバー上の `anthropic-proxy`（ポート4001）に向け替えています。プロキシが Anthropic API ↔ OpenAI API 形式を双方向変換し、LiteLLM 経由で vLLM のローカルモデルを呼びます。

**設定ファイル**: `~/.claude/settings.json`（Windows: `%USERPROFILE%\.claude\settings.json`）

---

## モデルの選び方

| モデル名 | 用途 |
|---|---|
| `smart-coder` | **推奨** — ローカル優先、失敗時は Claude へ自動切替 |
| `qwen3-coder` | ローカルのみ・高速・256K コンテキスト |
| `claude-sonnet` | 難しいタスク・品質最優先 |

OpenCode は `opencode.json` の `model` を編集、Claude Code は `settings.json` の `model` または起動時に選択。

---

## 詳細ドキュメント

- [docs/CLIENT_SETUP.md](docs/CLIENT_SETUP.md) — セットアップ手順の詳細
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) — トラブルシューティング

---

## 関連リポジトリ

| リポジトリ | 役割 |
|---|---|
| [cocoro-llm-server](https://github.com/mdl-systems/cocoro-llm-server) | LLM推論エンジン（サーバー側） |
| cocoro-llm-client | クライアント設定（本リポジトリ） |
