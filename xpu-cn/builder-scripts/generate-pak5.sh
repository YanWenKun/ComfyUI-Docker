#!/bin/bash
set -eu

echo '#' > pak5.txt

array=(
https://gh-proxy.org/https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt
https://gh-proxy.org/https://github.com/Comfy-Org/ComfyUI-Manager/raw/refs/heads/main/requirements.txt
# 性能
https://gh-proxy.org/https://github.com/openvino-dev-samples/comfyui_openvino/raw/refs/heads/main/requirements.txt
https://gh-proxy.org/https://github.com/welltop-cn/ComfyUI-TeaCache/raw/refs/heads/main/requirements.txt
https://gh-proxy.org/https://github.com/city96/ComfyUI-GGUF/raw/refs/heads/main/requirements.txt
# 工作空间
https://gh-proxy.org/https://github.com/crystian/ComfyUI-Crystools/raw/refs/heads/main/requirements.txt
# 综合
https://gh-proxy.org/https://github.com/ltdrdata/was-node-suite-comfyui/raw/refs/heads/main/requirements.txt
https://gh-proxy.org/https://github.com/kijai/ComfyUI-KJNodes/raw/refs/heads/main/requirements.txt
https://gh-proxy.org/https://github.com/jags111/efficiency-nodes-comfyui/raw/refs/heads/main/requirements.txt
https://gh-proxy.org/https://github.com/yolain/ComfyUI-Easy-Use/raw/refs/heads/main/requirements.txt
# 控制
https://gh-proxy.org/https://github.com/ltdrdata/ComfyUI-Impact-Pack/raw/refs/heads/Main/requirements.txt
https://gh-proxy.org/https://github.com/ltdrdata/ComfyUI-Impact-Subpack/raw/refs/heads/main/requirements.txt
https://gh-proxy.org/https://github.com/ltdrdata/ComfyUI-Inspire-Pack/raw/refs/heads/main/requirements.txt
https://gh-proxy.org/https://github.com/Fannovel16/comfyui_controlnet_aux/raw/refs/heads/main/requirements.txt
https://gh-proxy.org/https://github.com/Gourieff/ComfyUI-ReActor/raw/refs/heads/main/requirements.txt
https://gh-proxy.org/https://github.com/huchenlei/ComfyUI-layerdiffuse/raw/refs/heads/main/requirements.txt
https://gh-proxy.org/https://github.com/kijai/ComfyUI-Florence2/raw/refs/heads/main/requirements.txt
# 视频
https://gh-proxy.org/https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite/raw/refs/heads/main/requirements.txt
https://gh-proxy.org/https://github.com/Fannovel16/ComfyUI-Frame-Interpolation/raw/refs/heads/main/requirements-no-cupy.txt
https://gh-proxy.org/https://github.com/melMass/comfy_mtb/raw/refs/heads/main/requirements.txt
# 待删除
https://gh-proxy.org/https://github.com/cubiq/ComfyUI_essentials/raw/refs/heads/main/requirements.txt
)

for line in "${array[@]}";
    do curl -w "\n" -sSL "${line}" >> pak5.txt
done

sed -i '/^#/d' pak5.txt
sed -i 's/[[:space:]]*$//' pak5.txt
sed -i 's/>=.*$//' pak5.txt
sed -i 's/_/-/g' pak5.txt

# 不要原地写入 "sort foo.txt >foo.txt"，详见： https://stackoverflow.com/a/29244408
sort -ufo pak5.txt pak5.txt

# 根据 pak3.txt 已有内容，删除重复项
grep -Fixv -f pak3.txt pak5.txt > temp.txt && mv temp.txt pak5.txt

echo "已生成 <pak5.txt> ，检查后再用"
