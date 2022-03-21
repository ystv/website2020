# pre2022

## Backing up the existing database to a file
Create a `.pgpass` file in your home directory. Look at this [doc page](https://www.postgresql.org/docs/current/libpq-pgpass.html) for more information.

Then use `pg_dumpall` to dump the Postgres cluster
```
pg_dumpall > database-backup.sql
```