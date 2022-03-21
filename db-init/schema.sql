-- should be connecting to the website2020 db as the owner user  to run this
-- inputs:
-- - owner_user
-- - apps_role

SET ROLE :owner_user;

\echo 'creating schemas'
CREATE SCHEMA people;
CREATE SCHEMA video;
CREATE SCHEMA event;
CREATE SCHEMA misc;
CREATE SCHEMA mail;
CREATE SCHEMA creator;
CREATE SCHEMA playout;

\echo 'granting schema privleges'
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA people TO :apps_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA video TO :apps_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA event TO :apps_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA misc TO :apps_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA mail TO :apps_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA creator TO :apps_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA playout TO :apps_role;
