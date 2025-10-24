FROM quay.io/keycloak/keycloak:latest

# Set working directory
WORKDIR /opt/keycloak

# Copy startup script with executable permissions
COPY --chmod=755 start-keycloak.sh /opt/keycloak/start-keycloak.sh

# Expose port
EXPOSE 8080

# Use the startup script as entrypoint
ENTRYPOINT ["/opt/keycloak/start-keycloak.sh"]
