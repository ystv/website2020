\echo 'ystv_website2020 schema/table creation'
\if :{?owner_user}
    \c :owner_user
\endif
\echo 'creating people'
\i people.sql
\echo 'creating videos'
\i video.sql
\echo 'creating event'
\i event.sql
\echo 'loading misc'
\i misc.sql
\echo 'loading mail'
\i mail.sql
\echo 'loading creator'
\i creator.sql
\echo 'loading playout'
\i playout.sql
