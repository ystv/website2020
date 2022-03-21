\echo 'starting post-migration actions'
\echo 'loading keycard'
\i keycard.sql
\echo 'loading officership'
\i officership.sql
\echo 'loading viewcount (this may take a while)'
\i viewcount.sql
\echo 'post-migration actions finished'