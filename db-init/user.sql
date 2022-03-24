-- inputs:
-- - db_name
-- - owner_password
-- - wapi_password
-- - wauth_password
\set owner_user :db_name'_owner'
\set apps_role :db_name'_apps'
\set wapi_user :db_name'_wapi'
\set wauth_user :db_name'_wauth'

\echo 'creating database users and role'
CREATE USER :owner_user;
CREATE ROLE :apps_role;
CREATE USER :wapi_user;

\echo 'setting database users passwords'
ALTER USER :owner_user WITH LOGIN PASSWORD :'owner_password';
ALTER USER :wapi_user WITH LOGIN PASSWORD :'wapi_password';
ALTER USER :wauth_user WITH LOGIN PASSWORD :'wauth_password';

\echo 'add application users to apps role'
GRANT :apps_role TO :wapi_user;
GRANT :apps_role TO :wauth_user;