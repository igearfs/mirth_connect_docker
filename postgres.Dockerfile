# Use PostgreSQL 17 as the base image
FROM postgres:17

RUN apt-get update && apt-get install -y gettext-base

# Define build-time arguments (available only during build)
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
#ARG MC1_DATABASE
#ARG MC2_DATABASE
ARG MC1_DATABASE_USERNAME
ARG MC1_DATABASE_PASSWORD
ARG MC2_DATABASE_USERNAME
ARG MC2_DATABASE_PASSWORD

# Convert build-time arguments into runtime environment variables
ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
#ENV MC1_DATABASE=${MC1_DATABASE}
#ENV MC2_DATABASE=${MC2_DATABASE}
ENV MC1_DATABASE_USERNAME=${MC1_DATABASE_USERNAME}
ENV MC1_DATABASE_PASSWORD=${MC1_DATABASE_PASSWORD}
ENV MC2_DATABASE_USERNAME=${MC2_DATABASE_USERNAME}
ENV MC2_DATABASE_PASSWORD=${MC2_DATABASE_PASSWORD}

# Copy the SQL file into the container
COPY ./startup_files/postgres-init/ /tmp/postgres-init/
COPY ./startup_files/scripts/init.sh /usr/local/bin/init.sh

# Make sure the startup script is executable
RUN chmod +x /usr/local/bin/init.sh

# Set the entrypoint to our custom startup script
ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["docker-entrypoint.sh", "postgres"]
