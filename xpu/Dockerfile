################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:xpu'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# Running on XPU (Intel GPU).
# Using PyTorch built by Intel.
################################################################################

FROM intel/intel-extension-for-pytorch:2.7.10-xpu

LABEL maintainer="code@yanwk.fun"

RUN set -eu

# Cache left by upstream
RUN rm -rf /root/.cache/pip

# Python and tools
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && apt-get install -y \
fish \
fd-find \
vim \
less \
aria2 \
git \
ninja-build \
make \
cmake \
python3-dev \
python3-pybind11 \
libgl1-mesa-glx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Python Packages
ARG PIP_ROOT_USER_ACTION='ignore'

RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools

# Override original XPU image's PyTorch, from 2.7.0 to 2.7.1
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch==2.7.1 torchvision==0.22.1 torchaudio==2.7.1 --index-url https://download.pytorch.org/whl/xpu

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

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak9.txt

# Make sure the deps fit the needs for ComfyUI & Manager
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt \
        -r https://github.com/Comfy-Org/ComfyUI-Manager/raw/refs/heads/main/requirements.txt

# Optional: Install Intel Python packages (accelerated NumPy, SciPy)
# Mostly for Intel CPUs. Skipped here.
# https://www.intel.com/content/www/us/en/developer/tools/oneapi/distribution-for-python.html
# RUN --mount=type=cache,target=/root/.cache/pip \
#         pip install --index-url https://software.repos.intel.com/python/pypi \
#             numpy scipy dpnp dpctl tbb4py

# Make sure using the right version of Intel packages
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
intel-extension-for-pytorch==2.7.10+xpu \
    --extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us/

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
oneccl_bind_pt==2.7.0+xpu \
    --extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us/

################################################################################

RUN df -h \
    && du -ah /root \
    && find /root/ -mindepth 1 -delete

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
