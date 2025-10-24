# Build argument for Keycloak version (default: 26.0.0 - pinned for reproducibility)
ARG KEYCLOAK_VERSION=26.0.0

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}

# Set working directory
WORKDIR /opt/keycloak

# Pre-build Keycloak with PostgreSQL support
RUN /opt/keycloak/bin/kc.sh build --db=postgres && \
    # Create non-root user for security (DS002)
    # The Keycloak image is minimal, so we use shell built-ins
    groupadd -r keycloak 2>/dev/null || true && \
    useradd -r -g keycloak -u 1000 keycloak 2>/dev/null || true && \
    chown -R keycloak:keycloak /opt/keycloak

# Copy startup script with proper ownership
COPY --chown=keycloak:keycloak start-keycloak.sh ./start-keycloak.sh

# Switch to non-root user for security (DS002)
USER keycloak

# Expose port
EXPOSE 8080

# Health check to verify Keycloak is running (DS026)
HEALTHCHECK --interval=30s --timeout=5s --retries=3 --start-period=40s \
  CMD curl -f http://localhost:8080/health || exit 1

# Use bash to execute the script directly as entrypoint
ENTRYPOINT ["bash", "/opt/keycloak/start-keycloak.sh"]
