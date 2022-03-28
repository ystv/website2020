-- inputs:
-- - db_name
-- - owner_password
-- - wapi_password
-- - wauth_password
\echo 'ystv_website2020 database/user/schema/privilege creation'

\set owner_user :db_name'_owner'
\set apps_role :db_name'_apps'

\echo 'creating users and role'
\i user.sql
\echo 'creating database'
\i db.sql
\echo 'connecting to database'
\c :db_name
\echo 'installing extensions'
\i extension.sql
\echo 'creating schemas'
\i schema.sql
