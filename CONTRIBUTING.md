# Contributing to Keycloak-Heroku

Thank you for your interest in contributing to Keycloak-Heroku! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Issues

If you encounter a bug or have a feature request:

1. Check if the issue already exists in the [Issues](https://github.com/wiphoo/Keycloak-Heroku/issues) section
2. If not, create a new issue with:
   - A clear, descriptive title
   - Detailed description of the problem or feature
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment details (Heroku dyno type, database provider, etc.)

### Submitting Changes

1. **Fork the Repository**

   ```bash
   # Fork via GitHub UI, then clone your fork
   git clone https://github.com/YOUR-USERNAME/Keycloak-Heroku.git
   cd Keycloak-Heroku
   ```

2. **Create a Branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Follow the existing code style
   - Update documentation if needed
   - Test your changes thoroughly

4. **Test Locally**

   ```bash
   # Build the Docker image
   docker build -t keycloak-heroku-test .

   # Run with your test database
   docker run --env-file .env -p 8080:8080 keycloak-heroku-test
   ```

5. **Commit Your Changes**

   ```bash
   git add .
   git commit -m "Add a clear, descriptive commit message"
   ```

6. **Push to Your Fork**

   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Go to the original repository on GitHub
   - Click "New Pull Request"
   - Select your fork and branch
   - Provide a clear description of your changes

## Development Guidelines

### Code Style

- Use clear, descriptive variable names
- Add comments for complex logic
- Follow shell script best practices for bash scripts
- Keep Dockerfile instructions clean and minimal

### Testing Checklist

Before submitting a PR, ensure:

- [ ] Docker image builds successfully
- [ ] Container starts without errors
- [ ] Database connection works with external PostgreSQL
- [ ] Keycloak admin console is accessible
- [ ] Environment variables are properly parsed
- [ ] Documentation is updated if needed

### Documentation

- Update README.md for user-facing changes
- Add inline comments for complex code
- Include examples for new features

## Questions?

Feel free to open an issue for any questions about contributing!
