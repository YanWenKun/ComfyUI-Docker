################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:cu130-megapak-pt211'
# A runtime environment for https://github.com/Comfy-Org/ComfyUI
# Using 'root' user inside the container (easy for rootless deploy).
#
# Image hierarchy:
# 1. base-cu130-devel: 
#   - glibc 2.39 (from Rocky Linux 10)
#   - GCC 14 (from Rocky Linux 10)
#   - CUDA Toolkit devel 13.0.2
# 2. base-cu130-pt211:
#   - Python 3.13 (with GIL)
#   - PyTorch 2.11
# 3. base-cu130-pt211-cache
#   - Python dependencies for ComfyUI and Custom Nodes
#       - Without version-sensitive packages like comfyui-frontend
#   - Preloaded ComfyUI bundle
################################################################################

ARG REGISTRY=docker.io
FROM ${REGISTRY}/yanwk/comfyui-boot:base-cu130-pt211-cache

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

ARG USING_GITHUB_ACTIONS=false
#ARG PIP_INDEX_URL="https://mirrors.cernet.edu.cn/pypi/web/simple"
ARG PIP_ROOT_USER_ACTION='ignore'
ARG PIP_NO_BUILD_ISOLATION=1

################################################################################
# Update the ComfyUI bundle in the image

WORKDIR /default-comfyui-bundle

COPY builder-scripts/.  /builder-scripts/

RUN bash /builder-scripts/update-cache.sh

# Install deps (comfyui-frontend-package, etc) pair to the preloaded ComfyUI version
# Install ComfyUI-Manager (Python package)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -c /builder-scripts/constraints.txt \
        -r '/default-comfyui-bundle/ComfyUI/requirements.txt' \
        -r '/default-comfyui-bundle/ComfyUI/manager_requirements.txt' \
    && pip list

# Disable ComfyUI-Manager's cache update on startup ("FETCH ComfyRegistry Data")
RUN cd /usr/local/lib/python3.13/site-packages/comfyui_manager/legacy/ \
    && echo "Deleting the line in $(pwd)/manager_server.py:" \
    && grep -n "run(default_cache_update())" ./manager_server.py \
    && sed -i '/run(default_cache_update())/d' ./manager_server.py

################################################################################

RUN df -h \
    && du -ah /root \
    && fd -H . /root/ --min-depth 1 -x rm -rfv

COPY runner-scripts/.  /runner-scripts/

USER root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
