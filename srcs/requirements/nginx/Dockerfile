FROM debian:bullseye

RUN apt update -y
RUN apt upgrade -y
RUN apt install nginx openssl -y
RUN rm -rf /var/lib/apt/lists/* # Clean up APT cache
RUN mkdir /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "/etc/nginx/ssl/jmougel.key" -out "/etc/nginx/ssl/jmougel.crt" -subj \
    "/C=FR/L=Lyon/O=42/OU=student/CN=jmougel.42.fr"
COPY ./conf/default /etc/nginx/sites-available/default
COPY ./conf/index.html /var/www/html/

CMD ["nginx", "-g", "daemon off;"]