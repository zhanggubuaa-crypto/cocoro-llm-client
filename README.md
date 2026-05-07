# cocoro-llm-client

> cocoro-llm-server（ローカルLLM推論サーバー）に OpenCode から接続するためのセットアップリポジトリです。  
> スクリプトを1本実行するだけで **OpenCode のインストールから接続設定まで** 自動で完了します。

---

## 必要なもの

| 品目 | 内容 |
|---|---|
| サーバーIPアドレス | サーバーPCで `bash scripts/show_connection_info.sh` を実行して確認 |
| APIキー | 同上（`coco-` で始まる自動生成キー） |

---

## セットアップ手順

### Windows

```powershell
# 1. リポジトリをクローン
git clone https://github.com/zhanggubuaa-crypto/cocoro-llm-client.git
cd cocoro-llm-client

# 2. 実行ポリシーを設定（初回のみ）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. セットアップ実行
.\scripts\setup-client.ps1
```

スクリプトが以下を自動で行います：
1. **OpenCode をインストール**（未インストールの場合）
2. サーバーIP と APIキーを入力
3. 設定ファイルをグローバルに書き込む
4. サーバーへの接続を確認

完了後は **どのフォルダでも `opencode` コマンドで起動**できます。

---

### Linux / macOS

```bash
# 1. リポジトリをクローン
git clone https://github.com/zhanggubuaa-crypto/cocoro-llm-client.git
cd cocoro-llm-client

# 2. セットアップ実行
chmod +x scripts/setup-client.sh
./scripts/setup-client.sh
```

---

## 設定ファイルの場所

| OS | パス |
|---|---|
| Windows | `%USERPROFILE%\.config\opencode\opencode.json` |
| Linux / macOS | `~/.config/opencode/opencode.json` |

---

## モデルの選び方

| モデル名 | 用途 |
|---|---|
| `smart-coder` | **推奨** — ローカル優先、失敗時はClaudeへ自動切替 |
| `qwen3-coder` | ローカルのみ・高速・256K コンテキスト |
| `claude-sonnet` | 難しいタスク・品質最優先 |

---

## 詳細ドキュメント

- [CLIENT_SETUP.md](docs/CLIENT_SETUP.md) — セットアップ手順の詳細
- [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) — トラブルシューティング

---

## 関連リポジトリ

| リポジトリ | 役割 |
|---|---|
| [cocoro-llm-server](https://github.com/zhanggubuaa-crypto/cocoro-llm-server) | LLM推論エンジン（サーバー側） |
| cocoro-llm-client | クライアント設定（本リポジトリ） |
