@echo off
echo ========================================
echo  Ngrok Connectivity Diagnostic Tool
echo ========================================
echo.

echo [1/5] Checking ngrok installation...
where ngrok >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Ngrok found
    ngrok version
) else (
    echo [ERROR] Ngrok not found
    echo Please install from Microsoft Store or https://ngrok.com/download
    pause
    exit /b 1
)

echo.
echo [2/5] Testing DNS resolution...
nslookup connect.ngrok-agent.com >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Can resolve ngrok servers
) else (
    echo [ERROR] Cannot resolve ngrok domain
    echo This might be a DNS issue or network restriction
)

echo.
echo [3/5] Testing internet connectivity...
ping -n 1 google.com >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Internet connection working
) else (
    echo [ERROR] No internet connection
)

echo.
echo [4/5] Checking ngrok configuration...
ngrok config check >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Ngrok configured correctly
) else (
    echo [WARNING] Ngrok configuration may have issues
    echo Run: ngrok config add-authtoken YOUR_TOKEN
)

echo.
echo [5/5] Testing port availability...
netstat -ano | findstr :5014 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Port 5014 is in use (app might be running)
) else (
    echo [INFO] Port 5014 is available
)

echo.
echo ========================================
echo  Diagnostic Results
echo ========================================
echo.
echo Based on the results above, here are your options:
echo.
echo OPTION 1: Fix Ngrok Connection
echo   - Check firewall settings
echo   - Temporarily disable antivirus
echo   - Try from mobile hotspot
echo   - Read: NGROK_CONNECTION_ISSUES_FIX.md
echo.
echo OPTION 2: Use Alternative (Recommended if blocked)
echo   - Cloudflare Tunnel (no warning page, free)
echo   - LocalTunnel (npm install -g localtunnel)
echo   - Serveo (SSH-based, works anywhere)
echo.
echo OPTION 3: Use LAN Access (Best for Classroom)
echo   - Run: run_on_lan.bat
echo   - Faster and more reliable than tunnels
echo   - No external dependencies
echo.
echo ========================================
echo.
echo Press any key to test ngrok connection...
pause >nul

echo.
echo Testing ngrok connection (this may take 10-15 seconds)...
echo If this hangs or shows "reconnecting", press Ctrl+C and try alternatives.
echo.

timeout /t 3 /nobreak >nul
echo Starting ngrok test...
ngrok http 5014 --log=stdout

pause
