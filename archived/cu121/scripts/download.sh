#!/bin/bash

echo "########################################"
echo "[INFO] Downloading ComfyUI & Manager..."
echo "########################################"

set -euxo pipefail

# ComfyUI
# Using stable version (has a release tag)
cd /home/runner
(
    git clone https://github.com/comfyanonymous/ComfyUI.git &&
    cd ComfyUI &&
    git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"
) ||
# If fails, try git-pull
(
    cd /home/runner/ComfyUI && git pull
)

# ComfyUI Manager
cd /home/runner/ComfyUI/custom_nodes
git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/ltdrdata/ComfyUI-Manager.git \
    || (cd /home/runner/ComfyUI/custom_nodes/ComfyUI-Manager && git pull)

echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

# Models
cd /home/runner/ComfyUI/models
aria2c --input-file=/home/scripts/download-models.txt \
    --allow-overwrite=false --auto-file-renaming=false --continue=true \
    --max-connection-per-server=5

# Finish
touch /home/runner/.download-complete
