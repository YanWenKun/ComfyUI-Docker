#!/bin/bash
set -eu

# Tip: Within containers, you cannot access your host machine via 127.0.0.1.
# You can use "host.docker.internal"(for Docker) or "host.containers.internal"(for Podman)

# Example of setting proxy
#export HTTP_PROXY=http://host.docker.internal:1081
#export HTTPS_PROXY=$HTTP_PROXY
#export http_proxy=$HTTP_PROXY
#export https_proxy=$HTTP_PROXY
#export NO_PROXY="localhost,*.local,*.internal,[::1],fd00::/7,
#10.0.0.0/8,127.0.0.0/8,169.254.0.0/16,172.16.0.0/12,192.168.0.0/16,
#10.*,127.*,169.254.*,172.16.*,172.17.*,172.18.*,172.19.*,172.20.*,
#172.21.*,172.22.*,172.23.*,172.24.*,172.25.*,172.26.*,172.27.*,
#172.28.*,172.29.*,172.30.*,172.31.*,172.32.*,192.168.*"
#export no_proxy=$NO_PROXY
#echo "[INFO] Proxy set to $HTTP_PROXY"

echo "[INFO] Continue without proxy."
