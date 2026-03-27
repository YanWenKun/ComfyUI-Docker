################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:nightly'
# A image for testing with latest ComfyUI and nightly/experimental dependencies.
#
# Note about Ubuntu 26.04:
# - GCC 15
# - The Docker image uses glibc 2.42, but the daily ISO uses glibc 2.43.
#   Expect upgrades in the future.
################################################################################

ARG REGISTRY=docker.io
FROM ${REGISTRY}/library/ubuntu:26.04

ARG USING_GITHUB_ACTIONS=false

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/usr/bin/bash", "-euo", "pipefail", "-c"]

ARG PIP_ROOT_USER_ACTION='ignore'
ARG PIP_NO_BUILD_ISOLATION=1

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
python3.14-full \
python3.14-dev \
libegl1-mesa-dev \
ca-certificates \
curl \
git \
gnupg2 \
cmake \
ninja-build \
aria2 \
curl \
fish \
fd-find \
less \
vim \
ca-certificates \
libjpeg-dev \
libpng-dev \
    && rm -vrf /var/lib/apt/lists/* \
    && rm -vf /usr/lib/python3.14/EXTERNALLY-MANAGED

################################################################################
# Install PIP in a classic way
# Note: in Ubuntu/Debian, PIP packages installed by APT were locked.
RUN --mount=type=cache,target=/root/.cache/pip \
    aria2c https://bootstrap.pypa.io/get-pip.py \
    && python3.14 get-pip.py \
    && rm get-pip.py \
    && pip install \
        wheel setuptools \
    && pip list \
    && df -h

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
        --index-url https://download.pytorch.org/whl/nightly/cu130 \
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
        --index-url https://download.pytorch.org/whl/nightly/cu130

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-deps \
        "$(grep '^nvidia-cudnn' /tmp/packages-nvidia.txt)" \
        --index-url https://download.pytorch.org/whl/nightly/cu130

# Install all 'nvidia-' packages, 5 at a time
RUN --mount=type=cache,target=/root/.cache/pip \
    head -n 5 /tmp/packages-nvidia.txt | while read -r pkg; do \
        pip install --no-deps "$pkg" \
            --index-url https://download.pytorch.org/whl/nightly/cu130; \
    done

RUN --mount=type=cache,target=/root/.cache/pip \
    sed -n '6,10p' /tmp/packages-nvidia.txt | while read -r pkg; do \
        pip install --no-deps "$pkg" \
            --index-url https://download.pytorch.org/whl/nightly/cu130; \
    done

RUN --mount=type=cache,target=/root/.cache/pip \
    tail -n +11 /tmp/packages-nvidia.txt | while read -r pkg; do \
        pip install --no-deps "$pkg" \
            --index-url https://download.pytorch.org/whl/nightly/cu130; \
    done

# Install PyTorch alone
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-deps \
        "$(grep -oP 'torch-\S+' /tmp/packages.txt | sed 's/\(.*\)-\([^-]*\)$/\1==\2/')" \
        --index-url https://download.pytorch.org/whl/nightly/cu130

# Install everything else, also works as a fail-safe
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/nightly/cu130 \
    && rm -v /tmp/pip-dryrun.txt /tmp/packages.txt /tmp/packages-nvidia.txt

# Bind libs (.so files)
# Ref: https://github.com/pytorch/pytorch/blob/main/.ci/manywheel/build_cuda.sh
ENV LD_LIBRARY_PATH="/usr/local/lib64/python3.14/site-packages/torch/lib\
:/usr/local/lib/python3.14/site-packages/nvidia/cu13/lib\
:/usr/local/lib/python3.14/site-packages/nvidia/cudnn/lib\
:/usr/local/lib/python3.14/site-packages/nvidia/cusparselt/lib\
:/usr/local/lib/python3.14/site-packages/nvidia/nccl/lib\
:/usr/local/lib/python3.14/site-packages/nvidia/nvshmem/lib\
${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

################################################################################
# Bundle ComfyUI directly in /root
WORKDIR /root

# Use latest ComfyUI (dev)
RUN git clone 'https://github.com/comfyanonymous/ComfyUI.git'

# Install only essential dependencies for ComfyUI
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r /root/ComfyUI/requirements.txt

################################################################################
# Finishing
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

CMD ["bash", "-c", "python3.14 ./ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}"]
