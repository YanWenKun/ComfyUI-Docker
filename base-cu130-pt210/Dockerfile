################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:base-cu130-pt210'
# A base image with:
# * CUDA 13.0
# * Python 3.13 (with GIL)
# * GCC 15
# * PyTorch 2.10.x
#
# Using glibc 2.40 (from openSUSE Leap 16.0).
# Does not install xFormers.
################################################################################

FROM docker.io/opensuse/leap:16.0

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

ARG USING_GITHUB_ACTIONS=false

################################################################################
# NVIDIA CUDA devel
# Ref: https://gitlab.com/nvidia/container-images/cuda/
# Split the steps, so we have more of smaller sized image layers (ideally <500MiB each).
# Note: openSUSE Leap 15 repo is used here (forward-compatible).

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper update --no-confirm

RUN --mount=type=cache,target=/var/cache/zypp \
    printf "\
[cuda-opensuse15-x86_64]\n\
name=cuda-opensuse15-x86_64\n\
baseurl=https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64/D42D0685.pub\n" \
        > /etc/zypp/repos.d/cuda-opensuse15.repo \
    && zypper --verbose --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-cccl-13-0 \
cuda-command-line-tools-13-0 \
cuda-compat-13-0 \
cuda-compiler-13-0 \
cuda-cudart-13-0 \
cuda-minimal-build-13-0 \
cuda-nvcc-13-0 \
cuda-nvtx-13-0

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --verbose --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
libcublas-13-0

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --verbose --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
libcublas-devel-13-0

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --verbose --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-ctadvisor-13-0 \
cuda-cudart-devel-13-0 \
cuda-culibos-devel-13-0 \
cuda-nvml-devel-13-0 \
cuda-nvrtc-devel-13-0 \
cuda-sandbox-devel-13-0 \
libnpp-devel-13-0 \
libnvimgcodec-cuda-13 \
libnvptxcompiler-13-0 \
libnvvm-13-0

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --verbose --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
libcusolver-13-0 \
libcusolver-devel-13-0

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --verbose --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
libcusparse-13-0 \
libcusparse-devel-13-0

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --verbose --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-libraries-13-0

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --verbose --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-libraries-devel-13-0

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --verbose --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cusparselt-cuda-13

# Note the version is specified
# (check that by `zypper se -s libcudnn9` or `zypper -v in cudnn9-cuda-13-0`)
RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --verbose --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
libcudnn9-cuda-13-9.16.0.29-1

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --verbose --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cudnn9-cuda-13-0

ENV PATH="${PATH}:/usr/local/cuda-13.0/bin" \
    LD_LIBRARY_PATH="/usr/lib64:/usr/local/cuda-13.0/lib64" \
    LIBRARY_PATH="/usr/local/cuda-13.0/lib64/stubs" \
    CUDA_HOME="/usr/local/cuda-13.0"

################################################################################
# Python and tools

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_16.0/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python313-devel \
python313-x86-64-v3 \
python313-pip \
python313-wheel \
python313-setuptools \
python313-packaging \
python313-dbm

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
Mesa-libGL-devel \
Mesa-libEGL-devel \
libgthread-2_0-0

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
make \
cmake \
ninja \
git \
aria2 \
findutils \
fish \
fd \
vim \
which \
ffmpeg \
x264 \
x265

# Remove PEP 668 restriction (safe in containers)
RUN rm -vf /usr/lib64/python3.13/EXTERNALLY-MANAGED \
    # Ensure default Python version
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 100

################################################################################
# GCC 15
# Supported by CUDA 13.0: [6, 15]
# Available for openSUSE Leap 16.0: {13, 15}
# https://docs.nvidia.com/cuda/archive/13.0.2/cuda-installation-guide-linux/index.html#host-compiler-support-policy

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
gcc15 \
gcc15-c++ \
cpp15 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-15 90 \
    && update-alternatives --install /usr/bin/cc  cc  /usr/bin/gcc-15 90 \
    && update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-15 90 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-15 90 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-15 90 \
    && update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-15 90 \
    && update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-15 90 \
    && update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-15 90 \
    && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-15 90 \
    && update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-15 90 \
    && update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-15 90 

################################################################################
# PyTorch, xFormers
# Break down the steps, so we have more but smaller image layers.

RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools packaging \
    && pip install \
        --dry-run torch==2.10.0 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu130

# Here's some hack. To reduce image size & single layer size, we:
# 1. Install PyTorch and all its dependencies.
# 2. Uninstall PyTorch only,
# 3. Delete redundant NVIDIA Python libs (they are already installed as OS packages, except NCCL and NVSHMEM).
# 4. Install PyTorch again in another layer.
# Note: xFormers is not always released with latest PyTorch, so using `pip install --no-deps` is not a good idea.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch==2.10.0 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu130 \
&& pip uninstall --yes torch \
&& find /usr/local/lib/python3.13/site-packages/nvidia/ -mindepth 1 -maxdepth 1 ! -name 'nccl' ! -name 'nvshmem' -exec rm -rfv {} +

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch==2.10.0 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu130

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib64/python3.13/site-packages/torch/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/nccl/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/nvshmem/lib"

# ################################################################################
# # More Python Packages

# # Deps for ComfyUI & custom nodes
# COPY builder-scripts/.  /builder-scripts/

# RUN --mount=type=cache,target=/root/.cache/pip \
#     pip install \
#         -r /builder-scripts/pak3.txt

# RUN --mount=type=cache,target=/root/.cache/pip \
#     pip install \
#         -r /builder-scripts/pak5.txt

# RUN --mount=type=cache,target=/root/.cache/pip \
#     pip install \
#         -r /builder-scripts/pak7.txt

# # Prevent SAM-2 from installing CUDA packages
# # SAM-2 is used by ComfyUI-Impact-Pack
# RUN --mount=type=cache,target=/root/.cache/pip \
#     cd /builder-scripts \
#     && git clone https://github.com/facebookresearch/sam2.git \
#     && cd sam2 \
#     && SAM2_BUILD_CUDA=1 pip install \
#         -e . --no-deps --no-build-isolation \
#     && cd /

# # Prevent SAM-3 from installing NumPy1
# RUN --mount=type=cache,target=/root/.cache/pip \
#     cd /builder-scripts \
#     && git clone https://github.com/facebookresearch/sam3.git \
#     && cd sam3 \
#     && pip install \
#         -e . --no-deps --no-build-isolation \
#     && cd /

# RUN --mount=type=cache,target=/root/.cache/pip \
#     # Update UV
#     pip install -U uv \
#     # Nunchaku (binary pair with PyTorch)
#     && pip install \
# https://github.com/nunchaku-tech/nunchaku/releases/download/v1.0.2/nunchaku-1.0.2+torch2.8-cp312-cp312-linux_x86_64.whl \
#     # FlashAttention (version pair with xFormers, binary pair with PyTorch & CUDA)
#     && pip install \
# https://github.com/mjun0812/flash-attention-prebuild-wheels/releases/download/v0.3.14/flash_attn-2.8.2+cu128torch2.8-cp312-cp312-linux_x86_64.whl \
#     # SageAttention
#     && pip install \
# https://github.com/YanWenKun/ComfyUI-Containerfiles/releases/download/sageattn2/sageattention-2.2.0-cp312-cp312-linux_x86_64.whl \
#     # SpargeAttention (Sparse-SageAttention)
#     && pip install \
# https://github.com/YanWenKun/ComfyUI-Containerfiles/releases/download/sageattn2/spas_sage_attn-0.1.0-cp312-cp312-linux_x86_64.whl

# ################################################################################
# # Bundle ComfyUI in the image

# WORKDIR /default-comfyui-bundle

# RUN bash /builder-scripts/preload-cache.sh

# # Install deps (comfyui-frontend-package, etc) pair to the preloaded ComfyUI version
# RUN --mount=type=cache,target=/root/.cache/pip \
#     pip install \
#         -r '/default-comfyui-bundle/ComfyUI/requirements.txt' \
#         -r '/default-comfyui-bundle/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt' \
#     && pip list

# ################################################################################

# # Clean cache to avoid GitHub Actions "No space left on device"
# RUN --mount=type=cache,target=/root/.cache/pip \
#     if [ "${USING_GITHUB_ACTIONS}" = "true" ]; then \
#         rm -rf /root/.cache/pip/* ; \
#     fi

# RUN du -ah /root \
#     && find /root -mindepth 1 -maxdepth 1 -exec rm -rfv {} +

# COPY runner-scripts/.  /runner-scripts/

# USER root
# VOLUME /root
# WORKDIR /root
# EXPOSE 8188
# ENV CLI_ARGS=""
# CMD ["bash","/runner-scripts/entrypoint.sh"]
