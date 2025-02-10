-- Copyright (C) 2024 In-Game Event, A Red Flag Syndicate LLC
--
-- This program is free software: you can redistribute it and/or modify it under the terms of the Server Side Public License, version 1, as published by MongoDB, Inc., with the following additional terms:
--
-- - Any use of this software in a commercial capacity requires a commercial license agreement with In-Game Event, A Red Flag Syndicate LLC. Contact licence_request@igearfs.com for details.
--
-- - If you choose not to obtain a commercial license, you must comply with the SSPL terms, which include making publicly available the source code for all programs, tooling, and infrastructure used to operate this software as a service.
--
-- This program is distributed WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Server Side Public License for more details.
--
-- For licensing inquiries, contact: licence_request@igearfs.com

-- Create the databases for Mirth Connect instances
-- CREATE DATABASE ${MC1_DATABASE};
-- CREATE DATABASE ${MC2_DATABASE};

-- Create users for Mirth Connect
CREATE USER ${MC1_DATABASE_USERNAME} WITH PASSWORD '${MC1_DATABASE_PASSWORD}';
CREATE USER ${MC2_DATABASE_USERNAME} WITH PASSWORD '${MC2_DATABASE_PASSWORD}';

-- Grant privileges to the users on the databases
-- GRANT ALL PRIVILEGES ON DATABASE ${MC1_DATABASE} TO ${MC1_DATABASE_USERNAME};
-- GRANT ALL PRIVILEGES ON DATABASE ${MC2_DATABASE} TO ${MC2_DATABASE_USERNAME};

-- Switch to ${MC1_DATABASE} and create the schema and permissions
-- \c ${MC1_DATABASE};
CREATE SCHEMA IF NOT EXISTS ${MC1_DATABASE};

-- Grant permissions to ${MC1_DATABASE_USERNAME} for ${MC1_DATABASE}
GRANT USAGE, CREATE ON SCHEMA ${MC1_DATABASE} TO ${MC1_DATABASE_USERNAME};
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ${MC1_DATABASE} TO ${MC1_DATABASE_USERNAME};
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ${MC1_DATABASE} TO ${MC1_DATABASE_USERNAME};
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA ${MC1_DATABASE} TO ${MC1_DATABASE_USERNAME};

-- Set default privileges for ${MC1_DATABASE_USERNAME} in ${MC1_DATABASE} (custom schema)
ALTER DEFAULT PRIVILEGES IN SCHEMA ${MC1_DATABASE} GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${MC1_DATABASE_USERNAME};
ALTER DEFAULT PRIVILEGES IN SCHEMA ${MC1_DATABASE} GRANT EXECUTE ON FUNCTIONS TO ${MC1_DATABASE_USERNAME};
ALTER DEFAULT PRIVILEGES IN SCHEMA ${MC1_DATABASE} GRANT USAGE, SELECT ON SEQUENCES TO ${MC1_DATABASE_USERNAME};

-- Switch to ${MC2_DATABASE} and create the schema and permissions
--\c ${MC2_DATABASE};
CREATE SCHEMA IF NOT EXISTS ${MC2_DATABASE};

-- Grant permissions to ${MC2_DATABASE_USERNAME} for ${MC2_DATABASE}
GRANT USAGE, CREATE ON SCHEMA ${MC2_DATABASE} TO ${MC2_DATABASE_USERNAME};
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ${MC2_DATABASE} TO ${MC2_DATABASE_USERNAME};
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ${MC2_DATABASE} TO ${MC2_DATABASE_USERNAME};
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA ${MC2_DATABASE} TO ${MC2_DATABASE_USERNAME};

-- Set default privileges for ${MC2_DATABASE_USERNAME} in ${MC2_DATABASE} (custom schema)
ALTER DEFAULT PRIVILEGES IN SCHEMA ${MC2_DATABASE} GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${MC2_DATABASE_USERNAME};
ALTER DEFAULT PRIVILEGES IN SCHEMA ${MC2_DATABASE} GRANT EXECUTE ON FUNCTIONS TO ${MC2_DATABASE_USERNAME};
ALTER DEFAULT PRIVILEGES IN SCHEMA ${MC2_DATABASE} GRANT USAGE, SELECT ON SEQUENCES TO ${MC2_DATABASE_USERNAME};
