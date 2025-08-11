#!/bin/bash

set -euo pipefail

function gcs() {
    git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$@"
}

function set_repo () {
    git_remote_url=$(git -C "$1" remote get-url origin) ;

    if [[ $git_remote_url =~ ^(https:\/\/github\.com\/)(.*)(\.git)$ ]]; then
        echo "正在修改URL并更新: $1" ;
        git -C "$1" remote set-url origin "https://gh-proxy.com/$git_remote_url" ;
    fi ;
}

echo "########################################"
echo "[INFO] 下载 ComfyUI & Manager..."
echo "########################################"

cd /default-comfyui-bundle
git clone 'https://github.com/comfyanonymous/ComfyUI.git'
cd /default-comfyui-bundle/ComfyUI
# 使用稳定版 ComfyUI（GitHub 上有发布标签）
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

cd /default-comfyui-bundle/ComfyUI/custom_nodes
gcs 'https://github.com/Comfy-Org/ComfyUI-Manager.git'

# 使用镜像站点替换 ComfyUI-Manager 默认仓库地址，避免卡 UI
# 治标但不治本，使用 Manager 全部功能仍需挂代理或魔改
mkdir -p /default-comfyui-bundle/ComfyUI/user/default/ComfyUI-Manager

cat <<EOF > /default-comfyui-bundle/ComfyUI/user/default/ComfyUI-Manager/config.ini
[default]
channel_url = https://gh-proxy.com/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main
EOF

cat <<EOF > /default-comfyui-bundle/ComfyUI/user/default/ComfyUI-Manager/channels.list
default::https://gh-proxy.com/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main
recent::https://gh-proxy.com/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/node_db/new
legacy::https://gh-proxy.com/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/node_db/legacy
forked::https://gh-proxy.com/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/node_db/forked
dev::https://gh-proxy.com/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/node_db/dev
tutorial::https://gh-proxy.com/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/node_db/tutorial
EOF

echo "########################################"
echo "[INFO] 下载扩展组件（自定义节点）……"
echo "########################################"

gcs 'https://github.com/chrisgoringe/cg-use-everywhere.git'
gcs 'https://github.com/cubiq/ComfyUI_essentials.git'
gcs 'https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git'

gcs 'https://github.com/openvino-dev-samples/comfyui_openvino.git'
gcs 'https://github.com/welltop-cn/ComfyUI-TeaCache.git'
gcs 'https://github.com/city96/ComfyUI-GGUF.git'

echo "########################################"
echo "[INFO] 下载模型文件..."
echo "########################################"

# TAESD 模型（用于生成时预览）
cd /default-comfyui-bundle/ComfyUI/models/vae

aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesdxl_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd3_decoder.pth'
aria2c 'https://github.com/madebyollin/taesd/raw/refs/heads/main/taef1_decoder.pth'

echo "########################################"
echo "[INFO] 修改仓库远程地址为 CN 镜像……"
echo "########################################"

cd /default-comfyui-bundle

set_repo 'ComfyUI'

cd /default-comfyui-bundle/ComfyUI/custom_nodes

for D in *; do
    if [ -d "${D}" ]; then
        set_repo "${D}" &
    fi
done
