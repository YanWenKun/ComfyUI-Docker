#!/bin/bash
set -eu

echo '#' > pak5.txt

array=(
https://gh-proxy.com/https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt
https://gh-proxy.com/https://github.com/Comfy-Org/ComfyUI-Manager/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/cubiq/ComfyUI_essentials/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/cubiq/ComfyUI_FaceAnalysis/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/cubiq/ComfyUI_InstantID/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/cubiq/PuLID_ComfyUI/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/Fannovel16/comfyui_controlnet_aux/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/ltdrdata/ComfyUI-Impact-Pack/raw/refs/heads/Main/requirements.txt
https://gh-proxy.com/https://github.com/ltdrdata/ComfyUI-Impact-Subpack/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/ltdrdata/ComfyUI-Inspire-Pack/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/WASasquatch/was-node-suite-comfyui/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/openvino-dev-samples/comfyui_openvino/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/city96/ComfyUI-GGUF/raw/refs/heads/main/requirements.txt
https://gh-proxy.com/https://github.com/welltop-cn/ComfyUI-TeaCache/raw/refs/heads/main/requirements.txt
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
