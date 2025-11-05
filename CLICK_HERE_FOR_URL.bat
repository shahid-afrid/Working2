@echo off
setlocal enabledelayedexpansion
color 0E
title Get Your Direct URL

cls
echo.
echo ================================================
echo           GET YOUR DIRECT URL NOW!
echo ================================================
echo.

REM Check if ngrok is installed
where ngrok >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo [X] NGROK IS NOT INSTALLED!
    echo.
    echo Install it NOW:
    echo   1. Microsoft Store - Search "ngrok"
    echo   2. OR https://ngrok.com/download
    echo.
    echo After installing, run this script again!
    echo.
    pause
    exit /b 1
)

echo [OK] Ngrok found!
echo.

REM Check if ngrok is already running
tasklist /FI "IMAGENAME eq ngrok.exe" 2>NUL | find /I /N "ngrok.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [OK] Ngrok is already running!
    echo.
    echo Opening dashboard to get your URL...
    start http://127.0.0.1:4040
    echo.
    color 0A
    echo ================================================
    echo   YOUR URL IS IN THE BROWSER WINDOW!
    echo ================================================
    echo.
    echo Look for "Forwarding" - that's your URL!
    echo Example: https://xxxx.ngrok-free.app
    echo.
    echo Copy it and share! 
    echo.
    pause
    exit /b 0
)

echo [!] Starting everything for you...
echo.

REM Start application
echo Step 1: Starting application...
start /MIN "TutorLiveMentor App" cmd /c "dotnet run --urls http://localhost:5000"
echo Waiting 15 seconds for app to start...
timeout /t 15 /nobreak >nul
echo [OK] App started!
echo.

REM Start ngrok
echo Step 2: Starting ngrok tunnel...
start "Ngrok Tunnel" cmd /c "color 0E && echo. && echo ======================================== && echo YOUR URL WILL APPEAR BELOW IN A MOMENT && echo ======================================== && echo. && ngrok http 5000"
echo Waiting 5 seconds for ngrok to initialize...
timeout /t 5 /nobreak >nul
echo.

REM Open dashboard
echo Step 3: Opening dashboard...
start http://127.0.0.1:4040
timeout /t 2 /nobreak >nul

echo.
color 0A
echo ================================================
echo ================================================
echo.
echo   SUCCESS! YOUR URL IS READY!
echo.
echo   Check the ngrok window OR browser
echo   Look for: "Forwarding:"
echo   Copy the https:// URL
echo.
echo   Example: https://a1b2-12-34.ngrok-free.app
echo.
echo ================================================
echo ================================================
echo.
echo Keep both windows open to keep your URL active!
echo.
pause
