# migrations

Currently there is only one migration right now and this is from the existing website. Ideally it would stay that way with everything else being done through `goose` in [db](/db).

This is kept separate as when you are usually developing, you aren't using the old database as a datasource instead using [website-2020-test-data](https://github.com/ystv/website2020-test-data). If this was introduced as another migration to goose it would just result in superfluous errors.

## From the old website
`cd` into `old` and run:

```
psql -h {host} -d {database} -f meta.sql
```