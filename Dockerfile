FROM debian:jessie 
MAINTAINER Alexander Krupenkin <mail@akru.me>
LABEL Description="Cloud Ethereum node" Vendor="Airalab" Version="0.2"

ADD http://d1h4xl4cr1h0mo.cloudfront.net/v1.4.9/x86_64-unknown-linux-gnu/parity_1.4.9_amd64.deb /parity.deb
RUN dpkg -i parity.deb && rm -f parity.deb

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 30303 8545
VOLUME ["/root/.parity/keys"]
