@echo off
setlocal enabledelayedexpansion

echo ========================================
echo =   Barbera Software - Avvio Completo  =
echo ========================================
echo.

:: Verifica se Docker Desktop è installato
echo [INFO] Verifico se Docker Desktop è installato...
docker --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRORE] Docker Desktop non è installato o non è nel PATH.
    echo [ERRORE] Per favore installa Docker Desktop da https://www.docker.com/products/docker-desktop
    echo.
    echo Premi un tasto per chiudere questa finestra...
    pause > nul
    exit /b 1
)
echo [OK] Docker Desktop è installato.
echo.

:: Verifica se Docker è in esecuzione
echo [INFO] Verifico se Docker è in esecuzione...
docker info > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRORE] Docker non è in esecuzione.
    echo [ERRORE] Per favore avvia Docker Desktop e riprova.
    echo.
    echo Premi un tasto per chiudere questa finestra...
    pause > nul
    exit /b 1
)
echo [OK] Docker è in esecuzione.
echo.

:: Posizionati nella directory corretta
echo [INFO] Mi posiziono nella directory dell'applicazione...
cd /d "%~dp0"
echo [OK] Directory corrente: %cd%
echo.

:: Verifica se esistono già volumi Docker per l'app
echo [INFO] Verifico se ci sono volumi Docker esistenti per l'applicazione...
docker volume ls | findstr "barbera" > nul
if %errorlevel% equ 0 (
    echo [INFO] Sono stati trovati volumi Docker esistenti.
    
    choice /C SN /M "Vuoi rimuovere i volumi esistenti e iniziare con un database pulito? (S/N)"
    if errorlevel 2 (
        echo [INFO] Mantengo i volumi esistenti.
    ) else (
        echo [INFO] Rimuovo i container e i volumi esistenti...
        docker-compose down -v
        echo [OK] Container e volumi rimossi.
    )
)
echo.

:: Verifica esistenza file SQL completo
echo [INFO] Verifico la presenza del file schema SQL completo...
if not exist "barbera_development_complete.sql" (
    echo [ERRORE] Il file barbera_development_complete.sql non esiste.
    echo [ERRORE] Assicurati che il file sia nella stessa directory di questo script.
    echo.
    echo Premi un tasto per chiudere questa finestra...
    pause > nul
    exit /b 1
)
echo [OK] File schema SQL completo trovato.
echo.

:: Costruisci l'immagine Docker
echo [INFO] Costruisco l'immagine Docker dell'applicazione...
docker-compose build
if %errorlevel% neq 0 (
    echo [ERRORE] Errore durante la costruzione dell'immagine Docker.
    echo.
    echo Premi un tasto per chiudere questa finestra...
    pause > nul
    exit /b 1
)
echo [OK] Immagine Docker costruita con successo.
echo.

:: Avvia i container
echo [INFO] Avvio i container Docker in background...
docker-compose up -d
if %errorlevel% neq 0 (
    echo [ERRORE] Errore durante l'avvio dei container Docker.
    echo.
    echo Premi un tasto per chiudere questa finestra...
    pause > nul
    exit /b 1
)
echo [OK] Container Docker avviati con successo.
echo.

:: Aspetta un po' per permettere l'inizializzazione del database
echo [INFO] Attendo l'inizializzazione del database (30 secondi)...
timeout /t 30 /nobreak > nul

:: Verifica lo stato dei container
echo [INFO] Verifico lo stato dei container...
docker-compose ps
echo.

:: Mostra le informazioni di accesso
echo ================================================
echo =          BARBERA SOFTWARE AVVIATO            =
echo ================================================
echo.
echo L'applicazione è ora disponibile all'indirizzo:
echo   http://localhost:3000
echo.
echo Credenziali di accesso:
echo   Email: info@centrobarbera.it
echo   Password: barbera2025
echo.
echo ================================================
echo =            INFORMAZIONI AGGIUNTIVE           =
echo ================================================
echo.
echo Questa versione include tutte le correzioni necessarie:
echo  - Tabella auto_prova_rapporto_items integrata
echo  - Correzioni alla tabella variabili integrate
echo  - Schema completo del database in un unico file
echo.
echo Per visualizzare i log dell'applicazione:
echo   docker-compose logs -f web
echo.
echo Per arrestare l'applicazione:
echo   docker-compose down
echo.
echo Se riscontri problemi, prova a riavviare i container:
echo   docker-compose restart
echo.
echo ================================================
echo.
echo Premi un tasto per chiudere questa finestra...
pause > nul
exit /b 0 