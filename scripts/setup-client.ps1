# cocoro-llm-client Setup Script (Windows PowerShell)
# cocoro-llm-server との接続設定を行います

Write-Host "=== cocoro-llm-client Setup ===" -ForegroundColor Cyan

# 設定ファイルのコピー
Write-Host "Copying opencode.json.sample to opencode.json..." -ForegroundColor Yellow
Copy-Item -Path "opencode.json.sample" -Destination "opencode.json" -Force
if ($?) {
    Write-Host "✓ opencode.json created" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to copy opencode.json" -ForegroundColor Red
    exit 1
}

# APIキーの入力
Write-Host "`nPlease enter your LITELLM API Key:" -ForegroundColor Yellow
$apiKey = Read-Host "API Key (LITELLM_MASTER_KEY)"

if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Write-Host "✗ API Key is required" -ForegroundColor Red
    exit 1
}

# APIキーの置換
Write-Host "Updating opencode.json with API key..." -ForegroundColor Yellow
$content = Get-Content -Path "opencode.json" -Raw
$content = $content -replace '"apiKey": "YOUR_API_KEY_HERE"', "`"apiKey`": `"$apiKey`""
Set-Content -Path "opencode.json" -Value $content -NoNewline

if ($?) {
    Write-Host "✓ API key configured" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to update API key" -ForegroundColor Red
    exit 1
}

# ヘルスチェック
Write-Host "`nChecking connection to cocoro-llm-server..." -ForegroundColor Yellow
$serverUrl = "http://192.168.50.112:4000/health/liveliness"
try {
    $response = Invoke-RestMethod -Uri $serverUrl -Method Get -TimeoutSec 10
    if ($response -eq "ok") {
        Write-Host "✓ Server connection verified" -ForegroundColor Green
    } else {
        Write-Host "✗ Unexpected response: $response" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "✗ Connection failed: $_" -ForegroundColor Red
    Write-Host "  Ensure cocoro-llm-server is running at http://192.168.50.112:4000" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n=== Setup Complete ===" -ForegroundColor Cyan
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Review opencode.json settings" -ForegroundColor Cyan
Write-Host "  2. Run `opencode init` to initialize" -ForegroundColor Cyan
