# Build argument for Keycloak version (default: latest)
ARG KEYCLOAK_VERSION=latest

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}

# Set working directory
WORKDIR /opt/keycloak

# Pre-build Keycloak with PostgreSQL support to optimize runtime startup
RUN /opt/keycloak/bin/kc.sh build --db=postgres

# Copy startup script
COPY start-keycloak.sh ./start-keycloak.sh

# Expose port
EXPOSE 8080

# Use bash to execute the script directly as entrypoint
ENTRYPOINT ["bash", "/opt/keycloak/start-keycloak.sh"]
