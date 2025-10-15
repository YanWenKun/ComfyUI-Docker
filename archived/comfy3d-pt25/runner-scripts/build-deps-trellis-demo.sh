#!/bin/bash

set -eo pipefail

echo "########################################"
echo "[INFO] Building Dependencies for 3D-Pack..."
echo "########################################"

cd /root

if [ -z "${CMAKE_ARGS}" ]; then
    export CMAKE_ARGS='-DBUILD_opencv_world=ON -DWITH_CUDA=ON -DCUDA_FAST_MATH=ON -DWITH_CUBLAS=ON -DWITH_NVCUVID=ON'
    echo "[INFO] CMAKE_ARGS not set, setting to ${CMAKE_ARGS}"
fi ;

# Compile PyTorch3D
# Put it first because it takes longest time.
pip install --force-reinstall \
    "git+https://github.com/facebookresearch/pytorch3d.git"

# Compile libs in Comfy3D_Pre_Builds
aria2c \
    https://github.com/MrForExample/Comfy3D_Pre_Builds/archive/refs/heads/main.zip \
    -d /tmp \
    -o Comfy3D_Pre_Builds-main.zip ;
unzip -q /tmp/Comfy3D_Pre_Builds-main.zip -d /tmp ;
rm /tmp/Comfy3D_Pre_Builds-main.zip ;

for D in /tmp/Comfy3D_Pre_Builds-main/_Libs/*; do
    if [ -d "${D}" ] ; then
        pip install --force-reinstall "${D}"
    fi
done

# Compile other deps, using latest
cd /root

pip install --force-reinstall \
    "git+https://github.com/ashawkey/kiuikit.git"

pip install --force-reinstall \
    "git+https://github.com/NVlabs/nvdiffrast.git"

# For TRELLIS
# Note: vox2seq is already included in Comfy3D_Pre_Builds.

pip install git+https://github.com/JeffreyXiang/diffoctreerast.git

mkdir -p /tmp/build

git clone --depth=1 https://github.com/autonomousvision/mip-splatting.git \
    /tmp/build/mip-splatting
#pip uninstall --break-system-packages --yes diff-gaussian-rasterization
pip install --force-reinstall \
    /tmp/build/mip-splatting/submodules/diff-gaussian-rasterization/

# (Optional) Compile Flash Attention for Ampere and later GPUs.
# "MAX_JOBS" limits Ninja jobs to avoid OOM.
# If have >96GB RAM, just remove MAX_JOBS line.
export MAX_JOBS=4
pip install flash-attn --no-build-isolation

# For TRELLIS demo
pip install gradio==4.44.1 gradio_litmodel3d==0.0.1

# Ensure Numpy1
pip install numpy==1.26.4

# Finish
touch /root/.build-complete

echo "########################################"
echo "[INFO] Build Complete."
echo "########################################"
