# Website2ElectricBoogaloo

So this has changed a lot since the initial idea, but the general plan is break up the old CSF php site into a modular, easily deployable system written in more modern languages and frameworks.

The plan is use Next.js for the public-facing website

React for a video management and new internal site

Go and Node for REST and GraphQL APIs

Throw each subdomain in a separate repo and dockerfile and throw nginx in front of it, wrap up in a docker compose bow and worry about emails later :((

## THIS WILL ALL NEED REDOING

To deploy the website (or to rebuild the website image) use jenkins to set build arg "build_id" (cleans up intermediate image):

### `docker-compose up -d --build --force-recreate --remove-orphans --build-arg BUILD_ID`

### `docker image prune --filter label=stage=builder --filter label=build=$BUILD_ID`

To stop the website (and remove the images):

### `docker-compose down --rmi 'all' --remove-orphans`

To list all images on a machine:

### `docker image ls`

To remove all unused images (inc build images, WILL DELETE ALL UNUSED IMAGES ON THE SYSTEM):

### `docker image prune`

To update the external images (I think):

### `docker-compose pull`
