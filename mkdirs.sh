#!/bin/bash

# Create directories for mc-citusdata-postgres-master-data
mkdir -p ./mc/mc-citusdata-postgres-master-data

# Create directories for mc-pgadmin-data
mkdir -p ./mc/mc-pgadmin-data

# Create directories for mc-connect-1
mkdir -p ./mc/mc-connect-1-appdata
mkdir -p ./mc/mc-connect-1-custom-extensions
mkdir -p ./mc/mc-connect-1-custom-lib

# Create directories for mc-connect-2
mkdir -p ./mc/mc-connect-2-appdata
mkdir -p ./mc/mc-connect-2-custom-extensions
mkdir -p ./mc/mc-connect-2-custom-lib

echo "All required directories have been created!"
