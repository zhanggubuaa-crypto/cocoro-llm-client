# cocoro-llm-client Setup Script - Claude Code (Windows PowerShell)
# Claude Code を cocoro-llm-server (ローカルLLM) に接続します。
# ~/.claude/settings.json に env を書き込むため、PC全体・どのフォルダでも有効になります。

$ErrorActionPreference = "Stop"

Write-Host "=== Claude Code Setup ===" -ForegroundColor Cyan
Write-Host ""

# ──────────────────────────────────────────────────────────────
# Step 1: Claude Code のインストール確認
# ──────────────────────────────────────────────────────────────
Write-Host "Step 1: Claude Code の確認..." -ForegroundColor Yellow

$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
if ($claudeCmd) {
    Write-Host "  Claude Code はインストール済みです: $($claudeCmd.Source)" -ForegroundColor Green
} else {
    Write-Host "  Claude Code が見つかりません。" -ForegroundColor Yellow
    Write-Host "  以下を実行してインストールしてください (Node.js 必要):" -ForegroundColor Yellow
    Write-Host "    npm install -g @anthropic-ai/claude-code" -ForegroundColor Cyan
    Write-Host "  その後、もう一度このスクリプトを実行してください。" -ForegroundColor Yellow
    exit 1
}

# ──────────────────────────────────────────────────────────────
# Step 2: サーバーIPの入力
# ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Step 2: サーバー接続設定" -ForegroundColor Yellow
Write-Host "  cocoro-llm-server のIPアドレスを入力してください"
Write-Host "  - 同じLAN: サーバーPCのLAN IP (例: 192.168.x.x)"
Write-Host "  - Tailscale 経由: サーバーPCの Tailscale IP (例: 100.x.x.x)"
Write-Host "  サーバーPCで scripts/show_connection_info.sh を実行すれば一覧表示されます"
$serverIp = Read-Host "  Server IP"
if ([string]::IsNullOrWhiteSpace($serverIp)) {
    Write-Host "  Server IP は必須です" -ForegroundColor Red
    exit 1
}

# Claude Code は anthropic-proxy (port 4001) に接続する
$proxyUrl = "http://${serverIp}:4001"
$healthUrl = "http://${serverIp}:4000/health/liveliness"

# ──────────────────────────────────────────────────────────────
# Step 3: APIキーの入力
# ──────────────────────────────────────────────────────────────
Write-Host ""
$apiKey = Read-Host "  API Key (LITELLM_MASTER_KEY)"
if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Write-Host "  API Key は必須です" -ForegroundColor Red
    exit 1
}

# ──────────────────────────────────────────────────────────────
# Step 4: ~/.claude/settings.json を生成・マージ
# ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Step 3: Claude Code 設定ファイルを書き込んでいます..." -ForegroundColor Yellow

$claudeDir = Join-Path $env:USERPROFILE ".claude"
$settingsPath = Join-Path $claudeDir "settings.json"

if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
}

# 既存設定を読み込み（あれば）、env のみ上書きマージ
$settings = @{}
if (Test-Path $settingsPath) {
    try {
        $existing = Get-Content $settingsPath -Raw | ConvertFrom-Json
        # PSCustomObject -> Hashtable
        $existing.PSObject.Properties | ForEach-Object { $settings[$_.Name] = $_.Value }
        Write-Host "  既存の settings.json をマージします" -ForegroundColor Cyan
        # バックアップ
        $backupPath = "$settingsPath.bak"
        Copy-Item $settingsPath $backupPath -Force
        Write-Host "  バックアップ: $backupPath" -ForegroundColor Cyan
    } catch {
        Write-Host "  既存 settings.json のパース失敗。新規作成します。" -ForegroundColor Yellow
    }
}

# env を更新（既存の他のenv変数は保持）
$envBlock = @{}
if ($settings.ContainsKey("env") -and $settings["env"]) {
    $settings["env"].PSObject.Properties | ForEach-Object { $envBlock[$_.Name] = $_.Value }
}
$envBlock["ANTHROPIC_BASE_URL"] = $proxyUrl
$envBlock["ANTHROPIC_API_KEY"] = $apiKey

$settings["env"] = $envBlock
if (-not $settings.ContainsKey("model")) {
    $settings["model"] = "claude-sonnet-4-6"
}

$json = $settings | ConvertTo-Json -Depth 10
Set-Content -Path $settingsPath -Value $json -Encoding utf8 -NoNewline

Write-Host "  設定ファイルを書き込みました: $settingsPath" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────
# Step 4: サーバーへの接続確認
# ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Step 4: サーバーへの接続を確認しています..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $healthUrl -Method Get -TimeoutSec 10
    Write-Host "  サーバー接続成功" -ForegroundColor Green
} catch {
    Write-Host "  サーバーに接続できませんでした" -ForegroundColor Yellow
    Write-Host "  サーバーが起動しているか確認してください: $healthUrl" -ForegroundColor Yellow
}

# ──────────────────────────────────────────────────────────────
# 完了
# ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=== セットアップ完了 ===" -ForegroundColor Cyan
Write-Host "新しいターミナルを開いて、どのフォルダでも以下を実行できます:" -ForegroundColor Cyan
Write-Host "  claude" -ForegroundColor White
Write-Host ""
Write-Host "設定ファイル: $settingsPath" -ForegroundColor Cyan
Write-Host "接続先: $proxyUrl (ローカルLLM)" -ForegroundColor Cyan
