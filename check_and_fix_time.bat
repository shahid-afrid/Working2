@echo off
color 0E
echo.
echo ========================================
echo   TIME CHECK AND FIX UTILITY
echo ========================================
echo.

echo Current System Time:
echo -------------------
echo Date: %date%
echo Time: %time%
echo.

echo Checking Internet Time Sync...
echo.
w32tm /query /status
echo.

echo ========================================
echo.
echo Do you want to sync with internet time?
echo This requires Administrator privileges.
echo.
set /p choice="Sync now? (Y/N): "

if /i "%choice%"=="Y" (
    echo.
    echo Syncing with internet time server...
    w32tm /resync
    echo.
    echo New System Time:
    echo -------------------
    echo Date: %date%
    echo Time: %time%
    echo.
    echo Done! Press any key to close...
    pause >nul
) else (
    echo.
    echo No changes made.
    echo.
    echo To manually set time:
    echo 1. Right-click clock in taskbar
    echo 2. Click "Adjust date/time"
    echo 3. Set correct date: December 10, 2024
    echo 4. Set correct time
    echo.
    pause
)
