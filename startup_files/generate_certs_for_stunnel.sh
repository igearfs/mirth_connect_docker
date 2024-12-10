#!/bin/bash
#
# Sponsored by In-Game Event, A Red Flag Syndicate LLC.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#

# Define the channel name at the top (can be passed as an argument)
CHANNEL_NAME="${1:-channel1}"  # Default to 'channel1' if no argument is provided

# Ensure the channel name is not empty
if [ -z "$CHANNEL_NAME" ]; then
    echo "Error: Channel name must be provided."
    exit 1
fi

# Define the directory structure for server, client certs, and the CA
CA_DIR="../stunnel_certs/ca"
SERVER_DIR="../stunnel_certs/server"
CLIENT_DIR="../stunnel_certs/client"

# Create directories if they don't exist
mkdir -p "$CA_DIR" "$SERVER_DIR" "$CLIENT_DIR"

# Define file paths for the generated files
CA_KEY="${CA_DIR}/ca_key.pem"
CA_CERT="${CA_DIR}/ca_cert.pem"
CA_PEM="${CA_DIR}/ca.pem"
SERVER_KEY="${SERVER_DIR}/${CHANNEL_NAME}_server_key.pem"
SERVER_CSR="${SERVER_DIR}/${CHANNEL_NAME}_server_csr.pem"
SERVER_CERT="${SERVER_DIR}/${CHANNEL_NAME}_server_cert.pem"
SERVER_PEM="${SERVER_DIR}/${CHANNEL_NAME}_server.pem"
CLIENT_KEY="${CLIENT_DIR}/${CHANNEL_NAME}_client_key.pem"
CLIENT_CSR="${CLIENT_DIR}/${CHANNEL_NAME}_client_csr.pem"
CLIENT_CERT="${CLIENT_DIR}/${CHANNEL_NAME}_client_cert.pem"
CLIENT_PEM="${CLIENT_DIR}/${CHANNEL_NAME}_client.pem"

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
echo "Certificate and key files generated:"
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

echo "All files are preserved in the 'stunnel_certs' directory."
