FROM quay.io/keycloak/keycloak:latest

# Set working directory
WORKDIR /opt/keycloak

# Copy startup script
COPY start-keycloak.sh /opt/keycloak/start-keycloak.sh

# Make startup script executable (use sh -c to avoid permission issues)
RUN sh -c 'chmod +x /opt/keycloak/start-keycloak.sh'

# Expose port
EXPOSE 8080

# Use the startup script as entrypoint
ENTRYPOINT ["/opt/keycloak/start-keycloak.sh"]
