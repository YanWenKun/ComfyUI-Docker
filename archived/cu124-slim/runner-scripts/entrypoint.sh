#!/bin/bash

set -e

# Run user's set-proxy script
cd /root
if [ ! -f "/root/user-scripts/set-proxy.sh" ] ; then
    mkdir -p /root/user-scripts
    cp /runner-scripts/set-proxy.sh.example /root/user-scripts/set-proxy.sh
else
    echo "[INFO] Running set-proxy script..."

    chmod +x /root/user-scripts/set-proxy.sh
    source /root/user-scripts/set-proxy.sh
fi ;

# Install ComfyUI
cd /root
if [ ! -f "/root/.download-complete" ] ; then
    chmod +x /runner-scripts/download.sh
    bash /runner-scripts/download.sh
fi ;

# Run user's pre-start script
cd /root
if [ ! -f "/root/user-scripts/pre-start.sh" ] ; then
    mkdir -p /root/user-scripts
    cp /runner-scripts/pre-start.sh.example /root/user-scripts/pre-start.sh
else
    echo "[INFO] Running pre-start script..."

    chmod +x /root/user-scripts/pre-start.sh
    source /root/user-scripts/pre-start.sh
fi ;


echo "########################################"
echo "[INFO] Starting ComfyUI..."
echo "########################################"

# Let .pyc files be stored in one place
export PYTHONPYCACHEPREFIX="/root/.cache/pycache"
# Let PIP install packages to /root/.local
export PIP_USER=true
# Add above to PATH
export PATH="${PATH}:/root/.local/bin"
# Suppress [WARNING: Running pip as the 'root' user]
export PIP_ROOT_USER_ACTION=ignore

cd /root

python3 ./ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}
