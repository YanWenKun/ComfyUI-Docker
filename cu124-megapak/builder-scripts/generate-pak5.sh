#!/bin/bash
set -eu

array=(
https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt
https://raw.githubusercontent.com/crystian/ComfyUI-Crystools/main/requirements.txt
https://raw.githubusercontent.com/cubiq/ComfyUI_essentials/main/requirements.txt
https://raw.githubusercontent.com/cubiq/ComfyUI_FaceAnalysis/main/requirements.txt
https://raw.githubusercontent.com/cubiq/ComfyUI_InstantID/main/requirements.txt
https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt
https://raw.githubusercontent.com/Fannovel16/ComfyUI-Frame-Interpolation/main/requirements-no-cupy.txt
https://raw.githubusercontent.com/FizzleDorf/ComfyUI_FizzNodes/main/requirements.txt
https://raw.githubusercontent.com/jags111/efficiency-nodes-comfyui/main/requirements.txt
https://raw.githubusercontent.com/kijai/ComfyUI-KJNodes/main/requirements.txt
https://raw.githubusercontent.com/Kosinkadink/ComfyUI-VideoHelperSuite/main/requirements.txt
https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Pack/Main/requirements.txt
https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Subpack/main/requirements.txt
https://raw.githubusercontent.com/ltdrdata/ComfyUI-Inspire-Pack/main/requirements.txt
https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/requirements.txt
https://raw.githubusercontent.com/melMass/comfy_mtb/main/requirements.txt
https://raw.githubusercontent.com/storyicon/comfyui_segment_anything/main/requirements.txt
https://raw.githubusercontent.com/ZHO-ZHO-ZHO/ComfyUI-InstantID/main/requirements.txt
)

for line in "${array[@]}";
    do curl -w "\n" "${line}" >> pak5.txt
done

sed -i '/^#/d' pak5.txt
sed -i 's/[[:space:]]*$//' pak5.txt
sed -i 's/>=.*$//' pak5.txt
sed -i 's/_/-/g' pak5.txt

# Don't "sort foo.txt >foo.txt". See: https://stackoverflow.com/a/29244408
sort -ufo pak5.txt pak5.txt

echo "<pak5.txt> generated. Check before use."
