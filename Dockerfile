# build environment
FROM node:alpine as build
ARG BUILD_ID
LABEL stage=builder
LABEL build=$BUILD_ID
LABEL item_name=website_public
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY yarn.lock ./
RUN yarn install
COPY . ./
RUN yarn build

# production environment
FROM nginx:stable-alpine
RUN apt-get update && apt-get install -y \
    curl
LABEL stage=result
LABEL build=$BUILD_ID
LABEL item_name=website_public
COPY --from=build /app/build /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
HEALTHCHECK CMD curl --fail http://localhost:80/ || exit 1
CMD ["nginx", "-g", "daemon off;"]