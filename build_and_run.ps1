# -*- coding: utf-8 -*-
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "🚀 正在檢查並更新服務..." -ForegroundColor Cyan

docker compose up -d --build --remove-orphans

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ 服務已更新並在背景執行中！" -ForegroundColor Green
    Write-Host "----------------------------------------"
    Write-Host "🌐 FastAPI: http://localhost:8000/docs"
    Write-Host "📊 MLflow:  http://localhost:5000"
    Write-Host "💾 RustFS:  http://localhost:9001"
    Write-Host "----------------------------------------"
} else {
    Write-Host "❌ 啟動失敗，請檢查錯誤訊息。" -ForegroundColor Red
    exit 1
}