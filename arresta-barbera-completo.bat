@echo off
setlocal enabledelayedexpansion

echo ========================================
echo =   Barbera Software - Arresto         =
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

:: Arresta i container
echo [INFO] Arresto i container Docker...
docker-compose down
if %errorlevel% neq 0 (
    echo [ERRORE] Errore durante l'arresto dei container Docker.
    echo.
    echo Premi un tasto per chiudere questa finestra...
    pause > nul
    exit /b 1
)
echo [OK] Container Docker arrestati con successo.
echo.

echo ================================================
echo =      BARBERA SOFTWARE ARRESTATO              =
echo ================================================
echo.
echo L'applicazione è stata arrestata correttamente.
echo Per riavviare l'applicazione, eseguire:
echo   avvia-barbera-completo.bat
echo.
echo ================================================
echo.
echo Premi un tasto per chiudere questa finestra...
pause > nul
exit /b 0 