################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:cu118-megapak'
# A big all-in-one package for ComfyUI with many custom nodes.
# Using CUDA 11.8, Python 3.11, PyTorch 2.7.1
# Using 'root' inside the container (easy for rootless deploy).
################################################################################

FROM docker.io/opensuse/leap:15.6

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

RUN set -eu

################################################################################
# NVIDIA CUDA devel
# Ref: https://gitlab.com/nvidia/container-images/cuda/
# Break down the steps, so we have more but smaller image layers.

RUN --mount=type=cache,target=/var/cache/zypp \
    printf "\
[cuda-opensuse15-x86_64]\n\
name=cuda-opensuse15-x86_64\n\
baseurl=https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64/D42D0685.pub\n" \
        > /etc/zypp/repos.d/cuda-opensuse15.repo \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-cccl-11-8 \
cuda-command-line-tools-11-8 \
cuda-compat-11-8 \
cuda-cudart-11-8 \
cuda-minimal-build-11-8 \
cuda-nvcc-11-8 \
cuda-nvprof-11-8 \
cuda-nvtx-11-8 \
libcublas-11-8 \
libnpp-11-8

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-cudart-devel-11-8 \
cuda-nvml-devel-11-8 \
cuda-nvrtc-devel-11-8 \
libcublas-devel-11-8 \
libnpp-devel-11-8

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-libraries-11-8

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-libraries-devel-11-8

ENV PATH="${PATH}:/usr/local/cuda-11.8/bin" \
    LD_LIBRARY_PATH="/usr/local/cuda-11.8/lib64" \
    LIBRARY_PATH="/usr/local/cuda-11.8/lib64/stubs" \
    CUDA_HOME="/usr/local/cuda-11.8"

################################################################################
# Python and tools
# Since this image is so big, we use openSUSE-verified PIP packages for compatibility.

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_15.6/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python311-devel \
python311-pip \
python311-wheel \
python311-setuptools \
python311-Cython \
python311-aiohttp \
python311-dbm \
python311-GitPython \
python311-httpx \
python311-lark \
python311-matplotlib \
python311-numpy \
python311-opencv \
python311-qrcode \
python311-rich \
python311-scikit-build \
python311-tqdm \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 100

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
Mesa-libGL1 \
Mesa-libEGL-devel \
libgthread-2_0-0 \
make \
cmake \
ninja \
git \
aria2 \
# fish \
fd \
vim \
opencv \
opencv-devel \
ffmpeg \
x264 \
x265

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

# PyTorch, xFormers
# Break down the steps, so we have more but smaller image layers.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools \
    && pip install \
        --dry-run xformers==0.0.31.post1 torch==2.7.1 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu118

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps torch==2.7.1 \
        --index-url https://download.pytorch.org/whl/cu118

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        xformers==0.0.31.post1 torch==2.7.1 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu118

# Bind libs (.so files)
# Ref: https://github.com/pytorch/pytorch/blob/main/.ci/manywheel/build_cuda.sh
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib64/python3.11/site-packages/torch/lib\
:/usr/local/lib/python3.11/site-packages/cusparselt/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cublas/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cuda_cupti/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cuda_nvrtc/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cuda_runtime/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cudnn/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cufft/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cufile/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/curand/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cusolver/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cusparse/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cusparselt/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/nccl/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/nvjitlink/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/nvshmem/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/nvtx/lib"

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

# Install ONNX Runtime for CUDA 11.8
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --force-reinstall onnxruntime-gpu \
        --index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-11/pypi/simple/

# Make sure the deps fit the needs for ComfyUI
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt \
    && pip install mediapipe \
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
