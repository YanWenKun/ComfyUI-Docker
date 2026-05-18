################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:base-rocm72-pt211'
# Using:
# - Python 3.13 (with GIL)
# - PyTorch 2.11 + ROCm 7.2 
################################################################################

ARG REGISTRY=docker.io

FROM ${REGISTRY}/opensuse/tumbleweed:latest

LABEL maintainer="code@yanwk.fun"

ARG USING_GITHUB_ACTIONS=false

################################################################################
# System Packages

# Note: CMake may use different version of Python. Using 'update-alternatives' to ensure default version.
RUN --mount=type=cache,target=/var/cache/zypp \
    zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/' packman-essentials \
    && zypper addrepo --check --refresh --priority 80 \
        'https://download.opensuse.org/repositories/science:/GPU:/ROCm/openSUSE_Tumbleweed/science:GPU:ROCm.repo' \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python313-devel \
python313-pip \
python313-wheel \
python313-setuptools \
python313-Cython \
python313-py-build-cmake \
python313-aiohttp \
python313-dbm \
python313-ffmpeg-python \
python313-GitPython \
python313-httpx \
python313-joblib \
python313-lark \
python313-matplotlib \
python313-mpmath \
python313-numba-devel \
# python313-numpy \ # Numba conflicts with latest NumPy
# python313-onnx \
python313-opencv \
python313-pandas \
python313-qrcode \
python313-rich \
python313-scikit-build \
python313-scikit-build-core-pyproject \
python313-scikit-image \
python313-scikit-learn \
python313-scipy \
python313-svglib \
python313-tqdm \
    && rm /usr/lib64/python3.13/EXTERNALLY-MANAGED \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 100

# Note: 'half' for ONNX Runtime on ROCm.
RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
Mesa-libGL1 \
Mesa-libEGL-devel \
ghc-half \
libgthread-2_0-0 \
make \
ninja \
shadow \
git \
aria2 \
fish \
fd \
vim \
which \
opencv \
opencv-devel \
ffmpeg \
x264 \
x265 \
google-noto-sans-fonts \
google-noto-sans-cjk-fonts \
google-noto-coloremoji-fonts

################################################################################
# GCC 14
# Keep in mind that (GCC >= 13) does not implicitly include <cstdint>. Some repos will need fix before compiling.

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
gcc14 \
gcc14-c++ \
cpp14 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-14 90 \
    && update-alternatives --install /usr/bin/cc  cc  /usr/bin/gcc-14 90 \
    && update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-14 90 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 90 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 90 \
    && update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-14 90 \
    && update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-14 90 \
    && update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-14 90 \
    && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-14 90 \
    && update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-14 90 \
    && update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-14 90 

################################################################################
# PyTorch
# Note: the patch version digit is neglected.

RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools packaging \
    && pip install \
        --dry-run torch==2.11 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/rocm7.2

# To reduce image size & single layer size, we:
# 1. Install PyTorch and all its dependencies.
# 2. Uninstall PyTorch only,
# 3. Install PyTorch again in another layer.

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch==2.11 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/rocm7.2 \
    && pip uninstall --yes torch

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch==2.11 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/rocm7.2 \
    && pip list
