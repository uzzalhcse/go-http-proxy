#!/bin/bash

# Define the IP addresses of your proxy servers
PROXY1_IP="http://34.146.11.125:3000"
PROXY2_IP="http://34.146.155.165:3000"

# Update and install Nginx
sudo apt update
sudo apt install -y nginx

# Backup the original Nginx configuration file
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

# Create a new Nginx configuration
sudo tee /etc/nginx/nginx.conf > /dev/null <<EOF
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
    # multi_accept on;
}

http {
    upstream proxy_backend {
        server $PROXY1_IP;
        server $PROXY2_IP;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://proxy_backend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOF

# Validate Nginx configuration
sudo nginx -t

# Check if the configuration is valid before restarting Nginx
if [ $? -eq 0 ]; then
    sudo systemctl restart nginx
    echo "Nginx proxy gateway setup complete."
else
    echo "Nginx configuration is invalid. Please check the configuration and try again."
fi