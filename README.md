# ubuntu-nginx-cf-only

Configuration for NGINX to allow only CloudFlare to access your server. Tested with Ubuntu
Server 20.04.

## Installation

```
# cd ubuntu-nginx-cf-only
# bash mkpkg.sh
# cat ubuntu-nginx-cf-only.tar.gz | sudo tar -xzC /
# sudo systemctl daemon-reload
# sudo systemctl enable update-cf-ips.timer
# sudo /usr/local/bin/update-cf-ips.sh
```

Check if the correct rules have been added to UFW by typing `sudo ufw status`, and check if the
CloudFlare IPs have been added to `/etc/nginx/snippets/cloudflare-real-ip.conf`.

Then install your CloudFlare certificate at `/etc/ssl/cloudflare-origin.{key,pem}` (make sure to
have the .key file with perms 600), and add `include snippets/cloudflare.conf;` to your site config
at `/etc/nginx/sites-available`.

# Credits

Created by André Kugland &lt;kugland@gmail.com&gt;
