@echo off
echo ========================================
echo   CLEAN RESTART - TutorLiveMentor
echo ========================================
echo.

echo [1/5] Stopping any running instances...
taskkill /F /IM dotnet.exe /T >nul 2>&1
timeout /t 2 >nul

echo [2/5] Cleaning build artifacts...
dotnet clean >nul 2>&1

echo [3/5] Removing cached views...
if exist "obj" rd /s /q "obj"
if exist "bin\Debug\net8.0\Views" rd /s /q "bin\Debug\net8.0\Views"

echo [4/5] Building fresh...
dotnet build --no-incremental

echo [5/5] Starting application...
echo.
echo ========================================
echo   Application Starting on Port 5000
echo ========================================
echo.
start "" "http://localhost:5000"
dotnet run --urls "http://0.0.0.0:5000"

pause
