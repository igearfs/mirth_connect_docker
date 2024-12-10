"""
Copyright (C) 2024 In-Game Event, A Red Flag Syndicate LLC

This program is free software: you can redistribute it and/or modify it under the terms of the Server Side Public License, version 1, as published by MongoDB, Inc., with the following additional terms:

- Any use of this software in a commercial capacity requires a commercial license agreement with In-Game Event, A Red Flag Syndicate LLC. Contact licence_request@igearfs.com for details.

- If you choose not to obtain a commercial license, you must comply with the SSPL terms, which include making publicly available the source code for all programs, tooling, and infrastructure used to operate this software as a service.

This program is distributed WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Server Side Public License for more details.

For licensing inquiries, contact: licence_request@igearfs.com
"""

import socket
import ssl

# Define server address and port
server_address = ('127.0.0.1', 6666)

# Create a socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Create a custom SSL context for a client
context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
context.check_hostname = False  # Disable hostname checking
context.verify_mode = ssl.CERT_NONE  # Disable certificate verification

# Wrap the socket with SSL context
with context.wrap_socket(sock, server_hostname='localhost') as secure_sock:
    secure_sock.connect(server_address)
    print("SSL connection established")

    # Send a test message
    message = b'\x0bMSH|^~\&|SendingApp|SendingFac|ReceivingApp|ReceivingFac|20241208||ADT^A01|123456|P|2.5\x1c\x0d'
    secure_sock.sendall(message)
    print(f"Sent: {message}")

    # Receive the response (if any)
    response = secure_sock.recv(1024)
    print(f"Received: {response}")
