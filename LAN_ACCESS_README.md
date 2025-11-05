# ?? TutorLiveMentor - LAN Access Guide

## Quick Start

### Option 1: Batch File (Recommended for most users)
1. Double-click `run_on_lan.bat`
2. The script will display your local IP address and URLs
3. Share the displayed URLs with others on your network

### Option 2: PowerShell Script (Advanced - Auto firewall setup)
1. Right-click `run_on_lan.ps1` ? "Run with PowerShell" (or Run as Administrator)
2. If prompted about execution policy, type: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`
3. The script will automatically configure firewall rules and display URLs

---

## What URLs to Share?

After running either script, you'll see something like:

```
ACCESS FROM OTHER COMPUTERS:
  HTTP:  http://192.168.1.100:5000
  HTTPS: https://192.168.1.100:5001
```

**Share these URLs with people on your LAN:**
- **Home Page**: `http://YOUR_IP:5000`
- **Admin Login**: `http://YOUR_IP:5000/Admin/Login`
- **Student Registration**: `http://YOUR_IP:5000/Student/Register`
- **Faculty Login**: `http://YOUR_IP:5000/Faculty/Login`

Replace `YOUR_IP` with the IP address displayed by the script.

---

## Troubleshooting

### ? Can't access from other computers?

**1. Check Firewall:**
Run this command in Command Prompt (as Administrator):
```cmd
netsh advfirewall firewall add rule name="TutorLiveMentor HTTP" dir=in action=allow protocol=TCP localport=5000
netsh advfirewall firewall add rule name="TutorLiveMentor HTTPS" dir=in action=allow protocol=TCP localport=5001
```

**2. Check if server is listening:**
On the server computer, open Command Prompt and run:
```cmd
netstat -an | findstr :5000
```
You should see: `0.0.0.0:5000` or `[::]:5000`

**3. Make sure computers are on the same network:**
- Both computers should be connected to the same router/switch
- Check that other computer can ping your server: `ping YOUR_IP`

**4. Disable Windows Firewall temporarily (for testing):**
Control Panel ? Windows Defender Firewall ? Turn off (not recommended for production)

### ? HTTPS certificate warning?

This is normal for local development. Users will see a warning about the certificate.
- Click "Advanced" ? "Proceed anyway" (Chrome)
- Or use HTTP instead: `http://YOUR_IP:5000`

### ? Can't find your IP?

Open Command Prompt and run:
```cmd
ipconfig
```
Look for "IPv4 Address" under your active network adapter (usually starts with 192.168.x.x or 10.x.x.x)

---

## Manual Start (Without Scripts)

If the scripts don't work, you can manually start the server:

1. Open Command Prompt or PowerShell in the project directory
2. Run:
   ```
   dotnet run --urls "http://0.0.0.0:5000;https://0.0.0.0:5001"
   ```
3. Find your IP address using `ipconfig`
4. Share `http://YOUR_IP:5000` with others

---

## Network Types

- **Same WiFi Network**: ? Should work immediately
- **Ethernet LAN**: ? Should work immediately
- **Different Networks**: ? Won't work (need VPN or port forwarding)
- **Hotspot**: ? Should work if connected to your hotspot

---

## Security Notes

?? **Important:**
- This setup is for LOCAL NETWORK only (classroom, office, home)
- Don't expose this to the internet without proper security
- Change default admin passwords before deployment
- Use HTTPS in production environments

---

## Common Ports

- **Port 5000**: HTTP (recommended for LAN)
- **Port 5001**: HTTPS (may show certificate warnings)

If these ports are busy, you can change them in `appsettings.json`.

---

## Testing

1. On the server computer, open browser: `http://localhost:5000` ?
2. On another computer (same network): `http://SERVER_IP:5000` ?
3. On mobile (same WiFi): `http://SERVER_IP:5000` ?

---

## Quick Reference

| What | URL Format | Example |
|------|-----------|---------|
| Server (yourself) | http://localhost:5000 | http://localhost:5000 |
| Others on LAN | http://YOUR_IP:5000 | http://192.168.1.100:5000 |
| Admin Login | http://YOUR_IP:5000/Admin/Login | http://192.168.1.100:5000/Admin/Login |
| Student Register | http://YOUR_IP:5000/Student/Register | http://192.168.1.100:5000/Student/Register |

---

## Need Help?

1. Make sure the server is running (don't close the command window)
2. Check firewall settings
3. Verify both computers are on same network
4. Try HTTP instead of HTTPS
5. Check server logs in the command window for errors

**Status Check:**
- ? Server running: Command window shows "Now listening on: http://0.0.0.0:5000"
- ? Firewall open: Other computers can access the URLs
- ? Same network: Both computers can ping each other

---

**Happy Teaching! ??**
