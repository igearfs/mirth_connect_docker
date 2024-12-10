@echo off
REM Copyright (C) 2024 In-Game Event, A Red Flag Syndicate LLC
REM
REM This program is free software: you can redistribute it and/or modify it under the terms of the Server Side Public License, version 1, as published by MongoDB, Inc., with the following additional terms:
REM
REM - Any use of this software in a commercial capacity requires a commercial license agreement with In-Game Event, A Red Flag Syndicate LLC. Contact licence_request@igearfs.com for details.
REM
REM - If you choose not to obtain a commercial license, you must comply with the SSPL terms, which include making publicly available the source code for all programs, tooling, and infrastructure used to operate this software as a service.
REM
REM This program is distributed WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Server Side Public License for more details.
REM
REM For licensing inquiries, contact: licence_request@igearfs.com

REM Set the channel name (default to channel1 if not provided)
SET CHANNEL_NAME=%1
IF "%CHANNEL_NAME%"=="" SET CHANNEL_NAME=channel1

REM Define directories for certificates
SET CA_DIR=stunnel_certs\ca
SET SERVER_DIR=stunnel_certs\server
SET CLIENT_DIR=stunnel_certs\client

REM Create directories if they don't exist
mkdir "%CA_DIR%"
mkdir "%SERVER_DIR%"
mkdir "%CLIENT_DIR%"

REM Define file paths for the generated files
SET CA_KEY=%CA_DIR%\ca_key.pem
SET CA_CERT=%CA_DIR%\ca_cert.pem
SET CA_PEM=%CA_DIR%\ca.pem
SET SERVER_KEY=%SERVER_DIR%\%CHANNEL_NAME%_server_key.pem
SET SERVER_CSR=%SERVER_DIR%\%CHANNEL_NAME%_server_csr.pem
SET SERVER_CERT=%SERVER_DIR%\%CHANNEL_NAME%_server_cert.pem
SET SERVER_PEM=%SERVER_DIR%\%CHANNEL_NAME%_server.pem
SET CLIENT_KEY=%CLIENT_DIR%\%CHANNEL_NAME%_client_key.pem
SET CLIENT_CSR=%CLIENT_DIR%\%CHANNEL_NAME%_client_csr.pem
SET CLIENT_CERT=%CLIENT_DIR%\%CHANNEL_NAME%_client_cert.pem
SET CLIENT_PEM=%CLIENT_DIR%\%CHANNEL_NAME%_client.pem

REM Step 1: Generate the Certificate Authority (CA) key and certificate
echo Generating CA key and certificate...
"C:\Program Files\Git\usr\bin\openssl.exe" genpkey -algorithm RSA -out "%CA_KEY%"
"C:\Program Files\Git\usr\bin\openssl.exe" req -new -x509 -key "%CA_KEY%" -out "%CA_CERT%" -subj "/CN=MyCA-%CHANNEL_NAME%" -days 3650
IF NOT EXIST "%CA_CERT%" (
    echo Failed to create CA certificate. Exiting...
    exit /b 1
)

REM Combine the CA certificate and private key into one PEM file
type "%CA_KEY%" "%CA_CERT%" > "%CA_PEM%"

REM Step 2: Generate the server private key, CSR, and certificate
echo Generating server key, CSR, and certificate...
"C:\Program Files\Git\usr\bin\openssl.exe" genpkey -algorithm RSA -out "%SERVER_KEY%"
"C:\Program Files\Git\usr\bin\openssl.exe" req -new -key "%SERVER_KEY%" -out "%SERVER_CSR%" -subj "/CN=%CHANNEL_NAME%_server"
"C:\Program Files\Git\usr\bin\openssl.exe" x509 -req -in "%SERVER_CSR%" -CA "%CA_CERT%" -CAkey "%CA_KEY%" -CAcreateserial -out "%SERVER_CERT%" -days 365

REM Combine the server private key and certificate into a single PEM file
type "%SERVER_KEY%" "%SERVER_CERT%" > "%SERVER_PEM%"

REM Step 3: Generate the client private key, CSR, and certificate
echo Generating client key, CSR, and certificate...
"C:\Program Files\Git\usr\bin\openssl.exe" genpkey -algorithm RSA -out "%CLIENT_KEY%"
"C:\Program Files\Git\usr\bin\openssl.exe" req -new -key "%CLIENT_KEY%" -out "%CLIENT_CSR%" -subj "/CN=%CHANNEL_NAME%_client"
"C:\Program Files\Git\usr\bin\openssl.exe" x509 -req -in "%CLIENT_CSR%" -CA "%CA_CERT%" -CAkey "%CA_KEY%" -CAcreateserial -out "%CLIENT_CERT%" -days 365

REM Combine the client private key and certificate into a single PEM file
type "%CLIENT_KEY%" "%CLIENT_CERT%" > "%CLIENT_PEM%"

REM Print out the generated files
echo Certificate and key files generated:
echo CA Certificate: %CA_CERT%
echo CA Private Key: %CA_KEY%
echo Server Certificate: %SERVER_CERT%
echo Server Private Key: %SERVER_KEY%
echo Server CSR: %SERVER_CSR%
echo Server Combined PEM: %SERVER_PEM%
echo Client Certificate: %CLIENT_CERT%
echo Client Private Key: %CLIENT_KEY%
echo Client CSR: %CLIENT_CSR%
echo Client Combined PEM: %CLIENT_PEM%

echo All files are preserved in the 'stunnel_certs' directory.
pause
