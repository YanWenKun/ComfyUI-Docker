#!/bin/bash

set -euo pipefail

# Note: the "${BASH_REMATCH[2]}" here is REPO_NAME
# from [https://example.com/somebody/REPO_NAME.git] or [git@example.com:somebody/REPO_NAME.git]
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
echo "[INFO] Downloading Direct3D-S2..."
echo "########################################"

set +e
cd /root
git clone https://github.com/DreamTechAI/Direct3D-S2.git || git -C "Direct3D-S2" pull --ff-only
set -e
