################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:base-cu130-slim-s1'
# Using:
# - glibc 2.39 (from Rocky Linux 10)
# - GCC 14 (from Rocky Linux 10)
# - Python 3.13 (with GIL)
# - CUDA 13.0
# - PyTorch latest stable
################################################################################

# Registry mirror setting
ARG REGISTRY=docker.io
#ARG REGISTRY=m.daocloud.io/docker.io

FROM ${REGISTRY}/rockylinux/rockylinux:10

LABEL maintainer="code@yanwk.fun"

ARG USING_GITHUB_ACTIONS=false

# PyPI mirror setting
ARG PIP_INDEX_URL
#ARG PIP_INDEX_URL="https://mirrors.cernet.edu.cn/pypi/web/simple"

ARG PIP_ROOT_USER_ACTION='ignore'
ARG PIP_NO_BUILD_ISOLATION=1

################################################################################
# System Packages

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y --nogpgcheck \
        'https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-10.noarch.rpm' \
    && dnf upgrade -y \
    && dnf install -y \
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
mesa-libEGL

# RHEL 10 defaults to GCC 14
RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
gcc \
gcc-c++

RUN cd /usr/local/bin \
    && curl -sSLO https://github.com/ninja-build/ninja/releases/latest/download/ninja-linux.zip \
    && unzip -q -o ninja-linux.zip \
    && rm -vf ninja-linux.zip

################################################################################
# Configure Python

RUN --mount=type=cache,target=/root/.cache/pip \
    python3.13 -m ensurepip --upgrade \
    && python3.13 -m pip install --upgrade pip wheel setuptools packaging

################################################################################
# PyTorch
# Break down the steps, so we have more smaller image layers instead of a big solid one.

# 1. Dry run `pip install` to get the list of packages
# 2. Extract the package names and versions from the output
#    Example: nvidia-cuda-runtime-cu12-12.6.77 -> nvidia-cuda-runtime-cu12==12.6.77
RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --dry-run torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu130 \
            2>&1 | tee /tmp/pip-dryrun.txt \
    && grep -oP '(?<=Would install ).*' /tmp/pip-dryrun.txt > /tmp/packages.txt \
    && grep -oP 'nvidia-\S+-\S+' /tmp/packages.txt \
        | sed 's/\(.*\)-\([^-]*\)$/\1==\2/' > /tmp/packages-nvidia.txt \
    && echo "========== NVIDIA Packages ==========" \
    && cat /tmp/packages-nvidia.txt \
    && echo "====================================="

# Install big 'nvidia-' packages first
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-deps \
        "$(grep '^nvidia-cublas' /tmp/packages-nvidia.txt)" \
        --index-url https://download.pytorch.org/whl/cu130

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-deps \
        "$(grep '^nvidia-cudnn' /tmp/packages-nvidia.txt)" \
        --index-url https://download.pytorch.org/whl/cu130

# Install all 'nvidia-' packages, 5 at a time
RUN --mount=type=cache,target=/root/.cache/pip \
    head -n 5 /tmp/packages-nvidia.txt | while read -r pkg; do \
        pip install --no-deps "$pkg" \
            --index-url https://download.pytorch.org/whl/cu130; \
    done

RUN --mount=type=cache,target=/root/.cache/pip \
    sed -n '6,10p' /tmp/packages-nvidia.txt | while read -r pkg; do \
        pip install --no-deps "$pkg" \
            --index-url https://download.pytorch.org/whl/cu130; \
    done

RUN --mount=type=cache,target=/root/.cache/pip \
    tail -n +11 /tmp/packages-nvidia.txt | while read -r pkg; do \
        pip install --no-deps "$pkg" \
            --index-url https://download.pytorch.org/whl/cu130; \
    done

# Install PyTorch alone
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-deps \
        "$(grep -oP 'torch-\S+' /tmp/packages.txt | sed 's/\(.*\)-\([^-]*\)$/\1==\2/')" \
        --index-url https://download.pytorch.org/whl/cu130 \
    && rm -v /tmp/pip-dryrun.txt /tmp/packages.txt /tmp/packages-nvidia.txt

# Install everything else, also works as a fail-safe
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu130

# Install Triton (redundant)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        triton pytorch-triton \
        --index-url https://download.pytorch.org/whl/cu130

# Bind libs (.so files)
# Ref: https://github.com/pytorch/pytorch/blob/main/.ci/manywheel/build_cuda.sh
ENV LD_LIBRARY_PATH="/usr/local/lib64/python3.13/site-packages/torch/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cu13/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cudnn/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cusparselt/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/nccl/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/nvshmem/lib\
${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
