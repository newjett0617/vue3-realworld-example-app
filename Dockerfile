FROM docker.io/library/node:14-alpine as build
ARG API_HOST
ENV VITE_API_HOST=${API_HOST}
WORKDIR /usr/src/app
COPY . .
RUN yarn install && yarn build

FROM docker.io/library/nginx:stable-alpine
ARG output=/usr/share/nginx/html
COPY --from=build /usr/src/app/dist $output

RUN echo $'\
server {\n\
    listen 80;\n\
\n\
    location / {\n\
        root '$output$';\n\
        index index.html index.htm;\n\
        try_files $uri $uri/ /index.html =404;\n\
    }\n\
}\n\
' > /etc/nginx/conf.d/default.conf
