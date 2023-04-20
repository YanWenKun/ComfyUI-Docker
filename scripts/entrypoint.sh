#!/bin/bash

set -e

cd /home/runner

# Install ComfyUI or update it.
if [ ! -f "/home/runner/.download-complete" ] ; then
    chmod +x /home/scripts/download.sh
    bash /home/scripts/download.sh
else
    # If update failed, just skip.
    set +e
    chmod +x /home/scripts/update.sh
    bash /home/scripts/update.sh
    set -e
fi ;

echo "########################################"
echo "Starting ComfyUI..."
echo "########################################"

cd /home/runner/ComfyUI

python3 main.py --listen --port 8188 ${CLI_ARGS}
