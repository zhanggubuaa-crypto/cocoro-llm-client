# cocoro-llm-client Setup Script (Windows PowerShell / OpenCode)
# opencode.json を生成して cocoro-llm-server (ローカルLLM) に接続します。

$ErrorActionPreference = "Stop"

Write-Host "=== OpenCode Setup ===" -ForegroundColor Cyan
Write-Host ""

# ──────────────────────────────────────────────────────────────
# Step 1: サーバーIPの入力
# ──────────────────────────────────────────────────────────────
Write-Host "Step 1: サーバー接続設定" -ForegroundColor Yellow
Write-Host "  cocoro-llm-server のIPアドレスを入力してください"
Write-Host "  (サーバーPCで scripts/show_connection_info.sh を実行して確認できます)"
$serverIp = Read-Host "  Server IP"
if ([string]::IsNullOrWhiteSpace($serverIp)) {
    Write-Host "  Server IP は必須です" -ForegroundColor Red
    exit 1
}

$healthUrl = "http://${serverIp}:4000/health/liveliness"

# ──────────────────────────────────────────────────────────────
# Step 2: APIキーの入力
# ──────────────────────────────────────────────────────────────
Write-Host ""
$apiKey = Read-Host "  API Key (LITELLM_MASTER_KEY)"
if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Write-Host "  API Key は必須です" -ForegroundColor Red
    exit 1
}

# ──────────────────────────────────────────────────────────────
# Step 3: opencode.json を生成
# ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Step 2: opencode.json を生成しています..." -ForegroundColor Yellow

$samplePath = Join-Path $PSScriptRoot "..\opencode.json.sample"
$outputPath = Join-Path $PSScriptRoot "..\opencode.json"

if (-not (Test-Path $samplePath)) {
    Write-Host "  opencode.json.sample が見つかりません: $samplePath" -ForegroundColor Red
    exit 1
}

$content = [System.IO.File]::ReadAllText($samplePath, [System.Text.Encoding]::UTF8)
$content = $content -replace "YOUR_SERVER_IP", $serverIp
$content = $content -replace "YOUR_API_KEY_HERE", $apiKey
[System.IO.File]::WriteAllText($outputPath, $content, [System.Text.Encoding]::UTF8)

Write-Host "  opencode.json を書き込みました: $outputPath" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────
# Step 4: サーバーへの接続確認
# ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Step 3: サーバーへの接続を確認しています..." -ForegroundColor Yellow
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
Write-Host "次のステップ:" -ForegroundColor Cyan
Write-Host "  1. opencode.json の設定を確認する" -ForegroundColor White
Write-Host "  2. opencode を起動する" -ForegroundColor White
Write-Host ""
Write-Host "接続先: http://${serverIp}:4000 (ローカルLLM)" -ForegroundColor Cyan
