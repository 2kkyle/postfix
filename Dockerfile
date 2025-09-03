FROM debian:stable-slim

# Install Postfix only
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y postfix ca-certificates gettext && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy config and script
COPY postfix/main.cf /etc/postfix/main.cf
COPY postfix/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 25

CMD ["/entrypoint.sh"]

