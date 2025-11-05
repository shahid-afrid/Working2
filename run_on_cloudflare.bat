@echo off
color 0A
echo.
echo ========================================
echo   TutorLiveMentor - INTERNET ACCESS
echo   Using Cloudflare Tunnel
echo ========================================
echo.
echo  Better than Ngrok:
echo  * No warning page
echo  * No signup needed
echo  * Works on restricted networks
echo  * Free forever!
echo.
echo ========================================
echo.

REM Refresh PATH to include cloudflared
set "PATH=%PATH%;C:\Program Files\Cloudflare\Cloudflared"

REM Check if cloudflared is available
where cloudflared >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Cloudflare Tunnel not found!
    echo.
    echo Installing Cloudflare Tunnel...
    echo This will take 1-2 minutes...
    echo.
    winget install --id Cloudflare.cloudflared --silent
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo Installation failed. Please install manually:
        echo https://github.com/cloudflare/cloudflared/releases
        echo.
        pause
        exit /b 1
    )
    echo.
    echo Installation complete! Restarting script...
    timeout /t 3 /nobreak >nul
    "%~f0"
    exit /b 0
)

echo [SUCCESS] Cloudflare Tunnel ready!
cloudflared version
echo.

echo ========================================
echo  Starting Your Application...
echo ========================================
echo.
echo [1/2] Starting TutorLiveMentor on port 5014...
echo.

REM Start the application in a new window
start "TutorLiveMentor Application - Keep Open!" cmd /k "color 0B && echo === TutorLiveMentor Application === && echo Running on: http://localhost:5014 && echo. && echo Keep this window OPEN! && echo Close to stop the app. && echo. && dotnet run --launch-profile http"

echo Waiting for application to start...
echo (This takes about 10 seconds)
timeout /t 10 /nobreak >nul

echo.
echo [SUCCESS] Application should be running!
echo Test: http://localhost:5014
echo.

echo ========================================
echo  Creating Internet Tunnel...
echo ========================================
echo.
echo [2/2] Starting Cloudflare Tunnel...
echo.
color 0E
echo ========================================
echo ========================================
echo.
echo      WATCH FOR YOUR PUBLIC URL BELOW
echo      It will look like:
echo.
echo   https://xxxxx-xxxxx.trycloudflare.com
echo.
echo      COPY IT AND SHARE IT!
echo.
echo ========================================
echo ========================================
echo.
timeout /t 3 /nobreak >nul

REM Start cloudflared tunnel - the URL will appear in the output
echo Starting tunnel now...
echo.
echo *** YOUR URL WILL APPEAR BELOW ***
echo.
cloudflared tunnel --url http://localhost:5014 --loglevel info

echo.
echo.
echo ========================================
echo  Tunnel Closed
echo ========================================
echo.
echo To restart: Just run this script again!
echo.
pause
