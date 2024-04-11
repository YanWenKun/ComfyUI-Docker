################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:rocm'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# With ROCm for AMD GPU.
################################################################################

FROM opensuse/tumbleweed:latest

LABEL maintainer="code@yanwk.fun"

# Note: GCC for InsightFace, 
#       FFmpeg for video (pip[imageio-ffmpeg] will use system FFmpeg instead of bundled),
#       'half' for ORT on ROCm
RUN --mount=type=cache,target=/var/cache/zypp \
    set -eu \
    && zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys \
            install --no-confirm \
        python310 python310-pip python310-wheel python310-setuptools \
        python310-devel python310-Cython gcc-c++ cmake \
        python310-numpy python310-opencv \
        python310-ffmpeg-python ffmpeg x264 x265 \
        python310-dbm \
        ghc-half \
        google-noto-sans-fonts google-noto-sans-cjk-fonts google-noto-coloremoji-fonts \
        shadow git aria2 \
        Mesa-libGL1 libgthread-2_0-0 \
    && rm -f /usr/lib64/python3.10/EXTERNALLY-MANAGED

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        --upgrade pip wheel setuptools Cython numpy

# Install PyTorch from AMD repo
# https://rocm.docs.amd.com/projects/radeon/en/latest/docs/install/install-pytorch.html
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        https://repo.radeon.com/rocm/manylinux/rocm-rel-6.0.2/torch-2.1.2%2Brocm6.0-cp310-cp310-linux_x86_64.whl \
        https://repo.radeon.com/rocm/manylinux/rocm-rel-6.0.2/torchvision-0.16.1%2Brocm6.0-cp310-cp310-linux_x86_64.whl \
        --extra-index-url  https://download.pytorch.org/whl/nightly/rocm6.0

# Dependencies for frequently-used
# (Do this firstly so PIP won't be solving too many deps at one time)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt \
        -r https://raw.githubusercontent.com/crystian/ComfyUI-Crystools/main/requirements.txt \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_essentials/main/requirements.txt \
        -r https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt \
        -r https://raw.githubusercontent.com/jags111/efficiency-nodes-comfyui/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Pack/Main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Subpack/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Inspire-Pack/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/requirements.txt \
        --extra-index-url https://download.pytorch.org/whl/nightly/rocm6.0

# Dependencies for more, with few hand-pick:
# 'compel lark' for smZNodes
# 'torchdiffeq' for DepthFM
# 'fairscale' for APISR
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_FaceAnalysis/main/requirements.txt \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_InstantID/main/requirements.txt \
        -r https://raw.githubusercontent.com/Fannovel16/ComfyUI-Frame-Interpolation/main/requirements-no-cupy.txt \
        -r https://raw.githubusercontent.com/FizzleDorf/ComfyUI_FizzNodes/main/requirements.txt \
        -r https://raw.githubusercontent.com/kijai/ComfyUI-KJNodes/main/requirements.txt \
        -r https://raw.githubusercontent.com/melMass/comfy_mtb/main/requirements.txt \
        -r https://raw.githubusercontent.com/storyicon/comfyui_segment_anything/main/requirements.txt \
        -r https://raw.githubusercontent.com/ZHO-ZHO-ZHO/ComfyUI-InstantID/main/requirements.txt \
        compel lark torchdiffeq fairscale \
        python-ffmpeg \
        --extra-index-url https://download.pytorch.org/whl/nightly/rocm6.0

# 1. Force-Reinstall ONNX for ROCm
#    Ref: https://rocm.docs.amd.com/projects/radeon/en/latest/docs/install/install-onnx.html
# 2. Fix MediaPipe's broken dep (protobuf<4).
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        --force-reinstall \
        https://repo.radeon.com/rocm/manylinux/rocm-rel-6.0.2/onnxruntime_rocm-inference-1.17.0-cp310-cp310-linux_x86_64.whl \
    && pip install --break-system-packages \
        mediapipe \
    && pip list

RUN env \
    && du -ah /root \
    && rm -rf /root/* /root/.*

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS="--use-pytorch-cross-attention"
CMD ["bash","/runner-scripts/entrypoint.sh"]