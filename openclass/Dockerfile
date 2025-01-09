FROM ubuntu:noble

WORKDIR /

EXPOSE 8080

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
    dumb-init=1.2.5-3 \
    git=1:2.43.0-1ubuntu7.1 \
    wget=1.21.4-1ubuntu4.1 \
    tar=1.35+dfsg-3build1 \
    make=4.3-4.1build2 && \
    apt-get clean && \
    mkdir docker

WORKDIR /docker

RUN wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

RUN git clone https://github.com/OpenClassrooms-Student-Center/8431896-optimisez-votre-deploiement-en-creant-des-conteneurs-avec-docker.git /docker/libra

RUN make -C /docker/libra build

WORKDIR /docker/libra/bin/

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["./libra"]
