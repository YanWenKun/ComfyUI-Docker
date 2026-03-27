#!/bin/bash

set -euo pipefail

function git_force_sync () {
    git_remote_url=$(git -C "$1" remote get-url origin) ;

    if [[ $git_remote_url =~ ^(https:\/\/github\.com\/)(.*)(\.git)$ ]]; then
        echo "Updating: $1" ;
        git -C "$1" fetch --all --tags --prune --prune-tags ;
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

wait "$(jobs -p)"

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

# Have to add all items or Manager won't persist the config.
cat <<EOF > /default-comfyui-bundle/ComfyUI/user/__manager/config.ini
[default]
use_uv = False
security_level = weak
downgrade_blacklist = torch, torchvision, torchaudio
preview_method = 
git_exe = 
channel_url = 
share_option = 
bypass_ssl = 
file_logging = 
component_policy = 
update_policy = 
windows_selector_event_loop_policy = 
model_download_by_agent = 
always_lazy_install = 
network_mode = 
db_mode = 
EOF
