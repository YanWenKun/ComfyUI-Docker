################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:base-cu130-slim-s2'
################################################################################

# Registry mirror setting
ARG REGISTRY=docker.io
#ARG REGISTRY=m.daocloud.io/docker.io

FROM ${REGISTRY}/yanwk/comfyui-boot:base-cu130-slim-s1

LABEL maintainer="code@yanwk.fun"

ARG USING_GITHUB_ACTIONS=false

# PyPI mirror setting
ARG PIP_INDEX_URL
#ARG PIP_INDEX_URL="https://mirrors.cernet.edu.cn/pypi/web/simple"

ARG PIP_ROOT_USER_ACTION='ignore'
ARG PIP_NO_BUILD_ISOLATION=1

################################################################################
# Maintainance

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf upgrade -y

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

# Temp-fix for ONNX Runtime on CUDA 13
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        flatbuffers numpy packaging protobuf sympy \
    && pip install onnxruntime onnxruntime-gpu \
    && pip uninstall --yes onnxruntime-gpu \
    && pip install --pre --no-deps \
        onnxruntime-gpu \
        --index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/ort-cuda-13-nightly/pypi/simple/

################################################################################
# Pre-download a ComfyUI bundle in the image (will update later)

WORKDIR /default-comfyui-bundle

RUN bash /builder-scripts/preload-cache.sh

RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip --version
