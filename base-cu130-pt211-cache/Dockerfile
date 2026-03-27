################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:base-cu130-pt211-cache'
# Installs:
# - Dependencies for ComfyUI & Custom Nodes
################################################################################

ARG REGISTRY=docker.io
#ARG REGISTRY=m.daocloud.io/docker.io

FROM ${REGISTRY}/yanwk/comfyui-boot:base-cu130-pt211

LABEL maintainer="code@yanwk.fun"

ARG USING_GITHUB_ACTIONS=false

# PyPI mirror
#ARG PIP_INDEX_URL="https://mirrors.cernet.edu.cn/pypi/web/simple"

ARG PIP_ROOT_USER_ACTION='ignore'
ARG PIP_NO_BUILD_ISOLATION=1

################################################################################
# Maintainance

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf upgrade -y

# Fix for projects using CMAKE missing package configuration file
ENV CMAKE_PREFIX_PATH="/usr/local/lib64/python3.13/site-packages/torch/share/cmake" \
    CUDACXX="/usr/local/cuda-13.0/bin/nvcc"

################################################################################
# Dependencies for ComfyUI & custom nodes

COPY builder-scripts/.  /builder-scripts/

# Generate a version constraints file to pin PyTorch (prevent later installs from changing its version)
RUN pip list --format=freeze \
        | awk -F== 'BEGIN{want["torch"]=1;want["torchvision"]=1;want["torchaudio"]=1} $1 in want{print $1 "==" $2}' \
        > /builder-scripts/constraints.txt \
    && echo "Pinned PyTorch version:" \
    && cat /builder-scripts/constraints.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -c /builder-scripts/constraints.txt \
        -r /builder-scripts/pak3.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -c /builder-scripts/constraints.txt \
        -r /builder-scripts/pak5.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -c /builder-scripts/constraints.txt \
        -r /builder-scripts/pak7.txt

# Temp-fix: ONNX Runtime on CUDA 13
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        flatbuffers numpy packaging protobuf sympy \
    && pip install onnxruntime onnxruntime-gpu \
    && pip uninstall --yes onnxruntime-gpu \
    && pip install --pre --no-deps \
        onnxruntime-gpu \
        --index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/ort-cuda-13-nightly/pypi/simple/

# Temp-fix: Prevent SAM-2 from re-installing CUDA packages
# SAM-2 is used by ComfyUI-Impact-Pack
RUN --mount=type=cache,target=/root/.cache/pip \
    cd /builder-scripts \
    && git clone https://github.com/facebookresearch/sam2.git \
    && cd sam2 \
    && SAM2_BUILD_CUDA=1 pip install \
        -e . --no-deps --no-build-isolation \
    && cd /

# Temp-fix: Prevent SAM-3 from installing NumPy1
RUN --mount=type=cache,target=/root/.cache/pip \
    cd /builder-scripts \
    && git clone https://github.com/facebookresearch/sam3.git \
    && cd sam3 \
    && pip install \
        -e . --no-deps --no-build-isolation \
    && cd /

RUN --mount=type=cache,target=/root/.cache/pip \
    df -h \
    # Update UV
    && pip install -U uv \
    # Nunchaku (binary pair with PyTorch)
    && pip install \
https://github.com/nunchaku-ai/nunchaku/releases/download/v1.2.1/nunchaku-1.2.1+cu13.0torch2.11-cp313-cp313-linux_x86_64.whl \
    # SageAttention 2
    && pip install \
https://github.com/YanWenKun/ComfyUI-Containerfiles/releases/download/sageattn-py313-cu130-pt211/sageattention-2.2.0+hopper-cp313-cp313-linux_x86_64.whl \
    # SageAttention 3
    && pip install \
https://github.com/YanWenKun/ComfyUI-Containerfiles/releases/download/sageattn-py313-cu130-pt211/sageattn3-1.0.0-cp313-cp313-linux_x86_64.whl \
    # SpargeAttention (Sparse-SageAttention)
    && pip install \
https://github.com/YanWenKun/ComfyUI-Containerfiles/releases/download/sageattn-py313-cu130-pt211/spas_sage_attn-0.1.0-cp313-cp313-linux_x86_64.whl

RUN --mount=type=cache,target=/root/.cache/pip \
    # FlashAttention 2 (version pair with xFormers, binary pair with PyTorch & CUDA)
    pip install \
https://github.com/mjun0812/flash-attention-prebuild-wheels/releases/download/v0.9.4/flash_attn-2.8.3+cu130torch2.11-cp313-cp313-linux_x86_64.whl \
    # FlashAttention 3 (requires Hopper or Blackwell GPU)
    && pip install \
https://github.com/mjun0812/flash-attention-prebuild-wheels/releases/download/v0.9.4/flash_attn_3-3.0.0+cu130torch2.11gite2743ab-cp39-abi3-linux_x86_64.whl \
    # FlashAttention 4 (requires Hopper or Blackwell GPU)
    && pip install --pre "flash-attn-4[cu13]"

# llama-cpp-python
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
https://github.com/JamePeng/llama-cpp-python/releases/download/v0.3.33-cu130-Basic-linux-20260315/llama_cpp_python-0.3.33+cu130.basic-cp313-cp313-linux_x86_64.whl

# FastVideo
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        h5py wandb test-tube pytest flask flask_restful cloudpickle gpustat watch remote-pdb pyarrow \
    && pip install --no-deps \
        fastvideo \
https://github.com/YanWenKun/ComfyUI-Containerfiles/releases/download/fastvideo-kernel-py313/fastvideo_kernel-0.2.6-cp313-cp313-linux_x86_64.whl

################################################################################
# Pre-download a ComfyUI bundle in the image (will update later)

WORKDIR /default-comfyui-bundle

RUN bash /builder-scripts/preload-cache.sh

RUN --mount=type=cache,target=/root/.cache/pip \
    df -h \
    && pip list \
    && pip --version
