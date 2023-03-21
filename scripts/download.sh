#!/bin/bash

echo "########################################"
echo "Downloading ComfyUI & components..."
echo "########################################"

set -euxo pipefail

cd /home/runner
git clone https://github.com/comfyanonymous/ComfyUI.git

# Controlnet Preprocessor nodes by Fannovel16
cd /home/runner/ComfyUI/custom_nodes
git clone https://github.com/Fannovel16/comfy_controlnet_preprocessors

cd /home/runner/ComfyUI
aria2c --allow-overwrite=false --auto-file-renaming=false --continue=true \
    --max-connection-per-server=5 --input-file=/home/scripts/download.txt
