################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:rocm6'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# With ROCm 6 for AMD GPU.
################################################################################

FROM opensuse/tumbleweed:latest

LABEL maintainer="code@yanwk.fun"

RUN set -eu

ARG USING_GITHUB_ACTIONS=false

################################################################################
# Python and tools

# Note: CMake may use different version of Python. Using 'update-alternatives' to ensure default version.
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
python312-aiohttp \
python312-dbm \
python312-ffmpeg-python \
python312-GitPython \
python312-httpx \
python312-joblib \
python312-lark \
python312-matplotlib \
python312-mpmath \
python312-numba-devel \
# python312-numpy \ # Numba conflicts with latest NumPy
python312-onnx \
python312-opencv \
python312-pandas \
python312-qrcode \
python312-rich \
python312-scikit-build \
python312-scikit-build-core-pyproject \
python312-scikit-image \
python312-scikit-learn \
python312-scipy \
python312-svglib \
python312-tqdm \
    && rm /usr/lib64/python3.12/EXTERNALLY-MANAGED \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 100

# Note: 'half' for ORT on ROCm.
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
# GCC 13
# GCC 12 was dropped in 2025 OpenSUSE Tumbleweed updates.
# Keep in mind that (GCC >= 13) does not implicitly include <cstdint>. Some repos will need fix before compiling.

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
RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools

# PyTorch ROCm
# Ref: https://rocm.docs.amd.com/projects/radeon/en/latest/docs/install/native_linux/install-pytorch.html
# Ref: https://rocm.docs.amd.com/projects/radeon/en/latest/docs/install/native_linux/install-onnx.html
# Ref: https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html

# Break down the steps for smaller image layers.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
--no-deps https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/torch-2.7.1%2Brocm6.4.4.git1781ec08-cp312-cp312-linux_x86_64.whl

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/torch-2.7.1%2Brocm6.4.4.git1781ec08-cp312-cp312-linux_x86_64.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/pytorch_triton_rocm-3.3.1%2Brocm6.4.4.git9c7bc0a3-cp312-cp312-linux_x86_64.whl

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/torchvision-0.22.1%2Brocm6.4.4.git59a3e1f9-cp312-cp312-linux_x86_64.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/torchaudio-2.7.1%2Brocm6.4.4.git95c61b41-cp312-cp312-linux_x86_64.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/apex-1.7.0a0%2Brocm6.4.4.git20a62dc5-cp312-cp312-linux_x86_64.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/jax-0.4.35-py3-none-any.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/jaxlib-0.4.35-cp312-cp312-manylinux_2_28_x86_64.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/jax_rocm60_plugin-0.4.35-cp312-cp312-manylinux_2_28_x86_64.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/jax_rocm60_pjrt-0.4.35-py3-none-manylinux_2_28_x86_64.whl

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/onnxruntime_rocm-1.21.0-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl \
onnxruntime==1.21.0

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

# Preventing SAM-2 from installing CUDA packages
# SAM-2 is used by ComfyUI-Impact-Pack
RUN --mount=type=cache,target=/root/.cache/pip \
    cd /builder-scripts \
    && git clone https://github.com/facebookresearch/sam2.git \
    && cd sam2 \
    && SAM2_BUILD_CUDA=0 pip install \
        -e . --no-deps --no-build-isolation \
    && cd /

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

RUN df -h \
    && du -ah /root \
    && rm -rfv /root/* \
    && rm -rfv /root/.[^.]* /root/.??*

COPY runner-scripts/.  /runner-scripts/

# For ROCm
RUN groupadd --system video

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
