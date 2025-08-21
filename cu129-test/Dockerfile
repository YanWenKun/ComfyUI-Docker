################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:cu129-test'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# Using CUDA 12.9, Python 3.13
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
python313-onnx \
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

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
Mesa-libGL1 \
Mesa-libEGL-devel \
libgthread-2_0-0 \
make \
ninja \
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

# Temp fix for OpenCV on openSUSE
ENV LD_PRELOAD=/usr/lib64/libjpeg.so.8

# Temp fix for SentencePiece on CMAKE 4+
ENV CMAKE_POLICY_VERSION_MINIMUM=3.5

################################################################################
# GCC 14 
# Required for compiling CUDA 12.9-related code.

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
# Python Packages

# PyTorch (No xFormers for test-version)
# Break down the steps, so we have more but smaller image layers.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools \
    && pip install \
        --dry-run torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/test/cu129

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps torch \
        --index-url https://download.pytorch.org/whl/test/cu129

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/test/cu129

# Bind libs (.so files)
# Ref: https://github.com/pytorch/pytorch/blob/main/.ci/manywheel/build_cuda.sh
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib64/python3.13/site-packages/torch/lib\
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
:/usr/local/lib/python3.13/site-packages/nvidia/nvtx/lib"

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

# Make sure the deps fit the needs for ComfyUI & Manager
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt \
        -r https://github.com/Comfy-Org/ComfyUI-Manager/raw/refs/heads/main/requirements.txt \
    && pip list

################################################################################

RUN du -ah /root \
    && rm -rf /root/* \
    && rm -rf /root/.[^.]* /root/.??*

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
