# ?? TutorLiveMentor - Cloudflare Tunnel
# PowerShell Script - Alternative to Ngrok

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TutorLiveMentor - Cloudflare Tunnel" -ForegroundColor Yellow
Write-Host "  Alternative to Ngrok (Better!)" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if cloudflared is available
$cloudflaredExists = Get-Command cloudflared -ErrorAction SilentlyContinue
if (-not $cloudflaredExists) {
    Write-Host "[ERROR] Cloudflare Tunnel not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install cloudflared:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Option 1: Using Winget (Easiest)" -ForegroundColor Cyan
    Write-Host "  winget install --id Cloudflare.cloudflared" -ForegroundColor White
    Write-Host ""
    Write-Host "Option 2: Using Chocolatey" -ForegroundColor Cyan
    Write-Host "  choco install cloudflared" -ForegroundColor White
    Write-Host ""
    Write-Host "Option 3: Download Directly" -ForegroundColor Cyan
    Write-Host "  https://github.com/cloudflare/cloudflared/releases" -ForegroundColor White
    Write-Host ""
    Write-Host "Opening download page..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    Start-Process "https://github.com/cloudflare/cloudflared/releases"
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host "[SUCCESS] Cloudflare Tunnel found!" -ForegroundColor Green
$version = cloudflared version
Write-Host "Version: $version" -ForegroundColor Cyan
Write-Host ""

# Get local IP address
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like "192.168.*" -or $_.IPAddress -like "10.*" }).IPAddress | Select-Object -First 1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Local Port:        5014" -ForegroundColor White
Write-Host "Local IP:          $localIP" -ForegroundColor White
Write-Host "Local URL:         http://localhost:5014" -ForegroundColor White
Write-Host "Tunnel Type:       Cloudflare Quick Tunnel" -ForegroundColor White
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
Write-Host "  Starting Cloudflare Tunnel..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[2/2] Creating Cloudflare tunnel to port 5014..." -ForegroundColor Yellow
Write-Host ""

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  CLOUDFLARE TUNNEL STARTING..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "? Cloudflare Advantages over Ngrok:" -ForegroundColor Cyan
Write-Host "  ? No warning page before access" -ForegroundColor Green
Write-Host "  ? No signup or authtoken needed" -ForegroundColor Green
Write-Host "  ? Better performance" -ForegroundColor Green
Write-Host "  ? Works on more restricted networks" -ForegroundColor Green
Write-Host "  ? Unlimited connections" -ForegroundColor Green
Write-Host ""
Write-Host "?? Instructions:" -ForegroundColor Yellow
Write-Host "1. Copy the tunnel URL from the output below" -ForegroundColor White
Write-Host "2. Share this URL with anyone on the internet" -ForegroundColor White
Write-Host "3. They can access your app directly (no warning page!)" -ForegroundColor White
Write-Host ""
Write-Host "Example URL: https://random-name.trycloudflare.com" -ForegroundColor Cyan
Write-Host ""
Write-Host "??  Keep this window open to maintain the tunnel!" -ForegroundColor Red
Write-Host "??  Press Ctrl+C to stop the tunnel and application" -ForegroundColor Red
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Start cloudflared tunnel
try {
    cloudflared tunnel --url http://localhost:5014
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
    Write-Host "Cloudflare tunnel closed." -ForegroundColor Yellow
    Write-Host "Press any key to exit..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
