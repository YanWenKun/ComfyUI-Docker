#!/bin/bash

set -euo pipefail

gcs() {
    git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$@"
}

echo "########################################"
echo "[INFO] Downloading Custom Nodes (part 2)..."
echo "########################################"

cd /default-comfyui-bundle/ComfyUI/custom_nodes

# Big boy
gcs https://github.com/ClownsharkBatwing/RES4LYF.git

# To be removed in future
gcs https://github.com/cubiq/ComfyUI_essentials.git
gcs https://github.com/cubiq/ComfyUI_FaceAnalysis.git
gcs https://github.com/cubiq/ComfyUI_InstantID.git
gcs https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
gcs https://github.com/cubiq/PuLID_ComfyUI.git
gcs https://github.com/Gourieff/ComfyUI-ReActor.git ComfyUI-ReActor.disabled
