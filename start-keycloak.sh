#!/bin/bash

# Extract database connection details from DATABASE_URL
# Heroku provides DATABASE_URL in format: postgresql://user:password@host[:port]/database[?query_params]
if [ -z "$DATABASE_URL" ]; then
    echo "ERROR: DATABASE_URL environment variable is not set"
    exit 1
fi

# Remove query parameters if present
DATABASE_URL_NO_QUERY="${DATABASE_URL%%\?*}"
echo "Parsing DATABASE_URL..."

# Parse DATABASE_URL using string manipulation instead of regex
# Remove scheme (postgres:// or postgresql://)
URL_WITHOUT_SCHEME="${DATABASE_URL_NO_QUERY#*://}"

# Extract credentials (everything before @)
CREDS="${URL_WITHOUT_SCHEME%%@*}"
DB_USER="${CREDS%%:*}"
DB_PASSWORD="${CREDS#*:}"

# Extract host, port, and database
HOST_PORT_DB="${URL_WITHOUT_SCHEME#*@}"
HOST_PORT="${HOST_PORT_DB%%/*}"
DB_NAME="${HOST_PORT_DB#*/}"

# Try to extract port from host:port
if [[ "$HOST_PORT" == *:* ]]; then
    DB_HOST="${HOST_PORT%%:*}"
    DB_PORT="${HOST_PORT##*:}"
else
    # No port specified, use default PostgreSQL port
    DB_HOST="$HOST_PORT"
    DB_PORT="5432"
fi

# Validate parsed values
if [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ] || [ -z "$DB_HOST" ] || [ -z "$DB_NAME" ]; then
    echo "ERROR: Could not parse DATABASE_URL: $DATABASE_URL"
    echo "Parsed values:"
    echo "  User: $DB_USER"
    echo "  Password: [hidden]"
    echo "  Host: $DB_HOST"
    echo "  Port: $DB_PORT"
    echo "  Database: $DB_NAME"
    exit 1
fi

echo "Database connection parsed successfully:"
echo "  Host: $DB_HOST"
echo "  Port: $DB_PORT"
echo "  Database: $DB_NAME"
echo "  User: $DB_USER"

# Set Keycloak environment variables
export KC_DB=postgres
export KC_DB_URL="jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}?sslmode=require"
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
