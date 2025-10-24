# Keycloak-Heroku

[![Docker Build Test](https://github.com/wiphoo/Keycloak-Heroku/actions/workflows/docker-build.yml/badge.svg)](https://github.com/wiphoo/Keycloak-Heroku/actions/workflows/docker-build.yml)
[![Security Checks](https://github.com/wiphoo/Keycloak-Heroku/actions/workflows/security.yml/badge.svg)](https://github.com/wiphoo/Keycloak-Heroku/actions/workflows/security.yml)
[![TruffleHog Scan](https://github.com/wiphoo/Keycloak-Heroku/actions/workflows/trufflehog-scan.yml/badge.svg)](https://github.com/wiphoo/Keycloak-Heroku/actions/workflows/trufflehog-scan.yml)

Deploy Keycloak on Heroku with an external PostgreSQL database (e.g., Neon PostgreSQL).

## Overview

This repository provides a Docker-based deployment configuration for running Keycloak on Heroku with an external PostgreSQL database. It's designed to work seamlessly with Heroku's container registry and supports external database providers like Neon PostgreSQL.

**Security**: This project includes automated security scanning with TruffleHog and Trivy to detect secrets and vulnerabilities. See [SECURITY.md](SECURITY.md) for details.

## Prerequisites

- A Heroku account
- Heroku CLI installed ([Installation Guide](https://devcenter.heroku.com/articles/heroku-cli))
- Docker installed (for local testing)
- An external PostgreSQL database (e.g., Neon, ElephantSQL, AWS RDS, etc.)

## Quick Start

### One-Click Deploy to Heroku

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/wiphoo/Keycloak-Heroku)

**Note:** You'll need to provide your own external PostgreSQL database URL during setup.

### Manual Deployment

### 1. Clone the Repository

```bash
git clone https://github.com/wiphoo/Keycloak-Heroku.git
cd Keycloak-Heroku
```

### 2. Create a Heroku App

```bash
heroku create your-keycloak-app-name
```

### 3. Set Stack to Container

```bash
heroku stack:set container -a your-keycloak-app-name
```

### 4. Configure Environment Variables

Set up the required environment variables:

```bash
# Database URL (provided by your external PostgreSQL provider)
# Supports both postgres:// and postgresql:// schemes
heroku config:set DATABASE_URL="postgres://username:password@host:port/database" -a your-keycloak-app-name

# Keycloak admin credentials (change these!)
heroku config:set KEYCLOAK_ADMIN="admin" -a your-keycloak-app-name
heroku config:set KEYCLOAK_ADMIN_PASSWORD="change_me_to_strong_password" -a your-keycloak-app-name

# REQUIRED: Set your app's hostname (your-app-name.herokuapp.com or custom domain)
heroku config:set KEYCLOAK_HOSTNAME="your-keycloak-app-name.herokuapp.com" -a your-keycloak-app-name
```

**⚠️ Important:** The `KEYCLOAK_HOSTNAME` variable is required and must be set to your Heroku app's domain or custom domain before starting the application.

### 5. Deploy to Heroku

```bash
git push heroku main
```

Or if deploying from a different branch:

```bash
git push heroku your-branch:main
```

### 6. Access Keycloak

After deployment, access your Keycloak instance at:
```
https://your-keycloak-app-name.herokuapp.com
```

Login to the admin console at:
```
https://your-keycloak-app-name.herokuapp.com/admin
```

## Using Neon PostgreSQL

[Neon](https://neon.tech/) is a serverless PostgreSQL database that works great with Keycloak on Heroku.

### Setting up Neon

1. Create a Neon account at [neon.tech](https://neon.tech/)
2. Create a new project
3. Copy the connection string from your Neon dashboard
4. Set it as the DATABASE_URL in Heroku:

```bash
heroku config:set DATABASE_URL="postgres://user:password@ep-xxx.region.aws.neon.tech/neondb?sslmode=require" -a your-keycloak-app-name
```

**Note:** Neon connection strings include SSL parameters by default, which is recommended for security.

## Heroku Dyno Requirements

Keycloak requires adequate memory to run properly. The recommended dyno types are:

- **Minimum:** Standard-1X (512 MB RAM) - May be tight on resources during startup
- **Recommended:** Standard-2X (1 GB RAM) - Smooth performance for production use
- **Free Dyno:** Not recommended - Keycloak requires more than 512 MB and may fail to start

To upgrade your dyno type:

```bash
heroku dyno:type standard-2x -a your-keycloak-app-name
```

**Note:** Free dynos will cause Keycloak to crash due to memory limits.

## Configuration

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `DATABASE_URL` | PostgreSQL connection string | Yes | - |
| `KEYCLOAK_ADMIN` | Admin username | Yes | `admin` |
| `KEYCLOAK_ADMIN_PASSWORD` | Admin password (strong password recommended) | Yes | - |
| `KEYCLOAK_HOSTNAME` | Hostname for Keycloak (your-app.herokuapp.com or custom domain) | Yes | - |
| `PORT` | HTTP port (set by Heroku) | No | `8080` |

### Database Configuration

The startup script automatically parses the `DATABASE_URL` and configures Keycloak to use PostgreSQL. The URL format should be:

```
postgres://username:password@host:port/database
```

Additional parameters (like `?sslmode=require`) are supported and will be passed through to the JDBC connection.

## Local Development

### Option 1: Using Docker Compose (Recommended)

The easiest way to test locally is using Docker Compose, which sets up both Keycloak and a PostgreSQL database:

```bash
docker-compose up
```

This will:
- Start a PostgreSQL database container
- Build and start the Keycloak container
- Connect them together
- Make Keycloak available at `http://localhost:8080`

Default admin credentials:
- Username: `admin`
- Password: `admin`

To stop:
```bash
docker-compose down
```

To clean up volumes:
```bash
docker-compose down -v
```

### Option 2: Using Docker Directly

If you have your own PostgreSQL database:

1. Create a `.env` file with your configuration:

```bash
DATABASE_URL=postgres://username:password@localhost:5432/keycloak
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=admin
PORT=8080
```

2. Build the Docker image:

```bash
docker build -t keycloak-heroku .
```

3. Run the container:

```bash
docker run --env-file .env -p 8080:8080 keycloak-heroku
```

4. Access Keycloak at `http://localhost:8080`

## Troubleshooting

### Check Logs

```bash
heroku logs --tail -a your-keycloak-app-name
```

### Common Issues

1. **Database Connection Errors**
   - Verify DATABASE_URL is correctly set
   - Ensure your database allows connections from external IPs
   - Check if SSL/TLS is required by your database provider

2. **Container Build Failures**
   - Check Heroku build logs: `heroku logs --tail -a your-keycloak-app-name`
   - Ensure Docker image builds successfully locally

3. **Application Crashes**
   - Verify admin credentials are set
   - Check database connectivity
   - Review startup logs for specific errors

### Restart the Application

```bash
heroku restart -a your-keycloak-app-name
```

## Architecture

- **Base Image**: Official Keycloak image from Quay.io
- **Database**: External PostgreSQL (configured via DATABASE_URL)
- **Web Server**: Keycloak built-in server
- **Deployment**: Heroku container registry

## Security Considerations

1. **Use Strong Passwords**: Always use strong, unique passwords for KEYCLOAK_ADMIN_PASSWORD
2. **Enable SSL**: Use Heroku's automatic SSL or configure custom SSL certificates
3. **Database Security**: Ensure your external database requires SSL connections
4. **Regular Updates**: Keep Keycloak updated by rebuilding with the latest base image
5. **Environment Variables**: Never commit sensitive credentials to version control

## Scaling

Heroku makes it easy to scale your Keycloak instance:

```bash
# Scale to 2 dynos
heroku ps:scale web=2 -a your-keycloak-app-name

# Upgrade to a larger dyno type
heroku ps:resize web=standard-2x -a your-keycloak-app-name
```

## Cost Considerations

- **Heroku Dyno**: Starting from $7/month for Basic dyno
- **External Database**: Varies by provider
  - Neon: Free tier available, paid plans start at $19/month
  - ElephantSQL: Free tier available
  - AWS RDS: Pay as you go

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See [LICENSE](LICENSE) file for details.

## Support

For issues and questions:
- Open an issue in this repository
- Check Keycloak documentation: [keycloak.org/docs](https://www.keycloak.org/docs/latest/)
- Heroku support: [help.heroku.com](https://help.heroku.com/)

## Resources

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Heroku Container Registry](https://devcenter.heroku.com/articles/container-registry-and-runtime)
- [Neon PostgreSQL](https://neon.tech/)
- [Heroku Postgres](https://www.heroku.com/postgres)