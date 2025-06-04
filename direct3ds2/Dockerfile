################################################################################
# Dockerfile that builds 'yanwk/direct3ds2'
# An environment for running https://github.com/DreamTechAI/Direct3D-S2
################################################################################

FROM yanwk/comfyui-boot:base-cu128-pt27

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

RUN set -eu

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        dist-upgrade --no-confirm --no-recommends --auto-agree-with-licenses \
    && rm /usr/lib64/python3.12/EXTERNALLY-MANAGED

################################################################################
# Python Dependencies

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

# utils3d has version conflicts
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps utils3d \
    && pip list

################################################################################

RUN du -ah /root \
    && rm -rf /root/* \
    && rm -rf /root/.[^.]* /root/.??*

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 7860
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
