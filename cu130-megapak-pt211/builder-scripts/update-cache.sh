#!/bin/bash

set -euo pipefail

function git_force_sync () {
    git_remote_url=$(git -C "$1" remote get-url origin)

    if [[ $git_remote_url =~ ^(https:\/\/github\.com\/)(.*)(\.git)$ ]]; then
        git -C "$1" fetch --depth=1 --no-tags

        _local_head=$(git -C "$1" rev-parse HEAD)
        _remote_head=$(git -C "$1" rev-parse '@{upstream}')

        if [ "$_local_head" != "$_remote_head" ]; then
            echo "[INFO] Updating: $1"

            if ! git -C "$1" pull --ff-only; then
                git -C "$1" reset --hard '@{upstream}'
            fi

            git -C "$1" submodule update --init --recursive --depth=1
            echo "[INFO] Done Updating: $1"
        fi
    fi
}

echo "########################################"
echo "[INFO] Updating ComfyUI..."

cd /default-comfyui-bundle/ComfyUI

git fetch --all --tags --prune --prune-tags
git reset --hard '@{upstream}'

# Using stable version (has a release tag)
git reset --hard "$(git tag -l 'v*' | sort -V | tail -1)"

echo "########################################"
echo "[INFO] Updating Custom Nodes..."

cd /default-comfyui-bundle/ComfyUI/custom_nodes

for D in *; do
    if [ -d "${D}" ]; then
        git_force_sync "${D}" &
    fi
done

# Do not quote (jobs -p), word splitting is intended here.
wait $(jobs -p)

echo "########################################"
echo "[INFO] Installing additional Custom Nodes..."

cd /default-comfyui-bundle/ComfyUI/custom_nodes

# FastVideo
git clone --depth=1 --no-tags \
    https://github.com/hao-ai-lab/FastVideo.git \
    /tmp/FastVideo

mkdir -p /default-comfyui-bundle/ComfyUI/custom_nodes/FastVideo
cp --archive --update=none "/tmp/FastVideo/comfyui/." "/default-comfyui-bundle/ComfyUI/custom_nodes/FastVideo/"
rm -rf /tmp/FastVideo

# ComfyUI-SageAttention3
# A simple connector node for adapting SA3
cd /default-comfyui-bundle/ComfyUI/custom_nodes
git clone --depth=1 --no-tags \
https://github.com/wallen0322/ComfyUI-SageAttention3.git

echo "########################################"
echo "[INFO] Configuring ComfyUI & Manager..."

mkdir -p /default-comfyui-bundle/ComfyUI/user/default

# Enable TAESD preview by default
cat <<EOF > /default-comfyui-bundle/ComfyUI/user/default/comfy.settings.json
{
    "Comfy.Execution.PreviewMethod": "taesd"
}
EOF

# Configure Manager
mkdir -p /default-comfyui-bundle/ComfyUI/user/__manager

cat <<EOF > /default-comfyui-bundle/ComfyUI/user/__manager/config.ini
[default]
use_uv = False
security_level = weak
downgrade_blacklist = torch, torchvision, torchaudio
db_mode = local
network_mode = personal_cloud
EOF

echo "########################################"
echo "[INFO] Separating Custom Nodes from ComfyUI..."

cd /default-comfyui-bundle/

mkdir -p /default-comfyui-bundle/C_NODES

mv /default-comfyui-bundle/ComfyUI/custom_nodes/* \
   /default-comfyui-bundle/C_NODES/
