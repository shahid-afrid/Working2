@echo off
color 0B
echo.
echo ========================================
echo   Cloudflare Tunnel URL Checker
echo ========================================
echo.

REM Check if cloudflared process is running
tasklist /FI "IMAGENAME eq cloudflared.exe" 2>NUL | find /I /N "cloudflared.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [STATUS] Cloudflare tunnel IS running!
    echo.
    echo Unfortunately, there's no direct way to retrieve
    echo the URL from a running tunnel.
    echo.
    echo SOLUTION:
    echo 1. Look at the window where you started the tunnel
    echo 2. Scroll up to find a line like:
    echo    https://xxxxx-xxxxx.trycloudflare.com
    echo.
    echo 3. That's your public URL!
    echo.
    echo OR: Restart the tunnel using the updated script
    echo     which will show the URL more clearly.
    echo.
) else (
    echo [STATUS] No cloudflare tunnel is currently running.
    echo.
    echo To start a tunnel:
    echo 1. Run: run_on_cloudflare.bat
    echo 2. Wait for the URL to appear
    echo 3. Copy and share it!
    echo.
)

echo ========================================
echo.
pause
