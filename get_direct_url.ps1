$Host.UI.RawUI.WindowTitle = "Get Direct URL"
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Yellow"
Clear-Host

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   GET YOUR DIRECT URL" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if ngrok is installed
$ngrokPath = Get-Command ngrok -ErrorAction SilentlyContinue

if (-not $ngrokPath) {
    Write-Host "[X] NGROK NOT INSTALLED!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Quick Install Options:" -ForegroundColor Yellow
    Write-Host "  1. Microsoft Store: Search 'ngrok'" -ForegroundColor White
    Write-Host "  2. Download: https://ngrok.com/download" -ForegroundColor White
    Write-Host ""
    Write-Host "After installing, run this script again." -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "[OK] Ngrok is installed!" -ForegroundColor Green
Write-Host ""

# Check if ngrok is already running
Write-Host "Checking if ngrok is already running..." -ForegroundColor Cyan
$ngrokProcess = Get-Process ngrok -ErrorAction SilentlyContinue

if ($ngrokProcess) {
    Write-Host "[OK] Ngrok is running!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Fetching your URL..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    
    try {
        # Try to get URL from ngrok API
        $response = Invoke-RestMethod -Uri "http://127.0.0.1:4040/api/tunnels" -ErrorAction Stop
        
        if ($response.tunnels -and $response.tunnels.Count -gt 0) {
            $publicUrl = $response.tunnels[0].public_url
            
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "========================================" -ForegroundColor Green
            Write-Host ""
            Write-Host "   YOUR PUBLIC URL IS:" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "   $publicUrl" -ForegroundColor Cyan -BackgroundColor DarkBlue
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "========================================" -ForegroundColor Green
            Write-Host ""
            
            # Copy to clipboard
            $publicUrl | Set-Clipboard
            Write-Host "[OK] URL copied to clipboard!" -ForegroundColor Green
            Write-Host ""
            Write-Host "You can now paste it anywhere!" -ForegroundColor White
            Write-Host ""
            
            # Open browser
            Write-Host "Opening ngrok dashboard in browser..." -ForegroundColor Cyan
            Start-Process "http://127.0.0.1:4040"
        }
        else {
            Write-Host "[!] No tunnels found. Opening browser..." -ForegroundColor Yellow
            Start-Process "http://127.0.0.1:4040"
        }
    }
    catch {
        Write-Host "[!] Could not fetch URL automatically." -ForegroundColor Yellow
        Write-Host "Opening browser at: http://127.0.0.1:4040" -ForegroundColor Cyan
        Start-Process "http://127.0.0.1:4040"
    }
}
else {
    Write-Host "[!] Ngrok is NOT running yet." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Starting ngrok for you..." -ForegroundColor Cyan
    Write-Host ""
    
    # Check if app is running
    $appProcess = Get-Process dotnet -ErrorAction SilentlyContinue
    if (-not $appProcess) {
        Write-Host "Starting application first..." -ForegroundColor Yellow
        Start-Process -FilePath "dotnet" -ArgumentList "run --urls http://localhost:5000" -WindowStyle Minimized
        Write-Host "Waiting 15 seconds for app to start..." -ForegroundColor Cyan
        Start-Sleep -Seconds 15
        Write-Host "[OK] App should be running!" -ForegroundColor Green
        Write-Host ""
    }
    
    Write-Host "Starting ngrok tunnel..." -ForegroundColor Yellow
    Start-Process -FilePath "ngrok" -ArgumentList "http 5000"
    
    Write-Host "Waiting 5 seconds for ngrok to initialize..." -ForegroundColor Cyan
    Start-Sleep -Seconds 5
    
    Write-Host ""
    Write-Host "Opening ngrok dashboard..." -ForegroundColor Cyan
    Start-Process "http://127.0.0.1:4040"
    
    Write-Host ""
    Write-Host "Trying to fetch your URL..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    
    try {
        $response = Invoke-RestMethod -Uri "http://127.0.0.1:4040/api/tunnels" -ErrorAction Stop
        
        if ($response.tunnels -and $response.tunnels.Count -gt 0) {
            $publicUrl = $response.tunnels[0].public_url
            
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "========================================" -ForegroundColor Green
            Write-Host ""
            Write-Host "   YOUR PUBLIC URL IS:" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "   $publicUrl" -ForegroundColor Cyan -BackgroundColor DarkBlue
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "========================================" -ForegroundColor Green
            Write-Host ""
            
            # Copy to clipboard
            $publicUrl | Set-Clipboard
            Write-Host "[OK] URL copied to clipboard!" -ForegroundColor Green
            Write-Host ""
        }
    }
    catch {
        Write-Host "[!] Check the ngrok window or browser for your URL" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tips:" -ForegroundColor Yellow
Write-Host "  - Your URL is in the ngrok window" -ForegroundColor White
Write-Host "  - OR check browser: http://127.0.0.1:4040" -ForegroundColor White
Write-Host "  - Keep both windows open!" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to exit"
