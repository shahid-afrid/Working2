# ?? GET YOUR SHAREABLE URL - QUICK GUIDE

## ?? SUPER SIMPLE METHOD

### Step 1: Run the Script
Double-click: **`START_NGROK_SIMPLE.bat`**

### Step 2: Wait 15 Seconds
The script will:
- ? Start your application
- ? Create a public URL with ngrok
- ? Open a browser showing your URL

### Step 3: Copy Your URL
Look for the **"Forwarding"** line in the console window:
```
Forwarding: https://xxxx-xxxx-xxxx.ngrok-free.app -> http://localhost:5000
```

**THAT'S YOUR PUBLIC URL!** ?

---

## ?? WHAT YOU'LL SEE

### In the Command Window:
```
====================================================
   YOUR PUBLIC URL WILL APPEAR BELOW!
====================================================

Forwarding: https://1234-56-78-90-123.ngrok-free.app -> http://localhost:5000

COPY THAT URL AND SHARE IT!
====================================================
```

### In Your Browser (http://127.0.0.1:4040):
You'll see a nice web interface showing:
- ?? Your public URL (easy to copy)
- ?? Request history
- ?? Detailed request info

---

## ?? QUICK STEPS TO SHARE

1. **Run:** `START_NGROK_SIMPLE.bat`
2. **Wait:** 15 seconds
3. **Copy:** The URL that looks like `https://xxxx.ngrok-free.app`
4. **Share:** Send it to anyone via WhatsApp, Email, etc.
5. **Test:** Open the URL yourself first to verify it works

---

## ?? FIRST-TIME NGROK SETUP (If needed)

If ngrok isn't installed yet:

### Option 1: Microsoft Store (Easiest)
1. Open **Microsoft Store**
2. Search for **"ngrok"**
3. Click **Install**
4. Done! ?

### Option 2: Manual Download
1. Visit: https://ngrok.com/download
2. Download ngrok for Windows
3. Extract `ngrok.exe` to this folder
4. Done! ?

### Option 3: Free Account (Optional, but recommended)
1. Visit: https://dashboard.ngrok.com/signup
2. Sign up (free)
3. Get your authtoken
4. Run: `ngrok config add-authtoken YOUR_TOKEN`

**Free tier includes:**
- ? 1 online ngrok process
- ? 40 connections/minute
- ? Plenty for testing and small groups!

---

## ?? EXAMPLE SHARING

**Your URL:** `https://a1b2-123-45-67-89.ngrok-free.app`

**Share it like this:**
```
Hey! Check out our TutorLiveMentor app:
https://a1b2-123-45-67-89.ngrok-free.app

Note: If you see a warning page, just click "Visit Site"
```

---

## ??? TROUBLESHOOTING

### ? "ngrok not found"
**Solution:** Install ngrok using one of the methods above

### ? "Port 5000 already in use"
**Solution:** 
1. Close any other running instances
2. Or change the port in the script

### ? "Tunnel not found"
**Solution:** 
1. Make sure the application window is still open
2. Don't close the command windows
3. Run the script again

### ? "This site can't be reached"
**Solution:**
1. Check that both windows are open (app + ngrok)
2. Try the URL in the browser interface: http://127.0.0.1:4040
3. Copy the fresh URL from there

---

## ?? IMPORTANT NOTES

### ? DO:
- Keep both command windows open (app + ngrok)
- Copy the URL from the "Forwarding" line
- Share the `https://` URL (not the `http://localhost` one)
- Test the URL yourself before sharing

### ? DON'T:
- Close the command windows while people are using it
- Share the `http://localhost:5000` URL (that's only for you)
- Worry about the ngrok warning page (users just click "Visit Site")

---

## ?? RESTARTING

**To get a NEW URL:**
1. Close both command windows
2. Run `START_NGROK_SIMPLE.bat` again
3. You'll get a new URL (ngrok generates random URLs each time)

**To keep the SAME URL:**
- Use a paid ngrok plan with custom domains
- Or keep the tunnel running

---

## ?? WHAT OTHERS WILL SEE

When someone opens your shared URL:

1. **First time:** Ngrok warning page ? Click "Visit Site"
2. **After that:** Your TutorLiveMentor homepage! ??

They can:
- ? Register as student
- ? Login
- ? Select faculty
- ? Everything works exactly like localhost!

---

## ?? NEED HELP?

If something doesn't work:
1. Check both windows are open
2. Check the browser interface: http://127.0.0.1:4040
3. Try running the script again
4. Check the troubleshooting section above

---

## ? SUCCESS CHECKLIST

- [ ] Ngrok installed
- [ ] Script executed
- [ ] Application window open
- [ ] Ngrok window showing "Forwarding" URL
- [ ] Browser showing ngrok interface
- [ ] URL copied
- [ ] URL tested (opened in browser)
- [ ] URL shared with others
- [ ] Others can access successfully

---

**That's it! You're now live on the internet! ??**
