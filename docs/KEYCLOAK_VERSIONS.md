# Keycloak Version Management

## Overview

This project supports deploying different versions of Keycloak. By default, it deploys the `latest` version, but you can specify a specific version if needed.

## Specifying Keycloak Version

### Option 1: During Heroku Deployment

When using the Heroku button or manual deployment, set the `KEYCLOAK_VERSION` environment variable:

```bash
# Default (latest stable)
heroku config:set KEYCLOAK_VERSION=latest

# Specific version
heroku config:set KEYCLOAK_VERSION=26.4.2
heroku config:set KEYCLOAK_VERSION=25.0.0
heroku config:set KEYCLOAK_VERSION=24.0.0
```

### Option 2: Local Docker Build

Build locally with a specific Keycloak version:

```bash
# Default (latest)
docker build -t keycloak-heroku .

# Specific version
docker build --build-arg KEYCLOAK_VERSION=26.4.2 -t keycloak-heroku:26.4.2 .
```

### Option 3: Via app.json (One-Click Deploy)

The `KEYCLOAK_VERSION` environment variable is available in the one-click Heroku deployment button and defaults to `latest`.

## Available Versions

Keycloak versions are available from [quay.io/keycloak/keycloak](https://quay.io/repository/keycloak/keycloak?tab=tags).

### Current LTS Versions

- **26.x** - Current stable (recommended)
- **25.x** - Previous stable
- **24.x** - Older stable
- **23.x** - Legacy
- **latest** - Always the most recent release

### Version Compatibility

- **Keycloak 26.x**: Java 11+, PostgreSQL 10+
- **Keycloak 25.x**: Java 11+, PostgreSQL 10+
- **Keycloak 24.x**: Java 11+, PostgreSQL 10+

## Building with Specific Version

### In CI/CD

The GitHub Actions workflow can be configured to test multiple versions:

```yaml
strategy:
  matrix:
    keycloak-version: [latest, 26.4.2, 25.0.0]
```

### Environment Variables

Once deployed to Heroku with a specific `KEYCLOAK_VERSION`:

```bash
# View current version
heroku config:get KEYCLOAK_VERSION

# Change version (redeploy required)
heroku config:set KEYCLOAK_VERSION=25.0.0
git push heroku main
```

## Version Upgrade Process

To upgrade Keycloak version:

1. Update `KEYCLOAK_VERSION` environment variable:
   ```bash
   heroku config:set KEYCLOAK_VERSION=new.version.number
   ```

2. Trigger a new deployment:
   ```bash
   git push heroku main
   ```

3. Monitor logs for startup:
   ```bash
   heroku logs -a your-app-name --tail
   ```

4. If issues occur, rollback:
   ```bash
   heroku config:set KEYCLOAK_VERSION=old.version.number
   git push heroku main
   ```

## Dockerfile ARG

The `Dockerfile` includes a build argument for version specification:

```dockerfile
ARG KEYCLOAK_VERSION=latest
FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
```

This allows flexible version management at build time.

## Breaking Changes

Always review Keycloak release notes for breaking changes:

- Migration scripts may be required
- Configuration format may change
- Admin API changes
- Theme changes

See [Keycloak Release Notes](https://www.keycloak.org/downloads) for details.

## Testing New Versions

Before deploying to production:

```bash
# Build locally with new version
docker build --build-arg KEYCLOAK_VERSION=26.4.2 -t keycloak-test .

# Run locally
docker-compose up

# Test admin console
curl http://localhost:8080/admin/
```

## Recommendations

- **Production**: Use specific versions (e.g., 26.4.2) for stability
- **Staging**: Test with latest to identify compatibility issues
- **Development**: Use latest for new features

## Troubleshooting

### Build fails with specific version

```bash
# Verify version exists (Method 1 - Docker CLI)
docker pull quay.io/keycloak/keycloak:26.4.2

# Verify version exists (Method 2 - Browser)
# Visit: https://quay.io/repository/keycloak/keycloak?tab=tags

# Verify version exists (Method 3 - Skopeo)
skopeo list-tags docker://quay.io/keycloak/keycloak | grep 26.4.2

# Check Dockerfile syntax
docker build --no-cache --build-arg KEYCLOAK_VERSION=26.4.2 -t test .
```

### Checking Available Versions

To see all available Keycloak versions:

1. **Via Web Browser** (Easiest):
   - Navigate to: https://quay.io/repository/keycloak/keycloak?tab=tags
   - Browse through available versions

2. **Via Docker CLI**:
   ```bash
   # Attempt to pull a version to check if it exists
   docker pull quay.io/keycloak/keycloak:26.4.2
   # If successful, the version exists
   ```

3. **Via Skopeo** (if installed):
   ```bash
   skopeo list-tags docker://quay.io/keycloak/keycloak | jq '.Tags[]' | head -20
   ```

4. **Recent Stable Versions** (known):
   ```
   26.4.2 (current stable)
   26.4.1
   26.4.0
   25.0.6
   25.0.5
   24.0.7
   24.0.6
   latest (always current)
   ```

## Version Mismatch After Deployment

```bash
# Check current container version
heroku run "java -version"

# Redeploy with correct version
heroku config:set KEYCLOAK_VERSION=26.4.2
git push heroku main --force
```

## See Also

- [Keycloak Releases](https://www.keycloak.org/downloads)
- [Keycloak Docker Images](https://quay.io/repository/keycloak/keycloak)
- [DEPLOYMENT.md](./DEPLOYMENT.md) - Deployment instructions
