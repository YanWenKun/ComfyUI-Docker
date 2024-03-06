#!/bin/bash

set -e

cd /home/runner

# Install ComfyUI.
if [ ! -f "/home/runner/.download-complete" ] ; then
    chmod +x /home/scripts/download.sh
    bash /home/scripts/download.sh
fi ;

if [ -f "/home/runner/scripts/pre-start.sh" ]; then
    echo "########################################"
    echo "Checking for pre-start script..."
    echo "########################################"
    
    chmod +x /home/runner/scripts/pre-start.sh
    bash /home/runner/scripts/pre-start.sh
else
    echo "No pre-start script found. Skipping."
fi


echo "########################################"
echo "Starting ComfyUI..."
echo "########################################"

export PATH="${PATH}:/home/runner/.local/bin"

cd /home/runner

python3 ./ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}
