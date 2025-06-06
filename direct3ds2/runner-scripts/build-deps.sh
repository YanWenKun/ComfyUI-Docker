#!/bin/bash

set -eo pipefail

echo "########################################"
echo "[INFO] Building Dependencies for D3DS2..."
echo "########################################"

cd /root

if [ -z "${CMAKE_ARGS}" ]; then
    export CMAKE_ARGS='-DBUILD_opencv_world=ON -DWITH_CUDA=ON -DCUDA_FAST_MATH=ON -DWITH_CUBLAS=ON -DWITH_NVCUVID=ON'
    echo "[INFO] CMAKE_ARGS not set, setting to ${CMAKE_ARGS}"
fi ;

cd /root/Direct3D-S2/third_party/voxelize
pip install .

cd /root
pip install "git+https://github.com/mit-han-lab/torchsparse.git"

cd /root/Direct3D-S2
pip install -e .

# (Optional) Compile Flash Attention for Ampere and later GPUs.
# "MAX_JOBS" limits Ninja jobs to avoid OOM.
# If have >96GB RAM, just remove MAX_JOBS line.
cd /root
if [ "$ATTN_BACKEND" == "flash_attn" ] || [ "$SPARSE_ATTN_BACKEND" == "flash_attn" ]; then
    echo "########################################"
    echo "[INFO] Compile-Installing Flash Attention..."
    echo "########################################"

    export MAX_JOBS=4
    pip install flash-attn --no-build-isolation

    echo "########################################"
    echo "[INFO] Successfully Installed Flash Attention."
    echo "########################################"
fi

# Finish
touch /root/.build-complete

echo "########################################"
echo "[INFO] Build Complete."
echo "########################################"
