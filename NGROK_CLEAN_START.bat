@echo off
cls
echo ========================================
echo   NGROK + APP - CLEAN START
echo ========================================
echo.

REM Stop any existing instances
echo [STEP 1] Cleaning up existing processes...
taskkill /F /IM dotnet.exe /T >nul 2>&1
taskkill /F /IM ngrok.exe /T >nul 2>&1
timeout /t 2 >nul

REM Clean build
echo [STEP 2] Cleaning old build files...
dotnet clean >nul 2>&1
if exist "obj" rd /s /q "obj"
if exist "bin\Debug\net8.0\Views" rd /s /q "bin\Debug\net8.0\Views"

echo [STEP 3] Building fresh application...
dotnet build --no-incremental
if errorlevel 1 (
    echo.
    echo ERROR: Build failed! Check the errors above.
    pause
    exit /b 1
)

REM Start the app in a new window
echo [STEP 4] Starting application on port 5000...
start "TutorLiveMentor App" cmd /k "cd /d %~dp0 && dotnet run --urls http://0.0.0.0:5000"

REM Wait for app to start
echo [STEP 5] Waiting for app to initialize...
timeout /t 8 >nul

REM Start ngrok
echo [STEP 6] Starting ngrok tunnel...
start "Ngrok Tunnel" cmd /k "ngrok http 5000 --log=stdout"

REM Wait for ngrok to initialize
timeout /t 5 >nul

REM Open ngrok dashboard to show URL
echo [STEP 7] Opening ngrok dashboard...
start "" "http://127.0.0.1:4040"

echo.
echo ========================================
echo   SETUP COMPLETE!
echo ========================================
echo.
echo Your app is running on: http://localhost:5000
echo Ngrok dashboard: http://127.0.0.1:4040
echo.
echo Copy your public URL from the ngrok dashboard!
echo.
echo Press any key to see instructions...
pause >nul

cls
echo.
echo ????????????????????????????????????????????????????????????
echo ?                                                          ?
echo ?         YOUR PUBLIC URL IS READY! ??                    ?
echo ?                                                          ?
echo ????????????????????????????????????????????????????????????
echo.
echo   ?? COPY YOUR URL FROM:
echo   ----------------------------------------------------------
echo   http://127.0.0.1:4040
echo.
echo   Look for: "Forwarding"
echo   Example: https://xxxx-xxx-xxx-xxx-xxx.ngrok-free.app
echo.
echo   ? Your URL will look like:
echo      https://centralistic-fretfully-lizzette.ngrok-free.app
echo.
echo   ??  IMPORTANT:
echo   - Keep both windows open (App + Ngrok)
echo   - Don't close this window
echo   - Share the URL with anyone!
echo.
echo   ?? To stop everything: Close all windows or press Ctrl+C
echo.
pause
