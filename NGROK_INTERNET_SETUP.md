# ?? Ngrok Internet Access Setup Guide

## Prerequisites
? Ngrok installed from Microsoft Store

## Step-by-Step Setup

### 1?? Get Your Ngrok Auth Token
1. Go to https://dashboard.ngrok.com/signup
2. Sign up for a free account (or login if you have one)
3. Go to "Your Authtoken" section: https://dashboard.ngrok.com/get-started/your-authtoken
4. Copy your authtoken

### 2?? Configure Ngrok Authentication
Open PowerShell or Command Prompt and run:
```powershell
ngrok config add-authtoken YOUR_AUTH_TOKEN_HERE
```

Replace `YOUR_AUTH_TOKEN_HERE` with your actual token from step 1.

### 3?? Start Your Application
In your project directory:
```powershell
dotnet run --launch-profile http
```

Your application will start on: **http://localhost:5014**

### 4?? Start Ngrok Tunnel (HTTP)
In a **NEW** terminal window, run:
```powershell
ngrok http 5014
```

You'll see output like:
```
ngrok                                                                   

Session Status                online
Account                       Your Name (Plan: Free)
Version                       3.x.x
Region                        United States (us)
Forwarding                    https://abcd-123-456-789.ngrok-free.app -> http://localhost:5014

Web Interface                 http://127.0.0.1:4040
```

### 5?? Share Your Application
? **Your Internet URL**: Copy the `Forwarding` URL (e.g., `https://abcd-123-456-789.ngrok-free.app`)
? Share this URL with anyone - they can access your app from anywhere!

## ?? Quick Start Commands

```powershell
# Terminal 1: Start your application
dotnet run --launch-profile http

# Terminal 2: Start ngrok tunnel
ngrok http 5014
```

## ?? For HTTPS Application

If you want to run with HTTPS locally and tunnel it:

```powershell
# Terminal 1: Start with HTTPS
dotnet run --launch-profile https

# Terminal 2: Tunnel the HTTPS port
ngrok http https://localhost:7095
```

## ?? Monitoring Your Traffic

Ngrok provides a web interface to monitor all requests:
- Open: http://127.0.0.1:4040
- See all incoming requests, inspect traffic, and replay requests

## ?? Important Notes

### Free Tier Limitations
- ? Random URL each time (e.g., `random-name-123.ngrok-free.app`)
- ? Limited connections per minute
- ? Session expires when you close ngrok
- ?? Warning page before accessing your app (users must click "Visit Site")

### For Better Experience (Paid Plans)
- Custom subdomain: `your-app-name.ngrok-free.app`
- No warning page
- More concurrent connections

## ?? Troubleshooting

### Issue: "ERR_NGROK_3200"
**Solution**: You need to add your authtoken:
```powershell
ngrok config add-authtoken YOUR_TOKEN
```

### Issue: "Port already in use"
**Solution**: Make sure your app is running on port 5014:
```powershell
netstat -ano | findstr :5014
```

### Issue: SignalR not working through ngrok
**Solution**: SignalR should work automatically, but ensure:
- Your app is running on HTTP (not HTTPS only)
- WebSocket support is enabled (it is by default in ngrok)

## ?? Success Checklist

- [ ] Ngrok installed from Microsoft Store
- [ ] Authtoken configured
- [ ] Application running on http://localhost:5014
- [ ] Ngrok tunnel running
- [ ] Can access app from ngrok URL
- [ ] Real-time updates (SignalR) working through ngrok

## ?? Example Session

```powershell
# Step 1: Navigate to your project
cd C:\Users\shahi\Source\Repos\working2

# Step 2: Start application (Terminal 1)
dotnet run --launch-profile http
# Output: Now listening on: http://localhost:5014

# Step 3: Start ngrok (Terminal 2)
ngrok http 5014
# Output: Forwarding https://abc123.ngrok-free.app -> http://localhost:5014

# Step 4: Share the URL
# Send "https://abc123.ngrok-free.app" to anyone!
```

## ?? Alternative: Use Custom Domain (Paid)

With a paid ngrok plan, you can use a custom domain:
```powershell
ngrok http 5014 --domain=your-custom-domain.com
```

## ?? Pro Tips

1. **Keep Both Terminals Open**: Don't close the terminal running your app or ngrok
2. **Save Your URLs**: Each ngrok session gets a new URL (free tier)
3. **Monitor Traffic**: Use http://127.0.0.1:4040 to see all requests
4. **Test Real-time**: Open multiple browsers to test SignalR real-time updates
5. **Security**: Don't share sensitive data - ngrok exposes your app publicly!

## ?? Next Steps

Once your tunnel is running:
1. Test the ngrok URL in your browser
2. Test from a mobile device on different network
3. Share with students/faculty to test
4. Monitor the ngrok web interface for traffic

---

**Need Help?** Check the ngrok dashboard: https://dashboard.ngrok.com
