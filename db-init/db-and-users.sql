-- should be running this as a user who can make databases and users
-- inputs:
-- - db_name
-- - owner_password
-- - wapi_password

\echo 'ystv_website2020 database and users initialisation'

-- variables can be set with psql like so: psql -v "key=value" -v "foo=bar"
\if :{?db_name}
\else
    \set db_name 'ystv_website2020_dev'
\endif
\echo setting up a :"db_name" environment

\echo 'creating database users and roles'
\set owner_user :db_name'_owner'
\set apps_role :db_name'_apps'
\set wapi_user :db_name'_wapi'
CREATE USER :owner_user;
CREATE ROLE :apps_role;
CREATE USER :wapi_user;

\echo 'setting database users passwords'
ALTER USER :owner_user WITH LOGIN PASSWORD :'owner_password';
ALTER USER :wapi_user WITH LOGIN PASSWORD :'wapi_password';

\echo 'creating database'
CREATE DATABASE :db_name WITH OWNER :owner_user;

\echo 'revoking default connection privileges from public'
REVOKE CONNECT ON DATABASE :db_name FROM PUBLIC;

\echo 'revoking default privileges from public'
REVOKE ALL ON DATABASE :db_name FROM PUBLIC;

\echo 'setting apps role database-level privileges'
GRANT CONNECT ON DATABASE :db_name TO :apps_role;

\echo 'add wapi_user to apps role'
GRANT :apps_role TO :wapi_user;