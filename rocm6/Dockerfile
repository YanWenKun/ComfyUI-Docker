################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:rocm6'
# A runtime environment for https://github.com/Comfy-Org/ComfyUI
# Versions fixed:
# - PyTorch 2.6.0
# - Python 3.12
# - ROCm 6.4.4
# - GCC 13
# - glibc 2.38 (from openSUSE Leap 15.6)
# Ref: https://rocm.docs.amd.com/projects/radeon-ryzen/en/docs-6.4.4/docs/compatibility/compatibilityrad/native_linux/native_linux_compatibility.html#pytorch-rocm-support-matrix
################################################################################

FROM opensuse/leap:15.6

LABEL maintainer="code@yanwk.fun"

ARG USING_GITHUB_ACTIONS=false

################################################################################
# Python and tools

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_15.6/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python312-devel \
python312-pip \
python312-wheel \
python312-setuptools \
python312-packaging \
python312-dbm

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
Mesa-libGL1 \
Mesa-libEGL-devel \
libgthread-2_0-0 \
libQt5OpenGL-devel

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
ffmpeg \
x264 \
x265 \
git \
git-lfs

# Note: 'half' for ORT on ROCm.
RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
ghc-half \
make \
cmake \
bison \
gawk \
findutils \
fd \
ninja \
rustup \
shadow \
aria2 \
wget \
vim \
micro-editor \
which \
tar \
gzip \
xz \
update-alternatives \
google-noto-sans-cjk-fonts \
noto-coloremoji-fonts

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --non-interactive \
        install --force-resolution \
fish

# Remove the need for 'pip install --break-system-packages'
RUN rm -vf /usr/lib64/python3.12/EXTERNALLY-MANAGED \
    # Ensure default Python version
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 100

# Temp fix for OpenCV on openSUSE
ENV LD_PRELOAD=/usr/lib64/libjpeg.so.8

# Temp fix for SentencePiece on CMAKE 4+
ENV CMAKE_POLICY_VERSION_MINIMUM=3.5

################################################################################
# GCC 13
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
    pip install --upgrade \
        pip wheel setuptools packaging \
    && pip list

# PyTorch ROCm
# Ref: https://rocm.docs.amd.com/projects/radeon-ryzen/en/docs-6.4.4/docs/compatibility/compatibilityrad/native_linux/native_linux_compatibility.html#pytorch-rocm-support-matrix
# Ref: https://rocm.docs.amd.com/projects/radeon/en/latest/docs/install/native_linux/install-pytorch.html
# Ref: https://rocm.docs.amd.com/projects/radeon/en/latest/docs/install/native_linux/install-onnx.html
# Ref: https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html

# Break down the steps for smaller image layers.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
--no-deps https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/torch-2.6.0%2Brocm6.4.4.git2feede28-cp312-cp312-linux_x86_64.whl

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/torch-2.6.0%2Brocm6.4.4.git2feede28-cp312-cp312-linux_x86_64.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/pytorch_triton_rocm-3.2.0%2Brocm6.4.4.git20943800-cp312-cp312-linux_x86_64.whl

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/torchvision-0.21.0%2Brocm6.4.4.git4040d51f-cp312-cp312-linux_x86_64.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/torchaudio-2.6.0%2Brocm6.4.4.gitd8831425-cp312-cp312-linux_x86_64.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-6.4.4/apex-1.6.0%2Brocm6.4.4.git6596002f-cp312-cp312-linux_x86_64.whl \
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
    && pip install hydra-core \
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
# Redundant as openSUSE Leap 15.6 already has 'video' group, but just in case.
RUN groupadd --system --force video

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
