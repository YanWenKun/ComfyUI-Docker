#!/bin/bash
set -eu

echo '#' > pak5.txt

array=(
https://github.com/Comfy-Org/ComfyUI/raw/refs/heads/master/requirements.txt
https://github.com/Comfy-Org/ComfyUI-Manager/raw/refs/heads/main/requirements.txt
# Performance
https://github.com/city96/ComfyUI-GGUF/raw/refs/heads/main/requirements.txt
https://github.com/nunchaku-ai/ComfyUI-nunchaku/raw/refs/heads/main/requirements.txt
# Workspace
https://github.com/alexopus/ComfyUI-Image-Saver/raw/refs/heads/master/requirements.txt
https://github.com/crystian/ComfyUI-Crystools/raw/refs/heads/main/requirements.txt
https://github.com/pydn/ComfyUI-to-Python-Extension/raw/refs/heads/main/requirements.txt
https://github.com/willmiao/ComfyUI-Lora-Manager/raw/refs/heads/main/requirements.txt
https://github.com/Amorano/Jovi_Help/raw/refs/heads/main/requirements.txt
# General
https://github.com/ltdrdata/was-node-suite-comfyui/raw/refs/heads/main/requirements.txt
https://github.com/jags111/efficiency-nodes-comfyui/raw/refs/heads/main/requirements.txt
https://github.com/kijai/ComfyUI-KJNodes/raw/refs/heads/main/requirements.txt
https://github.com/mirabarukaso/ComfyUI_Mira/raw/refs/heads/main/requirements.txt
https://github.com/yolain/ComfyUI-Easy-Use/raw/refs/heads/main/requirements.txt
# Control
https://github.com/ltdrdata/ComfyUI-Impact-Pack/raw/refs/heads/Main/requirements.txt
https://github.com/ltdrdata/ComfyUI-Impact-Subpack/raw/refs/heads/main/requirements.txt
https://github.com/ltdrdata/ComfyUI-Inspire-Pack/raw/refs/heads/main/requirements.txt
https://github.com/ClownsharkBatwing/RES4LYF/raw/refs/heads/main/requirements.txt
https://github.com/Fannovel16/comfyui_controlnet_aux/raw/refs/heads/main/requirements.txt
https://github.com/Gourieff/ComfyUI-ReActor/raw/refs/heads/main/requirements.txt
https://github.com/huchenlei/ComfyUI-layerdiffuse/raw/refs/heads/main/requirements.txt
https://github.com/Jonseed/ComfyUI-Detail-Daemon/raw/refs/heads/main/requirements.txt
https://github.com/KohakuBlueleaf/z-tipo-extension/raw/refs/heads/main/requirements.txt
https://github.com/Ltamann/ComfyUI-TBG-SAM3/raw/refs/heads/main/requirements.txt
# LayerStyle
# Note that some deps in LayerStyle_Advance are outdated (causing trouble), pick wisely
https://github.com/chflame163/ComfyUI_LayerStyle/raw/refs/heads/main/requirements.txt
https://github.com/chflame163/ComfyUI_LayerStyle/raw/refs/heads/main/repair_dependency_list.txt
#https://github.com/chflame163/ComfyUI_LayerStyle_Advance/raw/refs/heads/main/requirements.txt
#https://github.com/chflame163/ComfyUI_LayerStyle_Advance/raw/refs/heads/main/repair_dependency_list.txt
# Video
https://github.com/Fannovel16/ComfyUI-Frame-Interpolation/raw/refs/heads/main/requirements-no-cupy.txt
https://github.com/FizzleDorf/ComfyUI_FizzNodes/raw/refs/heads/main/requirements.txt
https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite/raw/refs/heads/main/requirements.txt
https://github.com/melMass/comfy_mtb/raw/refs/heads/main/requirements.txt
https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler/raw/refs/heads/main/requirements.txt
# More
https://github.com/1038lab/ComfyUI-JoyCaption/raw/refs/heads/main/requirements.txt
https://github.com/1038lab/ComfyUI-QwenTTS/raw/refs/heads/main/requirements.txt
https://github.com/1038lab/ComfyUI-QwenVL/raw/refs/heads/main/requirements.txt
https://github.com/1038lab/ComfyUI-RMBG/raw/refs/heads/main/requirements.txt
https://github.com/1038lab/ComfyUI-WildPromptor/raw/refs/heads/main/requirements.txt
https://github.com/akatz-ai/ComfyUI-DepthCrafter-Nodes/raw/refs/heads/main/requirements.txt
https://github.com/digitaljohn/comfyui-propost/raw/refs/heads/master/requirements.txt
https://github.com/kijai/ComfyUI-DepthAnythingV2/raw/refs/heads/main/requirements.txt
https://github.com/kijai/ComfyUI-Florence2/raw/refs/heads/main/requirements.txt
https://github.com/lihaoyun6/ComfyUI-llama-cpp_vlm/raw/refs/heads/main/requirements.txt
https://github.com/pythongosssss/ComfyUI-WD14-Tagger/raw/refs/heads/main/requirements.txt
# Pending Removal
# cubiq is no longer developing ComfyUI custom nodes
https://github.com/cubiq/ComfyUI_essentials/raw/refs/heads/main/requirements.txt
https://github.com/cubiq/ComfyUI_FaceAnalysis/raw/refs/heads/main/requirements.txt
https://github.com/cubiq/ComfyUI_InstantID/raw/refs/heads/main/requirements.txt
https://github.com/cubiq/PuLID_ComfyUI/raw/refs/heads/main/requirements.txt
# Pending Removal 2
# Not in use but keep for extended packages
https://github.com/akatz-ai/ComfyUI-AKatz-Nodes/raw/refs/heads/main/requirements.txt
https://github.com/neverbiasu/ComfyUI-SAM2/raw/refs/heads/main/requirements.txt
)

for line in "${array[@]}";
    do curl -w "\n" -sSL "${line}" >> pak5.txt
done

sed -i '/^#/d' pak5.txt
sed -i 's/[[:space:]]*$//' pak5.txt
sed -i 's/>=.*$//' pak5.txt
sed -i 's/_/-/g' pak5.txt
sed -i 's/[ \t]*$//' pak5.txt

# Don't "sort foo.txt >foo.txt". See: https://stackoverflow.com/a/29244408
sort -ufo pak5.txt pak5.txt

# Remove duplicate items, compare to pak3.txt and pak7.txt
grep -Fixv -f pak3.txt pak5.txt > temp.txt && mv temp.txt pak5.txt
grep -Fixv -f pak7.txt pak5.txt > temp.txt && mv temp.txt pak5.txt

echo "<pak5.txt> generated. Check before use."
