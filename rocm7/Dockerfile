################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:rocm7'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# With ROCm 7 for AMD GPU.
#
# Using default components from Ubuntu 24.04:
# * Python 3.12
# * GCC 13
# * glibc 2.39
#
# The container will be running in root.
################################################################################

FROM rocm/pytorch:rocm7.2_ubuntu24.04_py3.12_pytorch_release_2.9.1

################################################################################
# Note the base image have already done:
# 1. Install Python 3.12 from Ubuntu repository (PPA/deadsnakes was added but not used).
# 2. Create virtual environment in /opt/venv with Python 3.12.
# 3. Configure PATH to include /opt/venv/bin as first entry.
#    So there is no need to run `. /opt/venv/bin/activate` afterwards.
# 4. Install ROCm environment using `amdgpu-install --usecase=rocm`.
# 5. Install PyTorch ROCm using /install/torch_installer.sh.
#    You can check that file and find supported GPU architectures, e.g.:
#    GFX_ARCH: 'gfx908;gfx90a;gfx942;gfx1030;gfx1100;gfx1101;gfx1200;gfx1201;gfx950;gfx1151;gfx1150'
################################################################################

LABEL maintainer="code@yanwk.fun"

ARG DEBIAN_FRONTEND=noninteractive

################################################################################
# Clean cache files inherited from base image

# Use default WORKDIR from base image
#WORKDIR /
RUN rm -vf *.whl

# Clean PIP cache and APT cache
RUN rm -vrf /root/.cache/pip \
    && rm -vrf /var/cache/apt

################################################################################
# Install Tools

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
git \
cmake \
ffmpeg \
ninja-build \
aria2 \
curl \
fish \
fd-find \
less \
vim \
fonts-noto-cjk \
fonts-noto-color-emoji \
    && rm -vrf /var/lib/apt/lists/*

################################################################################
# Python Packages

RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        wheel setuptools

# Additional packages for ROCm
# Need to pair with base image's version.
# Ref: https://rocm.docs.amd.com/projects/radeon-ryzen/en/latest/docs/install/installrad/native_linux/install-pytorch.html
# Ref: https://rocm.docs.amd.com/projects/radeon-ryzen/en/latest/docs/install/installrad/native_linux/install-onnx.html

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
https://repo.radeon.com/rocm/manylinux/rocm-rel-7.2/jax_rocm7_plugin-0.8.0%2Brocm7.2.0-cp312-cp312-manylinux_2_28_x86_64.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-7.2/jax_rocm7_pjrt-0.8.0%2Brocm7.2.0-py3-none-manylinux_2_28_x86_64.whl \
https://repo.radeon.com/rocm/manylinux/rocm-rel-7.2/jaxlib-0.8.0%2Brocm7.2.0-cp312-cp312-manylinux_2_27_x86_64.whl

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
https://repo.radeon.com/rocm/manylinux/rocm-rel-7.2/onnxruntime_migraphx-1.23.2-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl \
onnxruntime==1.23.2

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
https://repo.radeon.com/rocm/manylinux/rocm-rel-7.2/transformer_engine_rocm-2.4.0-py3-none-manylinux_2_28_x86_64.whl

# The /builder-scripts is also used as a compile-install workspace for some Python packages
COPY builder-scripts/.  /builder-scripts/

# Compile-Install Flash Attention for ROCm
# https://github.com/Dao-AILab/flash-attention#amd-rocm-support
# https://rocm.docs.amd.com/en/latest/how-to/rocm-for-ai/inference-optimization/model-acceleration-libraries.html#installing-flash-attention-2

# Triton backend
ENV FLASH_ATTENTION_TRITON_AMD_ENABLE=TRUE
# Composable Kernel (CK) backend
#ENV FLASH_ATTENTION_SKIP_CK_BUILD=FALSE

RUN --mount=type=cache,target=/root/.cache/pip \
    cd /builder-scripts \
    && git clone https://github.com/Dao-AILab/flash-attention \
    && cd flash-attention \
    && python3 setup.py install \
    && cd /

# Deps for ComfyUI & custom nodes
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak3.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak5.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak7.txt

# Prevent SAM-2 from installing CUDA packages
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
# Finishing

RUN df -h \
    && du -ah /root \
    && find /root -mindepth 1 -maxdepth 1 -exec rm -rfv {} +

COPY runner-scripts/.  /runner-scripts/

# Note: ROCm images already have 'video' and 'render' group
#RUN groupadd --system video

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
