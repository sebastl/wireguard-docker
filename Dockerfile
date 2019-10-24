FROM debian:buster

RUN echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list \
    && printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        linux-headers-$(uname -r) \
        wireguard-tools \
        iptables \
        nano \
        net-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /scripts
ENV PATH="/scripts:${PATH}"
COPY install-module /scripts
COPY run /scripts
COPY genkeys /scripts
RUN chmod 755 /scripts/*

CMD ["run"]
