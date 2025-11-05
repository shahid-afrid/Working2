@echo off
color 0E
cls
echo.
echo ========================================
echo   GET YOUR DIRECT URL NOW!
echo ========================================
echo.
echo QUICK SETUP - 3 STEPS:
echo.
echo STEP 1: Install ngrok
echo   Option A: Microsoft Store
echo     1. Open Microsoft Store
echo     2. Search "ngrok"
echo     3. Click Install
echo.
echo   Option B: Download directly
echo     1. Visit: https://ngrok.com/download
echo     2. Download and extract
echo     3. Place ngrok.exe in this folder
echo.
echo STEP 2: Run this script again
echo.
echo STEP 3: Get your URL!
echo.
echo ========================================
echo.
echo Checking if ngrok is installed...
where ngrok >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo [X] NGROK NOT INSTALLED!
    echo.
    echo Please install ngrok first using one of the options above.
    echo After installing, run this script again.
    echo.
    pause
    exit /b 1
)

color 0A
echo.
echo [OK] Ngrok found!
echo.
echo ========================================
echo   Starting Application...
echo ========================================
echo.

REM Start app in background
start /MIN cmd /c "dotnet run --urls http://localhost:5000"
echo Waiting for app to start (15 seconds)...
timeout /t 15 /nobreak >nul

echo.
echo ========================================
echo   Creating Your Public URL...
echo ========================================
echo.
echo Your URL will appear below in a few seconds...
echo.

REM Start ngrok and capture output
start "Ngrok Tunnel" cmd /k "color 0E && title Your Public URL && echo. && echo ======================================== && echo    YOUR PUBLIC URL IS BELOW! && echo ======================================== && echo. && ngrok http 5000 && echo. && echo Tunnel closed. && pause"

timeout /t 3 /nobreak >nul

echo.
echo ========================================
echo   GETTING YOUR URL...
echo ========================================
echo.
echo Opening ngrok web interface...
start http://127.0.0.1:4040

timeout /t 2 /nobreak >nul

echo.
color 0E
echo ========================================
echo ========================================
echo.
echo   YOUR URL IS READY!
echo.
echo   1. Check the ngrok window that opened
echo   2. Look for "Forwarding" line
echo   3. Copy the https:// URL
echo.
echo   OR
echo.
echo   Open your browser at:
echo   http://127.0.0.1:4040
echo.
echo   Your URL looks like:
echo   https://xxxx-xxx-xxx.ngrok-free.app
echo.
echo ========================================
echo ========================================
echo.
pause
