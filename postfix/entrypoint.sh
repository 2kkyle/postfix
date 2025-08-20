#!/bin/bash
set -e

# Inject environment variables into main.cf
envsubst < /etc/postfix/main.cf > /etc/postfix/main.cf.tmp && mv /etc/postfix/main.cf.tmp /etc/postfix/main.cf

# Start Postfix in foreground
exec postfix start-fg

