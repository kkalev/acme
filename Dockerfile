FROM httpd:2.4-trixie

RUN apt-get update && \
    apt-get install -y --no-install-recommends procps libcap2-bin && \
    setcap 'cap_kill+ep' /usr/bin/kill && \
    rm -rf /var/lib/apt/lists/*

# Ensure persistent directory exists for ACME state/keys
RUN mkdir -p /usr/local/apache2/md && \
    chown -R www-data:www-data /usr/local/apache2/md

# Copy your configuration
COPY ./httpd-md.conf /usr/local/apache2/conf/extra/httpd-md.conf

# Copy md-notify script
COPY --chmod=0755 ./md-notify.sh /usr/local/bin/md-notify.sh

# Enable inclusion in main configuration
RUN echo "Include conf/extra/httpd-md.conf" >> /usr/local/apache2/conf/httpd.conf

ENV ACME_CONTACT_EMAIL=identity@gunet.gr
ENV ACME_DIRECTORY_URL=https://acme-v02.api.letsencrypt.org/directory
ENV ACME_EAB_KID=your-eab-kid
ENV ACME_EAB_HMAC=your-eab-hmac
ENV APP_DOMAIN=yourdomain.com
ENV TZ=Europe/Athens