FROM debian:bullseye

RUN apt update -y
RUN apt upgrade -y
RUN apt install nginx -y

COPY ./conf/default.conf /etc/nginx/sites-available/default