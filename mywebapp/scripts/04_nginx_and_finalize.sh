#!/bin/bash
set -e

echo "8. Config nginx"
cat <<EOF > /etc/nginx/sites-available/mywebapp
server {
    listen 80;
    # Write logs for all http requests
    access_log /var/log/nginx/mywebapp_access.log;

    # http://localhost/(items) => nginx => http://127.0.0.1:5000
    location = / { proxy_pass http://127.0.0.1:5000; }
    location /items { proxy_pass http://127.0.0.1:5000; }

    # Block everything else (e.g., /health endpoints)
    location / { return 403; }
}
EOF

# /etc/nginx/sites-enabled/: nginx auto read config from this folder
# ln create link to file (-s: create link, -f rewrite)
# /etc/nginx/sites-available/mywebapp: original config
# /etc/nginx/sites-enabled/: link to original config
ln -sf /etc/nginx/sites-available/mywebapp /etc/nginx/sites-enabled/
# delete default site from nginx
rm -f /etc/nginx/sites-enabled/default
# reload config for nginx to add our changes (without stop nginx)
systemctl reload nginx

echo "9. Create grade book"
echo "14" > /home/student/gradebook
# owner & group of file
chown student:student /home/student/gradebook

echo "10. Lock default system user"
# disable default user in ubuntu cloud to prevent external access
# -L lock input password
# 2>/dev/null ignore errors; || true -> if fail continue
usermod -L ubuntu 2>/dev/null || true