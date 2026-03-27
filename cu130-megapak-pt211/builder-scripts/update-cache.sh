#!/bin/bash

set -euo pipefail

function git_force_sync () {
    git_remote_url=$(git -C "$1" remote get-url origin) ;

    if [[ $git_remote_url =~ ^(https:\/\/github\.com\/)(.*)(\.git)$ ]]; then
        echo "Updating: $1" ;
        git -C "$1" fetch ;
        git -C "$1" reset --hard '@{upstream}' ;
        echo "Done Updating: $1" ;
    fi ;
}

echo "########################################"
echo "[INFO] Updating ComfyUI & Nodes..."
echo "########################################"

cd /default-comfyui-bundle/ComfyUI

git fetch --all --tags --prune --prune-tags
git reset --hard '@{upstream}'

# Using stable version (has a release tag)
git reset --hard "$(git tag -l 'v*' | sort -V | tail -1)"

cd /default-comfyui-bundle/ComfyUI/custom_nodes

for D in *; do
    if [ -d "${D}" ]; then
        git_force_sync "${D}" &
    fi
done

wait

# Install FastVideo
git clone --depth=1 --no-tags \
    https://github.com/hao-ai-lab/FastVideo.git \
    /tmp/FastVideo

mkdir -p /default-comfyui-bundle/ComfyUI/custom_nodes/FastVideo
cp --archive --update=none "/tmp/FastVideo/comfyui/." "/default-comfyui-bundle/ComfyUI/custom_nodes/FastVideo/"
rm -rf /tmp/FastVideo

# Install ComfyUI-SageAttention3
# A simple connector node for adapting SA3
cd /default-comfyui-bundle/ComfyUI/custom_nodes
git clone --depth=1 --no-tags \
https://github.com/wallen0322/ComfyUI-SageAttention3.git

echo "########################################"
echo "[INFO] Configuring ComfyUI & Nodes..."
echo "########################################"

mkdir -p /default-comfyui-bundle/ComfyUI/user/default

# Enable TAESD preview by default
cat <<EOF > /default-comfyui-bundle/ComfyUI/user/default/comfy.settings.json
{
    "Comfy.Execution.PreviewMethod": "taesd"
}
EOF

cd /default-comfyui-bundle/ComfyUI/custom_nodes/ComfyUI-Manager

# Disable Manager's cache update on startup ("FETCH ComfyRegistry Data")
grep -n "run(default_cache_update())" ./glob/manager_server.py && 
sed -i.bak '/run(default_cache_update())/d' ./glob/manager_server.py

# Configure Manager
mkdir -p /default-comfyui-bundle/ComfyUI/user/__manager

cat <<EOF > /default-comfyui-bundle/ComfyUI/user/__manager/config.ini
[default]
use_uv = False
security_level = weak
downgrade_blacklist = torch, torchvision, torchaudio
EOF
