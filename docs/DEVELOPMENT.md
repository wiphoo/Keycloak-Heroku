# Development Setup Guide

This guide helps developers set up their environment for contributing to the Keycloak-Heroku project.

## Prerequisites

- Python 3.11 or higher
- Git 2.9+
- Docker (for local testing)
- Heroku CLI (for deployment)

## Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/wiphoo/Keycloak-Heroku.git
cd Keycloak-Heroku
```

### 2. Install Pre-Commit Hooks

Pre-commit hooks automatically validate code before each commit, catching issues early.

```bash
# Install pre-commit framework
pip install pre-commit

# Install the git hooks
pre-commit install

# (Optional) Run all hooks on all files
pre-commit run --all-files
```

### 3. What Pre-Commit Hooks Do

The following hooks are automatically run on each commit:

#### File Integrity Checks

- **Large Files**: Prevents accidental commits of files > 1MB
- **JSON/YAML Validation**: Ensures JSON and YAML files are valid
- **Merge Conflicts**: Detects unresolved merge conflicts
- **Private Keys**: Prevents committing private keys and credentials
- **Trailing Whitespace**: Removes unnecessary trailing whitespace
- **End of File Fixer**: Ensures files end with newline

#### Code Quality

- **Python Syntax**: Validates Python syntax with AST
- **YAML Linting**: Lints all YAML files with strict validation
- **Shell Script Linting**: Uses ShellCheck for bash validation
- **Dockerfile Linting**: Validates Dockerfile with hadolint

#### Security

- **Secret Detection**: TruffleHog scans for exposed credentials
- **Private Keys**: Detects accidentally committed keys

#### Formatting

- **Python Black**: Auto-formats Python code
- **Python isort**: Auto-formats Python imports
- **Markdown**: Formats Markdown files

### 4. Docker Compose Setup for Local Testing

```bash
# Start Keycloak locally with PostgreSQL
docker-compose up

# Access Keycloak at http://localhost:8080
# Default credentials: admin/admin
```

### 5. Making Changes

When making changes:

1. Create a feature branch:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes

3. Pre-commit hooks will run automatically:

   ```bash
   git add .
   git commit -m "feat: your feature description"
   ```

4. If hooks fail:
   - Some issues are auto-fixed (formatting, trailing whitespace)
   - For others, fix manually and commit again
   - Review suggestions carefully

5. Push your branch:
   ```bash
   git push origin feature/your-feature-name
   ```

### 6. CI/CD Workflows

Three GitHub Actions workflows ensure code quality:

#### 1. **Security & Linting** (`.github/workflows/security.yml`)

- Runs on push and pull requests
- Daily scheduled scans at 2 AM UTC
- Jobs:
  - YAML Linting (yamllint)
  - JSON Linting (json.tool)
  - Shell Linting (ShellCheck)
  - Dockerfile Linting (hadolint)
  - Secret Scanning (TruffleHog)
  - Container Security (Trivy)
  - Configuration Validation
  - Docker Build Test

#### 2. **Pre-Commit Checks** (`.github/workflows/trufflehog-scan.yml`)

- Runs pre-commit hooks in CI
- Runs on all pushes and PRs
- Comments on PRs if issues found

#### 3. **CI/CD - Build & Test** (`.github/workflows/docker-build.yml`)

- Docker build verification
- Script syntax validation
- Configuration file validation

### 7. Configuration Files

#### `.pre-commit-config.yaml`

Central configuration for all pre-commit hooks. Hooks are organized by:

- General file checks
- YAML linting
- Shell script linting
- Dockerfile linting
- Python code quality
- Security checks
- Markdown formatting

### 8. Troubleshooting

**Pre-commit installation fails:**

```bash
python3 -m pip install --upgrade pip
pip install pre-commit
pre-commit install
```

**Hooks are slow on first run:**
This is normal - they install dependencies the first time. Subsequent runs are faster.

**Want to skip pre-commit for a commit:**

```bash
git commit --no-verify
```

⚠️ Note: CI will still run and may fail if code doesn't pass checks.

**Update pre-commit hooks to latest versions:**

```bash
pre-commit autoupdate
git add .pre-commit-config.yaml
git commit -m "chore: update pre-commit hooks"
```

### 9. Linting Individual File Types

You can run specific linters manually:

```bash
# YAML files
yamllint -d relaxed .github/workflows/ docker-compose.yml heroku.yml

# JSON files
python3 -m json.tool app.json

# Shell scripts
shellcheck start-keycloak.sh

# Dockerfile
hadolint Dockerfile

# Python files (if present)
black --check .
isort --check-only .
flake8 .
```

### 10. Commit Message Guidelines

Follow conventional commits format:

```
type(scope): short description

Long description explaining the changes, if needed.

Fixes #123
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Test changes
- `chore`: Build/tooling changes

**Examples:**

```
feat(security): add TruffleHog scanning workflow
fix(docker): resolve permission issues with startup script
docs: update deployment guide
chore(deps): update pre-commit hooks
```

### 11. Pull Request Checklist

Before submitting a PR:

- [ ] Code passes all pre-commit hooks (`pre-commit run --all-files`)
- [ ] Docker image builds successfully (`docker build -t keycloak-heroku:test .`)
- [ ] Shell scripts have valid syntax (`bash -n start-keycloak.sh`)
- [ ] JSON files are valid
- [ ] YAML files are valid
- [ ] No credentials or secrets in commits
- [ ] Commit messages follow conventional commits
- [ ] Documentation is updated if needed
- [ ] No merge conflicts

### 12. Useful Commands

```bash
# Run all hooks on all files
pre-commit run --all-files

# Run specific hook
pre-commit run yamllint --all-files

# Clean up pre-commit cache
pre-commit clean

# Uninstall pre-commit hooks
pre-commit uninstall

# Run Docker Compose
docker-compose up -d      # Start in background
docker-compose logs -f    # Follow logs
docker-compose down       # Stop containers

# Test locally before pushing
docker build -t keycloak-heroku:test .
bash -n start-keycloak.sh
python3 -m json.tool app.json
```

## Getting Help

- Check [SECURITY.md](SECURITY.md) for security guidelines
- Review [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
- Check [README.md](README.md) for project overview
- Open an issue with `[dev-setup]` tag for setup problems

## Additional Resources

- [Pre-commit Documentation](https://pre-commit.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Keycloak Documentation](https://www.keycloak.org/documentation.html)
