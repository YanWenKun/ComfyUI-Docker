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

cd /root
set +e
git clone https://github.com/comfyanonymous/ComfyUI.git \
    || git -C "ComfyUI" pull --ff-only
set -e

echo "########################################"
echo "[INFO] Downloading ComfyUI-3D-Pack..."
echo "########################################"

cd /root/ComfyUI/custom_nodes
set +e
git clone --recurse-submodules https://github.com/MrForExample/ComfyUI-3D-Pack.git \
    || git -C "ComfyUI-3D-Pack" pull --ff-only ;
set -e

git -C "ComfyUI-3D-Pack" reset --hard b015ed3918d6916ff2a2ee230beafe2169a5de51


echo "########################################"
echo "[INFO] Downloading Custom Nodes..."
echo "########################################"

cd /root/ComfyUI/custom_nodes

# ComfyUI-Manager can do re-install of dependencies, which is not wanted for 3D-Pack.
# Here we download it but disable it by default.
clone_or_pull https://github.com/ltdrdata/ComfyUI-Manager.git
mv ComfyUI-Manager ComfyUI-Manager.disabled

# GUI Translation
clone_or_pull https://github.com/AIGODLIKE/AIGODLIKE-ComfyUI-Translation.git

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
