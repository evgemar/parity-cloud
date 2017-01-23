FROM debian:jessie 
MAINTAINER Alexander Krupenkin <mail@akru.me>
LABEL Description="Cloud Ethereum node" Vendor="Airalab" Version="0.4"

ADD http://d1h4xl4cr1h0mo.cloudfront.net/v1.5.0/x86_64-unknown-linux-gnu/parity_1.5.0_amd64.deb /tmp/parity.deb
RUN apt-get update && apt-get install -y libssl1.0.0
RUN dpkg -x /tmp/parity.deb /tmp/parity \
    && cp /tmp/parity/usr/bin/parity /usr/local/bin/ \
    && rm -rf /tmp/parity*

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 30303 8545
VOLUME ["/root/.local/share/io.parity.ethereum/keys"]
