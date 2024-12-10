# @copywright In-Game event, A Red Flag Syndicate LLC
#
# Sponsored by In-Game Event, A Red Flag Syndicate LLC.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
#
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
