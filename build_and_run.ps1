# -*- coding: utf-8 -*-
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "🧹 清理舊容器與緩存中..." -ForegroundColor Yellow
docker compose down --remove-orphans

Write-Host "🧼 清除建構快取與未使用映像..." -ForegroundColor Yellow
docker builder prune -af --force
docker image prune -af --force

Write-Host "🧱 重新建構所有服務 (不使用快取)..." -ForegroundColor Cyan
docker compose build --no-cache

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 建構失敗，請檢查錯誤訊息！" -ForegroundColor Red
    exit 1
}

Write-Host "🚀 啟動所有服務..." -ForegroundColor Green
docker compose up -d --force-recreate

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ 所有服務啟動成功！" -ForegroundColor Green
    Write-Host "🌐 FastAPI: http://localhost:8000/docs"
    Write-Host "📊 MLflow: http://localhost:5000"
    Write-Host "💾 RustFS: http://localhost:9001"
} else {
    Write-Host "⚠️ 啟動失敗，請檢查 docker-compose 輸出。" -ForegroundColor Red
}
