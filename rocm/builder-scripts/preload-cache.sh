#!/bin/bash

set -euo pipefail

gcs() {
    git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$@"
}

echo "########################################"
echo "[INFO] Downloading ComfyUI & Nodes..."
echo "########################################"

mkdir -p /default-comfyui-bundle
cd /default-comfyui-bundle
git clone 'https://github.com/comfyanonymous/ComfyUI.git'
cd /default-comfyui-bundle/ComfyUI
# Using stable version (has a release tag)
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

cd /default-comfyui-bundle/ComfyUI/custom_nodes
gcs https://github.com/Comfy-Org/ComfyUI-Manager.git

# Force ComfyUI-Manager to use PIP instead of UV
mkdir -p /default-comfyui-bundle/ComfyUI/user/__manager

cat <<EOF > /default-comfyui-bundle/ComfyUI/user/__manager/config.ini
[default]
use_uv = False
EOF

# General
gcs https://github.com/ltdrdata/was-node-suite-comfyui.git
gcs https://github.com/chrisgoringe/cg-use-everywhere.git
gcs https://github.com/cubiq/ComfyUI_essentials.git
gcs https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git

# Control
gcs https://github.com/cubiq/ComfyUI_InstantID.git
gcs https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
gcs https://github.com/cubiq/PuLID_ComfyUI.git
gcs https://github.com/Fannovel16/comfyui_controlnet_aux.git
gcs https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
gcs https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
gcs https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git
gcs https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git

# Video
gcs https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
gcs https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git

# Other
gcs https://github.com/cubiq/ComfyUI_FaceAnalysis.git

echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

# VAE Models
cd /default-comfyui-bundle/ComfyUI/models/vae

aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesdxl_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd3_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taef1_decoder.pth'
