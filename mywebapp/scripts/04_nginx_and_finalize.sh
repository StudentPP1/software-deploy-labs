#!/bin/bash
set -e

echo "8. Config nginx"
cat <<EOF > /etc/nginx/sites-available/mywebapp
server {
    listen 80;
    access_log /var/log/nginx/mywebapp_access.log;

    # Allow access to root and business logic endpoints
    location = / { proxy_pass http://127.0.0.1:5000; }
    location /items { proxy_pass http://127.0.0.1:5000; }

    # Block everything else (e.g., /health endpoints)
    location / { return 403; }
}
EOF

# Enable the new site and disable the default one
ln -sf /etc/nginx/sites-available/mywebapp /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
systemctl reload nginx

echo "9. Create grade book"
echo "14" > /home/student/gradebook
chown student:student /home/student/gradebook

echo "10. Lock default system user"
# Prevent login for standard cloud image users
usermod -L ubuntu 2>/dev/null || true