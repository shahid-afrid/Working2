@echo off
color 0E
title Ngrok - Complete Reset and Fix

cls
echo.
echo ========================================
echo   NGROK - COMPLETE RESET AND FIX
echo ========================================
echo.
echo This will:
echo  1. Clean up old ngrok processes
echo  2. Reset ngrok configuration
echo  3. Add firewall rules
echo  4. Try different connection methods
echo  5. Test if ngrok works
echo.
echo ========================================
echo.
pause

REM Step 1: Kill all ngrok processes
echo.
echo [1/6] Stopping all ngrok processes...
taskkill /F /IM ngrok.exe >nul 2>&1
timeout /t 2 /nobreak >nul
echo [OK] Processes stopped

REM Step 2: Check ngrok installation
echo.
echo [2/6] Checking ngrok installation...
where ngrok >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Ngrok not found!
    echo.
    echo Please install ngrok first:
    echo 1. From Microsoft Store
    echo 2. Or download from https://ngrok.com/download
    echo.
    pause
    exit /b 1
)
echo [OK] Ngrok found
ngrok version

REM Step 3: Configure authtoken
echo.
echo [3/6] Configuring authtoken...
echo.
echo Please enter your ngrok authtoken:
echo (Get it from: https://dashboard.ngrok.com/get-started/your-authtoken)
echo.
set /p AUTH_TOKEN="Paste your authtoken here: "

if "%AUTH_TOKEN%"=="" (
    echo [ERROR] No authtoken provided!
    pause
    exit /b 1
)

ngrok config add-authtoken %AUTH_TOKEN%
if %ERRORLEVEL% EQU 0 (
    echo [OK] Authtoken configured
) else (
    echo [WARNING] Authtoken configuration may have failed
)

REM Step 4: Add firewall rule (requires admin)
echo.
echo [4/6] Adding Windows Firewall rule...
echo This requires Administrator privileges.
echo.

REM Try to add firewall rule
netsh advfirewall firewall delete rule name="Ngrok" >nul 2>&1
netsh advfirewall firewall add rule name="Ngrok" dir=in action=allow program="%ProgramFiles%\WindowsApps\ngrok.ngrok_1g87z0zv29zzc\ngrok.exe" enable=yes >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Firewall rule added
) else (
    echo [WARNING] Could not add firewall rule (may need admin rights)
    echo You can try running this script as Administrator
)

REM Step 5: Test connectivity
echo.
echo [5/6] Testing connectivity...
echo.

echo Testing DNS resolution...
nslookup connect.ngrok-agent.com >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] DNS resolution works
) else (
    echo [WARNING] Cannot resolve ngrok domain
    echo This might be a network restriction
)

echo.
echo Testing internet connection...
ping -n 1 google.com >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Internet connection works
) else (
    echo [ERROR] No internet connection
)

REM Step 6: Try to start ngrok with different regions
echo.
echo [6/6] Testing ngrok connection...
echo.
echo ========================================
echo  TESTING NGROK CONNECTION
echo ========================================
echo.
echo Trying to connect to ngrok servers...
echo This may take 10-15 seconds.
echo.
echo If you see "Session Status: online", ngrok works!
echo If you see "reconnecting" or errors, ngrok is blocked.
echo.
echo Press Ctrl+C to stop if it hangs.
echo.
echo ========================================
echo.

timeout /t 3 /nobreak >nul

REM Try US region
echo Trying US region...
echo.
start /MIN cmd /c "ngrok http 5014 --region us --log=stdout > ngrok_test.log 2>&1"

timeout /t 15 /nobreak >nul

REM Check if ngrok is running
tasklist | findstr ngrok.exe >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo  NGROK PROCESS IS RUNNING!
    echo ========================================
    echo.
    echo Checking connection status...
    
    REM Try to get the status
    curl -s http://127.0.0.1:4040/api/tunnels >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo [SUCCESS] Ngrok is working! ?
        echo.
        echo Check: http://127.0.0.1:4040 for details
        echo.
        echo Your ngrok tunnel should be active now.
        echo.
        echo To use ngrok for your app:
        echo 1. Start your app: dotnet run --launch-profile http
        echo 2. Run: ngrok http 5014
        echo 3. Share the URL!
        echo.
    ) else (
        echo.
        echo [INFO] Ngrok process running but checking status...
        echo Open: http://127.0.0.1:4040
        echo.
    )
    
    echo.
    echo Stopping test...
    taskkill /F /IM ngrok.exe >nul 2>&1
    
) else (
    echo.
    echo ========================================
    echo  NGROK FAILED TO START
    echo ========================================
    echo.
    echo [ERROR] Ngrok cannot connect to servers
    echo.
    echo This means ngrok is BLOCKED on your network.
    echo.
    echo RECOMMENDED SOLUTIONS:
    echo.
    echo Option 1: Use Mobile Hotspot
    echo   - Enable hotspot on your phone
    echo   - Connect laptop to it
    echo   - Try ngrok again
    echo.
    echo Option 2: Use Cloudflare Tunnel (BETTER!)
    echo   - Works on more networks
    echo   - No warning page
    echo   - Run: run_on_cloudflare.bat
    echo.
    echo Option 3: Use LAN Access (For Classroom)
    echo   - Fastest option
    echo   - Run: run_on_lan.bat
    echo.
)

REM Cleanup
del ngrok_test.log >nul 2>&1

echo.
echo ========================================
echo  RESET COMPLETE
echo ========================================
echo.
pause
