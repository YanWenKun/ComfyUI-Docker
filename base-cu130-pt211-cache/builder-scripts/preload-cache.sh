#!/bin/bash

set -euo pipefail

# Note that --depth=1 is not used here.
# We need to update the repos in the later stage and they will become fat anyway.
gcr() {
    git clone --recurse-submodules "$@"
}

echo "########################################"
echo "[INFO] Downloading ComfyUI & Nodes..."
echo "########################################"

mkdir -p /default-comfyui-bundle

cd /default-comfyui-bundle

git clone 'https://github.com/Comfy-Org/ComfyUI.git'

cd /default-comfyui-bundle/ComfyUI
# Using stable version (has a release tag)
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"

cd /default-comfyui-bundle/ComfyUI/custom_nodes

# Performance
gcr https://github.com/city96/ComfyUI-GGUF.git
gcr https://github.com/nunchaku-ai/ComfyUI-nunchaku.git
gcr https://github.com/woct0rdho/ComfyUI-RadialAttn.git

# Workspace
gcr https://github.com/alexopus/ComfyUI-Image-Saver.git
gcr https://github.com/chrisgoringe/cg-use-everywhere.git
gcr https://github.com/crystian/ComfyUI-Crystools.git
gcr https://github.com/pydn/ComfyUI-to-Python-Extension.git
gcr https://github.com/SLAPaper/ComfyUI-Image-Selector.git
gcr https://github.com/willmiao/ComfyUI-Lora-Manager.git
gcr https://github.com/Amorano/Jovi_Colorizer.git
gcr https://github.com/Amorano/Jovi_Help.git
gcr https://github.com/Amorano/Jovi_Measure.git
gcr https://github.com/Amorano/Jovi_Preset.git

# General
gcr https://github.com/ltdrdata/was-node-suite-comfyui.git
gcr https://github.com/bash-j/mikey_nodes.git
gcr https://github.com/jags111/efficiency-nodes-comfyui.git
gcr https://github.com/kijai/ComfyUI-KJNodes.git
gcr https://github.com/mirabarukaso/ComfyUI_Mira.git
gcr https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git
gcr https://github.com/rgthree/rgthree-comfy.git
gcr https://github.com/shiimizu/ComfyUI_smZNodes.git
gcr https://github.com/yolain/ComfyUI-Easy-Use.git

# Control
gcr https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
gcr https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git
gcr https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
gcr https://github.com/chflame163/ComfyUI_LayerStyle.git
gcr https://github.com/ClownsharkBatwing/RES4LYF.git
gcr https://github.com/Fannovel16/comfyui_controlnet_aux.git
gcr https://github.com/florestefano1975/comfyui-portrait-master.git
gcr https://github.com/huchenlei/ComfyUI-IC-Light-Native.git
gcr https://github.com/huchenlei/ComfyUI-layerdiffuse.git
gcr https://github.com/Jonseed/ComfyUI-Detail-Daemon.git
gcr https://github.com/KohakuBlueleaf/z-tipo-extension.git
gcr https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
gcr https://github.com/mcmonkeyprojects/sd-dynamic-thresholding.git
gcr https://github.com/pamparamm/ComfyUI-ppm.git
gcr https://github.com/twri/sdxl_prompt_styler.git

# Video
gcr https://github.com/aigc-apps/VideoX-Fun.git
gcr https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
gcr https://github.com/FizzleDorf/ComfyUI_FizzNodes.git
gcr https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
gcr https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
gcr https://github.com/Lightricks/ComfyUI-LTXVideo.git
gcr https://github.com/melMass/comfy_mtb.git
gcr https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler.git

# More
gcr https://github.com/1038lab/ComfyUI-JoyCaption.git
gcr https://github.com/1038lab/ComfyUI-QwenTTS.git
gcr https://github.com/1038lab/ComfyUI-QwenVL.git
gcr https://github.com/1038lab/ComfyUI-RMBG.git
gcr https://github.com/1038lab/ComfyUI-WildPromptor.git
gcr https://github.com/akatz-ai/ComfyUI-DepthCrafter-Nodes.git
gcr https://github.com/digitaljohn/comfyui-propost.git
gcr https://github.com/kijai/ComfyUI-DepthAnythingV2.git
gcr https://github.com/kijai/ComfyUI-Florence2.git
gcr https://github.com/lihaoyun6/ComfyUI-llama-cpp_vlm.git
gcr https://github.com/pythongosssss/ComfyUI-WD14-Tagger.git
gcr https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git

# To be removed in future
gcr https://github.com/cubiq/ComfyUI_essentials.git
gcr https://github.com/cubiq/ComfyUI_FaceAnalysis.git
gcr https://github.com/cubiq/ComfyUI_InstantID.git
gcr https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
gcr https://github.com/cubiq/PuLID_ComfyUI.git
gcr https://github.com/Gourieff/ComfyUI-ReActor.git ComfyUI-ReActor.disabled

echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

cd /default-comfyui-bundle/ComfyUI/models/vae_approx
gcr https://github.com/madebyollin/taesd.git
cp taesd/*.pth .
rm -rf taesd
