#!/bin/bash
# @copywright In-Game event, A Red Flag Syndicate LLC
#
# Sponsored by In-Game Event, A Red Flag Syndicate LLC.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
#
# Start from an Alpine base image
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
