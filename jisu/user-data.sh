#!/bin/bash
sudo yum install httpd -y
cat <<'EOF' >> /etc/httpd/conf.d/httpd-vhosts.conf
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so
<VirtualHost *:80>
  ProxyRequests off
  ProxyPreserveHost On
  ProxyPass / http://a9b750a8a1f494df2adb4896ab32078c-761282924.us-east-2.elb.amazonaws.com:8080/ acquire=3000 timeout=600 Keepalive=On
  ProxyPassReverse / http://a9b750a8a1f494df2adb4896ab32078c-761282924.us-east-2.elb.amazonaws.com:8080/
</VirtualHost>
EOF
sudo systemctl enable --now httpd