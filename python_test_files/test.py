"""
Copyright (C) 2024 In-Game Event, A Red Flag Syndicate LLC

This program is free software: you can redistribute it and/or modify it under the terms of the Server Side Public License, version 1, as published by MongoDB, Inc., with the following additional terms:

- Any use of this software in a commercial capacity requires a commercial license agreement with In-Game Event, A Red Flag Syndicate LLC. Contact licence_request@igearfs.com for details.

- If you choose not to obtain a commercial license, you must comply with the SSPL terms, which include making publicly available the source code for all programs, tooling, and infrastructure used to operate this software as a service.

This program is distributed WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Server Side Public License for more details.

For licensing inquiries, contact: licence_request@igearfs.com
"""

import socket

server_address = ('localhost', 5555)  # Connect to stunnel on localhost
sock = socket.create_connection(server_address)

# Send/receive data
sock.sendall(b'\x0b MSH|^~\&|SendingApp|SendingFac|ReceivingApp|ReceivingFac|20241208||ADT^A01|123456|P|2.5\x1c\x0d')
response = sock.recv(1024)
print('Received:', response)

sock.close()