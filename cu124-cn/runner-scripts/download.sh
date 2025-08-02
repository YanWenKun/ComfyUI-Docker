#!/bin/bash

set -euo pipefail

# 下载（clone）自定义节点，如已存在，则更新（pull），额外处理含有子模块的节点
# 其中，正则表达式内容为：从链接中查找仓库名称 REPO_NAME
# 先匹配 [https://example.com/xyz/REPO_NAME.git] 或 [git@example.com:xyz/REPO_NAME.git]
# 再匹配 [http(s)://example.com/xyz/REPO_NAME]
# 查找结果存放在 BASH_REMATCH[2]
function clone_or_pull () {
    if [[ $1 =~ ^(.*[/:])(.*)(\.git)$ ]] || [[ $1 =~ ^(http.*\/)(.*)$ ]]; then
        echo "正在下载： ${BASH_REMATCH[2]}" ;
        set +e ;
            git clone --depth=1 --no-tags "$1" || git -C "${BASH_REMATCH[2]}" pull --ff-only ;

            if [ -f "${BASH_REMATCH[2]}/.gitmodules" ] ; then
                echo "正在下载 ${BASH_REMATCH[2]} 的子模块..." ;
                sed -i.bak 's|url = https://github.com/|url = https://gh-proxy.com/https://github.com/|' "${BASH_REMATCH[2]}/.gitmodules" ;
                git -C "${BASH_REMATCH[2]}" submodule update --init --recursive ;
            fi ;
        set -e ;
    else
        echo "[ERROR] 无效的 URL: $1" ;
        return 1 ;
    fi ;
}


echo "########################################"
echo "[INFO] 下载 ComfyUI & Manager..."
echo "########################################"

# 使用稳定版 ComfyUI（GitHub 上有发布标签）
set +e
cd /root
git clone https://gh-proxy.com/https://github.com/comfyanonymous/ComfyUI.git || git -C ComfyUI pull --ff-only
cd /root/ComfyUI
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"
set -e

cd /root/ComfyUI/custom_nodes
clone_or_pull https://gh-proxy.com/https://github.com/ltdrdata/ComfyUI-Manager.git

# 使用镜像站点替换 ComfyUI-Manager 默认仓库地址，避免卡 UI
# 治标但不治本，使用 Manager 全部功能仍需挂代理或魔改
mkdir -p /root/ComfyUI/user/default/ComfyUI-Manager

cat <<EOF > /root/ComfyUI/user/default/ComfyUI-Manager/config.ini
[default]
channel_url = https://gh-proxy.com/https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main
EOF

cat <<EOF > /root/ComfyUI/user/default/ComfyUI-Manager/channels.list
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

cd /root/ComfyUI/custom_nodes

# 工作空间
clone_or_pull https://gh-proxy.com/https://github.com/crystian/ComfyUI-Crystools.git

# 性能
clone_or_pull https://gh-proxy.com/https://github.com/welltop-cn/ComfyUI-TeaCache.git
clone_or_pull https://gh-proxy.com/https://github.com/nunchaku-tech/ComfyUI-nunchaku.git
clone_or_pull https://gh-proxy.com/https://github.com/city96/ComfyUI-GGUF.git

# 综合
clone_or_pull https://gh-proxy.com/https://github.com/bash-j/mikey_nodes.git
clone_or_pull https://gh-proxy.com/https://github.com/chrisgoringe/cg-use-everywhere.git
clone_or_pull https://gh-proxy.com/https://github.com/cubiq/ComfyUI_essentials.git
clone_or_pull https://gh-proxy.com/https://github.com/jags111/efficiency-nodes-comfyui.git
clone_or_pull https://gh-proxy.com/https://github.com/kijai/ComfyUI-KJNodes.git
clone_or_pull https://gh-proxy.com/https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
clone_or_pull https://gh-proxy.com/https://github.com/rgthree/rgthree-comfy.git
clone_or_pull https://gh-proxy.com/https://github.com/shiimizu/ComfyUI_smZNodes.git
clone_or_pull https://gh-proxy.com/https://github.com/WASasquatch/was-node-suite-comfyui.git
clone_or_pull https://gh-proxy.com/https://github.com/yolain/ComfyUI-Easy-Use.git

# 控制
clone_or_pull https://gh-proxy.com/https://github.com/cubiq/ComfyUI_InstantID.git
clone_or_pull https://gh-proxy.com/https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
clone_or_pull https://gh-proxy.com/https://github.com/cubiq/PuLID_ComfyUI.git
clone_or_pull https://gh-proxy.com/https://github.com/Fannovel16/comfyui_controlnet_aux.git
clone_or_pull https://gh-proxy.com/https://github.com/florestefano1975/comfyui-portrait-master.git
clone_or_pull https://gh-proxy.com/https://github.com/Gourieff/ComfyUI-ReActor.git
clone_or_pull https://gh-proxy.com/https://github.com/huchenlei/ComfyUI-layerdiffuse.git
clone_or_pull https://gh-proxy.com/https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
clone_or_pull https://gh-proxy.com/https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
clone_or_pull https://gh-proxy.com/https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git
clone_or_pull https://gh-proxy.com/https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
clone_or_pull https://gh-proxy.com/https://github.com/mcmonkeyprojects/sd-dynamic-thresholding.git
clone_or_pull https://gh-proxy.com/https://github.com/neverbiasu/ComfyUI-SAM2.git
clone_or_pull https://gh-proxy.com/https://github.com/twri/sdxl_prompt_styler.git

# 视频
clone_or_pull https://gh-proxy.com/https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
clone_or_pull https://gh-proxy.com/https://github.com/FizzleDorf/ComfyUI_FizzNodes.git
clone_or_pull https://gh-proxy.com/https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
clone_or_pull https://gh-proxy.com/https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
clone_or_pull https://gh-proxy.com/https://github.com/melMass/comfy_mtb.git

# 更多
clone_or_pull https://gh-proxy.com/https://github.com/cubiq/ComfyUI_FaceAnalysis.git
clone_or_pull https://gh-proxy.com/https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git
clone_or_pull https://gh-proxy.com/https://github.com/SLAPaper/ComfyUI-Image-Selector.git
clone_or_pull https://gh-proxy.com/https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git

echo "########################################"
echo "[INFO] 下载模型……"
echo "########################################"

cd /root/ComfyUI/models
aria2c \
  --input-file=/runner-scripts/download-models.txt \
  --allow-overwrite=false \
  --auto-file-renaming=false \
  --continue=true \
  --max-connection-per-server=3

# 标记为下载完成，下次启动不再尝试下载
touch /root/.download-complete
