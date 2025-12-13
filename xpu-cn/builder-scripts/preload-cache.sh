#!/bin/bash
# 先从 GitHub 下载仓库，再修改仓库远程地址到镜像站

set -euo pipefail

function gcs() {
    git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$@"
}

function set_repo () {
    git_remote_url=$(git -C "$1" remote get-url origin) ;

    if [[ $git_remote_url =~ ^(https:\/\/github\.com\/)(.*)(\.git)$ ]]; then
        echo "正在替换为 GitHub 代理地址: $1" ;
        git -C "$1" remote set-url origin "https://gh-proxy.org/$git_remote_url" ;
    fi ;
}

echo "########################################"
echo "[INFO] 下载 ComfyUI & 扩展节点..."
echo "########################################"

cd /default-comfyui-bundle
git clone 'https://github.com/comfyanonymous/ComfyUI.git'
cd /default-comfyui-bundle/ComfyUI
# 使用稳定版 ComfyUI（GitHub 上有发布标签）
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

echo "########################################"
echo "[INFO] 配置 ComfyUI-Manager..."
echo "########################################"

# 使用镜像站点替换 ComfyUI-Manager 默认仓库地址，避免卡 UI
# 治标但不治本，使用 Manager 全部功能仍需挂代理或魔改
mkdir -p /default-comfyui-bundle/ComfyUI/user/__manager

cat <<EOF > /default-comfyui-bundle/ComfyUI/user/__manager/config.ini
[default]
channel_url = https://gh-proxy.org/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main
use_uv = False
security_level = weak
EOF

cat <<EOF > /default-comfyui-bundle/ComfyUI/user/__manager/channels.list
default::https://gh-proxy.org/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main
recent::https://gh-proxy.org/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/node_db/new
legacy::https://gh-proxy.org/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/node_db/legacy
forked::https://gh-proxy.org/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/node_db/forked
dev::https://gh-proxy.org/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/node_db/dev
tutorial::https://gh-proxy.org/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/node_db/tutorial
EOF

echo "########################################"
echo "[INFO] 下载扩展组件（自定义节点）……"
echo "########################################"

cd /default-comfyui-bundle/ComfyUI/custom_nodes

# 性能
gcs https://github.com/openvino-dev-samples/comfyui_openvino.git
gcs https://github.com/welltop-cn/ComfyUI-TeaCache.git
gcs https://github.com/city96/ComfyUI-GGUF.git

# 工作空间
gcs https://github.com/crystian/ComfyUI-Crystools.git

# 综合
gcs https://github.com/ltdrdata/was-node-suite-comfyui.git
gcs https://github.com/kijai/ComfyUI-KJNodes.git
gcs https://github.com/bash-j/mikey_nodes.git
gcs https://github.com/chrisgoringe/cg-use-everywhere.git
gcs https://github.com/jags111/efficiency-nodes-comfyui.git
gcs https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
gcs https://github.com/rgthree/rgthree-comfy.git
gcs https://github.com/shiimizu/ComfyUI_smZNodes.git
gcs https://github.com/yolain/ComfyUI-Easy-Use.git

# 控制
gcs https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
gcs https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git
gcs https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
gcs https://github.com/Fannovel16/comfyui_controlnet_aux.git
gcs https://github.com/florestefano1975/comfyui-portrait-master.git
gcs https://github.com/huchenlei/ComfyUI-layerdiffuse.git
gcs https://github.com/kijai/ComfyUI-Florence2.git
gcs https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
gcs https://github.com/mcmonkeyprojects/sd-dynamic-thresholding.git
gcs https://github.com/twri/sdxl_prompt_styler.git

# 视频
gcs https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
gcs https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
gcs https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
gcs https://github.com/melMass/comfy_mtb.git

# 其他
gcs https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git
gcs https://github.com/SLAPaper/ComfyUI-Image-Selector.git
gcs https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git

# 已停更，待删除
gcs https://github.com/cubiq/ComfyUI_essentials.git
gcs https://github.com/Gourieff/ComfyUI-ReActor.git ComfyUI-ReActor.disabled


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
        set_repo "${D}"
    fi
done
