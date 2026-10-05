# Deploying OUTGROW on Fly.io

This guide will help you deploy OUTGROW on Fly.io with persistent SQLite storage.

## Prerequisites

1. **Install Fly CLI**
   ```bash
   # macOS
   brew install flyctl

   # Linux
   curl -L https://fly.io/install.sh | sh

   # Windows
   iwr https://fly.io/install.ps1 -useb | iex
   ```

2. **Sign up/Login**
   ```bash
   flyctl auth signup
   flyctl auth login
   ```

## Deployment Steps

### Step 1: Initialize Fly App

```bash
cd /path/to/Outgrow-main
fly launch
```

When prompted:
- **App name**: Choose a unique name (e.g., `yourname-outgrow`)
- **Region**: Choose one close to you (e.g., `sjc` for San Jose, `iad` for Virginia)
- **PostgreSQL**: Choose **No** (we're using SQLite)
- **Redis**: Choose **No**

This will create a `fly.toml` file. Replace it with the provided `fly.toml` from this repo.

### Step 2: Create Persistent Volume

Fly.io volumes provide persistent storage for the SQLite database:

```bash
fly volumes create outgrow_data --size 1 --region <your-region>
```

Example:
```bash
fly volumes create outgrow_data --size 1 --region sjc
```

### Step 3: Set Environment Variables

Set admin users and other configuration:

```bash
flyctl secrets set OUTGROW_ADMINS=yourusername
```

Optional secrets:
```bash
flyctl secrets set OUTGROW_DISCORD_WEBHOOK=https://discord.com/api/webhooks/...
```

### Step 4: Deploy

```bash
fly deploy
```

This will:
- Build the Docker image
- Create the volume
- Deploy the app
- Assign a URL like `https://yourname-outgrow.fly.dev`

### Step 5: Get Invite Code

After first deployment, the app creates a default crew with an invite code:

```bash
fly ssh console
cat /data/INVITE_CODE.txt
exit
```

Or check the logs:
```bash
fly logs
```

Look for the line: `Invite code: XXXXXX`

## Configuration

### Region Selection

Choose a region close to your users:

- **sjc** - San Jose (US West)
- **iad** - Virginia (US East)
- **ams** - Amsterdam (Europe)
- **hkg** - Hong Kong (Asia)
- **syd** - Sydney (Australia)

View all regions:
```bash
flyctl regions list
```

### Scaling

The current configuration uses 1 shared CPU and 512MB RAM (within free tier limits).

To scale up:
```bash
fly scale memory 1024
fly scale count 2
```

### Health Checks

The app includes a `/api/ping` endpoint for health checks. Fly.io will automatically monitor this.

## Database Management

### Backup Database

```bash
# Copy database to local machine
fly ssh "cat /data/outgrow.db" > backup-$(date +%Y%m%d).db
```

### Restore Database

```bash
# Upload backup to Fly.io
fly ssh sftp put backup-20250105.db /data/outgrow.db
fly ssh "chmod 644 /data/outgrow.db"
```

### Volume Snapshots

Fly.io supports volume snapshots:

```bash
fly volumes snapshot outgrow_data
```

List snapshots:
```bash
fly volumes snapshots outgrow_data
```

## Monitoring

### View Logs

```bash
fly logs
```

### Real-time logs

```bash
fly logs --tail
```

### App Status

```bash
fly status
```

### SSH into App

```bash
fly ssh console
```

## Updates

### Deploy Changes

After making code changes:

```bash
fly deploy
```

This performs a zero-downtime deployment.

### Rollback

If something goes wrong:

```bash
fly deploy --remote-only
# View deploy history
fly releases
# Rollback to specific version
fly releases rollback v123
```

## Cost Estimation

### Free Tier (Sufficient for Testing)
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

## Troubleshooting

### App Not Starting

Check logs:
```bash
fly logs
```

Common issues:
- Volume not created: Run `fly volumes create outgrow_data`
- Port conflict: Ensure PORT=8765 in fly.toml
- Permissions: Check volume mount in fly.toml

### Database Locked

SQLite can have locking issues with concurrent writes. OUTGROW uses WAL mode, but if you see locks:

```bash
fly ssh console
sqlite3 /data/outgrow.db "PRAGMA wal_checkpoint;"
```

### High Memory Usage

Monitor usage:
```bash
fly status
```

Scale up if needed:
```bash
fly scale memory 1024
```

## Custom Domain

To use your own domain:

```bash
flyctl certs add yourdomain.com
```

Then update DNS to point to the Fly.io app.

## Alternative: PostgreSQL

For production, consider upgrading to PostgreSQL:

```bash
fly postgres create
fly postgres attach outgrow-db
```

Then modify `server.py` to use PostgreSQL instead of SQLite. This requires more code changes.

## Admin Dashboard

Access the admin dashboard by:
1. Setting `OUTGROW_ADMINS` secret
2. Logging in with that username
3. Go to "Me" tab → "Server dashboard"

From there you can:
- View live stats
- Download database backup
- Reset user PINs

## Support

- Fly.io docs: https://fly.io/docs/
- OUTGROW issues: Check your GitHub repository
