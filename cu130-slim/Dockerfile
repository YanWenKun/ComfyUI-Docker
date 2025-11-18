################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:cu130-slim'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# Using CUDA 13.0, Python 3.13 (with GIL).
# Does not install xFormers by default.
# The container will be running in root (easy for rootless deploy).
################################################################################

FROM docker.io/opensuse/tumbleweed:latest

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

RUN set -eu

################################################################################
# Python and tools
# Since this image is so big, we use openSUSE-verified PIP packages for compatibility.

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python313-devel \
python313-pip \
python313-wheel \
python313-setuptools \
python313-Cython \
python313-py-build-cmake \
python313-matplotlib \
python313-mpmath \
python313-numba-devel \
# python313-numpy \ # Numba conflicts with latest NumPy
python313-onnx \
python313-pandas \
python313-scikit-build \
python313-scikit-build-core-pyproject \
python313-scikit-image \
python313-scikit-learn \
python313-scipy

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python313-opencv \
opencv \
opencv-devel \
Mesa-libGL1 \
Mesa-libEGL-devel \
libgthread-2_0-0 \
libQt5OpenGL5

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python313-ffmpeg-python \
python313-imageio \
python313-svglib \
ffmpeg \
x264 \
x265 \
python313-GitPython \
python313-pygit2 \
git

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
make \
bison \
gawk \
ninja \
aria2 \
findutils \
fish \
fd \
fuse \
vim \
which \
google-noto-sans-fonts \
    && rm -v /usr/lib64/python3.13/EXTERNALLY-MANAGED \
    # Ensure default Python version
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 100

# Temp fix for OpenCV on openSUSE
ENV LD_PRELOAD=/usr/lib64/libjpeg.so.8

# Temp fix for SentencePiece on CMAKE 4+
ENV CMAKE_POLICY_VERSION_MINIMUM=3.5

################################################################################
# GCC 15
# Compatible with CUDA 13.0.
# https://docs.nvidia.com/cuda/archive/13.0.1/cuda-installation-guide-linux/index.html#host-compiler-support-policy

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
# Python Packages

# PyTorch
# Break down the steps, so we have more but smaller image layers.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools

# 1. Dry run `pip install` to get the list of packages
# 2. Extract the package names and versions from the output
#    Example: nvidia-cuda-runtime-cu12-12.6.77 -> nvidia-cuda-runtime-cu12==12.6.77
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
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
:/usr/local/lib/python3.13/site-packages/cusparselt/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cublas/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cuda_cupti/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cuda_nvrtc/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cuda_runtime/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cudnn/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cufft/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cufile/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/curand/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cusolver/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cusparse/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/cusparselt/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/nccl/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/nvjitlink/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/nvshmem/lib\
:/usr/local/lib/python3.13/site-packages/nvidia/nvtx/lib\
${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

# Deps for ComfyUI & custom nodes
COPY builder-scripts/.  /builder-scripts/

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak3.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak5.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak7.txt

################################################################################
# Pre-download a ComfyUI bundle in the image

WORKDIR /default-comfyui-bundle

RUN bash /builder-scripts/preload-cache.sh

# Install deps (comfyui-frontend-package, etc) pair to the preloaded ComfyUI version
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r '/default-comfyui-bundle/ComfyUI/requirements.txt' \
        -r '/default-comfyui-bundle/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt' \
    && pip list

################################################################################

RUN du -ah /root \
    && rm -rfv /root/* \
    && rm -rfv /root/.[^.]* /root/.??*

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
