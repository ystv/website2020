\echo 'ystv_website2020 database post-migration initialisation'
\echo 'loading event...'
\i event.sql
\echo 'loaded event'
\echo 'loading keycard...'
\i keycard.sql
\echo 'loaded keycard'
\echo 'loading officership...'
\i officership.sql
\echo 'loaded officership'
\echo 'loading viewcount...'
\i viewcount.sql
\echo 'loaded viewcount'
\echo 'post-migration initialisation finished'