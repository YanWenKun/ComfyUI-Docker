#!/bin/bash

set -euo pipefail

gcs() {
    git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$@"
}

echo "########################################"
echo "[INFO] Downloading ComfyUI & Nodes..."
echo "########################################"

cd /default-comfyui-bundle
git clone 'https://github.com/comfyanonymous/ComfyUI.git'
cd /default-comfyui-bundle/ComfyUI
# Using stable version (has a release tag)
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

cd /default-comfyui-bundle/ComfyUI/custom_nodes
gcs 'https://github.com/Comfy-Org/ComfyUI-Manager.git'

gcs 'https://github.com/chrisgoringe/cg-use-everywhere.git'
gcs 'https://github.com/cubiq/ComfyUI_essentials.git'
gcs 'https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git'

gcs 'https://github.com/openvino-dev-samples/comfyui_openvino.git'
gcs 'https://github.com/welltop-cn/ComfyUI-TeaCache.git'
gcs 'https://github.com/city96/ComfyUI-GGUF.git'


echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

# VAE Models
cd /default-comfyui-bundle/ComfyUI/models/vae

aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesdxl_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd3_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taef1_decoder.pth'
