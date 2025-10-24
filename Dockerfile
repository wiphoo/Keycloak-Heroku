FROM quay.io/keycloak/keycloak:latest

# Set working directory
WORKDIR /opt/keycloak

# Copy startup script
COPY start-keycloak.sh ./start-keycloak.sh

# Expose port
EXPOSE 8080

# Use bash to execute the script directly as entrypoint
ENTRYPOINT ["bash", "/opt/keycloak/start-keycloak.sh"]
