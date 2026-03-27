################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:base-cu130-pt211'
# Installs:
# - Python 3.13 (with GIL)
# - PyTorch 2.11.0+cu130
################################################################################

# Registry mirror
ARG REGISTRY=docker.io
#ARG REGISTRY=m.daocloud.io/docker.io

FROM ${REGISTRY}/yanwk/comfyui-boot:base-cu130-devel

LABEL maintainer="code@yanwk.fun"

ARG USING_GITHUB_ACTIONS=false

# PyPI mirror
#ARG PIP_INDEX_URL="https://mirrors.cernet.edu.cn/pypi/web/simple"

ARG PIP_ROOT_USER_ACTION='ignore'
ARG PIP_NO_BUILD_ISOLATION=1

################################################################################
# CUDA packgages for PyTorch 2.11.0+cu130

# cuDNN
# Find the version used by PyTorch:
# pip list | grep cudnn
# Or:
# cat /usr/local/lib/python3.13/site-packages/nvidia/cudnn/include/cudnn_version.h | grep -E "CUDNN_MAJOR|CUDNN_MINOR|CUDNN_PATCHLEVEL"
RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
libcudnn9-cuda-13-9.19.0.56

# Includes devel packages
RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
cudnn9-cuda-13-1-9.19.0.56

# NCCL
# Find the version used by PyTorch:
# pip list | grep nccl
# Or:
# strings /usr/local/lib/python3.13/site-packages/nvidia/nccl/lib/libnccl.so.2 | grep "NCCL version"
RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
libnccl-2.28.9-1+cuda13.0 \
libnccl-devel-2.28.9-1+cuda13.0

# NVSHMEM
# Find the version used by PyTorch:
# pip list | grep nvshmem
RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
nvshmem-cuda-13-3.4.5 \
libnvshmem3-cuda-13-3.4.5 \
libnvshmem3-devel-cuda-13-3.4.5 \
libnvshmem3-static-cuda-13-3.4.5

# Disable CUDA repo to avoid any unexpected package updates
RUN sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/cuda.repo

################################################################################
# System Packages

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y --nogpgcheck \
        'https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-10.noarch.rpm' \
    && dnf upgrade -y

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
python3.13-devel \
fish \
make \
cmake \
which \
alternatives \
fd-find \
findutils \
git \
git-lfs \
fuse \
bison \
tar \
zip \
unzip \
wget \
aria2 \
default-fonts-cjk \
google-noto-emoji-fonts \
google-noto-color-emoji-fonts \
ffmpeg \
x264 \
x265 \
mesa-libGL \
mesa-libEGL \
gcc \
gcc-c++

# GCC should be already installed by installing cuda-minimal-build, just in case here.

RUN cd /usr/local/bin \
    && curl -sSLO https://github.com/ninja-build/ninja/releases/latest/download/ninja-linux.zip \
    && unzip -q -o ninja-linux.zip \
    && rm -vf ninja-linux.zip

################################################################################
# Configure Python

RUN --mount=type=cache,target=/root/.cache/pip \
    python3.13 -m ensurepip --upgrade \
    && python3.13 -m pip install --upgrade pip wheel setuptools packaging \
    && pip list

################################################################################
# PyTorch
# Break down the steps, so we have more smaller image layers instead of a big solid one.

# 1. Install PyTorch and all its dependencies.
# Note: xFormers is now de-coupled from PyTorch version
# 2. Uninstall PyTorch only,
# 3. Delete redundant NVIDIA Python libs (they are already installed as OS packages, except cuSPARSELt).
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch==2.11.0 torchvision torchaudio \
        torchcodec==0.11.0 xformers \
        --index-url https://download.pytorch.org/whl/cu130 \
&& pip uninstall --yes torch \
&& find /usr/local/lib/python3.13/site-packages/nvidia/ -mindepth 1 -maxdepth 1 ! -name 'cusparselt' -exec rm -rfv {} +

# 4. Install PyTorch again in another layer.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch==2.11.0 torchvision torchaudio \
        torchcodec==0.11.0 xformers \
        --index-url https://download.pytorch.org/whl/cu130

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib64/python3.13/site-packages/torch/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cusparselt/lib"
