################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:cu126-megapak'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# Using CUDA 12.6, Python 3.12
# The container will be running in root (easy for rootless deploy).
################################################################################

FROM docker.io/opensuse/tumbleweed:latest

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
cuda-cccl-12-6 \
cuda-command-line-tools-12-6 \
cuda-compat-12-6 \
cuda-cudart-12-6 \
cuda-minimal-build-12-6 \
cuda-nvcc-12-6 \
cuda-nvprof-12-6 \
cuda-nvtx-12-6

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
libcublas-12-6 \
libnpp-12-6

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-cudart-devel-12-6 \
cuda-nvml-devel-12-6 \
cuda-nvrtc-devel-12-6 \
libcublas-devel-12-6 \
libnpp-devel-12-6

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-libraries-12-6

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-libraries-devel-12-6

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
libcusparselt-devel

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
libcudnn9-cuda-12

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cudnn9-cuda-12-6

ENV PATH="${PATH}:/usr/local/cuda-12.6/bin" \
    LD_LIBRARY_PATH="/usr/lib64:/usr/local/cuda-12.6/lib64" \
    LIBRARY_PATH="/usr/local/cuda-12.6/lib64/stubs" \
    CUDA_HOME="/usr/local/cuda-12.6"

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
python312-numpy \
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

# Note: Using 'update-alternatives' to ensure default Python version.
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
findutils \
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
google-noto-coloremoji-fonts \
    && rm -v /usr/lib64/python3.12/EXTERNALLY-MANAGED \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 100

# Temp fix for OpenCV on openSUSE
ENV LD_PRELOAD=/usr/lib64/libjpeg.so.8

# Temp fix for SentencePiece on CMAKE 4+
ENV CMAKE_POLICY_VERSION_MINIMUM=3.5

################################################################################
# GCC 13 
# Required for compiling CUDA 12.6-related code.

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
gcc13 \
gcc13-c++ \
cpp13 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-13 90 \
    && update-alternatives --install /usr/bin/cc  cc  /usr/bin/gcc-13 90 \
    && update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-13 90 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 90 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 90 \
    && update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-13 90 \
    && update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-13 90 \
    && update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-13 90 \
    && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-13 90 \
    && update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-13 90 \
    && update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-13 90 

################################################################################
# Python Packages

# PyTorch, xFormers
# Break down the steps, so we have more but smaller image layers.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools \
    && pip install \
        --dry-run xformers torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu126 \
        --extra-index-url https://pypi.org/simple

# Here's some hack. To reduce image size & single layer size, we:
# 1. Install PyTorch and all its dependencies.
# 2. Uninstall PyTorch only,
# 3. Delete redundant NVIDIA Python libs (they are already installed as OS packages, except NCCL).
# 4. Install PyTorch again in another layer.
# Note: xFormers is not always released with latest PyTorch, so using `pip install --no-deps` is not a good idea.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        xformers torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu126 \
        --extra-index-url https://pypi.org/simple \
&& pip uninstall --yes torch \
&& find /usr/local/lib/python3.12/site-packages/nvidia/ -mindepth 1 -maxdepth 1 ! -name 'nccl' -exec rm -rfv {} +

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        xformers torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu126 \
        --extra-index-url https://pypi.org/simple

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib64/python3.12/site-packages/torch/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nccl/lib"

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
