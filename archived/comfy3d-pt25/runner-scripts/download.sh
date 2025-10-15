#!/bin/bash

set -euo pipefail

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
echo "[INFO] Downloading ComfyUI..."
echo "########################################"

set +e

cd /root
git clone https://github.com/comfyanonymous/ComfyUI.git || git -C ComfyUI pull --ff-only

cd /root/ComfyUI
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

set -e

echo "########################################"
echo "[INFO] Downloading ComfyUI-3D-Pack..."
echo "########################################"

cd /root/ComfyUI/custom_nodes
clone_or_pull https://github.com/YanWenKun/ComfyUI-3D-Pack.git

# Copy example files of 3D-Pack
set +e

mkdir -p /root/ComfyUI/user/default/workflows

cp -r /root/ComfyUI/custom_nodes/ComfyUI-3D-Pack/_Example_Workflows/. \
    /root/ComfyUI/user/default/workflows/

rm -rf /root/ComfyUI/user/default/workflows/_Example_Inputs_Files
rm -rf /root/ComfyUI/user/default/workflows/_Example_Outputs

cp -r /root/ComfyUI/custom_nodes/ComfyUI-3D-Pack/_Example_Workflows/_Example_Inputs_Files/. \
    /root/ComfyUI/input/

set -e

echo "########################################"
echo "[INFO] Downloading Custom Nodes..."
echo "########################################"

cd /root/ComfyUI/custom_nodes

# ComfyUI-Manager
clone_or_pull https://github.com/ltdrdata/ComfyUI-Manager.git

# Nodes used by 3D-Pack
clone_or_pull https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
clone_or_pull https://github.com/edenartlab/eden_comfy_pipelines.git
clone_or_pull https://github.com/kijai/ComfyUI-KJNodes.git
clone_or_pull https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
clone_or_pull https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
clone_or_pull https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git
clone_or_pull https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
clone_or_pull https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git
clone_or_pull https://github.com/WASasquatch/was-node-suite-comfyui.git

# Finish
touch /root/.download-complete
