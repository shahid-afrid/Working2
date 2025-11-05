@echo off
color 0B
title Get My Ngrok URL

echo.
echo ====================================================
echo    Quick URL Finder
echo ====================================================
echo.

REM Check if ngrok is running
tasklist /FI "IMAGENAME eq ngrok.exe" 2>NUL | find /I /N "ngrok.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [OK] Ngrok is running!
    echo.
    echo Opening ngrok web interface...
    echo.
    start http://127.0.0.1:4040
    echo.
    echo Your public URL is shown in the browser window.
    echo Look for the "Forwarding" line!
    echo.
    echo Example: https://xxxx-xxx.ngrok-free.app
    echo.
) else (
    color 0C
    echo [X] Ngrok is NOT running!
    echo.
    echo To start ngrok and get your URL:
    echo Run: START_NGROK_SIMPLE.bat
    echo.
)

echo ====================================================
echo.
pause
