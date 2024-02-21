#!/bin/bash

set -e

cd /home/runner

# Install ComfyUI.
if [ ! -f "/home/runner/.download-complete" ] ; then
    chmod +x /home/scripts/download.sh
    bash /home/scripts/download.sh
fi ;

echo "########################################"
echo "Starting ComfyUI..."
echo "########################################"

export PATH="${PATH}:/home/runner/.local/bin"

cd /home/runner/ComfyUI

python3 main.py --listen --port 8188 ${CLI_ARGS}
