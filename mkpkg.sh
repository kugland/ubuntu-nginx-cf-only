#!/bin/bash

cd "$(dirname "$(realpath "$0")")"

install -m644 cloudflare.conf -D -t pkg/etc/nginx/snippets
install -m644 origin-pull-ca.pem -D -t pkg/etc/ssl
install -m644 update-cf-ips.{service,timer} -D -t pkg/etc/systemd/system
install -m755 update-cf-ips.sh -D -t pkg/usr/local/bin

tar -C pkg --owner 0 --group 0 -c etc usr |gzip >ubuntu-nginx-cf-only.tar.gz
