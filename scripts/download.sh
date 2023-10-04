#!/bin/bash

echo "########################################"
echo "Downloading ComfyUI & components..."
echo "########################################"

set -euxo pipefail

cd /home/runner
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/comfyanonymous/ComfyUI.git \
    || (cd /home/runner/ComfyUI && git pull)

# ControlNet Auxiliary Preprocessors by Fannovel16
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/Fannovel16/comfyui_controlnet_aux.git \
    || (cd /home/runner/ComfyUI/custom_nodes/comfyui_controlnet_aux && git pull)

# ComfyUI Manager
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/ltdrdata/ComfyUI-Manager.git \
    || (cd /home/runner/ComfyUI/custom_nodes/ComfyUI-Manager && git pull)

cd /home/runner/ComfyUI
aria2c --allow-overwrite=false --auto-file-renaming=false --continue=true \
    --max-connection-per-server=5 --input-file=/home/scripts/download.txt

touch /home/runner/.download-complete
