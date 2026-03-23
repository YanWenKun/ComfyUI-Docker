################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:rocm'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# With ROCm for AMD GPU.
################################################################################

ARG USING_GITHUB_ACTIONS=false

ARG REGISTRY=docker.io

FROM ${REGISTRY}/yanwk/comfyui-boot:base-rocm72-pt211

LABEL maintainer="code@yanwk.fun"

################################################################################
# Python Packages

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
onnxruntime-rocm \
onnxruntime-migraphx

COPY builder-scripts/.  /builder-scripts/

# Note: No FlashAttention for ROCm in this image
# PyTorch's ROCm builds will try to find CUDA to compile and throw errors.

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
# Finishing

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
