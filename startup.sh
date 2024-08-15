#!/bin/bash
# Set ulimit
ulimit -n 1000000

# Change to root directory
cd /root

# Download the proxy executable
curl -O https://raw.githubusercontent.com/uzzalhcse/go-http-proxy/dev/dist/proxy

# Make the proxy executable
chmod +x proxy

# Install nvm, Node.js, and PM2
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Ensure nvm is loaded in the current shell session
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js version 20
nvm install v20

# Install PM2 globally
npm install pm2 -g

# Start the proxy using PM2
pm2 start ./proxy --name go-http-proxy

# Save the PM2 process list and configure it to start on boot
pm2 save
pm2 startup
