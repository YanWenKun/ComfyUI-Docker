################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:latest'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
################################################################################

FROM opensuse/tumbleweed:latest

LABEL maintainer="code@yanwk.fun"

RUN --mount=type=cache,target=/var/cache/zypp \
    set -eu \
    && zypper install --no-confirm \
        python310 python310-pip \
        shadow git aria2 \
        Mesa-libGL1

# Install PyTorch nightly
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install wheel setuptools numpy \
    && pip install --pre torch torchvision \
        --index-url https://download.pytorch.org/whl/nightly/cu118 

# Install xFormers from wheel file we just compiled
COPY --from=yanwk/comfyui-boot:xformers /wheels /root/wheels

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install /root/wheels/*.whl \
    && rm -rf /root/wheels

# Deps for main app
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt

# Deps for ControlNet Preprocessors
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r https://raw.githubusercontent.com/Fannovel16/comfy_controlnet_preprocessors/main/requirements.txt \
    --extra-index-url https://download.pytorch.org/whl/nightly/cu118 

# Fix for CuDNN
WORKDIR /usr/lib64/python3.10/site-packages/torch/lib
RUN ln -s libnvrtc-672ee683.so.11.2 libnvrtc.so 
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib64/python3.10/site-packages/torch/lib"

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
