# TutorLiveMentor - LAN Server Launcher (PowerShell)
# Run as Administrator for automatic firewall configuration

$Host.UI.RawUI.WindowTitle = "TutorLiveMentor - LAN Server"
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TutorLiveMentor - LAN Server Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Get local IP address
Write-Host "[1/4] Detecting your local IP address..." -ForegroundColor Yellow
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254.*"} | Select-Object -First 1).IPAddress

if ($localIP) {
    Write-Host "     ? Your Local IP: " -NoNewline -ForegroundColor Green
    Write-Host "$localIP" -ForegroundColor White
} else {
    Write-Host "     ? Could not detect IP. Using localhost." -ForegroundColor Red
    $localIP = "localhost"
}
Write-Host ""

# Configure firewall
Write-Host "[2/4] Checking firewall configuration..." -ForegroundColor Yellow
if ($isAdmin) {
    try {
        # Remove existing rules if they exist
        Remove-NetFirewallRule -DisplayName "TutorLiveMentor HTTP" -ErrorAction SilentlyContinue
        Remove-NetFirewallRule -DisplayName "TutorLiveMentor HTTPS" -ErrorAction SilentlyContinue
        
        # Add new firewall rules
        New-NetFirewallRule -DisplayName "TutorLiveMentor HTTP" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5000 | Out-Null
        New-NetFirewallRule -DisplayName "TutorLiveMentor HTTPS" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5001 | Out-Null
        
        Write-Host "     ? Firewall rules configured successfully!" -ForegroundColor Green
    } catch {
        Write-Host "     ? Firewall configuration failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "     ? Not running as Administrator" -ForegroundColor Yellow
    Write-Host "     Please allow firewall prompts or run as Administrator" -ForegroundColor Yellow
}
Write-Host ""

# Display QR Code option
Write-Host "[3/4] Access Information:" -ForegroundColor Yellow
Write-Host "     You can generate a QR code for easy mobile access" -ForegroundColor Gray
Write-Host ""

# Display URLs
Write-Host "[4/4] Starting server..." -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ACCESS FROM OTHER COMPUTERS:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  HTTP:  " -NoNewline -ForegroundColor White
Write-Host "http://$localIP:5000" -ForegroundColor Green
Write-Host "  HTTPS: " -NoNewline -ForegroundColor White
Write-Host "https://$localIP:5001" -ForegroundColor Green
Write-Host ""
Write-Host "  Example URLs to share:" -ForegroundColor Yellow
Write-Host "  - Home:       http://$localIP:5000" -ForegroundColor Gray
Write-Host "  - Admin:      http://$localIP:5000/Admin/Login" -ForegroundColor Gray
Write-Host "  - Student:    http://$localIP:5000/Student/Register" -ForegroundColor Gray
Write-Host "  - Faculty:    http://$localIP:5000/Faculty/Login" -ForegroundColor Gray
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "? Server is starting... Press Ctrl+C to stop" -ForegroundColor Green
Write-Host ""
Write-Host "Tip: Share the IP address with others on your network!" -ForegroundColor Yellow
Write-Host ""

# Run the application
dotnet run --urls "http://0.0.0.0:5000;https://0.0.0.0:5001"

Read-Host "Press Enter to exit"
