#!/bin/bash

set -euo pipefail

gcs() {
    git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$@"
}

echo "########################################"
echo "[INFO] Downloading ComfyUI & Nodes..."
echo "########################################"

mkdir -p /default-comfyui-bundle
cd /default-comfyui-bundle
git clone 'https://github.com/comfyanonymous/ComfyUI.git'
cd /default-comfyui-bundle/ComfyUI
# Using stable version (has a release tag)
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

cd /default-comfyui-bundle/ComfyUI/custom_nodes
gcs https://github.com/Comfy-Org/ComfyUI-Manager.git

# Force ComfyUI-Manager to use PIP instead of UV
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

echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

cd /default-comfyui-bundle/ComfyUI/models/vae_approx
gcs https://github.com/madebyollin/taesd.git
cp taesd/*.pth .
rm -rf taesd
