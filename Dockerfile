# Copyright (C) 2018 Sebastian Pipping <sebastian@pipping.org>
# Licensed under the MIT license

FROM alpine:3.17

RUN echo '@edge-testing https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
        && \
    apk add --update \
        gatling@edge-testing \
        jekyll

RUN jekyll -v

# Render website
WORKDIR /root/site
COPY _includes/ _includes/
COPY _layouts/ _layouts/
COPY _posts/ _posts/
COPY css/ css/
COPY dokumentation/ dokumentation/
COPY downloads/ downloads/
COPY img/ img/
COPY kontakt/ kontakt/
COPY support/ support/
COPY _config.yml index.html ./
RUN jekyll build --destination /var/www/default --trace

# Serve website
# -F        no FTP
# -S        no Samba
# -d        enable directory listings
# -c <DIR>  change into and serve directory <DIR>
EXPOSE 80
CMD ["gatling", "-F", "-S", "-d", "-c", "/var/www/default"]
