################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:cpu'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# Using CPU only (not using GPU).
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
# python313-numpy \ # Latest NumPy conflicts with Numba
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
python313-addict \
python313-aenum \
python313-aiohttp \
python313-alembic \
python313-black \
python313-cachetools \
python313-chardet \
python313-dbm \
python313-deepdiff \
python313-dill \
python313-ffmpeg-python \
python313-filelock \
python313-ftfy \
python313-GitPython \
python313-httpx \
python313-imageio \
python313-importlib-metadata \
python313-joblib \
python313-lark \
python313-loguru \
python313-mss \
python313-numexpr \
python313-piexif \
python313-protobuf \
python313-py-cpuinfo \
python313-pydantic \
python313-pydantic-settings \
python313-pydub \
python313-pygit2 \
python313-PyGithub \
python313-PyYAML \
python313-regex \
python313-qrcode \
python313-rich \
python313-safetensors \
python313-simpleeval \
python313-SoundFile \
python313-SQLAlchemy \
python313-svglib \
python313-tokenizers \
python313-toml \
python313-tqdm \
python313-typer \
python313-uv \
python313-webcolors \
python313-yapf \
python313-yarl

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
    && rm -v /usr/lib64/python3.13/EXTERNALLY-MANAGED \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 100

# Temp fix for OpenCV on openSUSE
ENV LD_PRELOAD=/usr/lib64/libjpeg.so.8

# Temp fix for SentencePiece on CMAKE 4+
ENV CMAKE_POLICY_VERSION_MINIMUM=3.5

################################################################################
# GCC 14
# Align with CUDA 12.9.

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

# PyTorch
# Break down the steps, so we have more but smaller image layers.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools \
    && pip install \
        --dry-run torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cpu

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cpu

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cpu

# Bind libs (.so files)
ENV LD_LIBRARY_PATH="/usr/local/lib64/python3.13/site-packages/torch/lib\
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
    && rm -rf /root/* \
    && rm -rf /root/.[^.]* /root/.??*

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS="--cpu"
CMD ["bash","/runner-scripts/entrypoint.sh"]
