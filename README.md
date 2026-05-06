# cocoro-llm-client

cocoro-llm-server に接続するためのクライアント設定ガイドです。

| リポジトリ | 役割 |
|---|---|
| [cocoro-llm-server](https://github.com/mdl-systems/cocoro-llm-server) | LLM推論エンジン（サーバー側） |
| cocoro-llm-client | クライアント設定（opencode.json等） |

## クイックスタート

### Windows

```powershell
# リポジトリを clone
git clone https://github.com/mdl-systems/cocoro-llm-client.git

# 自動セットアップスクリプト実行
cd cocoro-llm-client
.\scripts\setup-client.ps1
```

### Linux / WSL

```bash
# リポジトリを clone
git clone https://github.com/mdl-systems/cocoro-llm-client.git

# 自動セットアップスクリプト実行
cd cocoro-llm-client
chmod +x scripts/setup-client.sh
./scripts/setup-client.sh
```

## GitHub Actions

```yaml
- name: Setup cocoro-llm-client
  uses: ./.github/actions/setup-client
  with:
    api-key: ${{ secrets.LITELLM_API_KEY }}
```
