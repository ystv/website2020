\echo 'ystv_website2020 database-server initialisation'

\if :{?env}
\else
    \set env 'dev'
\endif
\echo setting up a :"env" environment

\echo 'creating database users...'
\set admin_user 'ystv_website2020_':env'_admin'
\set wapi_user 'ystv_website2020_':env'_wapi'
CREATE USER :admin_user;
CREATE USER :wapi_user;
\echo 'created database users'

\echo 'creating database...'
\set db_name ystv_website2020_:env
CREATE DATABASE :db_name WITH OWNER :admin_user;
\echo 'created database'

\echo 'removing default schema...'
DROP SCHEMA IF EXISTS default;
\echo 'removed default schema'

\echo 'setting permissions...'
REVOKE ALL ON DATABASE :db_name FROM PUBLIC;
GRANT CREATE ON DATABASE :db_name TO :admin_user;
GRANT SELECT, INSERT, DELETE, EXECUTE ON DATABASE :db_name TO :wapi_user;
\echo 'permissions set'
