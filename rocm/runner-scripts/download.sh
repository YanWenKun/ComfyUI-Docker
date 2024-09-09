#!/bin/bash

set -euo pipefail

# Regex that matches REPO_NAME
# First from pattern [https://example.com/xyz/REPO_NAME.git] or [git@example.com:xyz/REPO_NAME.git]
# Second from pattern [http(s)://example.com/xyz/REPO_NAME]
# They all extract REPO_NAME to BASH_REMATCH[2]
function clone_or_pull () {
    if [[ $1 =~ ^(.*[/:])(.*)(\.git)$ ]] || [[ $1 =~ ^(http.*\/)(.*)$ ]]; then
        echo "${BASH_REMATCH[2]}" ;
        set +e ;
            git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$1" \
                || git -C "${BASH_REMATCH[2]}" pull --ff-only ;
        set -e ;
    else
        echo "[ERROR] Invalid URL: $1" ;
        return 1 ;
    fi ;
}


echo "########################################"
echo "[INFO] Downloading ComfyUI & Manager..."
echo "########################################"

cd /root
clone_or_pull https://github.com/comfyanonymous/ComfyUI.git

cd /root/ComfyUI/custom_nodes
clone_or_pull https://github.com/ltdrdata/ComfyUI-Manager.git


echo "########################################"
echo "[INFO] Downloading Custom Nodes..."
echo "########################################"

cd /root/ComfyUI/custom_nodes

# Workspace
clone_or_pull https://github.com/AIGODLIKE/AIGODLIKE-ComfyUI-Translation.git
clone_or_pull https://github.com/crystian/ComfyUI-Crystools.git
clone_or_pull https://github.com/crystian/ComfyUI-Crystools-save.git

# General
clone_or_pull https://github.com/chrisgoringe/cg-use-everywhere.git
clone_or_pull https://github.com/cubiq/ComfyUI_essentials.git
clone_or_pull https://github.com/jags111/efficiency-nodes-comfyui.git
clone_or_pull https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git

# Control
clone_or_pull https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
clone_or_pull https://github.com/Fannovel16/comfyui_controlnet_aux.git
clone_or_pull https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
clone_or_pull https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
clone_or_pull https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
clone_or_pull https://github.com/twri/sdxl_prompt_styler.git

# Video
clone_or_pull https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
clone_or_pull https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
clone_or_pull https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git


echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

# Models
cd /root/ComfyUI
aria2c \
  --input-file=/runner-scripts/download.txt \
  --allow-overwrite=false \
  --auto-file-renaming=false \
  --continue=true \
  --max-connection-per-server=5

# Finish
touch /root/.download-complete
