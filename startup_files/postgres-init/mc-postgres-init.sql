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
CREATE DATABASE mirthdb1;
CREATE DATABASE mirthdb2;

-- Create users for Mirth Connect
CREATE USER mirthuser1 WITH PASSWORD 'mirthpassword1';
CREATE USER mirthuser2 WITH PASSWORD 'mirthpassword2';

-- Grant privileges to the users on the databases
GRANT ALL PRIVILEGES ON DATABASE mirthdb1 TO mirthuser1;
GRANT ALL PRIVILEGES ON DATABASE mirthdb2 TO mirthuser2;

-- Switch to mirthdb1 and create the schema and permissions
\c mirthdb1;
CREATE SCHEMA IF NOT EXISTS mirthdb1;

-- Grant permissions to mirthuser1 for mirthdb1
GRANT USAGE, CREATE ON SCHEMA mirthdb1 TO mirthuser1;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA mirthdb1 TO mirthuser1;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA mirthdb1 TO mirthuser1;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA mirthdb1 TO mirthuser1;

-- Set default privileges for mirthuser1 in mirthdb1 (custom schema)
ALTER DEFAULT PRIVILEGES IN SCHEMA mirthdb1 GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO mirthuser1;
ALTER DEFAULT PRIVILEGES IN SCHEMA mirthdb1 GRANT EXECUTE ON FUNCTIONS TO mirthuser1;
ALTER DEFAULT PRIVILEGES IN SCHEMA mirthdb1 GRANT USAGE, SELECT ON SEQUENCES TO mirthuser1;

-- Switch to mirthdb2 and create the schema and permissions
\c mirthdb2;
CREATE SCHEMA IF NOT EXISTS mirthdb2;

-- Grant permissions to mirthuser2 for mirthdb2
GRANT USAGE, CREATE ON SCHEMA mirthdb2 TO mirthuser2;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA mirthdb2 TO mirthuser2;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA mirthdb2 TO mirthuser2;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA mirthdb2 TO mirthuser2;

-- Set default privileges for mirthuser2 in mirthdb2 (custom schema)
ALTER DEFAULT PRIVILEGES IN SCHEMA mirthdb2 GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO mirthuser2;
ALTER DEFAULT PRIVILEGES IN SCHEMA mirthdb2 GRANT EXECUTE ON FUNCTIONS TO mirthuser2;
ALTER DEFAULT PRIVILEGES IN SCHEMA mirthdb2 GRANT USAGE, SELECT ON SEQUENCES TO mirthuser2;
