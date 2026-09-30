#!/bin/sh
ACTION="$1"
DOMAIN="$2"

# Log the action and domain
echo "$(date) - Action: $ACTION, Domain: $DOMAIN" >> /tmp/md-notify.log

# When a certificate is renewed, reload Apache gracefully
if [ "$ACTION" = "renewed" ]; then
    # In official Apache Docker container, PID 1 is httpd
    /usr/bin/kill -USR1 1
fi

