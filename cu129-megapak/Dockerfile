################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:cu129-megapak'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# Using CUDA 12.9, Python 3.12
# The container will be running in root (easy for rootless deploy).
################################################################################

FROM docker.io/opensuse/tumbleweed:latest

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

RUN set -eu

ARG USING_GITHUB_ACTIONS=false

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
cuda-cccl-12-9 \
cuda-command-line-tools-12-9 \
cuda-compat-12-9 \
cuda-cudart-12-9 \
cuda-minimal-build-12-9 \
cuda-nvcc-12-9 \
cuda-nvprof-12-9 \
cuda-nvtx-12-9

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
libcublas-12-9 \
libnpp-12-9

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-cudart-devel-12-9 \
cuda-nvml-devel-12-9 \
cuda-nvrtc-devel-12-9 \
libcublas-devel-12-9 \
libnpp-devel-12-9

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-libraries-12-9

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-libraries-devel-12-9

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
libcusparselt-devel

# Since 12.9 is the last version of CUDA 12, we don't need to specify the exact version of libcudnn9.
RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
libcudnn9-cuda-12

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cudnn9-cuda-12-9

ENV PATH="${PATH}:/usr/local/cuda-12.9/bin" \
    LD_LIBRARY_PATH="/usr/lib64:/usr/local/cuda-12.9/lib64" \
    LIBRARY_PATH="/usr/local/cuda-12.9/lib64/stubs" \
    CUDA_HOME="/usr/local/cuda-12.9"

################################################################################
# Python and tools
# Since this image is so big, we use openSUSE-verified PIP packages for compatibility.

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python312-devel \
python312-pip \
python312-wheel \
python312-setuptools \
python312-Cython \
python312-py-build-cmake \
python312-matplotlib \
python312-mpmath \
python312-numba-devel \
# python312-numpy \ # Numba conflicts with latest NumPy
python312-onnx \
python312-pandas \
python312-scikit-build \
python312-scikit-build-core-pyproject \
python312-scikit-image \
python312-scikit-learn \
python312-scipy

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python312-opencv \
opencv \
opencv-devel \
Mesa-libGL1 \
Mesa-libEGL-devel \
libgthread-2_0-0 \
libQt5OpenGL-devel

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python312-addict \
python312-aenum \
python312-aiohttp \
python312-alembic \
python312-black \
python312-cachetools \
python312-chardet \
python312-dbm \
python312-deepdiff \
python312-dill \
python312-ffmpeg-python \
python312-filelock \
python312-ftfy \
python312-GitPython \
python312-httpx \
python312-imageio \
python312-importlib-metadata \
python312-joblib \
python312-lark \
python312-loguru \
python312-mss \
python312-numexpr \
python312-piexif \
python312-protobuf \
python312-py-cpuinfo \
python312-pydantic \
python312-pydantic-settings \
python312-pydub \
python312-pygit2 \
python312-PyGithub \
python312-PyYAML \
python312-regex \
python312-qrcode \
python312-rich \
python312-safetensors \
python312-simpleeval \
python312-SoundFile \
python312-SQLAlchemy \
python312-svglib \
python312-tokenizers \
python312-toml \
python312-tqdm \
python312-typer \
python312-uv \
python312-webcolors \
python312-yapf \
python312-yarl

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
make \
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
x265 \
google-noto-sans-fonts \
google-noto-sans-cjk-fonts \
google-noto-coloremoji-fonts \
    && rm -v /usr/lib64/python3.12/EXTERNALLY-MANAGED \
    # Ensure default Python version
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 100

# Temp fix for OpenCV on openSUSE
ENV LD_PRELOAD=/usr/lib64/libjpeg.so.8

# Temp fix for SentencePiece on CMAKE 4+
ENV CMAKE_POLICY_VERSION_MINIMUM=3.5

################################################################################
# GCC 14
# Compatible with CUDA 12.9.
# https://docs.nvidia.com/cuda/archive/12.9.1/cuda-installation-guide-linux/index.html#host-compiler-support-policy

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

# PyTorch, xFormers
# Break down the steps, so we have more but smaller image layers.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools \
    && pip install \
        --dry-run xformers==0.0.32.post2 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu129

# Here's some hack. To reduce image size & single layer size, we:
# 1. Install PyTorch and all its dependencies.
# 2. Uninstall PyTorch only,
# 3. Delete redundant NVIDIA Python libs (they are already installed as OS packages, except NCCL).
# 4. Install PyTorch again in another layer.
# Note: xFormers is not always released with latest PyTorch, so using `pip install --no-deps` is not a good idea.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        xformers==0.0.32.post2 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu129 \
&& pip uninstall --yes torch \
&& find /usr/local/lib/python3.12/site-packages/nvidia/ -mindepth 1 -maxdepth 1 ! -name 'nccl' -exec rm -rfv {} +

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        xformers==0.0.32.post2 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu129

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib64/python3.12/site-packages/torch/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nccl/lib"

# Install Triton (redundant)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        triton pytorch-triton \
        --index-url https://download.pytorch.org/whl/cu129

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

# Temp fixes
# Prevent SAM-2 from installing CUDA packages
# SAM-2 is used by ComfyUI-Impact-Pack
RUN --mount=type=cache,target=/root/.cache/pip \
    cd /builder-scripts \
    && git clone https://github.com/facebookresearch/sam2.git \
    && cd sam2 \
    && SAM2_BUILD_CUDA=1 pip install \
        -e . --no-deps --no-build-isolation \
    && cd /

RUN --mount=type=cache,target=/root/.cache/pip \
    # Update UV
    pip install -U uv \
    # Nunchaku version needs to sync with PyTorch version
    && pip install \
https://github.com/nunchaku-tech/nunchaku/releases/download/v1.0.0/nunchaku-1.0.0+torch2.8-cp312-cp312-linux_x86_64.whl

# Notes on FlashAttention:
# <xformers 0.0.32.post2> requires <flash-attn [2.7.1, 2.8.2]>,
# but flash-attn 2.8.2 does not have binary wheel for PyTorch 2.8.
# Now using xformers embbeded flash-attn.
# May need to suppress some custom nodes that explicit depends on flash-attn.
# Wait for xFormers to update.

################################################################################
# Bundle ComfyUI in the image

WORKDIR /default-comfyui-bundle

RUN bash /builder-scripts/preload-cache.sh

# Install deps (comfyui-frontend-package, etc) pair to the preloaded ComfyUI version
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r '/default-comfyui-bundle/ComfyUI/requirements.txt' \
        -r '/default-comfyui-bundle/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt' \
    && pip list

################################################################################

# Clean cache to avoid GitHub Actions "No space left on device"
RUN --mount=type=cache,target=/root/.cache/pip \
    if [ "${USING_GITHUB_ACTIONS}" = "true" ]; then \
        rm -rf /root/.cache/pip/* ; \
    fi

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
