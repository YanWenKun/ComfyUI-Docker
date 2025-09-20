#!/bin/bash
set -eu

echo '#' > pak5.txt

array=(
https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt
https://github.com/crystian/ComfyUI-Crystools/raw/refs/heads/main/requirements.txt
https://github.com/cubiq/ComfyUI_essentials/raw/refs/heads/main/requirements.txt
https://github.com/cubiq/ComfyUI_FaceAnalysis/raw/refs/heads/main/requirements.txt
https://github.com/cubiq/ComfyUI_InstantID/raw/refs/heads/main/requirements.txt
https://github.com/cubiq/PuLID_ComfyUI/raw/refs/heads/main/requirements.txt
https://github.com/Fannovel16/comfyui_controlnet_aux/raw/refs/heads/main/requirements.txt
https://github.com/Fannovel16/ComfyUI-Frame-Interpolation/raw/refs/heads/main/requirements-no-cupy.txt
https://github.com/FizzleDorf/ComfyUI_FizzNodes/raw/refs/heads/main/requirements.txt
https://github.com/Gourieff/ComfyUI-ReActor/raw/refs/heads/main/requirements.txt
https://github.com/huchenlei/ComfyUI-layerdiffuse/raw/refs/heads/main/requirements.txt
https://github.com/jags111/efficiency-nodes-comfyui/raw/refs/heads/main/requirements.txt
https://github.com/kijai/ComfyUI-KJNodes/raw/refs/heads/main/requirements.txt
https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite/raw/refs/heads/main/requirements.txt
https://github.com/ltdrdata/ComfyUI-Impact-Pack/raw/refs/heads/Main/requirements.txt
https://github.com/ltdrdata/ComfyUI-Impact-Subpack/raw/refs/heads/main/requirements.txt
https://github.com/ltdrdata/ComfyUI-Inspire-Pack/raw/refs/heads/main/requirements.txt
https://github.com/ltdrdata/ComfyUI-Manager/raw/refs/heads/main/requirements.txt
https://github.com/melMass/comfy_mtb/raw/refs/heads/main/requirements.txt
https://github.com/storyicon/comfyui_segment_anything/raw/refs/heads/main/requirements.txt
https://github.com/WASasquatch/was-node-suite-comfyui/raw/refs/heads/main/requirements.txt
)

for line in "${array[@]}";
    do curl -w "\n" -sSL "${line}" >> pak5.txt
done

sed -i '/^#/d' pak5.txt
sed -i 's/[[:space:]]*$//' pak5.txt
sed -i 's/>=.*$//' pak5.txt
sed -i 's/_/-/g' pak5.txt

# Don't "sort foo.txt >foo.txt". See: https://stackoverflow.com/a/29244408
sort -ufo pak5.txt pak5.txt

# Remove duplicate items, compare to pak3.txt
grep -Fixv -f pak3.txt pak5.txt > temp.txt && mv temp.txt pak5.txt

echo "<pak5.txt> generated. Check before use."
