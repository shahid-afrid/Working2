# ?? Ngrok Troubleshooting Guide

## Common Issues & Solutions

### 1. Ngrok Command Not Found ?

**Error:**
```
'ngrok' is not recognized as an internal or external command
```

**Solutions:**

#### Solution A: Add to PATH (if installed from Microsoft Store)
1. Press `Win + R`, type `shell:AppsFolder`, press Enter
2. Find "ngrok" in the list
3. Right-click ? "Open file location"
4. Copy the path
5. Add to System PATH:
   - Press `Win + X` ? System ? Advanced system settings
   - Environment Variables ? System variables ? Path ? Edit
   - New ? Paste the ngrok path ? OK

#### Solution B: Use Full Path
```powershell
# Find where ngrok is installed
where.exe ngrok

# Use full path
C:\Path\To\ngrok.exe http 5014
```

#### Solution C: Reinstall
1. Uninstall from Microsoft Store
2. Download from https://ngrok.com/download
3. Extract to `C:\ngrok`
4. Add `C:\ngrok` to PATH
5. Restart terminal

---

### 2. Authtoken Required ?

**Error:**
```
ERR_NGROK_3200
Your account is limited to 1 simultaneous ngrok agent session.
```

**Solution:**
```powershell
# Get your token from: https://dashboard.ngrok.com/get-started/your-authtoken
ngrok config add-authtoken YOUR_TOKEN_HERE
```

After adding token, restart ngrok:
```powershell
ngrok http 5014
```

---

### 3. Port Already in Use ?

**Error:**
```
listen tcp 127.0.0.1:4040: bind: address already in use
```

**Solutions:**

#### Solution A: Close Existing Ngrok
```powershell
# Find ngrok processes
tasklist | findstr ngrok

# Kill all ngrok processes
taskkill /F /IM ngrok.exe
```

#### Solution B: Use Different Web Interface Port
```powershell
ngrok http 5014 --web-addr=localhost:4041
```
Then access web interface at http://localhost:4041

---

### 4. Application Not Running ?

**Error:**
When you access ngrok URL, you see "502 Bad Gateway" or "Connection refused"

**Solution:**
1. Make sure your application is running:
   ```powershell
   dotnet run --launch-profile http
   ```

2. Verify it's accessible locally:
   - Open browser: http://localhost:5014
   - Should see your application

3. **Then** start ngrok in a separate terminal:
   ```powershell
   ngrok http 5014
   ```

---

### 5. SignalR Not Working Through Ngrok ?

**Symptoms:**
- Real-time updates don't work
- Console shows WebSocket errors
- Connection status shows "disconnected"

**Solutions:**

#### Solution A: Verify WebSocket Support (Usually Fine)
Ngrok supports WebSockets by default on free tier ?

#### Solution B: Check SignalR Connection
Open browser console (F12) and look for:
```javascript
SignalR Connected for Faculty!
```

If you see errors, check:
1. Application is running
2. Ngrok tunnel is active
3. No firewall blocking WebSockets

#### Solution C: Force HTTP (Not HTTPS)
```powershell
# Make sure you're using HTTP profile
dotnet run --launch-profile http

# Then tunnel to HTTP
ngrok http 5014
```

---

### 6. "Visit Site" Warning Page ??

**Issue:**
Free ngrok shows a warning page before accessing your app.

**Solutions:**

#### Solution A: Just Click "Visit Site"
This is normal for free tier. Users just click "Visit Site" button.

#### Solution B: Upgrade to Paid Plan
- No warning page
- Custom domains
- More features

#### Solution C: Self-host Alternative
Use alternatives like:
- LocalTunnel: `lt --port 5014`
- Cloudflare Tunnel (free, no warning page)

---

### 7. Slow or Intermittent Connection ??

**Causes:**
- Free tier has connection limits
- Server far from your region
- Network issues

**Solutions:**

#### Solution A: Choose Closer Region
```powershell
# List regions
ngrok http 5014 --region us    # United States
ngrok http 5014 --region eu    # Europe
ngrok http 5014 --region ap    # Asia Pacific
ngrok http 5014 --region au    # Australia
ngrok http 5014 --region sa    # South America
ngrok http 5014 --region jp    # Japan
ngrok http 5014 --region in    # India
```

#### Solution B: Check Status
Visit: https://status.ngrok.com/

#### Solution C: Monitor Traffic
Open ngrok web interface: http://127.0.0.1:4040
- Check request times
- Look for failed requests

---

### 8. Session Expires Too Quickly ?

**Issue:**
Free tier sessions can expire.

**Solutions:**

#### Solution A: Keep Terminal Open
Don't close the terminal running ngrok.

#### Solution B: Use `--keep-alive`
```powershell
ngrok http 5014 --log=stdout --log-level=info
```

#### Solution C: Upgrade to Paid
Paid plans have longer session durations.

---

### 9. Database Connection Issues ??

**Issue:**
Database errors when accessing through ngrok URL.

**Solutions:**

#### Solution A: Verify Local Database
```powershell
# Check if SQL Server is running
Get-Service MSSQL*
```

Should show "Running" status.

#### Solution B: Check Connection String
Your app connects to localhost database - this is fine!
Ngrok only tunnels HTTP traffic, database remains local.

#### Solution C: If Using Remote Database
Update connection string in `appsettings.json` to use public IP/domain.

---

### 10. Multiple Devices Not Connecting ??

**Issue:**
First device works, but others can't connect.

**Solutions:**

#### Solution A: Check Connection Limit
Free tier has limited concurrent connections.

#### Solution B: Check Application Pool
Your ASP.NET Core app might have connection limits.

#### Solution C: Monitor in Ngrok Dashboard
Open: http://127.0.0.1:4040
- See how many active connections
- Check for errors

---

## ?? Debugging Steps

### Step 1: Verify Local Access
```powershell
# Start app
dotnet run --launch-profile http

# Test locally
curl http://localhost:5014
```
Should return HTML. If not, fix app first.

### Step 2: Verify Ngrok
```powershell
# Start ngrok
ngrok http 5014
```
Should show Forwarding URL. If not, check authtoken.

### Step 3: Test Ngrok URL
```powershell
# Test from command line
curl https://your-ngrok-url.ngrok-free.app
```

### Step 4: Check Logs
- **Application Logs**: Check terminal running `dotnet run`
- **Ngrok Logs**: Check terminal running `ngrok`
- **Web Interface**: http://127.0.0.1:4040

### Step 5: Test from Different Network
- Use mobile data (not same WiFi)
- Try from friend's computer
- Use incognito/private browsing

---

## ?? Getting Help

### Check Ngrok Status
https://status.ngrok.com/

### Ngrok Documentation
https://ngrok.com/docs

### Ngrok Community
https://github.com/inconshreveable/ngrok/issues

### View Ngrok Config
```powershell
ngrok config check
```

### View Ngrok Version
```powershell
ngrok version
```

---

## ?? Quick Diagnostics

Run this in PowerShell to check your setup:

```powershell
Write-Host "=== TutorLiveMentor Ngrok Diagnostics ===" -ForegroundColor Cyan

# Check ngrok
if (Get-Command ngrok -ErrorAction SilentlyContinue) {
    Write-Host "? Ngrok installed" -ForegroundColor Green
    ngrok version
} else {
    Write-Host "? Ngrok not found" -ForegroundColor Red
}

# Check port 5014
$port = netstat -ano | findstr :5014
if ($port) {
    Write-Host "? Port 5014 in use (app running)" -ForegroundColor Green
} else {
    Write-Host "??  Port 5014 not in use (app not running?)" -ForegroundColor Yellow
}

# Check ngrok processes
$ngrokProcess = Get-Process ngrok -ErrorAction SilentlyContinue
if ($ngrokProcess) {
    Write-Host "? Ngrok process running" -ForegroundColor Green
} else {
    Write-Host "??  Ngrok not running" -ForegroundColor Yellow
}

# Test local access
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5014" -UseBasicParsing -TimeoutSec 5
    Write-Host "? App accessible locally (Status: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "? App not accessible locally" -ForegroundColor Red
}

Write-Host "=== End Diagnostics ===" -ForegroundColor Cyan
```

---

## ?? Still Having Issues?

1. **Check the documentation**: [NGROK_INTERNET_SETUP.md](NGROK_INTERNET_SETUP.md)
2. **Try the automated scripts**: `run_on_internet.bat` or `run_on_internet.ps1`
3. **Verify each step**: Don't skip verification steps
4. **Read error messages carefully**: They often contain the solution

---

## ?? Pro Tips

? Always start your app **before** starting ngrok
? Keep both terminals open while testing
? Use the ngrok web interface to debug
? Test from a different network (mobile data)
? Check ngrok status page if having issues
