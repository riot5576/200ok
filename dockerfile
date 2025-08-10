FROM nginx:alpine-slim
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
