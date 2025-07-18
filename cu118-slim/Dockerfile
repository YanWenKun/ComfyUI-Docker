################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:cu118-slim'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# Using CUDA 11.8, Python 3.10, PyTorch 2.7.1
# Using 'root' inside the container (easy for rootless deploy).
################################################################################

FROM docker.io/opensuse/leap:15.6

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

RUN set -eu

################################################################################
# Python and tools
# Since this image is so big, we use openSUSE-verified PIP packages for compatibility.

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_15.6/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python310-devel \
python310-pip \
python310-wheel \
python310-setuptools \
python310-Cython \
python310-py-build-cmake \
python310-aiohttp \
python310-dbm \
python310-ffmpeg-python \
python310-GitPython \
python310-httpx \
python310-joblib \
python310-lark \
python310-matplotlib \
python310-mpmath \
python310-numba-devel \
python310-numpy1 \
python310-onnx \
python310-opencv \
python310-pandas \
python310-qrcode \
python310-rich \
python310-scikit-build \
python310-scikit-build-core-pyproject \
python310-scikit-image \
python310-scikit-learn \
python310-scipy \
python310-svglib \
python310-tqdm \
    && rm /usr/lib64/python3.10/EXTERNALLY-MANAGED \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 100

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

################################################################################
# GCC 11 
# Required for compiling CUDA 11.8-related code.
# Ref: https://docs.nvidia.com/cuda/archive/11.8.0/cuda-installation-guide-linux/index.html

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
gcc11 \
gcc11-c++ \
cpp11 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-11 90 \
    && update-alternatives --install /usr/bin/cc  cc  /usr/bin/gcc-11 90 \
    && update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-11 90 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 90 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 90 \
    && update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-11 90 \
    && update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-11 90 \
    && update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-11 90 \
    && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-11 90 \
    && update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-11 90 \
    && update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-11 90 

################################################################################
# Python Packages

# PyTorch (No xFormers for test-version)
# Break down the steps, so we have more but smaller image layers.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools \
    && pip install \
        --dry-run xformers==0.0.31.post1 torch==2.7.1 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu118 \
        --extra-index-url https://pypi.org/simple

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps torch==2.7.1 \
        --index-url https://download.pytorch.org/whl/cu118 \
        --extra-index-url https://pypi.org/simple

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        xformers==0.0.31.post1 torch==2.7.1 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu118 \
        --extra-index-url https://pypi.org/simple

# Bind libs (.so files)
# Ref: https://github.com/pytorch/pytorch/blob/main/.ci/manywheel/build_cuda.sh
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib64/python3.10/site-packages/torch/lib\
:/usr/local/lib/python3.10/site-packages/cusparselt/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/cublas/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/cuda_cupti/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/cuda_nvrtc/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/cuda_runtime/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/cudnn/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/cufft/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/cufile/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/curand/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/cusolver/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/cusparse/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/cusparselt/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/nccl/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/nvjitlink/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/nvshmem/lib\
:/usr/local/lib/python3.10/site-packages/nvidia/nvtx/lib"

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

# Make sure the deps fit the needs for ComfyUI
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt \
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
