# Fly.io Quick Start Guide

Deploy OUTGROW to Fly.io in 5 minutes.

## 1. Install Fly CLI

```bash
# macOS
brew install flyctl

# Linux
curl -L https://fly.io/install.sh | sh

# Windows
iwr https://fly.io/install.ps1 -useb | iex
```

## 2. Login

```bash
flyctl auth login
```

## 3. Deploy

```bash
cd /path/to/Outgrow-main
fly launch
```

When prompted:
- **App name**: Choose unique name (e.g., `my-outgrow`)
- **Region**: Choose one near you (e.g., `sjc`)
- **PostgreSQL**: No
- **Redis**: No

## 4. Create Volume

```bash
fly volumes create outgrow_data --size 1 --region <your-region>
```

Example:
```bash
fly volumes create outgrow_data --size 1 --region sjc
```

## 5. Set Admin

```bash
flyctl secrets set OUTGROW_ADMINS=yourusername
```

## 6. Deploy

```bash
fly deploy
```

## 7. Get Invite Code

```bash
fly logs
```

Look for: `Invite code: XXXXXX`

## 8. Access

Your app will be at: `https://your-app-name.fly.dev`

## Done! 🎉

## Common Commands

```bash
# View logs
fly logs

# View status
fly status

# SSH into app
fly ssh console

# Update code
fly deploy

# Backup database
./fly-backup.sh your-app-name

# Restore database
./fly-restore.sh your-app-name backups/outgrow-backup-20250105.db
```

## Notes

- Free tier: 1 shared CPU, 256MB RAM, 3GB storage
- Production: 512MB RAM recommended (~$5-10/month)
- SQLite database persists on volume
- Zero-downtime deployments

For detailed instructions, see [FLY_DEPLOY.md](FLY_DEPLOY.md).
