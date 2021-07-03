#!/bin/bash

set -euo pipefail
IFS=$'\n\t'
set -x

DATETIME="$(date +'%Y-%m-%dT%H:%M:%SZ')"

rm /tmp/cloudflare-real-ip.conf || true
(
  curl -sfL 'https://www.cloudflare.com/ips-v4'
  curl -sfL 'https://www.cloudflare.com/ips-v6'
) | (
  while read addr; do
    ufw allow in from "$addr" to any port 443 proto tcp comment "[update-cf-ips-$DATETIME]"
    echo "set_real_ip_from $addr;" >>/tmp/cloudflare-real-ip.conf
  done
)

while :; do
  NUMBER="$(ufw status numbered \
    | fgrep update-cf-ips \
    | fgrep -v "$DATETIME" \
    | head -n1 \
    | perl -pe 's,^\[\s*(\d+)\].*,\1,g;' || true)"
  test -z "$NUMBER" && break
  yes | ufw delete "$NUMBER" || true
done

chmod 644 /tmp/cloudflare-real-ip.conf
chown root:root /tmp/cloudflare-real-ip.conf
mv /tmp/cloudflare-real-ip.conf /etc/nginx/snippets/cloudflare-real-ip.conf
systemctl reload nginx
