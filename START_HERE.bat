@echo off
color 0E
title TutorLiveMentor - Quick Start

cls
echo.
echo ========================================
echo   TUTORLIVE MENTOR - QUICK START
echo ========================================
echo.
echo  Make your app accessible from anywhere!
echo.
echo ========================================
echo.
echo.
echo What would you like to do?
echo.
echo  1. Internet Access (Cloudflare Tunnel)
echo     - Share with remote users
echo     - Access from anywhere
echo     - Works on restricted networks
echo     - No warning page!
echo.
echo  2. Local Network Access (LAN)
echo     - Faster for classroom use
echo     - Same WiFi only
echo     - Best for 30+ students
echo.
echo  3. Try Ngrok (if not blocked)
echo     - Alternative internet access
echo     - Has warning page
echo     - May be blocked on your network
echo.
echo  4. Exit
echo.
echo ========================================
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto cloudflare
if "%choice%"=="2" goto lan
if "%choice%"=="3" goto ngrok
if "%choice%"=="4" goto end

echo Invalid choice! Please enter 1, 2, 3, or 4.
timeout /t 3 >nul
"%~f0"
exit /b

:cloudflare
cls
echo.
echo ========================================
echo  Starting Cloudflare Tunnel...
echo ========================================
echo.
echo This is the BEST option for internet access!
echo.
echo Starting in 3 seconds...
timeout /t 3 /nobreak >nul
call run_on_cloudflare.bat
goto end

:lan
cls
echo.
echo ========================================
echo  Starting LAN Access...
echo ========================================
echo.
echo Best for classroom use (fastest!)
echo.
echo Starting in 3 seconds...
timeout /t 3 /nobreak >nul
call run_on_lan.bat
goto end

:ngrok
cls
echo.
echo ========================================
echo  Starting Ngrok Tunnel...
echo ========================================
echo.
echo Note: This may not work if blocked on your network.
echo If it fails, use Cloudflare instead (Option 1)
echo.
echo Starting in 3 seconds...
timeout /t 3 /nobreak >nul
call run_on_internet.bat
goto end

:end
exit
