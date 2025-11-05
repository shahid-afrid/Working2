# ?? Alternative to Ngrok - Cloudflare Tunnel

## Why Cloudflare Tunnel?

If ngrok is blocked on your network, Cloudflare Tunnel is the **BEST alternative**:

? **Free forever**
? **No warning page** (unlike ngrok free tier)
? **Better performance**
? **More reliable on restricted networks**
? **Easy to use**

---

## ?? Quick Setup (5 Minutes)

### Step 1: Install Cloudflare Tunnel

**Option A: Using Winget (Recommended)**
```powershell
winget install --id Cloudflare.cloudflared
```

**Option B: Download Directly**
1. Visit: https://github.com/cloudflare/cloudflared/releases
2. Download: `cloudflared-windows-amd64.exe`
3. Rename to: `cloudflared.exe`
4. Move to: `C:\cloudflared\`
5. Add `C:\cloudflared` to PATH

**Option C: Using Chocolatey**
```powershell
choco install cloudflared
```

### Step 2: Verify Installation

```powershell
cloudflared version
```

Expected output: `cloudflared version 2024.x.x`

---

## ?? How to Use

### Method 1: Quick Tunnel (Easiest)

```powershell
# Terminal 1: Start your app
dotnet run --launch-profile http

# Terminal 2: Start tunnel
cloudflared tunnel --url http://localhost:5014
```

**Output:**
```
Your quick Tunnel has been created! Visit it at:
https://random-name.trycloudflare.com
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^
                Share this URL!
```

That's it! No signup, no authtoken needed!

---

### Method 2: Automated Script

I'll create a script for you:

```powershell
# run_on_cloudflare.bat
```

Just double-click it!

---

## ?? Comparison: Ngrok vs Cloudflare Tunnel

| Feature | Ngrok Free | Cloudflare Tunnel |
|---------|-----------|-------------------|
| **Warning Page** | ?? Yes | ? No |
| **Signup Required** | ?? Yes | ? No |
| **Connection Limits** | ?? 40/min | ? Unlimited |
| **URL Type** | Random | Random |
| **Speed** | Good | Excellent |
| **Reliability** | Good | Excellent |
| **Works on Restricted Networks** | ?? Sometimes | ? Usually |

---

## ?? For Your TutorLiveMentor App

### Classroom Use (Best Option)
```powershell
.\run_on_lan.bat
# Fastest, most reliable
```

### Internet Access (If Ngrok Blocked)
```powershell
.\run_on_cloudflare.bat
# Better than ngrok for restricted networks
```

---

## ?? Troubleshooting Cloudflare Tunnel

### Issue: Command Not Found
**Fix:**
```powershell
# Add to PATH
$env:Path += ";C:\cloudflared"
```

### Issue: Connection Failed
Cloudflare works on almost all networks, but if it fails:
1. Try mobile hotspot
2. Check antivirus
3. Use LAN access instead

---

## ?? Pro Tip: Best of Both Worlds

Keep both options available:

```powershell
# At home (ngrok works)
.\run_on_internet.bat     # Uses ngrok

# At school (ngrok blocked)
.\run_on_cloudflare.bat   # Uses Cloudflare

# In classroom
.\run_on_lan.bat          # Fastest!
```

---

## ?? Ready to Use!

**Next Steps:**
1. Install Cloudflare Tunnel
2. Test it with your app
3. Share the URL!

No signup, no authtoken, no hassle! ??
