#!/bin/bash

# Extract database connection details from DATABASE_URL
# Heroku provides DATABASE_URL in format: postgres://user:password@host:port/database
if [ -z "$DATABASE_URL" ]; then
    echo "ERROR: DATABASE_URL environment variable is not set"
    exit 1
fi

# Parse DATABASE_URL
DB_URL_REGEX="postgres://([^:]+):([^@]+)@([^:]+):([^/]+)/(.+)"
if [[ $DATABASE_URL =~ $DB_URL_REGEX ]]; then
    DB_USER="${BASH_REMATCH[1]}"
    DB_PASSWORD="${BASH_REMATCH[2]}"
    DB_HOST="${BASH_REMATCH[3]}"
    DB_PORT="${BASH_REMATCH[4]}"
    DB_NAME="${BASH_REMATCH[5]}"
else
    echo "ERROR: Could not parse DATABASE_URL"
    exit 1
fi

# Set Keycloak environment variables
export KC_DB=postgres
export KC_DB_URL="jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}"
export KC_DB_USERNAME="${DB_USER}"
export KC_DB_PASSWORD="${DB_PASSWORD}"

# Set hostname (required for Heroku)
export KC_HOSTNAME="${KEYCLOAK_HOSTNAME:-$(echo $HEROKU_APP_NAME.herokuapp.com)}"
export KC_HOSTNAME_STRICT=false
export KC_HOSTNAME_STRICT_HTTPS=false

# Set proxy headers (required for Heroku)
export KC_PROXY=edge

# Set HTTP settings
export KC_HTTP_ENABLED=true
export KC_HTTP_PORT="${PORT:-8080}"

# Set admin credentials (if provided)
if [ -n "$KEYCLOAK_ADMIN" ] && [ -n "$KEYCLOAK_ADMIN_PASSWORD" ]; then
    export KC_BOOTSTRAP_ADMIN_USERNAME="${KEYCLOAK_ADMIN}"
    export KC_BOOTSTRAP_ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD}"
fi

# Build Keycloak (required for database configuration)
echo "Building Keycloak with PostgreSQL support..."
/opt/keycloak/bin/kc.sh build --db=postgres

# Start Keycloak in production mode
echo "Starting Keycloak..."
exec /opt/keycloak/bin/kc.sh start --optimized
