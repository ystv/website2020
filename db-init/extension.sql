-- inputs
-- - owner_user

SET ROLE :owner_user;

\echo 'loading extensions'
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "tsm_system_rows";
