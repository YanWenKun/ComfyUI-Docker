################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:nightly'
# A image with preview (nightly) dependencies for ComfyUI.
# Does not download ComfyUI or any models.
#
# Using image from NVIDIA as base image:
# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda/tags
#
# Ubuntu 24.04 comes with GCC 13, so no additional config here.
#
# Note about env vars: in NVIDIA's image, there's no CUDA_HOME or CUDA_PATH.
# Also, the LD_LIBRARY_PATH is intended to point to a non-existent folder.
# Ref: https://gitlab.com/nvidia/container-images/cuda/-/issues/47
################################################################################

FROM nvcr.io/nvidia/cuda:12.6.1-cudnn-devel-ubuntu24.04

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
python3.12-full \
python3.12-dev \
libegl1-mesa-dev \
git \
cmake \
ninja-build \
aria2 \
curl \
fish \
fd-find \
less \
vim \
ffmpeg \
x264 \
x265 \
    && rm -rf /var/lib/apt/lists/* \
    && rm /usr/lib/python3.12/EXTERNALLY-MANAGED

# In Ubuntu/Debian, PIP packages installed by APT were locked.
# So here we install PIP in a classic way, make it easier to update.
RUN --mount=type=cache,target=/root/.cache/pip \
    aria2c https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py \
    && rm get-pip.py \
    && pip install \
        wheel setuptools \
    && pip list \
    && df -h

# PyTorch
# Break down the steps, so we have more but smaller image layers.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --dry-run --pre torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/nightly/cu124

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps --pre torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/nightly/cu124

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --pre torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/nightly/cu124

# Dependencies
# RUN --mount=type=cache,target=/root/.cache/pip \
#     pip install \
# accelerate \
# compel \
# cupy-cuda12x \
# diffusers \
# fairscale \
# ftfy \
# imageio \
# joblib \
# kornia \
# lark \
# matplotlib \
# onnxruntime \
# opencv-contrib-python-headless \
# opencv-python-headless \
# pandas \
# pilgram \
# pillow \
# pygit2 \
# python-ffmpeg \
# regex \
# scikit-image \
# scikit-learn \
# scipy \
# timm \
# torchdiffeq \
# torchmetrics \
# transformers

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
-r https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt \
-r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/requirements.txt

# RUN --mount=type=cache,target=/root/.cache/pip \
#     pip install \
# -r https://raw.githubusercontent.com/crystian/ComfyUI-Crystools/main/requirements.txt \
# -r https://raw.githubusercontent.com/cubiq/ComfyUI_essentials/main/requirements.txt \
# -r https://raw.githubusercontent.com/cubiq/ComfyUI_FaceAnalysis/main/requirements.txt \
# -r https://raw.githubusercontent.com/cubiq/ComfyUI_InstantID/main/requirements.txt \
# -r https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt \
# -r https://raw.githubusercontent.com/Fannovel16/ComfyUI-Frame-Interpolation/main/requirements-no-cupy.txt \
# -r https://raw.githubusercontent.com/FizzleDorf/ComfyUI_FizzNodes/main/requirements.txt \
# -r https://raw.githubusercontent.com/jags111/efficiency-nodes-comfyui/main/requirements.txt \
# -r https://raw.githubusercontent.com/kijai/ComfyUI-KJNodes/main/requirements.txt \
# -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Pack/Main/requirements.txt \
# -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Subpack/main/requirements.txt \
# -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Inspire-Pack/main/requirements.txt \
# -r https://raw.githubusercontent.com/melMass/comfy_mtb/main/requirements.txt \
# -r https://raw.githubusercontent.com/MrForExample/ComfyUI-3D-Pack/main/requirements.txt \
# -r https://raw.githubusercontent.com/storyicon/comfyui_segment_anything/main/requirements.txt \
# -r https://raw.githubusercontent.com/yolain/ComfyUI-Easy-Use/main/requirements.txt \
# -r https://raw.githubusercontent.com/ZHO-ZHO-ZHO/ComfyUI-InstantID/main/requirements.txt \
#     && pip uninstall --break-system-packages --yes \
#         onnxruntime-gpu \
#     && pip --no-cache-dir install --break-system-packages \
#         onnxruntime-gpu \
#         --index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/ \
#         --extra-index-url https://pypi.org/simple \
#     && pip install \
#         mediapipe \
#     && pip list

RUN du -ah /root \
    && find /root/ -mindepth 1 -delete \
    && df -h

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""

# Let .pyc files be stored in one place
ENV PYTHONPYCACHEPREFIX="/root/.cache/pycache"
# Let PIP install packages to /root/.local
ENV PIP_USER=true
# Add above to PATH
ENV PATH="${PATH}:/root/.local/bin"
# Suppress [WARNING: Running pip as the 'root' user]
ENV PIP_ROOT_USER_ACTION=ignore

CMD ["python3","./ComfyUI/main.py","--listen","--port 8188","${CLI_ARGS}"]
