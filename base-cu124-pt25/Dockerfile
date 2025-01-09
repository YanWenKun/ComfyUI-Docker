################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:base-cu124-pt25'
# An environment for PyTorch 2.5, CUDA 12.4, Python 3.12
################################################################################

FROM yanwk/comfyui-boot:base-cu124

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

RUN set -eu

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        dist-upgrade --no-confirm --no-recommends --auto-agree-with-licenses

################################################################################
# PyTorch Packages

RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools

ARG PIP_INDEX_URL="https://download.pytorch.org/whl/cu124"
ARG PIP_EXTRA_INDEX_URL="https://pypi.org/simple"

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --dry-run xformers==0.0.29.post1 torch==2.5.1 torchvision torchaudio

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps torch==2.5.1

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps xformers==0.0.29.post1 torch==2.5.1

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        xformers==0.0.29.post1 torch==2.5.1 torchvision torchaudio

ARG PIP_INDEX_URL=
ARG PIP_EXTRA_INDEX_URL=

# Bind libs (.so files)
# Even we have CUDA installed by Zypper, we still need to install CUDA libs for Python in order to run PyTorch.
# What's more, NVIDIA's openSUSE15 repo didn't provide CuDNN & NCCL, we have to use Python packages anyway.
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib64/python3.12/site-packages/torch/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cuda_cupti/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cuda_runtime/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cudnn/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cufft/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cublas/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cuda_nvrtc/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/curand/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cusolver/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cusparse/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nccl/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nvjitlink/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nvtx/lib"
