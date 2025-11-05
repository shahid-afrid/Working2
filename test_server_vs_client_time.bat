@echo off
color 0B
echo.
echo ========================================
echo   SERVER TIME vs CLIENT TIME TEST
echo ========================================
echo.

echo This test proves that enrollment times
echo come from the SERVER, not the client!
echo.

echo Starting application...
start /min cmd /c "cd /d %~dp0 && dotnet run --urls http://localhost:5014"

echo Waiting for application to start...
timeout /t 5 /nobreak >nul

echo.
echo Opening test page...
start http://localhost:5014/Student/TestTime

echo.
echo ========================================
echo.
echo INSTRUCTIONS:
echo.
echo 1. Look at the JSON output in your browser
echo 2. Note the "serverLocalTime" value
echo 3. Compare it with YOUR computer's time
echo.
echo YOUR COMPUTER TIME: %date% %time%
echo.
echo If they match = Server is using YOUR computer's time
echo (which is CORRECT behavior!)
echo.
echo If they don't match = Something is very wrong!
echo.
echo ========================================
echo.
echo The enrollment time will ALWAYS use the
echo "serverLocalTime" value, NOT the client's
echo computer time!
echo.
echo This ensures:
echo - Fair enrollment order
echo - No cheating by changing client time
echo - Consistent timestamps for all students
echo.
echo ========================================
echo.
echo Press any key to stop the test...
pause >nul

taskkill /F /IM dotnet.exe 2>nul
echo.
echo Test complete!
pause
