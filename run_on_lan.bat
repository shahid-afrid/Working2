@echo off
color 0A
title TutorLiveMentor - LAN Server

echo ========================================
echo   TutorLiveMentor - LAN Server Setup
echo ========================================
echo.

REM Clean and build first to avoid view caching issues
echo [1/5] Cleaning previous build...
dotnet clean >nul 2>&1
echo     Done!
echo.

echo [2/5] Building project...
dotnet build >nul 2>&1
if errorlevel 1 (
    echo     ERROR: Build failed!
    pause
    exit /b 1
)
echo     Done!
echo.

REM Get local IP address
echo [3/5] Detecting your local IP address...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set IP=%%a
    goto :found
)
:found
set IP=%IP:~1%
echo     Your Local IP: %IP%
echo.

REM Display firewall warning
echo [4/5] Firewall Configuration:
echo     Make sure Windows Firewall allows port 5000 and 5001
echo     If blocked, run: netsh advfirewall firewall add rule name="TutorLiveMentor" dir=in action=allow protocol=TCP localport=5000-5001
echo.

REM Display URLs for other computers
echo [5/5] Starting server...
echo.
echo ========================================
echo   ACCESS FROM OTHER COMPUTERS:
echo ========================================
echo.
echo   HTTP:  http://%IP%:5000
echo   HTTPS: https://%IP%:5001
echo.
echo   Share these URLs with others on your LAN
echo ========================================
echo.
echo Server is starting... Press Ctrl+C to stop
echo.

REM Run the application
dotnet run --urls "http://0.0.0.0:5000;https://0.0.0.0:5001"

pause
