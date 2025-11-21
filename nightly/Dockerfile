################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:nightly'
# A image for testing with latest ComfyUI and nightly/experimental dependencies.
#
# Using image from NVIDIA as base image:
# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda/tags
#
# Note about Python:
# Using No-GIL (free threading) build, note the 't' suffix in python3.14t.
#
# Note about GCC:
# Ubuntu 24.04 comes with GCC 13, so no additional config here.
#
# Note about environment variables in NVIDIA's image:
# 1. There's no CUDA_HOME or CUDA_PATH.
# 2. The LD_LIBRARY_PATH was intended to point to a non-existent folder.
# Ref: https://gitlab.com/nvidia/container-images/cuda/-/issues/47
################################################################################

FROM nvidia/cuda:13.0.2-cudnn-devel-ubuntu24.04

ARG USING_GITHUB_ACTIONS=false

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        gnupg2 ca-certificates curl \
    && echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu noble main" \
        > /etc/apt/sources.list.d/deadsnakes.list \
    && curl -fsSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x6a755776' \
       | gpg --dearmor -o /etc/apt/trusted.gpg.d/deadsnakes.gpg \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
python3.14-full \
python3.14-dev \
python3.14-nogil \
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
ca-certificates \
libjpeg-dev \
libpng-dev

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get install -y --no-install-recommends \
# Will also install libcusparselt0-cuda-13 & libcusparselt0-dev-cuda-13
cusparselt-cuda-13 \
# Will also install libnvshmem3-cuda-13 & libnvshmem3-dev-cuda-13 & libnvshmem3-static-cuda-13
nvshmem-cuda-13 \
    && rm -vrf /var/lib/apt/lists/* \
    && rm -vf /usr/lib/python3.14/EXTERNALLY-MANAGED

################################################################################
# In Ubuntu/Debian, PIP packages installed by APT were locked.
# So here we install PIP in a classic way, make it easier to update.
RUN --mount=type=cache,target=/root/.cache/pip \
    aria2c https://bootstrap.pypa.io/get-pip.py \
    && python3.14t get-pip.py \
    && rm get-pip.py \
    && pip install \
        wheel setuptools \
    && pip list \
    && df -h

################################################################################
# PyTorch
# To reduce image size & single layer size, we:
# 1. Fetch the list of packages and download them into the cache.
# 2. Install PyTorch only.
# 3. Install all dependencies.
# 4. Delete redundant NVIDIA Python libs (they are already installed as OS packages).
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --dry-run --pre torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/nightly/cu130

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps --pre torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/nightly/cu130

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --pre torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/nightly/cu130 \
    && find /usr/local/lib/python3.14t/dist-packages/nvidia/ -mindepth 1 -maxdepth 1 -exec rm -rfv {} +

################################################################################
# Bundle ComfyUI directly in /root
WORKDIR /root

# Use latest ComfyUI (dev)
RUN git clone 'https://github.com/comfyanonymous/ComfyUI.git'

# Install only essential dependencies for ComfyUI
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r /root/ComfyUI/requirements.txt

################################################################################
# Clean cache to avoid GitHub Actions "No space left on device"
RUN --mount=type=cache,target=/root/.cache/pip \
    if [ "${USING_GITHUB_ACTIONS}" = "true" ]; then \
        rm -rf /root/.cache/pip/* ; \
    fi

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

CMD ["bash", "-c", "python3.14t ./ComfyUI/main.py --listen --port 8188 ${CLI_ARGS}"]
