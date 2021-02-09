# Stage 1
FROM node:12.0-alpine as node

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install 

COPY . .

RUN npm run build 
RUN npm prune --production
# Stage 2
FROM nginx:1.13.12-alpine

COPY --from=node /usr/src/app/dist/projet /usr/share/nginx/html/

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

CMD ["/bin/sh",  "-c",  "envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]

