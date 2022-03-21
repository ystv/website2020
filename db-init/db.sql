-- should be running this as a user who can make databases
-- inputs:
-- - db_name
-- - owner_user
-- - apps_role

\echo 'ystv_website2020 database initialisation'

\if :{?db_name}
\else
    \set db_name 'ystv_website2020_dev'
\endif
\echo setting up database :"db_name"

\echo 'creating database'
CREATE DATABASE :db_name WITH OWNER :owner_user;

\echo 'revoking default connection privileges from public'
REVOKE CONNECT ON DATABASE :db_name FROM PUBLIC;

\echo 'revoking default privileges from public'
REVOKE ALL ON DATABASE :db_name FROM PUBLIC;

\echo 'setting apps role database-level privileges'
GRANT CONNECT ON DATABASE :db_name TO :apps_role;
