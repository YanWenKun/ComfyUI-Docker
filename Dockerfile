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
        python311-devel python311-Cython \
        gcc-c++ cmake \
        shadow git aria2 \
        Mesa-libGL1 libgthread-2_0-0 \
    && rm /usr/lib64/python3.11/EXTERNALLY-MANAGED

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
	    --upgrade pip

# Install xFormers (stable version, will specify PyTorch version)
# and Torchvision + Torchaudio (will downgrade to match xFormers' PyTorch version)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        xformers torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu121 \
        --extra-index-url https://pypi.org/simple

# Upgrade xFormers to dev version
# (While keeping most dependencies using stable version)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        --pre --upgrade xformers \
        --index-url https://download.pytorch.org/whl/cu121 \
        --extra-index-url https://pypi.org/simple

# Dependencies for: ComfyUI,
# InstantID, ControlNet Auxiliary Preprocessors,
# ComfyUI-Manager, Inspire-Pack, Impact-Pack, "Essentials", Efficiency Nodes, Crystools
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt \
        -r https://raw.githubusercontent.com/ZHO-ZHO-ZHO/ComfyUI-InstantID/main/requirements.txt \
        -r https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Inspire-Pack/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Pack/Main/requirements.txt \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_essentials/main/requirements.txt \
        -r https://raw.githubusercontent.com/jags111/efficiency-nodes-comfyui/main/requirements.txt \
        -r https://raw.githubusercontent.com/crystian/ComfyUI-Crystools/main/requirements.txt

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
