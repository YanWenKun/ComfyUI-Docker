################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:xpu'
# A runtime environment for https://github.com/Comfy-Org/ComfyUI
# Running on XPU (Intel GPU).
# Using Python 3.14, GCC 15.
# Using 'root' user inside container.
################################################################################

FROM fedora:43

LABEL maintainer="code@yanwk.fun"

################################################################################
# System Packages

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y --nogpgcheck \
        'https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-43.noarch.rpm' \
    && dnf upgrade -y \
    && dnf install -y \
python3.14-devel \
python3-pip \
python3-wheel \
python3-setuptools \
python3-cython \
make \
ninja-build \
python3-cmake

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
ffmpeg \
x264 \
x265 \
default-fonts-cjk

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
mesa-libGL \
mesa-libEGL \
git \
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

# Fedora 43 defaults to GCC 15
RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
gcc \
gcc-c++

################################################################################
# Python Packages - PyTorch

ARG PIP_ROOT_USER_ACTION='ignore'
ARG PIP_NO_BUILD_ISOLATION=1

RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools packaging

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/xpu \
    && pip uninstall --yes torch

# Install torch separately to reduce image layer size
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/xpu

################################################################################
# Python Packages - Deps for ComfyUI & custom nodes
COPY builder-scripts/.  /builder-scripts/

# Generate a version constraints file to pin PyTorch (prevent later installs from changing its version)
RUN pip list --format=freeze \
        | awk -F== 'BEGIN{want["torch"]=1;want["torchvision"]=1;want["torchaudio"]=1} $1 in want{print $1 "==" $2}' \
        > /builder-scripts/constraints.txt \
    && echo "Pinned PyTorch version:" \
    && cat /builder-scripts/constraints.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak3.txt \
        -c /builder-scripts/constraints.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak5.txt \
        -c /builder-scripts/constraints.txt

# Temp fix for SentencePiece on CMAKE 4+
ENV CMAKE_POLICY_VERSION_MINIMUM=3.5

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak7.txt \
        -c /builder-scripts/constraints.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak9.txt \
        -c /builder-scripts/constraints.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pakA.txt \
        -c /builder-scripts/constraints.txt

################################################################################

WORKDIR /default-comfyui-bundle

RUN bash /builder-scripts/preload-cache.sh

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r '/default-comfyui-bundle/ComfyUI/requirements.txt' \
        -r '/default-comfyui-bundle/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt' \
        -c /builder-scripts/constraints.txt

# Ensure deps match
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/xpu \
    && pip list

################################################################################

ENV LD_LIBRARY_PATH="/usr/local/lib\
:/usr/local/lib64/python3.14/site-packages/torch/lib/\
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
