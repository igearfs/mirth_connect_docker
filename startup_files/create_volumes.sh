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

# Get the current user's UID and GID (we use UID 1000 as requested)
USER_UID=1000
USER_GID=1000

# Define the base mc directory and subdirectories to be created
MC_BASE_DIR="./mc"
VOLUME_DIRS=(
  "$MC_BASE_DIR/mc-data/mc-connect-1/appdata"
  "$MC_BASE_DIR/mc-data/mc-connect-1/custom-extensions"
  "$MC_BASE_DIR/mc-data/mc-connect-1/extensions"
  "$MC_BASE_DIR/mc-data/mc-connect-1/custom-lib"
  "$MC_BASE_DIR/mc-data/mc-connect-2/appdata"
  "$MC_BASE_DIR/mc-data/mc-connect-2/custom-extensions"
  "$MC_BASE_DIR/mc-data/mc-connect-2/extensions"
  "$MC_BASE_DIR/mc-data/mc-connect-2/custom-lib"
  "$MC_BASE_DIR/mc-postgres-data"
  "$MC_BASE_DIR/mc-pgadmin-data"
  "$MC_BASE_DIR/postgres-init"
  "$MC_BASE_DIR/certificates-to-load-into-mc"
)

# Create directories if they don't exist and set ownership
for DIR in "${VOLUME_DIRS[@]}"; do
  # Create the directory if it doesn't exist
  if [ ! -d "$DIR" ]; then
    echo "Creating directory: $DIR"
    mkdir -p "$DIR"
  else
    echo "Directory already exists: $DIR"
  fi

  # Set ownership to UID 1000 and GID 1000
  echo "Setting ownership for $MC_BASE_DIR to UID:$USER_UID GID:$USER_GID"
  sudo chown -R $USER_UID:$USER_GID $MC_BASE_DIR
  sudo chmod 770 -R $MC_BASE_DIR  # Ensure the directory is readable and writable
done

echo "All directories under the mc folder created and ownership set to UID 1000 and GID 1000!"
