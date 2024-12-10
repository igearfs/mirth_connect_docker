#!/bin/bash
#
# @copywright In-Game event, A Red Flag Syndicate LLC
#
# Sponsored by In-Game Event, A Red Flag Syndicate LLC.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
#


# Directory where certificates are stored locally
LOCAL_CERT_DIR="/opt/connect/certificates-to-load-into-mc"  # The directory containing certificates to load
CONTAINER_CACERTS_PATH="/opt/java/openjdk/lib/security/cacerts"
KEYSTORE_PASS="changeit"  # Default password for cacerts in the container

# Function to add certificates to the cacerts file
add_certs_to_cacerts() {
  echo "Adding certificates to cacerts..."

  # Loop through all certificates in the local directory and import them using keytool
  for cert in $LOCAL_CERT_DIR/*.crt; do
    if [[ -f "$cert" ]]; then
      cert_alias=$(basename "$cert" .crt)  # Use the file name (without extension) as the alias
      echo "Adding certificate $cert_alias from $cert"
      keytool -importcert -file "$cert" -alias "$cert_alias" -keystore "$CONTAINER_CACERTS_PATH" -storepass "$KEYSTORE_PASS" -noprompt
    fi
  done
}

# Add certificates to the container's cacerts file
add_certs_to_cacerts

# Execute the original command to start the container
exec "$@"
