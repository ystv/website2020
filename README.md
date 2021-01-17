# Website2ElectricBoogaloo

This repo contains the schemas for the website2020 project.

## Other docs

- [developing](developing.md)
- [searching](searching.md)
- [viewcount](viewcount.md)

## Plan

So this has changed a lot since the initial idea, but the general plan is break up the old CSF php site into a modular, easily deployable system written in more modern languages and frameworks.

- Next.js for the public-facing website
- React for a video management and new internal site
- Go and Node for REST and GraphQL APIs

## Layout

`/schemas` - Database Schemas
`/setup` - Inital database data
`/planning` - Rough ideas of how the project is layed out

## Initialising

### Dependencies

- postgres
- S3 or equivalent (i.e. minio)
- docker (optional)

You'll want to setup the databases first, currently developed using postgres.

You'll want to then add the schema to the database. You can either copy and paste the SQL or use `psql -h {host} -d {database} -f {schema_file}`. You will want to create it in the following order:

1. people.sql
2. video.sql
3. event.sql
4. misc.sql
5. creator.sql

Then you will want to add load in the inital data from the SQL found in `/setup`.

After the data is loaded you will want to setup each software stack in the following order:

1. web-auth
2. web-api
3. my-tv
4. creator-studio
5. public-site

Once all configured following their own setup guides you should be setup!
