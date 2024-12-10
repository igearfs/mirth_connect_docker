#!/bin/bash
# Copyright (C) 2024 In-Game Event, A Red Flag Syndicate LLC
#
# This program is free software: you can redistribute it and/or modify it under the terms of the Server Side Public License, version 1, as published by MongoDB, Inc., with the following additional terms:
#
# - Any use of this software in a commercial capacity requires a commercial license agreement with In-Game Event, A Red Flag Syndicate LLC. Contact licence_request@igearfs.com for details.
#
# - If you choose not to obtain a commercial license, you must comply with the SSPL terms, which include making publicly available the source code for all programs, tooling, and infrastructure used to operate this software as a service.
#
# For licensing inquiries, contact: licence_request@igearfs.com


# Define the channel name (must be passed as an argument)
CHANNEL_NAME="${1}"  # No default value, force user to provide a channel name

# Ensure the channel name is not empty
if [ -z "$CHANNEL_NAME" ]; then
    echo "Error: Channel name must be provided as an argument."
    exit 1
fi

# Define the base directory for certificates
BASE_DIR="../stunnel_certs"

# Define the directory for the specific channel
CHANNEL_DIR="${BASE_DIR}/${CHANNEL_NAME}"

# Check if the channel folder already exists
if [ -d "$CHANNEL_DIR" ]; then
    echo "Error: Channel directory '$CHANNEL_DIR' already exists. Please choose a different channel name."
    exit 1
fi

# Create channel-specific directory
mkdir -p "$CHANNEL_DIR"

# Define the directory structure for CA, server, and client certs
CA_DIR="${CHANNEL_DIR}/ca"
SERVER_DIR="${CHANNEL_DIR}/server"
CLIENT_DIR="${CHANNEL_DIR}/client"

# Create directories for CA, server, and client certs
mkdir -p "$CA_DIR" "$SERVER_DIR" "$CLIENT_DIR"

# Define file paths for the generated files
CA_KEY="${CA_DIR}/ca_key.pem"
CA_CERT="${CA_DIR}/ca_cert.pem"
CA_PEM="${CA_DIR}/ca.pem"
SERVER_KEY="${SERVER_DIR}/server_key.pem"
SERVER_CSR="${SERVER_DIR}/server_csr.pem"
SERVER_CERT="${SERVER_DIR}/server_cert.pem"
SERVER_PEM="${SERVER_DIR}/server.pem"
CLIENT_KEY="${CLIENT_DIR}/client_key.pem"
CLIENT_CSR="${CLIENT_DIR}/client_csr.pem"
CLIENT_CERT="${CLIENT_DIR}/client_cert.pem"
CLIENT_PEM="${CLIENT_DIR}/client.pem"

# Step 1: Generate the Certificate Authority (CA) key and certificate

# Generate a private key for the CA (no passphrase)
openssl genpkey -algorithm RSA -out "$CA_KEY"

# Generate a self-signed CA certificate (valid for 3650 days)
openssl req -new -x509 -key "$CA_KEY" -out "$CA_CERT" -subj "/CN=MyCA-${CHANNEL_NAME}" -days 3650

# Combine the CA certificate and private key into one PEM file
cat "$CA_KEY" "$CA_CERT" > "$CA_PEM"

# Set proper permissions for the CA files
chmod 600 "$CA_KEY"
chmod 644 "$CA_CERT"
chmod 644 "$CA_PEM"

# Step 2: Generate the server private key, CSR, and self-signed certificate (signed by the CA)

# Generate an unencrypted private key for the server (no passphrase)
openssl genpkey -algorithm RSA -out "$SERVER_KEY"

# Generate a Certificate Signing Request (CSR) for the server
openssl req -new -key "$SERVER_KEY" -out "$SERVER_CSR" -subj "/CN=${CHANNEL_NAME}_server"

# Sign the server certificate with the CA certificate
openssl x509 -req -in "$SERVER_CSR" -CA "$CA_CERT" -CAkey "$CA_KEY" -CAcreateserial -out "$SERVER_CERT" -days 365

# Combine the server private key and certificate into a single PEM file
cat "$SERVER_KEY" "$SERVER_CERT" > "$SERVER_PEM"

# Set proper permissions for the server files
chmod 600 "$SERVER_KEY"
chmod 644 "$SERVER_CERT"
chmod 644 "$SERVER_CSR"
chmod 644 "$SERVER_PEM"

# Step 3: Generate the client private key, CSR, and self-signed certificate (signed by the CA)

# Generate an unencrypted private key for the client (no passphrase)
openssl genpkey -algorithm RSA -out "$CLIENT_KEY"

# Generate a Certificate Signing Request (CSR) for the client
openssl req -new -key "$CLIENT_KEY" -out "$CLIENT_CSR" -subj "/CN=${CHANNEL_NAME}_client"

# Sign the client certificate with the CA certificate
openssl x509 -req -in "$CLIENT_CSR" -CA "$CA_CERT" -CAkey "$CA_KEY" -CAcreateserial -out "$CLIENT_CERT" -days 365

# Combine the client private key and certificate into a single PEM file
cat "$CLIENT_KEY" "$CLIENT_CERT" > "$CLIENT_PEM"

# Set proper permissions for the client files
chmod 600 "$CLIENT_KEY"
chmod 644 "$CLIENT_CERT"
chmod 644 "$CLIENT_CSR"
chmod 644 "$CLIENT_PEM"

# Print out the generated files
echo "Certificate and key files generated in '$CHANNEL_DIR':"
echo "CA Certificate: $CA_CERT"
echo "CA Private Key: $CA_KEY"
echo "Server Certificate: $SERVER_CERT"
echo "Server Private Key: $SERVER_KEY"
echo "Server CSR: $SERVER_CSR"
echo "Server Combined PEM: $SERVER_PEM"
echo "Client Certificate: $CLIENT_CERT"
echo "Client Private Key: $CLIENT_KEY"
echo "Client CSR: $CLIENT_CSR"
echo "Client Combined PEM: $CLIENT_PEM"

echo "All files are preserved in the channel directory: $CHANNEL_DIR"
