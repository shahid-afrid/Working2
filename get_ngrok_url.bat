@echo off
color 0B
echo.
echo ========================================
echo   NGROK URL FINDER
echo ========================================
echo.
echo Checking for your ngrok public URL...
echo.

timeout /t 2 /nobreak >nul

:CHECK
curl -s http://localhost:4040/api/tunnels > temp_ngrok.json 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo [INFO] Ngrok API not responding yet...
    echo       Make sure ngrok is running!
    echo.
    echo Retrying in 3 seconds...
    timeout /t 3 /nobreak >nul
    goto CHECK
)

echo [SUCCESS] Ngrok is running!
echo.
echo ========================================
echo   YOUR PUBLIC URLs:
echo ========================================
echo.

REM Parse JSON to find URLs using PowerShell
powershell -Command "$json = Get-Content temp_ngrok.json | ConvertFrom-Json; $json.tunnels | ForEach-Object { Write-Host ''; Write-Host '  URL: ' -NoNewline -ForegroundColor Cyan; Write-Host $_.public_url -ForegroundColor Green; Write-Host '  -> Maps to: ' -NoNewline; Write-Host $_.config.addr -ForegroundColor Yellow }"

echo.
echo ========================================
echo   COPY THE HTTPS URL AND SHARE IT!
echo ========================================
echo.
echo Note: Visitors will see an ngrok warning page
echo       Tell them to click "Visit Site" button
echo.

del temp_ngrok.json >nul 2>&1

echo.
echo Press any key to check again or close window...
pause >nul
goto CHECK
