################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:xpu'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# Running on XPU (Intel GPU).
# Does NOT install IPEX (Intel Extension for PyTorch).
# Using Python 3.13, GCC 14.
# Using 'root' inside the container.
################################################################################

FROM fedora:42

LABEL maintainer="code@yanwk.fun"

RUN set -eu

################################################################################
# OS Packages

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y --nogpgcheck \
        'https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-42.noarch.rpm' \
    && dnf upgrade -y \
    && dnf install -y \
python3.13-devel \
python3-pip \
python3-wheel \
python3-setuptools \
python3-cython \
make \
ninja \
python3-cmake

# RUN --mount=type=cache,target=/var/cache/dnf \
#     dnf install -y \
# python3-matplotlib \
# python3-mpmath \
# python3-numpy \
# python3-onnx

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
ffmpeg \
x264 \
x265 \
default-fonts-cjk

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
python3-opencv \
python3-cairo

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
mesa-libGL \
mesa-libEGL \
# python3-GitPython \
git \
# python3-pandas \
# python3-scikit-build-core \
# python3-scikit-image \
# python3-scikit-learn \
fish \
aria2 \
fd-find \
vim \
which

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
intel-compute-runtime \
intel-level-zero \
intel-level-zero-devel \
oneapi-level-zero \
oneapi-level-zero-devel \
intel-ocloc \
intel-opencl \
intel-igc \
clinfo \
openssl

################################################################################
# GCC 14
# Fedora 42 defaults to GCC 15

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
gcc14 \
gcc14-c++ \
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

# ################################################################################
# PyTorch (No IPEX)

ARG PIP_ROOT_USER_ACTION='ignore'
ARG PIP_NO_BUILD_ISOLATION=1

RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --dry-run torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/xpu \
    && pip install \
        --no-deps torch \
        --index-url https://download.pytorch.org/whl/xpu

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/xpu

# Deps for ComfyUI & custom nodes
COPY builder-scripts/.  /builder-scripts/

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak3.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak5.txt

# Temp fix for SentencePiece on CMAKE 4+
ENV CMAKE_POLICY_VERSION_MINIMUM=3.5

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak7.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak9.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pakA.txt

# Ensure deps match
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/xpu

################################################################################

WORKDIR /default-comfyui-bundle

RUN bash /builder-scripts/preload-cache.sh

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r '/default-comfyui-bundle/ComfyUI/requirements.txt' \
        -r '/default-comfyui-bundle/ComfyUI/manager_requirements.txt' \
    && pip list

################################################################################

ENV LD_LIBRARY_PATH="/usr/local/lib\
:/usr/local/lib64/python3.13/site-packages/torch/lib/\
${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

################################################################################

RUN df -h \
    && du -ah /root \
    && find /root/ -mindepth 1 -delete

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
