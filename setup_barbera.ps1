# 🚀 Script Setup Automatico - Barbera Software
# Autore: Assistente AI
# Data: 25/06/2025

Write-Host "🚀 Avvio Setup Barbera Software..." -ForegroundColor Green

# Verifica prerequisiti
Write-Host "📋 Verifica prerequisiti..." -ForegroundColor Yellow
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker non trovato! Installa Docker Desktop." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "❌ docker-compose.yml non trovato!" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "barbera_complete_export.sql")) {
    Write-Host "❌ barbera_complete_export.sql non trovato!" -ForegroundColor Red
    Write-Host "Assicurati di avere l'export del database nella directory corrente." -ForegroundColor Yellow
    exit 1
}

# Opzione pulizia
$cleanup = Read-Host "🧹 Vuoi pulire container/volumi esistenti? (y/N)"
if ($cleanup -eq "y" -or $cleanup -eq "Y") {
    Write-Host "🧹 Pulizia ambiente..." -ForegroundColor Yellow
    docker-compose down -v 2>$null
    docker system prune -f 2>$null
    docker volume prune -f 2>$null
}

# Avvio database
Write-Host "🗄️ Avvio database MySQL..." -ForegroundColor Yellow
docker-compose up -d db
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Errore avvio database!" -ForegroundColor Red
    exit 1
}

Write-Host "⏳ Attendo che MySQL sia pronto (30s)..." -ForegroundColor Yellow
Start-Sleep 30

# Avvio applicazione
Write-Host "🌐 Avvio applicazione Rails..." -ForegroundColor Yellow
docker-compose up -d web
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Errore avvio applicazione!" -ForegroundColor Red
    exit 1
}

Write-Host "⏳ Attendo che Rails sia pronto (30s)..." -ForegroundColor Yellow
Start-Sleep 30

# Importazione database
Write-Host "📊 Importazione database..." -ForegroundColor Yellow
Get-Content barbera_complete_export.sql | docker exec -i barberasoftware-db-1 mysql -u barbera -pbarbera2025 barbera_development
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Errore importazione database!" -ForegroundColor Red
    exit 1
}

# Configurazione wrapper PDF
Write-Host "🖨️ Configurazione wrapper PDF..." -ForegroundColor Yellow
if (Test-Path "prince_wrapper.sh") {
    docker cp prince_wrapper.sh barberasoftware-web-1:/usr/local/bin/prince
    docker exec barberasoftware-web-1 chmod +x /usr/local/bin/prince
    Write-Host "✅ Wrapper PDF configurato!" -ForegroundColor Green
} else {
    Write-Host "⚠️ prince_wrapper.sh non trovato - PDF potrebbero non funzionare" -ForegroundColor Yellow
}

# Test finale
Write-Host "🔍 Test sistema..." -ForegroundColor Yellow

# Test database
$dbTest = docker exec barberasoftware-db-1 mysql -u barbera -pbarbera2025 -e "USE barbera_development; SELECT COUNT(*) FROM parametri;" 2>$null
if ($dbTest -match "22") {
    Write-Host "✅ Database: 22 parametri importati" -ForegroundColor Green
} else {
    Write-Host "⚠️ Database: problemi con parametri" -ForegroundColor Yellow
}

# Test applicazione
$appTest = docker exec barberasoftware-web-1 curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 2>$null
if ($appTest -eq "200") {
    Write-Host "✅ Applicazione: attiva su porta 3000" -ForegroundColor Green
} else {
    Write-Host "⚠️ Applicazione: possibili problemi" -ForegroundColor Yellow
}

# Risultato finale
Write-Host ""
Write-Host "🎉 Setup completato!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Informazioni accesso:" -ForegroundColor Cyan
Write-Host "  URL: http://localhost:3000" -ForegroundColor White
Write-Host "  Email: info@centrobarbera.it" -ForegroundColor White
Write-Host "  Password: barbera2025" -ForegroundColor White
Write-Host ""
Write-Host "🔗 Pagine utili:" -ForegroundColor Cyan
Write-Host "  Login: http://localhost:3000/login" -ForegroundColor White
Write-Host "  Rapporti: http://localhost:3000/rapporti" -ForegroundColor White
Write-Host "  Test PDF: http://localhost:3000/rapporti/rdp/1?format=pdf" -ForegroundColor White
Write-Host ""
Write-Host "🛠️ Comandi utili:" -ForegroundColor Cyan
Write-Host "  Log: docker-compose logs -f web" -ForegroundColor White
Write-Host "  Restart: docker-compose restart" -ForegroundColor White
Write-Host "  Stop: docker-compose down" -ForegroundColor White
Write-Host ""
Write-Host "✅ Il sistema è pronto all'uso!" -ForegroundColor Green 