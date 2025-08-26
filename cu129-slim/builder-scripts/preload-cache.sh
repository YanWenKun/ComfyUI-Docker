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

echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

# VAE Models
cd /default-comfyui-bundle/ComfyUI/models/vae

aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesdxl_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd3_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taef1_decoder.pth'
