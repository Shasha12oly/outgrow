# Deploy OUTGROW via Fly.io Web Dashboard

This guide shows you how to deploy OUTGROW using the Fly.io web interface (no CLI required).

## Prerequisites

1. **Fly.io account**: Sign up at https://fly.io
2. **GitHub account**: Fly.io web deployment requires GitHub integration
3. **Repository**: Push your OUTGROW code to GitHub

## Step 1: Push Code to GitHub

```bash
git init
git add .
git commit -m "Initial commit for Fly.io deployment"
git branch -M main
git remote add origin https://github.com/yourusername/your-repo.git
git push -u origin main
```

## Step 2: Create New App on Fly.io

1. Go to https://fly.io/dashboard
2. Click **"Create an app"**
3. Choose **"From a Dockerfile"** or **"From existing source"**
4. Click **"Browse GitHub"** and select your repository
5. Fly.io will detect the Dockerfile automatically

## Step 3: Configure App

### Basic Settings

- **App Name**: Choose a unique name (e.g., `my-outgrow`)
- **Region**: Choose one close to you
  - `sjc` - San Jose (US West)
  - `iad` - Virginia (US East)
  - `ams` - Amsterdam (Europe)
  - `hkg` - Hong Kong (Asia)
- **Organization**: Your personal account (free tier)

### Environment Variables

Add these in the **Environment Variables** section:

```
PORT = 8765
OUTGROW_BIND = 0.0.0.0
OUTGROW_DATA_DIR = /data
PYTHONUNBUFFERED = true
OUTGROW_ADMINS = yourusername
```

**Secrets** (click "Secrets" tab):

```
OUTGROW_DISCORD_WEBHOOK = https://discord.com/api/webhooks/... (optional)
```

## Step 4: Create Volume (Persistent Storage)

1. Go to your app dashboard
2. Click **"Volumes"** in the left sidebar
3. Click **"Create Volume"**
4. Configure:
   - **Name**: `outgrow_data`
   - **Size**: 1 GB (or more)
   - **Region**: Same as your app region
5. Click **"Create Volume"**

## Step 5: Mount Volume

1. In your app dashboard, click **"Settings"**
2. Scroll to **"Docker options"** or create a `fly.toml` via the web editor
3. Add volume mount configuration:

```toml
[mounts]
  source = "outgrow_data"
  destination = "/data"
```

**Alternative**: Upload the `fly.toml` file included in this repo via the web UI.

## Step 6: Deploy

1. Click **"Deploy"** or **"Release"**
2. Fly.io will:
   - Clone your repository
   - Build the Docker image
   - Deploy to your chosen region
3. Wait for deployment to complete (1-2 minutes)

## Step 7: Access Your App

Once deployed, you'll see:
- **App URL**: `https://your-app-name.fly.dev`
- **Status**: Running

## Step 8: Get Invite Code

1. Go to **"Monitoring"** → **"Logs"**
2. Look for the line: `Invite code: XXXXXX`
3. Or use the **"Exec"** feature to SSH into the app:
   - Click **"Exec"** button
   - Run: `cat /data/INVITE_CODE.txt`

## Step 9: Test Your App

1. Open your app URL in a browser
2. Click "New here?"
3. Enter the invite code
4. Create your account
5. Verify everything works

## Managing Your App via Web Dashboard

### View Logs
- Go to **"Monitoring"** → **"Logs"**
- Real-time logs available

### Restart App
- Go to **"Monitoring"** → **"Overview"**
- Click **"Restart"** button

### Scale Resources
- Go to **"Resources"**
- Adjust CPU, memory, or machine count

### Environment Variables
- Go to **"Settings"** → **"Environment Variables"**
- Add, edit, or delete variables
- Changes require redeploy

### Database Backup (via Exec)

1. Click **"Exec"** button in dashboard
2. In the shell, run:
   ```bash
   cat /data/outgrow.db
   ```
3. Copy the output and save locally as `backup.db`

### Database Restore (via Exec)

1. Click **"Exec"** button
2. Upload your backup file (if supported) or use SFTP
3. Run:
   ```bash
   chmod 644 /data/outgrow.db
   ```
4. Restart the app

## Update Code

To update your app:

1. Push changes to GitHub
2. Go to Fly.io dashboard
3. Click **"Deploy"** → **"Release"**
4. Fly.io will auto-deploy from your repository

## Monitoring

### Metrics
- Go to **"Monitoring"** → **"Metrics"**
- View CPU, memory, request metrics

### Alerts
- Go to **"Monitoring"** → **"Alerts"**
- Set up alerts for CPU, memory, response time

## Cost Summary

### Free Tier
- 1 shared CPU
- 256MB RAM
- 3GB volume storage
- 160GB bandwidth/month
- **Cost: $0**

### Recommended Production
- 1 shared CPU
- 512MB RAM
- 1GB volume storage
- **Cost: ~$5-10/month**

Billing is available in **"Billing"** section of dashboard.

## Troubleshooting

### App Won't Start

1. Check logs in **"Monitoring"** → **"Logs"**
2. Common issues:
   - Volume not created
   - Environment variables missing
   - Port conflict

### Database Errors

1. Ensure volume is mounted at `/data`
2. Check volume exists in **"Volumes"** section
3. Restart app after volume creation

### High Memory Usage

1. Go to **"Resources"**
2. Increase memory allocation
3. Monitor in **"Monitoring"** → **"Metrics"**

## Custom Domain

To use your own domain:

1. Go to **"Settings"** → **"Domains"**
2. Click **"Add Domain"**
3. Enter your domain name
4. Update DNS records as instructed

## Differences from CLI

| Feature | CLI | Web Dashboard |
|---------|-----|--------------|
| Deployment | `fly deploy` | Click "Deploy" button |
| Logs | `fly logs` | Monitoring → Logs |
| SSH | `fly ssh console` | Exec button |
| Secrets | `flyctl secrets set` | Settings → Secrets |
| Volumes | `fly volumes create` | Volumes section |
| Scaling | `fly scale` | Resources section |

## Best Practices

1. **Always backup before major changes**
2. **Monitor logs after deployments**
3. **Set up alerts for resource usage**
4. **Use GitHub branches for testing**
5. **Keep your Dockerfile updated**

## Support

- Fly.io docs: https://fly.io/docs/
- Fly.io community: https://community.fly.io/
- OUTGROW issues: Check your GitHub repository

## Next Steps

After successful deployment:

1. Share the URL with friends
2. Set up regular backups
3. Configure custom domain (optional)
4. Set up monitoring alerts
5. Consider upgrading to PostgreSQL for production
