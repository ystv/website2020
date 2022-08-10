# Website2ElectricBoogaloo

This repo contains the schemas for the website2020 project.

## Plan

So this has changed a lot since the initial idea, but the general plan is break
up the old CSF php site into a modular, easily deployable system written in
more modern languages and frameworks.

- Next.js for the public-facing website
- React for a video management and new internal site
- Go and Node for REST and GraphQL APIs

## Layout

- `/plan-design` - Plan the project overview
- `/plan-method` - Plan the specifics of a website component
- `/db-init` - Initialise the database and schemas
- `/schema-structure` - Create the tables
- `/schema-migrate` - Migrate the database from an old schema

## Initialising

### Developing database locally

Setup a PostgreSQL instance running which you can get running easy with Docker.

```sh
docker-compose up -d
```

Started and stopped with `docker-compose up -d / docker-compose down`

Access the built-in psql client with

```sh
docker exec -it ystv-website2020-db psql -U postgres
```

### Installing the `psql` client

It's recommended to also install `psql` which is not available in Ubuntu's apt
repos so it will need to be added.

Add PostgreSQL repo signing key

```sh
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
```

Add PostgreSQL repo

```sh
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql-pgdg.list > /dev/null
```

Update apt metdata

```sh
sudo apt update
```

Install `psql` client

```sh
sudo apt install postgresql-client-common postgresql-client-14
```

If Postgres is running in Docker, connect using:

```sh
psql -h localhost
```

### Deleting Docker DB

Specify the `-v` flag to remove named volumes in addition to deleting the
postgres container.

```sh
docker-compose down -v
```

## setup.sh

Enables easy management over the website2020 database with a couple of useful
tools. Dependent on `psql`. See `--help` for usage.

#### setup

```sh
./setup.sh setup -d ${new_database_name}
```

Initialise a blank `website2020` database, required users, and tables. Returns
the DB user's passwords on a successful setup.

> Requires the connecting user can access the `postgres` database and has
> grants to `CREATE database` and `CREATE` / `ALTER ROLE`.

#### export

```sh
./setup.sh export db-backup -d ${target_database}
```

Export the database __data and schema__, excludes users and roles. Used for
when moving between Postgres instances. (compatible with both pre-2020 and
website2020 DBs)

#### backup

```sh
./setup.sh backup ${database_backup_file} -d ${target_database}
```

Export the database __data__, this would be used when the `target-database` has
already had `setup` ran on it.

#### import

```sh
./setup.sh import ${database_backup_file} -d ${target_database}
```

Import an existing `website2020` db. Compatibile with both `export` and
`backup` outputs.

> Requires an existing database, for `backup` run `setup` first. For `export`
> create a database manually.

#### migrate

```sh
./setup.sh ${pre_2020_database_backup_file} -d ${target_database}
```

Import and migrate a pre-2020 database to the latest `website2020` schema.

> Requires an existing database, run `setup` first.

> Removes all existing website2020 data.

> If a pre-2020 database has already been imported. It will overwrite.

### Dependencies

- postgres
- S3 or equivalent (i.e. minio)
- docker (optional)

Create the databases first.

Add extensions: `uuid-ossp` and `tsm_system_rows`.

Add the schemas to the database (`psql -h {host} -d {database} -f
{schema_file}`). Create it in the following order:

1. people.sql
2. video.sql
3. event.sql
4. misc.sql
5. mail.sql
6. creator.sql
7. playout.sql

Add in the inital data from the SQL found in `/setup`.

After the data is loaded setup each software stack in the following order:

1. web-auth
2. web-api
3. my-tv
4. creator-studio
5. public-site

Once all configured following their own setup guides, setup should be complete!
