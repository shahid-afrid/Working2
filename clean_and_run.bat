@echo off
color 0B
title TutorLiveMentor - Clean Build and Run

echo ========================================
echo    Clean Build and Run Application
echo ========================================
echo.

echo [1/4] Cleaning build artifacts...
dotnet clean
if errorlevel 1 (
    echo ERROR: Clean failed!
    pause
    exit /b 1
)
echo     Done!

echo.
echo [2/4] Building project...
dotnet build
if errorlevel 1 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)
echo     Done!

echo.
echo [3/4] Starting application...
echo.
echo ========================================
echo    Application Starting
echo ========================================
echo.
echo    Local URL:  http://localhost:5000
echo.
echo    This will fix view caching issues!
echo ========================================
echo.
echo [4/4] Server Running...
echo Press Ctrl+C to stop the server
echo.

dotnet run --urls "http://localhost:5000"
