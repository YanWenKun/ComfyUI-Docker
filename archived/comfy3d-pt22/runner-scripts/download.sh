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
echo "[INFO] Downloading ComfyUI..."
echo "########################################"

# Using stable version (has a release tag)
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

set +e
git clone --recurse-submodules https://github.com/MrForExample/ComfyUI-3D-Pack.git \
    || git -C "ComfyUI-3D-Pack" pull --ff-only ;
set -e

git -C "ComfyUI-3D-Pack" reset --hard 3b4e715939376634c68aa4c1c7d4ea4a8665c098


# Finish
touch /root/.download-complete
