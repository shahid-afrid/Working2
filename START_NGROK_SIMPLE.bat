@echo off
color 0E
title TutorLiveMentor - Get Your Shareable URL

echo.
echo ====================================================
echo    TutorLiveMentor - Internet Access with NGROK
echo ====================================================
echo.
echo  This will give you a PUBLIC URL to share!
echo.
echo ====================================================
echo.

REM Check if ngrok is installed
where ngrok >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo [X] NGROK NOT FOUND!
    echo.
    echo Please install ngrok first:
    echo.
    echo Option 1 - Microsoft Store (Recommended):
    echo   1. Open Microsoft Store
    echo   2. Search for "ngrok"
    echo   3. Click Install
    echo.
    echo Option 2 - Manual Download:
    echo   1. Visit: https://ngrok.com/download
    echo   2. Download and extract ngrok.exe
    echo   3. Place it in this folder OR add to PATH
    echo.
    pause
    exit /b 1
)

color 0A
echo [OK] Ngrok is installed!
echo.

REM Get ngrok version
echo Ngrok Version:
ngrok version
echo.

echo ====================================================
echo  STEP 1: Starting Your Application
echo ====================================================
echo.
echo Starting TutorLiveMentor on port 5000...
echo.

REM Start the application in a new window
start "TutorLiveMentor Application" cmd /k "color 0B && title TutorLiveMentor Application && echo ======================================== && echo    TutorLiveMentor Application Running && echo ======================================== && echo. && echo Local URL: http://localhost:5000 && echo. && echo Keep this window OPEN! && echo Close it to stop the application. && echo. && echo ======================================== && echo. && dotnet run --urls http://localhost:5000"

echo Waiting for application to start...
echo (Please wait 10-15 seconds)
timeout /t 15 /nobreak >nul

echo.
color 0A
echo [OK] Application started!
echo.

echo ====================================================
echo  STEP 2: Creating Your Public URL
echo ====================================================
echo.
echo Opening Ngrok Web Interface...
echo (A browser window will open at http://127.0.0.1:4040)
echo.

REM Open ngrok web interface in browser
start http://127.0.0.1:4040

timeout /t 3 /nobreak >nul

color 0E
echo.
echo ====================================================
echo ====================================================
echo.
echo   YOUR PUBLIC URL WILL APPEAR BELOW!
echo.
echo   Look for the line that says "Forwarding"
echo   It will look like this:
echo.
echo   https://xxxx-xxx-xxx-xxx.ngrok-free.app
echo.
echo   COPY THAT URL AND SHARE IT!
echo.
echo ====================================================
echo ====================================================
echo.
echo NOTE: First-time visitors will see an ngrok warning
echo       page. Just click "Visit Site" to continue.
echo.
echo ALSO: Check the browser window at http://127.0.0.1:4040
echo       for a better view of your public URL!
echo.
echo ====================================================
echo.

REM Start ngrok tunnel
ngrok http 5000

REM When ngrok is closed
color 0C
echo.
echo ====================================================
echo  Ngrok Tunnel Closed
echo ====================================================
echo.
echo To get a new URL, just run this script again!
echo.
pause
