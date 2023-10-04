################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:latest'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
################################################################################

FROM opensuse/tumbleweed:latest

LABEL maintainer="code@yanwk.fun"

RUN --mount=type=cache,target=/var/cache/zypp \
    set -eu \
    && zypper install --no-confirm \
        python311 python311-pip \
        python311-wheel python311-setuptools python311-numpy \
        shadow git aria2 \
        Mesa-libGL1

# Install PyTorch nightly
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages --pre torch torchvision \
        --index-url https://download.pytorch.org/whl/nightly/cu121 

# Install pre-release xFormers
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages --pre xformers

# Deps for main app
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages -r https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt

# Deps for ControlNet Auxiliary Preprocessors
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages -r https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt \
    --extra-index-url https://download.pytorch.org/whl/nightly/cu121 

# Fix for CuDNN
WORKDIR /usr/lib64/python3.11/site-packages/torch/lib
RUN ln -s libnvrtc-b51b459d.so.12 libnvrtc.so 
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib64/python3.11/site-packages/torch/lib"

# Create a low-privilege user.
RUN printf 'CREATE_MAIL_SPOOL=no' > /etc/default/useradd \
    && mkdir -p /home/runner /home/scripts \
    && groupadd runner \
    && useradd runner -g runner -d /home/runner \
    && chown runner:runner /home/runner /home/scripts

COPY --chown=runner:runner scripts/. /home/scripts/

USER runner:runner
VOLUME /home/runner
WORKDIR /home/runner
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/home/scripts/entrypoint.sh"]
