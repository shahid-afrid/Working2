# ?? TutorLiveMentor - Internet Access with Ngrok
# PowerShell Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TutorLiveMentor - Internet Access" -ForegroundColor Yellow
Write-Host "  Using Ngrok Tunnel" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if ngrok is available
$ngrokExists = Get-Command ngrok -ErrorAction SilentlyContinue
if (-not $ngrokExists) {
    Write-Host "[ERROR] Ngrok not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install ngrok:" -ForegroundColor Yellow
    Write-Host "1. Install from Microsoft Store" -ForegroundColor White
    Write-Host "2. OR download from https://ngrok.com/download" -ForegroundColor White
    Write-Host "3. Configure authtoken: ngrok config add-authtoken YOUR_TOKEN" -ForegroundColor White
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host "[SUCCESS] Ngrok found!" -ForegroundColor Green
Write-Host ""

# Get local IP address
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like "192.168.*" -or $_.IPAddress -like "10.*" }).IPAddress | Select-Object -First 1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Local Port:        5014" -ForegroundColor White
Write-Host "Local IP:          $localIP" -ForegroundColor White
Write-Host "Local URL:         http://localhost:5014" -ForegroundColor White
Write-Host "Ngrok Web UI:      http://127.0.0.1:4040" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Application..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[1/2] Starting ASP.NET Core application on port 5014..." -ForegroundColor Yellow
Write-Host ""

# Start the application in a new PowerShell window
$appProcess = Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host '?? TutorLiveMentor Application' -ForegroundColor Green; Write-Host 'Running on: http://localhost:5014' -ForegroundColor Cyan; Write-Host ''; dotnet run --launch-profile http" -PassThru -WindowStyle Normal

Write-Host "Waiting for application to start (10 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Ngrok Tunnel..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[2/2] Starting ngrok tunnel to port 5014..." -ForegroundColor Yellow
Write-Host ""

# Open ngrok web interface
Write-Host "Opening ngrok web interface at: http://127.0.0.1:4040" -ForegroundColor Cyan
Start-Process "http://127.0.0.1:4040"
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  NGROK TUNNEL STARTING..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "?? Instructions:" -ForegroundColor Yellow
Write-Host "1. Copy the 'Forwarding' URL from the ngrok output below" -ForegroundColor White
Write-Host "2. Share this URL with anyone on the internet" -ForegroundColor White
Write-Host "3. They can access your app from anywhere!" -ForegroundColor White
Write-Host ""
Write-Host "Example URL: https://abc123.ngrok-free.app" -ForegroundColor Cyan
Write-Host ""
Write-Host "??  Keep this window open to maintain the tunnel!" -ForegroundColor Red
Write-Host "??  Press Ctrl+C to stop the tunnel and application" -ForegroundColor Red
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Start ngrok tunnel
try {
    ngrok http 5014
}
finally {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "  Cleaning Up..." -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host ""
    
    # Stop the application process
    if ($appProcess -and !$appProcess.HasExited) {
        Write-Host "Stopping application..." -ForegroundColor Yellow
        Stop-Process -Id $appProcess.Id -Force -ErrorAction SilentlyContinue
        Write-Host "Application stopped." -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Ngrok tunnel closed." -ForegroundColor Yellow
    Write-Host "Press any key to exit..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
