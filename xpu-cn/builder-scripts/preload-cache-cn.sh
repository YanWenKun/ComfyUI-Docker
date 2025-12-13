#!/bin/bash
# 直接从 GitHub 镜像站下载仓库

set -euo pipefail

function gcs() {
    git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$@"
}

echo "########################################"
echo "[INFO] 下载 ComfyUI..."
echo "########################################"

cd /default-comfyui-bundle
git clone 'https://gh-proxy.org/https://github.com/comfyanonymous/ComfyUI.git'
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
gcs https://gh-proxy.org/https://github.com/openvino-dev-samples/comfyui_openvino.git
gcs https://gh-proxy.org/https://github.com/welltop-cn/ComfyUI-TeaCache.git
gcs https://gh-proxy.org/https://github.com/city96/ComfyUI-GGUF.git

# 工作空间
gcs https://gh-proxy.org/https://github.com/crystian/ComfyUI-Crystools.git

# 综合
gcs https://gh-proxy.org/https://github.com/ltdrdata/was-node-suite-comfyui.git
gcs https://gh-proxy.org/https://github.com/kijai/ComfyUI-KJNodes.git
gcs https://gh-proxy.org/https://github.com/bash-j/mikey_nodes.git
gcs https://gh-proxy.org/https://github.com/chrisgoringe/cg-use-everywhere.git
gcs https://gh-proxy.org/https://github.com/jags111/efficiency-nodes-comfyui.git
gcs https://gh-proxy.org/https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
gcs https://gh-proxy.org/https://github.com/rgthree/rgthree-comfy.git
gcs https://gh-proxy.org/https://github.com/shiimizu/ComfyUI_smZNodes.git

# 控制
gcs https://gh-proxy.org/https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
gcs https://gh-proxy.org/https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git
gcs https://gh-proxy.org/https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
gcs https://gh-proxy.org/https://github.com/Fannovel16/comfyui_controlnet_aux.git
gcs https://gh-proxy.org/https://github.com/florestefano1975/comfyui-portrait-master.git
gcs https://gh-proxy.org/https://github.com/huchenlei/ComfyUI-layerdiffuse.git
gcs https://gh-proxy.org/https://github.com/kijai/ComfyUI-Florence2.git
gcs https://gh-proxy.org/https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
gcs https://gh-proxy.org/https://github.com/mcmonkeyprojects/sd-dynamic-thresholding.git
gcs https://gh-proxy.org/https://github.com/twri/sdxl_prompt_styler.git

# 视频
gcs https://gh-proxy.org/https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
gcs https://gh-proxy.org/https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
gcs https://gh-proxy.org/https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git

# 其他
gcs https://gh-proxy.org/https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git
gcs https://gh-proxy.org/https://github.com/SLAPaper/ComfyUI-Image-Selector.git

# 已停更，待删除
gcs https://gh-proxy.org/https://github.com/cubiq/ComfyUI_essentials.git
gcs https://gh-proxy.org/https://github.com/Gourieff/ComfyUI-ReActor.git ComfyUI-ReActor.disabled

# 这些节点需要额外克隆 Git 子模块（GitHub 仓库），可能下载失败，故不在 CN 脚本中下载
#gcs https://gh-proxy.org/https://github.com/yolain/ComfyUI-Easy-Use.git
#gcs https://gh-proxy.org/https://github.com/melMass/comfy_mtb.git
#gcs https://gh-proxy.org/https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git


echo "########################################"
echo "[INFO] 下载模型文件..."
echo "########################################"

# TAESD 模型（用于生成时预览）
cd /default-comfyui-bundle/ComfyUI/models/vae

# gh-proxy.org 屏蔽了 aria2，这里改用 curl 下载
curl -LO 'https://gh-proxy.org/https://github.com/madebyollin/taesd/raw/refs/heads/main/taesdxl_decoder.pth'
curl -LO 'https://gh-proxy.org/https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd_decoder.pth'
curl -LO 'https://gh-proxy.org/https://github.com/madebyollin/taesd/raw/refs/heads/main/taesd3_decoder.pth'
curl -LO 'https://gh-proxy.org/https://github.com/madebyollin/taesd/raw/refs/heads/main/taef1_decoder.pth'
