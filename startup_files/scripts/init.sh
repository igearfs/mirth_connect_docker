#!/bin/bash

# Substitute environment variables into the SQL file
envsubst < /tmp/postgres-init/mc-postgres-init.sql > /docker-entrypoint-initdb.d/mc-postgres-init.sql

# Ensure permissions are correct
chmod 644 /docker-entrypoint-initdb.d/mc-postgres-init.sql

# Execute the original entrypoint command
exec "$@"
