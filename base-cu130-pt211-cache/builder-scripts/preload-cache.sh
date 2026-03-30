#!/bin/bash

set -euo pipefail

echo "########################################"
echo "[INFO] Downloading ComfyUI..."
echo "########################################"

mkdir -p /default-comfyui-bundle

cd /default-comfyui-bundle

git clone 'https://github.com/Comfy-Org/ComfyUI.git'

cd /default-comfyui-bundle/ComfyUI
# Using stable version (has a release tag)
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

cd /default-comfyui-bundle/ComfyUI/models/vae_approx
git clone --depth=1 --no-tags https://github.com/madebyollin/taesd.git
cp taesd/*.pth .
rm -rf taesd
