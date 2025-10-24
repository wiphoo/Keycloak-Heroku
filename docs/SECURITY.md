# Security Guidelines

## Overview

This project implements automated security scanning and checks to ensure code quality and detect potential vulnerabilities.

## Automated Security Scans

### TruffleHog Secret Scanning
- **Purpose**: Detects exposed secrets, API keys, passwords, and other sensitive data in the repository
- **Trigger**: 
  - On every push to `main` and `copilot/deploy-keycloak-heroku` branches
  - On every pull request to `main`
  - Daily scheduled scan at 2 AM UTC
- **Workflow**: `.github/workflows/trufflehog-scan.yml`

### Comprehensive Security Checks
The `security.yml` workflow includes:

1. **Secret Scanning** - TruffleHog detection with PR notifications
2. **Dockerfile Security** - Trivy vulnerability scanning for configuration security
3. **Configuration Validation** - JSON and shell script syntax validation
4. **Base Image Scanning** - Scans the official Keycloak Docker image for known vulnerabilities

## Reporting Security Issues

If you discover a security vulnerability:

1. **DO NOT** open a public GitHub issue
2. **DO** email the maintainers with details
3. **Include**: Affected version, vulnerability description, proof of concept (if applicable)
4. **Wait** for a response before public disclosure (give 90 days)

## Security Best Practices

When deploying this application:

### Environment Variables
- Never commit `.env` files or secrets to the repository
- Use Heroku's secure config variable management
- Rotate credentials regularly
- Never share admin passwords via insecure channels

### Database Security
- Always use SSL/TLS for database connections
- Use strong, randomly generated passwords
- Enable database backups
- Monitor database access logs

### Heroku Configuration
- Keep the Keycloak Docker image updated
- Use Standard-2X or larger dynos in production
- Enable Heroku's DDoS protection
- Set up security group rules if applicable
- Enable two-factor authentication on Heroku account

### Application Security
- Change default admin credentials immediately
- Disable unnecessary Keycloak services
- Enable HTTPS (handled by Heroku proxy)
- Configure firewall rules appropriately
- Monitor application logs for suspicious activity

## Supported Vulnerability Scanners

- **TruffleHog**: Git history and filesystem secret scanning
- **Trivy**: Vulnerability scanning for Docker images and configurations

## Security Updates

- Monitor security advisories for Keycloak
- Watch for updates to base Docker image
- Subscribe to Heroku security bulletins
- Keep local development environment updated

## GitHub Security Features

This repository leverages GitHub's built-in security features:

- **Code Scanning**: Automated scanning on pull requests
- **Secret Scanning**: Detection of GitHub tokens and credentials
- **Dependabot**: Automatic dependency update checks (via Trivy)

Results are visible in the **Security** tab of the GitHub repository.
