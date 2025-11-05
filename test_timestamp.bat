@echo off
color 0A
echo.
echo ========================================
echo   TIMESTAMP DIAGNOSTIC TEST
echo ========================================
echo.

echo Starting application...
start /min cmd /c "cd /d %~dp0 && dotnet run --urls http://localhost:5014"

echo Waiting for application to start...
timeout /t 5 /nobreak >nul

echo.
echo Opening diagnostic endpoint...
start http://localhost:5014/Student/TestTime

echo.
echo ========================================
echo.
echo INSTRUCTIONS:
echo.
echo 1. Check the JSON output in your browser
echo 2. Compare "serverLocalTime" with your actual current time
echo 3. If they don't match, your system clock is wrong!
echo.
echo Current correct time: %date% %time%
echo.
echo ========================================
echo.
echo Press any key to stop the application...
pause >nul

taskkill /F /IM dotnet.exe 2>nul
echo.
echo Application stopped.
pause
