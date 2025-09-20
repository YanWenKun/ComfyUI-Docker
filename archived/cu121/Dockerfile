################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:cu121'
# A runtime environment for https://github.com/comfyanonymous/ComfyUI
# Using CUDA 12.1& Python 3.11
################################################################################

FROM opensuse/tumbleweed:latest

LABEL maintainer="code@yanwk.fun"

# Note: GCC for InsightFace;
#       FFmpeg for video (pip[imageio-ffmpeg] will use system FFmpeg instead of bundled).
# Note: CMake may use different version of Python. Using 'update-alternatives' to ensure default version.
RUN --mount=type=cache,target=/var/cache/zypp \
    set -eu \
    && zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys \
            install --no-confirm \
        python311 python311-pip python311-wheel python311-setuptools \
        python311-devel python311-Cython gcc-c++ python311-py-build-cmake \
        python311-numpy1 python311-opencv \
        python311-ffmpeg-python ffmpeg x264 x265 \
        python311-dbm \
        google-noto-sans-fonts google-noto-sans-cjk-fonts google-noto-coloremoji-fonts \
        shadow git aria2 \
        Mesa-libGL1 libgthread-2_0-0 \
    && rm /usr/lib64/python3.11/EXTERNALLY-MANAGED \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 100

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --upgrade pip wheel setuptools

# Install xFormers (stable version, will specify PyTorch version),
# and Torchvision + Torchaudio (will downgrade to match xFormers' PyTorch version).
# Break down the steps, so we have more but smaller image layers.

ARG PIP_INDEX_URL="https://download.pytorch.org/whl/cu121"

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --dry-run xformers==0.0.29.post1 torch==2.5.1 torchvision torchaudio

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps torch==2.5.1

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps xformers==0.0.29.post1 torch==2.5.1

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        xformers==0.0.29.post1 torch==2.5.1 torchvision torchaudio

ARG PIP_INDEX_URL=

# Dependencies for frequently-used
# (Do this firstly so PIP won't be solving too many deps at one time)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt \
        -r https://raw.githubusercontent.com/crystian/ComfyUI-Crystools/main/requirements.txt \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_essentials/main/requirements.txt \
        -r https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt \
        -r https://raw.githubusercontent.com/jags111/efficiency-nodes-comfyui/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Pack/Main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Impact-Subpack/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Inspire-Pack/main/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/requirements.txt

# Dependencies for more, with few hand-pick:
# 'cupy-cuda12x' for Frame Interpolation
# 'compel lark' for smZNodes
# 'torchdiffeq' for DepthFM
# 'fairscale' for APISR
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_FaceAnalysis/main/requirements.txt \
        -r https://raw.githubusercontent.com/cubiq/ComfyUI_InstantID/main/requirements.txt \
        -r https://raw.githubusercontent.com/Fannovel16/ComfyUI-Frame-Interpolation/main/requirements-no-cupy.txt \
        cupy-cuda12x \
        -r https://raw.githubusercontent.com/FizzleDorf/ComfyUI_FizzNodes/main/requirements.txt \
        -r https://raw.githubusercontent.com/kijai/ComfyUI-KJNodes/main/requirements.txt \
        -r https://raw.githubusercontent.com/melMass/comfy_mtb/main/requirements.txt \
        -r https://raw.githubusercontent.com/ZHO-ZHO-ZHO/ComfyUI-InstantID/main/requirements.txt \
        compel lark torchdiffeq fairscale \
        python-ffmpeg

# Fix for libs (.so files)
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib64/python3.11/site-packages/torch/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cuda_cupti/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cuda_runtime/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cudnn/lib\
:/usr/local/lib/python3.11/site-packages/cusparselt/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cufft/lib"

# More libs (not necessary, just in case)
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/local/lib/python3.11/site-packages/nvidia/cublas/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cuda_nvrtc/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/curand/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cusolver/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/cusparse/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/nccl/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/nvjitlink/lib\
:/usr/local/lib/python3.11/site-packages/nvidia/nvtx/lib"

# Create a low-privilege user
RUN printf 'CREATE_MAIL_SPOOL=no' >> /etc/default/useradd \
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
