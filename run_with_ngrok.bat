@echo off
color 0A
echo.
echo ========================================
echo   TutorLiveMentor - NGROK INTERNET ACCESS
echo ========================================
echo.
echo  Starting application and creating public URL...
echo.
echo ========================================
echo.

REM Check if ngrok is available
where ngrok >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Ngrok not found!
    echo.
    echo Please install ngrok first:
    echo https://ngrok.com/download
    echo.
    pause
    exit /b 1
)

echo [SUCCESS] Ngrok is ready!
ngrok version
echo.

echo ========================================
echo  Step 1: Starting Your Application...
echo ========================================
echo.
echo Starting TutorLiveMentor on port 5000...
echo.

REM Start the application in a new window
start "TutorLiveMentor Application" cmd /k "color 0B && echo === TutorLiveMentor Application === && echo Running on: http://localhost:5000 && echo. && echo Keep this window OPEN! && echo Close to stop the app. && echo. && dotnet run --launch-profile http"

echo Waiting for application to start...
echo (This takes about 10-15 seconds)
timeout /t 15 /nobreak >nul

echo.
echo [SUCCESS] Application should be running!
echo Test: http://localhost:5000
echo.

echo ========================================
echo  Step 2: Creating Public URL with Ngrok...
echo ========================================
echo.
color 0E
echo ========================================
echo ========================================
echo.
echo      YOUR PUBLIC URL WILL APPEAR BELOW
echo      It will look like:
echo.
echo   https://xxxx-xx-xx-xxx-xxx.ngrok-free.app
echo.
echo      COPY IT AND SHARE IT!
echo.
echo      Note: First-time visitors will see
echo      a warning page - just click "Visit Site"
echo.
echo ========================================
echo ========================================
echo.
timeout /t 3 /nobreak >nul

echo Starting ngrok now...
echo.
echo *** YOUR PUBLIC URL WILL APPEAR BELOW ***
echo.

REM Start ngrok tunnel
ngrok http 5000

echo.
echo.
echo ========================================
echo  Ngrok Tunnel Closed
echo ========================================
echo.
echo To restart: Just run this script again!
echo.
pause
