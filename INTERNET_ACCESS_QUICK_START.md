# ?? QUICK START - Internet Access (2 Minutes)

## ? Fastest Method - Just 3 Commands!

### 1?? Configure Ngrok (First Time Only)
```powershell
ngrok config add-authtoken YOUR_AUTH_TOKEN
```
Get your token from: https://dashboard.ngrok.com/get-started/your-authtoken

### 2?? Use the Automated Script
**Option A: Double-click the file**
```
run_on_internet.bat
```

**Option B: Run in PowerShell**
```powershell
.\run_on_internet.ps1
```

### 3?? Share Your URL!
Copy the forwarding URL from ngrok output:
```
https://abc-123-xyz.ngrok-free.app
```

## ? That's It!
Your app is now accessible from anywhere on the internet!

---

## ?? Manual Method (If Scripts Don't Work)

### Terminal 1 - Start Application
```powershell
dotnet run --launch-profile http
```

### Terminal 2 - Start Ngrok
```powershell
ngrok http 5014
```

### Copy & Share
Copy the `Forwarding` URL and share it!

---

## ?? Monitor Your Traffic
Open in browser: http://127.0.0.1:4040

---

## ?? Time Estimate
- **First time setup**: 5 minutes (including ngrok signup)
- **Subsequent runs**: 30 seconds (just run the script!)

---

## ?? Expected Output

When you run `run_on_internet.bat` or `run_on_internet.ps1`:

```
========================================
  TutorLiveMentor - Internet Access
  Using Ngrok Tunnel
========================================

[SUCCESS] Ngrok found!

========================================
  Starting Application...
========================================

[1/2] Starting ASP.NET Core application on port 5014...

Waiting for application to start (10 seconds)...

========================================
  Starting Ngrok Tunnel...
========================================

[2/2] Starting ngrok tunnel to port 5014...

========================================
  NGROK TUNNEL ACTIVE
========================================

Copy the "Forwarding" URL and share it!
Example: https://abc123.ngrok-free.app

Forwarding: https://xyz-789-abc.ngrok-free.app -> http://localhost:5014
```

**?? Share the Forwarding URL with anyone!**

---

## ?? Test Your Setup

1. ? Copy your ngrok URL (e.g., `https://xyz.ngrok-free.app`)
2. ? Open it in a private/incognito browser
3. ? Open it on your phone (using mobile data, not WiFi)
4. ? Share with a friend to test from another location

All should work! ??

---

## ?? Troubleshooting

### "Ngrok not found"
**Solution**: Install from Microsoft Store or https://ngrok.com/download

### "Authtoken required"
**Solution**: Run `ngrok config add-authtoken YOUR_TOKEN`

### "Port 5014 already in use"
**Solution**: Close other instances of your app and try again

### "Can't access ngrok URL"
**Solution**: 
1. Check if app is running (http://localhost:5014 should work)
2. Check if ngrok is running (look for Forwarding URL in terminal)
3. Try accessing the ngrok URL with `/Home/Index` at the end

---

## ?? Pro Tip

Keep both windows open:
- **Window 1**: Your application (don't close!)
- **Window 2**: Ngrok tunnel (don't close!)
- **Optional Window 3**: Your browser at http://127.0.0.1:4040 to monitor traffic

---

## ?? Security Note

?? **Your app is now PUBLIC!** Anyone with the URL can access it.

For production use, consider:
- Adding authentication
- Using ngrok paid plan for password protection
- Deploying to a proper cloud hosting service (Azure, AWS, etc.)

---

## ?? Success!

If you can access your app from your phone (using mobile data), you've successfully exposed your app to the internet! ??

Share your ngrok URL and let others test your application from anywhere in the world!
