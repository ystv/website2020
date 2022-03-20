\echo 'ystv_website2020 database initialisation'
\echo 'loading extensions...'
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "tsm_system_rows";
\echo 'loaded extensions'
\echo 'loading people...'
\i people.sql
\echo 'loaded people'
\echo 'loading videos...'
\i video.sql
\echo 'loaded video'
\echo 'loading event...'
\i event.sql
\echo 'loaded event'
\echo 'loading misc...'
\i misc.sql
\echo 'loaded misc'
\echo 'loading mail...'
\i mail.sql
\echo 'loaded mail'
\echo 'loading creator...'
\i creator.sql
\echo 'loaded creator'
\echo 'loading playout...'
\i playout.sql
\echo 'loaded playout'
\echo 'initialisation finished'

