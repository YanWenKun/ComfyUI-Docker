#!/bin/bash

set -euo pipefail

echo "########################################"
echo "[INFO] Downloading ComfyUI..."
echo "########################################"

cd /root
set +e
git clone https://github.com/comfyanonymous/ComfyUI.git \
    || git -C "ComfyUI" pull --ff-only
set -e

# ComfyUI-Manager can do re-install of dependencies, which is not wanted for 3D-Pack.
# Uncomment the commands below if you still want to have ComfyUI-Manager.

# cd /root/ComfyUI/custom_nodes
# set +e
# git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
#     https://github.com/ltdrdata/ComfyUI-Manager.git \
#     || git -C "ComfyUI-Manager" pull --ff-only
# set -e

echo "########################################"
echo "[INFO] Downloading ComfyUI-3D-Pack..."
echo "########################################"

cd /root/ComfyUI/custom_nodes
set +e
git clone --recurse-submodules https://github.com/MrForExample/ComfyUI-3D-Pack.git \
    || git -C "ComfyUI-3D-Pack" pull --ff-only ;
set -e

git -C "ComfyUI-3D-Pack" reset --hard c1718943d8e13844332c346285685681fdba3070


# Finish
touch /root/.download-complete
