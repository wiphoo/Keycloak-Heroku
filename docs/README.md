# Documentation Index

Welcome to the Keycloak-Heroku documentation. This directory contains comprehensive guides for deploying, developing, and managing Keycloak on Heroku.

## 📚 Documentation Files

### [DEPLOYMENT.md](./DEPLOYMENT.md)

Complete guide for deploying Keycloak to Heroku, including:

- Prerequisites and setup steps
- Environment variables configuration
- Database setup with Neon PostgreSQL
- Deployment procedures
- Troubleshooting common issues

### [DEVELOPMENT.md](./DEVELOPMENT.md)

Developer setup and workflow guide, including:

- Local development environment setup
- Pre-commit hooks explanation and installation
- Making changes and running tests
- CI/CD workflow overview
- Git commit message guidelines
- Troubleshooting and useful commands

### [KEYCLOAK_VERSIONS.md](./KEYCLOAK_VERSIONS.md)

Keycloak version management guide, including:

- Specifying different Keycloak versions
- Available versions and compatibility
- Building with specific versions
- Version upgrade and rollback procedures
- Breaking changes and migration notes
- Troubleshooting version issues

### [SECURITY.md](./SECURITY.md)

Security policy and best practices, including:

- Automated security scanning tools
- Security testing procedures
- Incident reporting guidelines
- Deployment security recommendations
- Vulnerability management

## 🚀 Quick Links

- **Getting Started**: See [DEPLOYMENT.md](./DEPLOYMENT.md) for deployment instructions
- **Local Development**: See [DEVELOPMENT.md](./DEVELOPMENT.md) to set up your development environment
- **Version Management**: See [KEYCLOAK_VERSIONS.md](./KEYCLOAK_VERSIONS.md) for version selection and upgrades
- **Security**: See [SECURITY.md](./SECURITY.md) for security policies and scanning

## 📖 Document Organization

```
docs/
├── README.md                    # This file - documentation index
├── DEPLOYMENT.md               # Deployment guide
├── DEVELOPMENT.md              # Development guide
├── KEYCLOAK_VERSIONS.md        # Version management guide
└── SECURITY.md                 # Security policy
```

## 🔗 Main Documentation

For project overview, feature list, and architecture, see:

- [README.md](../README.md) - Main project documentation
- [app.json](../app.json) - Heroku deployment configuration
- [Dockerfile](../Dockerfile) - Container image definition

## ⚙️ Configuration Files

- `.github/workflows/` - GitHub Actions CI/CD pipelines
- `.pre-commit-config.yaml` - Pre-commit hooks configuration
- `docker-compose.yml` - Local development environment

## 🤝 Contributing

When making changes to documentation:

1. Update relevant files in this `docs/` directory
2. Ensure changes follow Markdown formatting standards
3. Update this index if adding new documentation
4. Submit changes via pull request for review

## 📞 Support

For issues or questions:

1. Check the relevant documentation file
2. Review the troubleshooting sections
3. Open an issue on GitHub for bugs or feature requests

---

Last Updated: October 25, 2025
