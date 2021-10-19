# db

To control versioning of the schema the [goose](https://github.com/pressly/goose) tool is used. This just essentially allows us to go `up` and `down` with schema versions by simply using `goose up` and `goose down`. This does mean that when there is a schema change, there will also need to be a reversal migration written.

## Installing
### Prebuilt binaries
Install `goose` through the [releases](https://github.com/pressly/goose/releases) section on their repo.

### From source
Alternatively if you have Go installed run:

```
go install github.com/pressly/goose/v3/cmd/goose@latest
```

## Running
You will need to have an instance of postgres running for `goose` to work.

You can read `goose --help` but as a general guideline for our usecases, set the environment variables:

```
GOOSE_DRIVER="postgres"`
GOOSE_DBSTRING="postgres connection string"
```

> If you are using goose on the ystv dev or prod database refer to Vault for the correct `GOOSE_DBSTRING` in the `Developments` collection.

If configured correctly you should be able to run `goose status` without it returning an error.

### Getting to latest
Luckily this is fairly simply to do:

```
goose up
```

> If you want to migrate from the old DB, Checkout [migrations](/migrations). As a little note, this migration is one way and will likely track the latest version of this schema.

### Creating a new version
We are attempting to follow goose's [Hybrid Versioning](https://github.com/pressly/goose#hybrid-versioning). This results in SQL files like `20211019024458_v1.sql` which include the timestamp of when it was created and the version.

```
goose create v{version number incremented} sql
```

 If you want to provide a bit more context in the name like `goose create v1_add_video` that would be beneficial.

### Where am I?
Knowing what the current state of a database can be a little daunting, luckily goose keeps track of the state making this quite peaceful.

```
goose status
```

Will show you the connected database's schema version is, what time it was applied and and show you how many it is behind.