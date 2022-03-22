# Website2ElectricBoogaloo

This repo contains the schemas for the website2020 project.

## Plan

So this has changed a lot since the initial idea, but the general plan is break up the old CSF php site into a modular, easily deployable system written in more modern languages and frameworks.

- Next.js for the public-facing website
- React for a video management and new internal site
- Go and Node for REST and GraphQL APIs

## Layout

`/plan-design` - Plan the project overview
`/plan-method` - Plan the specifics of a website component
`/db-init` - Initialise the database and schemas
`/schema-structure` - Create the tables
`/schema-migrate` - Migrate the database from an old schema

## Initialising

### Developing database locally
You will need a PostgreSQL instance running which you can get running easy with Docker.
```
docker-compose up -d
```

Started and stopped with `docker-compose up -d / docker-compose down`

Access the built-in psql client with
```
docker exec -it ystv-website2020-db psql -U postgres
```

### Installing the `psql` client
It's recommended to also install `psql` which is not available in Ubuntu 20.40's repos so it will need to be added.

Add PostgreSQL repo signing key
```
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
```

Add PostgreSQL repo
```
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql-pgdg.list > /dev/null
```

Update apt metdata
```
sudo apt update
```

Install `psql` client
```
sudo apt install postgresql-client-common postgresql-client-14
```

If you started Postgres in Docker you will be able to connect using:
```
psql -h localhost
```

### Deleting Docker DB
Specify the `-v` flag to remove named volumes in addition to deleting the postgres container
```
docker-compose down -v
```

### Getting the source-code
You will need to clone the repo to your computer in order to initialise the database with the correct information. It is recommended you setup access to GitHub with SSH. (which you can read more about [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh))
```
git clone git@github.com:ystv/website2020
```

## setup.sh
Enables easy management over the website2020 database with a couple of useful tools.

#### setup
````
./setup.sh -D new-database
````
Initialises a blank `website2020` database, required users, and tables. Returns the DB user's passwords on a successful setup.

#### export
```
./setup.sh -D target-database export db-backup
```
Export the database data and schema, excludes users and roles. Used for when moving between Postgres instances. (compatible with both pre-2020 and website2020 DBs)

#### export-data
```
./setup.sh -D target-database export-data db-backup
```
Export only the data, this would be used when the `target-database` has already had `setup` ran on it.

#### import
```
./setup.sh -D target-database import db-backup
```
Import an existing `website2020` db. Compatibile with both `export` and `export-data` outputs.

#### migrate
```
./setup.sh -D new-database pre2020-db
```
Import and migrate a pre-2020 database to the latest `website2020` schema. Returns the DB user's passwords on a successful migrate.

### Dependencies

- postgres
- S3 or equivalent (i.e. minio)
- docker (optional)

You'll want to setup the databases first, currently developed using postgres.

You'll want to then add the schemas to the database. You can either copy and paste the SQL or use `psql -h {host} -d {database} -f {schema_file}`. If you want to setup all tables automatically, `cd` into the `schemas` folder then execute `psql -h {host} -d {database} -f _meta.sql`. Alternatively, if you want to do it manually, you will want to create it in the following order:

Add extensions: `uuid-ossp` and `tsm_system_rows`.

1. people.sql
2. video.sql
3. event.sql
4. misc.sql
5. mail.sql
6. creator.sql
7. playout.sql

Then you will want to add load in the inital data from the SQL found in `/setup`.

After the data is loaded you will want to setup each software stack in the following order:

1. web-auth
2. web-api
3. my-tv
4. creator-studio
5. public-site

Once all configured following their own setup guides you should be setup!
