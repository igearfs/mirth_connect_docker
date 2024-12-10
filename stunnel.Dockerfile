# Copyright (C) 2024 In-Game Event, A Red Flag Syndicate LLC
#
# This program is free software: you can redistribute it and/or modify it under the terms of the Server Side Public License, version 1, as published by MongoDB, Inc., with the following additional terms:
#
# - Any use of this software in a commercial capacity requires a commercial license agreement with In-Game Event, A Red Flag Syndicate LLC. Contact licence_request@igearfs.com for details.
#
# - If you choose not to obtain a commercial license, you must comply with the SSPL terms, which include making publicly available the source code for all programs, tooling, and infrastructure used to operate this software as a service.
#
# For licensing inquiries, contact: licence_request@igearfs.com

FROM alpine:3.15

# Install dependencies: curl, stunnel, openssl, and bash
RUN apk update && apk add --no-cache \
    curl \
    stunnel \
    openssl \
    bash \
    && rm -rf /var/cache/apk/*

# Create a user and group with UID 1000 and GID 1000 if they don't already exist
RUN addgroup -g 1000 stunnel || true && \
    adduser -D -u 1000 -G stunnel stunnel || true

# Set the working directory
WORKDIR /etc/stunnel

# Create directories to store configuration and certificates
RUN mkdir -p /etc/stunnel/certs

# Copy the Stunnel configuration file and certificates from the local machine
COPY ./stunnel.conf /etc/stunnel/stunnel.conf
COPY ./stunnel_certs/server /etc/stunnel/certs/

# Ensure the correct permissions for files
RUN chown -R stunnel:stunnel /etc/stunnel
RUN chown -R stunnel:stunnel /etc/stunnel/certs
RUN chmod 774 -R /etc/stunnel/
RUN chmod 774 -R /etc/stunnel/certs

# Set the entrypoint to start Stunnel with the given configuration
USER stunnel
CMD ["stunnel", "/etc/stunnel/stunnel.conf"]
