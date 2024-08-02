#! /bin/bash
# Set ulimit
ulimit -n 1000000
cd /root
curl -O https://raw.githubusercontent.com/uzzalhcse/go-http-proxy/dev/dist/proxy
chmod +x proxy
nohup ./proxy > output.log 2>&1 &