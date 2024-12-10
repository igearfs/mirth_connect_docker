# Mirth Connect Architecture

This setup involves two Mirth Connect instances behind HAProxy and Stunnel, connected to a PostgreSQL database. The architecture diagram below illustrates the flow:

![output.png](output.png))

## Components

- **Stunnel**: Handles secure tunneling.
- **HAProxy**: Distributes traffic to the Mirth Connect instances.
- **Mirth Connect Instances**:
  - Mirth Connect 1
  - Mirth Connect 2
- **PostgreSQL**: Database backend for both Mirth Connect instances. (if heavy load I sugges )

## Flow

1. Incoming traffic reaches **Stunnel** for secure tunneling.
2. Traffic is routed to **HAProxy** for load balancing.
3. **HAProxy** directs requests to one of the Mirth Connect instances.
4. Each Mirth Connect instance communicates with the shared **PostgreSQL** database.


@copywright In-Game event, A Red Flag Syndicate LLC

Sponsored by In-Game Event, A Red Flag Syndicate LLC.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.



I own all copyrights
Use at your own risk, You download and run it it's your issue is something breaks.
Don't cry to me. You were warned.
You may not sell this code as your own or modify it.


Ok - I'll fill all this in with directions later.

Right now it allows connections without needing a client cert. I wanted this example out in case anyone else has this same idea.

This will allow any connection over sll to the STUNNEL.

I will fill this out in a bit and give instructions on how to use it.

Then I will add in cert verification... maybe.. I mean if we firewall and only allow this
ip to send us messages. Need to do encrypted folders as well. and all that other fun stuff...

Open external ports:

PGAdmin, STUNNEL, Mirth connects on 8443 and 8444.
haproxy is balancing the load.
1 postgres for both connects but seperate database and schemas

ok I am tired...
