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

# Force ComfyUI-Manager to use PIP instead of UV
mkdir -p /default-comfyui-bundle/ComfyUI/user/__manager

cat <<EOF > /default-comfyui-bundle/ComfyUI/user/__manager/config.ini
[default]
use_uv = False
security_level = weak
EOF

cd /default-comfyui-bundle/ComfyUI/custom_nodes

# Performance
gcs https://github.com/openvino-dev-samples/comfyui_openvino.git
gcs https://github.com/welltop-cn/ComfyUI-TeaCache.git
gcs https://github.com/city96/ComfyUI-GGUF.git

# Workspace
gcs https://github.com/crystian/ComfyUI-Crystools.git

# General
gcs https://github.com/ltdrdata/was-node-suite-comfyui.git
gcs https://github.com/kijai/ComfyUI-KJNodes.git
gcs https://github.com/bash-j/mikey_nodes.git
gcs https://github.com/chrisgoringe/cg-use-everywhere.git
gcs https://github.com/jags111/efficiency-nodes-comfyui.git
gcs https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
gcs https://github.com/rgthree/rgthree-comfy.git
gcs https://github.com/shiimizu/ComfyUI_smZNodes.git
gcs https://github.com/yolain/ComfyUI-Easy-Use.git

# Control
gcs https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
gcs https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git
gcs https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
gcs https://github.com/Fannovel16/comfyui_controlnet_aux.git
gcs https://github.com/florestefano1975/comfyui-portrait-master.git
gcs https://github.com/huchenlei/ComfyUI-layerdiffuse.git
gcs https://github.com/kijai/ComfyUI-Florence2.git
gcs https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
gcs https://github.com/mcmonkeyprojects/sd-dynamic-thresholding.git
gcs https://github.com/twri/sdxl_prompt_styler.git

# Video
gcs https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
gcs https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
gcs https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
gcs https://github.com/melMass/comfy_mtb.git

# More
gcs https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git
gcs https://github.com/SLAPaper/ComfyUI-Image-Selector.git
gcs https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git

# To be removed in future
gcs https://github.com/cubiq/ComfyUI_essentials.git
gcs https://github.com/Gourieff/ComfyUI-ReActor.git ComfyUI-ReActor.disabled


echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

# VAE Models
cd /default-comfyui-bundle/ComfyUI/models/vae

aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesdxl_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd3_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taef1_decoder.pth'
