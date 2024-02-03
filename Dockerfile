################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:latest'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
################################################################################

FROM opensuse/tumbleweed:latest

LABEL maintainer="code@yanwk.fun"

RUN --mount=type=cache,target=/var/cache/zypp \
    set -eu \
    && zypper install --no-confirm \
        python311 python311-pip python311-devel \
        python311-wheel python311-setuptools python311-numpy \
        shadow git aria2 \
        Mesa-libGL1 libgthread-2_0-0 \
    && rm /usr/lib64/python3.11/EXTERNALLY-MANAGED

# Install xFormers (dev version, will install PyTorch as well)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        --pre -U xformers \
        --index-url https://download.pytorch.org/whl/cu121 \
        --extra-index-url https://pypi.org/simple

# Deps for main app
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt

# Deps for ControlNet Auxiliary Preprocessors
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt

# Fix for libs (.so files)
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib64/python3.11/site-packages/torch/lib"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/python3.11/site-packages/nvidia/cufft/lib"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/python3.11/site-packages/nvidia/cuda_runtime/lib"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/python3.11/site-packages/nvidia/cuda_cupti/lib"

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
