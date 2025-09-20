#!/bin/bash

set -e

# Run user's set-proxy script
cd /home/runner
if [ -f "/home/runner/scripts/set-proxy.sh" ] ; then
    echo "[INFO] Running set-proxy script..."

    chmod +x /home/runner/scripts/set-proxy.sh
    source /home/runner/scripts/set-proxy.sh
fi ;

# Install ComfyUI
cd /home/runner
if [ ! -f "/home/runner/.download-complete" ] ; then
    chmod +x /home/scripts/download.sh
    bash /home/scripts/download.sh
fi ;

# Run user's pre-start script
cd /home/runner
if [ -f "/home/runner/scripts/pre-start.sh" ] ; then
    echo "[INFO] Running pre-start script..."

    chmod +x /home/runner/scripts/pre-start.sh
    source /home/runner/scripts/pre-start.sh
else
    echo "[INFO] No pre-start script found. Skipping."
fi ;


echo "########################################"
echo "[INFO] Starting ComfyUI..."
echo "########################################"

export PATH="${PATH}:/home/runner/.local/bin"
export PYTHONPYCACHEPREFIX="/home/runner/.cache/pycache"

cd /home/runner

python3 ./ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}
