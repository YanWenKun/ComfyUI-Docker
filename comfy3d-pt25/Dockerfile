################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:comfy3d-pt25'
# An environment for running ComfyUI with ComfyUI-3D-Pack.
# Using PyTorch 2.5, CUDA 12.4, Python 3.12
################################################################################

FROM yanwk/comfyui-boot:base-cu124-pt25

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

RUN set -eu

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        dist-upgrade --no-confirm --no-recommends --auto-agree-with-licenses

################################################################################
# Extra Packages
RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
        meshlab \
    && zypper remove --no-confirm libQt5Core5 # Temp fix for PyMeshLab

################################################################################
# More Python Packages

COPY builder-scripts/.  /builder-scripts/

# Deps for ComfyUI & custom nodes
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak3.txt \
    && pip install \
        -r /builder-scripts/pak4.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak5.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak6.txt \
    && pip install \
        -r /builder-scripts/pak7.txt \
    && pip install \
        -r /builder-scripts/pak8.txt \
    && pip install \
        -r /builder-scripts/pak9.txt \
    && pip install \
        -r /builder-scripts/pakA.txt \
    && pip list

################################################################################

RUN du -ah /root \
    && find /root/ -mindepth 1 -delete

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
