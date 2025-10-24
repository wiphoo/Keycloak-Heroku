# Deployment Guide

This guide provides detailed step-by-step instructions for deploying Keycloak on Heroku with an external PostgreSQL database.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Database Setup](#database-setup)
3. [Heroku Setup](#heroku-setup)
4. [Deployment](#deployment)
5. [Post-Deployment](#post-deployment)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure you have:

- A Heroku account ([Sign up here](https://signup.heroku.com/))
- Heroku CLI installed ([Installation Guide](https://devcenter.heroku.com/articles/heroku-cli))
- Git installed
- An external PostgreSQL database (we'll use Neon as an example)

### Install Heroku CLI

**macOS (Homebrew):**
```bash
brew tap heroku/brew && brew install heroku
```

**Ubuntu/Debian:**
```bash
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
```

**Windows:**
Download from [Heroku Dev Center](https://devcenter.heroku.com/articles/heroku-cli)

### Login to Heroku

```bash
heroku login
```

## Database Setup

### Option 1: Neon PostgreSQL (Recommended)

1. Go to [neon.tech](https://neon.tech/) and sign up
2. Create a new project
3. Navigate to your project dashboard
4. Copy the connection string (it looks like):
   ```
   postgres://user:password@ep-xxx-xxx.region.aws.neon.tech/neondb?sslmode=require
   ```
5. Save this connection string - you'll need it later

**Neon Benefits:**
- Serverless (auto-scales)
- Free tier available
- SSL enabled by default
- Easy to set up

### Option 2: ElephantSQL

1. Go to [elephantsql.com](https://www.elephantsql.com/) and sign up
2. Create a new instance
3. Copy the connection URL from the instance details
4. Save this connection string

### Option 3: Heroku Postgres

**Note:** While you can use Heroku Postgres, this guide focuses on external databases.

```bash
heroku addons:create heroku-postgresql:mini -a your-app-name
heroku config:get DATABASE_URL -a your-app-name
```

## Heroku Setup

### 1. Clone this Repository

```bash
git clone https://github.com/wiphoo/Keycloak-Heroku.git
cd Keycloak-Heroku
```

### 2. Create a Heroku Application

```bash
# Create app with a specific name
heroku create my-keycloak-app

# Or let Heroku generate a name
heroku create
```

Note the app name - you'll need it for the next steps.

### 3. Set Container Stack

Keycloak-Heroku uses Docker, so we need to use Heroku's container stack:

```bash
heroku stack:set container -a my-keycloak-app
```

### 4. Configure Environment Variables

Set all required environment variables:

```bash
# Set database URL (use your actual connection string)
heroku config:set DATABASE_URL="postgres://user:password@host:port/database" -a my-keycloak-app

# Set admin credentials (change these to secure values!)
heroku config:set KEYCLOAK_ADMIN="admin" -a my-keycloak-app
heroku config:set KEYCLOAK_ADMIN_PASSWORD="YourStrongPasswordHere123!" -a my-keycloak-app
```

**Optional: Set custom hostname** (if using a custom domain):
```bash
heroku config:set KEYCLOAK_HOSTNAME="auth.yourdomain.com" -a my-keycloak-app
```

### 5. Verify Configuration

```bash
heroku config -a my-keycloak-app
```

You should see:
- DATABASE_URL
- KEYCLOAK_ADMIN
- KEYCLOAK_ADMIN_PASSWORD
- (Optional) KEYCLOAK_HOSTNAME

## Deployment

### Deploy to Heroku

If you're on the main branch:
```bash
git push heroku main
```

If you're on a different branch:
```bash
git push heroku your-branch:main
```

### Monitor the Build

```bash
heroku logs --tail -a my-keycloak-app
```

The build process will:
1. Build the Docker image
2. Push it to Heroku's container registry
3. Start the application
4. Connect to your PostgreSQL database
5. Initialize Keycloak

This process typically takes 3-5 minutes.

## Post-Deployment

### 1. Verify Deployment

Check if the app is running:
```bash
heroku ps -a my-keycloak-app
```

You should see:
```
=== web (Basic): /opt/keycloak/start-keycloak.sh (1)
web.1: up 2025/10/24 15:30:00 +0000 (~ 1m ago)
```

### 2. Access Keycloak

Open your Keycloak instance:
```bash
heroku open -a my-keycloak-app
```

Or visit: `https://my-keycloak-app.herokuapp.com`

### 3. Login to Admin Console

1. Navigate to: `https://my-keycloak-app.herokuapp.com/admin`
2. Login with the credentials you set:
   - Username: Value of KEYCLOAK_ADMIN
   - Password: Value of KEYCLOAK_ADMIN_PASSWORD

### 4. Initial Configuration

After logging in:

1. **Create a Realm**
   - Click "Create Realm"
   - Enter a name (e.g., "myrealm")
   - Click "Create"

2. **Create a Client**
   - Navigate to Clients
   - Click "Create client"
   - Configure according to your application needs

3. **Create Users**
   - Navigate to Users
   - Click "Add user"
   - Set credentials in the Credentials tab

## Troubleshooting

### Check Logs

Always start by checking logs:
```bash
heroku logs --tail -a my-keycloak-app
```

### Common Issues

#### Issue: Application Crashed

**Symptoms:**
- App shows "Application Error"
- `heroku ps` shows state as "crashed"

**Solutions:**
1. Check logs for specific errors:
   ```bash
   heroku logs --tail -a my-keycloak-app
   ```

2. Verify DATABASE_URL is set correctly:
   ```bash
   heroku config:get DATABASE_URL -a my-keycloak-app
   ```

3. Restart the application:
   ```bash
   heroku restart -a my-keycloak-app
   ```

#### Issue: Cannot Connect to Database

**Symptoms:**
- Logs show "Could not connect to database"
- Startup fails with database errors

**Solutions:**
1. Verify DATABASE_URL format:
   - Should be: `postgres://user:password@host:port/database`
   - Include `?sslmode=require` if your database requires SSL

2. Test database connectivity:
   ```bash
   heroku run bash -a my-keycloak-app
   # In the container:
   echo $DATABASE_URL
   ```

3. Check if your database allows external connections:
   - For Neon: Check project settings
   - Verify IP whitelist (if applicable)

#### Issue: Admin Console Not Accessible

**Symptoms:**
- Cannot login to `/admin`
- Login page doesn't load

**Solutions:**
1. Verify admin credentials are set:
   ```bash
   heroku config -a my-keycloak-app | grep KEYCLOAK_ADMIN
   ```

2. Check if Keycloak started successfully:
   ```bash
   heroku logs --tail -a my-keycloak-app | grep "Started"
   ```

3. Clear browser cache and try again

#### Issue: Slow Performance

**Symptoms:**
- Pages load slowly
- Timeouts occur

**Solutions:**
1. Upgrade dyno type:
   ```bash
   heroku ps:resize web=standard-1x -a my-keycloak-app
   ```

2. Check database performance:
   - Upgrade database tier if needed
   - Review database query logs

3. Enable database connection pooling (already configured)

### Database-Specific Troubleshooting

#### Neon PostgreSQL

- **Connection Timeout:** Neon has a connection timeout. Ensure your app is actively using the connection.
- **SSL Required:** Always include `?sslmode=require` in the connection string
- **Compute Auto-Suspend:** Free tier auto-suspends. Upgrade to paid tier for always-on compute.

#### ElephantSQL

- **Connection Limit:** Free tier has a 5 connection limit
- **Upgrade:** Consider upgrading if you hit connection limits

### Performance Optimization

1. **Scale Dynos:**
   ```bash
   heroku ps:scale web=2 -a my-keycloak-app
   ```

2. **Upgrade Dyno Type:**
   ```bash
   heroku ps:resize web=standard-2x -a my-keycloak-app
   ```

3. **Monitor Performance:**
   ```bash
   heroku metrics -a my-keycloak-app
   ```

### Getting Help

If you're still having issues:

1. Check Keycloak documentation: [keycloak.org/docs](https://www.keycloak.org/docs/latest/)
2. Open an issue on GitHub: [Keycloak-Heroku Issues](https://github.com/wiphoo/Keycloak-Heroku/issues)
3. Heroku support: [help.heroku.com](https://help.heroku.com/)

## Maintenance

### Update Keycloak

To update to the latest Keycloak version:

1. Rebuild and redeploy:
   ```bash
   heroku builds:create -a my-keycloak-app
   ```

2. Or trigger a rebuild by making a commit:
   ```bash
   git commit --allow-empty -m "Rebuild to update Keycloak"
   git push heroku main
   ```

### Backup Database

Regularly backup your database. For Neon:
1. Go to your Neon project dashboard
2. Use the branching feature to create backups

### Monitor Application

Set up monitoring:
```bash
heroku logs --tail -a my-keycloak-app
```

Consider setting up log drains for long-term log storage.

## Next Steps

- Configure your application to use Keycloak for authentication
- Set up custom domains
- Configure SSL certificates
- Set up monitoring and alerting
- Implement backup strategies

## Resources

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Heroku Container Registry](https://devcenter.heroku.com/articles/container-registry-and-runtime)
- [Neon PostgreSQL Docs](https://neon.tech/docs)
- [Heroku CLI Commands](https://devcenter.heroku.com/articles/heroku-cli-commands)
