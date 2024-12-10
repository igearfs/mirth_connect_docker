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

server_address = ('localhost', 5555)  # Connect to stunnel on localhost
sock = socket.create_connection(server_address)

# Send/receive data
sock.sendall(b'\x0b MSH|^~\&|SendingApp|SendingFac|ReceivingApp|ReceivingFac|20241208||ADT^A01|123456|P|2.5\x1c\x0d')
response = sock.recv(1024)
print('Received:', response)

sock.close()