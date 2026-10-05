# Fly.io Web Deployment - Quick Start

Deploy OUTGROW to Fly.io using the web dashboard (no CLI needed).

## Prerequisites

1. **Fly.io account**: https://fly.io
2. **GitHub account**: Required for web deployment
3. **Code pushed to GitHub**

## 5-Minute Deployment

### Step 1: Push to GitHub

```bash
git add .
git commit -m "Ready for Fly.io"
git push origin main
```

### Step 2: Create App on Fly.io

1. Go to https://fly.io/dashboard
2. Click **"Create an app"**
3. Choose **"From GitHub"**
4. Select your repository
5. Enter app name: `my-outgrow`
6. Choose region (e.g., `sjc` for San Jose)
7. Click **"Create App"**

### Step 3: Add Environment Variables

In your app dashboard → **Settings** → **Environment Variables**:

```
PORT = 8765
OUTGROW_BIND = 0.0.0.0
OUTGROW_DATA_DIR = /data
PYTHONUNBUFFERED = true
OUTGROW_ADMINS = yourusername
```

### Step 4: Create Volume

Go to **Volumes** → **Create Volume**:
- Name: `outgrow_data`
- Size: 1 GB
- Region: Same as app

### Step 5: Deploy

Click **"Deploy"** button and wait 1-2 minutes.

### Step 6: Get Invite Code

Go to **Monitoring** → **Logs** and look for: `Invite code: XXXXXX`

### Step 7: Access

Your app is at: `https://your-app-name.fly.dev`

## Done! 🎉

## Common Tasks

**View logs**: Monitoring → Logs
**Restart app**: Monitoring → Overview → Restart
**Update code**: Push to GitHub → Click Deploy
**Backup database**: Exec button → `cat /data/outgrow.db`
**Check status**: Monitoring → Overview

## Notes

- Free tier available (256MB RAM, 3GB storage)
- Production: 512MB RAM recommended (~$5-10/month)
- SQLite database persists on volume

For detailed instructions, see [FLY_WEB_DEPLOY.md](FLY_WEB_DEPLOY.md).
