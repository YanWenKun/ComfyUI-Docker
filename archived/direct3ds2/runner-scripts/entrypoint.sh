#!/bin/bash

set -e

# Let .pyc files be stored in one place
export PYTHONPYCACHEPREFIX="/root/.cache/pycache"
# Let PIP install packages to /root/.local
export PIP_USER=true
# Add above to PATH
export PATH="${PATH}:/root/.local/bin"
# Suppress [WARNING: Running pip as the 'root' user]
export PIP_ROOT_USER_ACTION=ignore

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

# Download/Update D3DS2
cd /root
chmod +x /runner-scripts/download-repo.sh
bash /runner-scripts/download-repo.sh

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

# Build Dependencies
cd /root
if [ ! -f "/root/.build-complete" ] ; then
    chmod +x /runner-scripts/build-deps.sh
    bash /runner-scripts/build-deps.sh
fi ;

# Download Models
# Try only once. If first download failed, the Gradio app will download on demand.
cd /root
if [ ! -f "/root/.download-complete" ] ; then
    chmod +x /runner-scripts/download-models.sh
    bash /runner-scripts/download-models.sh
    touch /root/.download-complete
fi ;

echo "########################################"
echo "[INFO] Starting Direct3D-S2..."
echo "########################################"

cd /root
python3 ./Direct3D-S2/app.py
