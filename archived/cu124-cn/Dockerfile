################################################################################
# 用于构建镜像 'yanwk/comfyui-boot:cu124-cn' 的 Dockerfile
# 为适应国内网络环境，运行时的下载地址均改用国内源。
# 但需注意，构建本镜像时仍需要流畅的网络环境（完全走国内源请参考另一 Dockerfile）。
#
# 使用 CUDA 12.4, Python 3.12, GCC 13
# 容器内将以 root 用户运行，以便于 rootless 部署
################################################################################

FROM docker.io/opensuse/tumbleweed:latest

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

RUN set -eu

################################################################################
# 安装 Python 及工具
# 使用 openSUSE 软件仓库的 Python 包，以确保兼容性以及更多的系统级支持。后续仍可使用 PIP 更新。

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python312-devel \
python312-pip \
python312-wheel \
python312-setuptools \
python312-Cython \
python312-py-build-cmake \
python312-matplotlib \
python312-mpmath \
python312-numba-devel \
python312-numpy \
python312-onnx \
python312-pandas \
python312-scikit-build \
python312-scikit-build-core-pyproject \
python312-scikit-image \
python312-scikit-learn \
python312-scipy

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python312-opencv \
opencv \
opencv-devel \
Mesa-libGL1 \
Mesa-libEGL-devel \
libgthread-2_0-0 \
libQt5OpenGL5

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python312-ffmpeg-python \
python312-imageio \
python312-svglib \
ffmpeg \
x264 \
x265 \
python312-GitPython \
python312-pygit2 \
git

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
make \
ninja \
aria2 \
findutils \
fish \
fd \
fuse \
vim \
which \
google-noto-sans-fonts \
google-noto-sans-cjk-fonts \
google-noto-coloremoji-fonts \
    # 解除锁定，使得 PIP 默认可以安装修改系统级 Python 包
    && rm -v /usr/lib64/python3.12/EXTERNALLY-MANAGED \
    # 确保默认 Python 版本不被覆盖
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 100

# Temp fix for OpenCV on openSUSE
# 临时修复：其他组件会优先寻找 libjpeg 版本 6 (实际 8)
ENV LD_PRELOAD=/usr/lib64/libjpeg.so.8

# Temp fix for SentencePiece on CMAKE 4+
# 临时修复：解决 CMAKE 4+ 编译 SentencePiece 报错，强制最低版本 3.5
ENV CMAKE_POLICY_VERSION_MINIMUM=3.5

################################################################################
# GCC 13 
# 与 CUDA 12.4 兼容

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
gcc13 \
gcc13-c++ \
cpp13 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-13 90 \
    && update-alternatives --install /usr/bin/cc  cc  /usr/bin/gcc-13 90 \
    && update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-13 90 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 90 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 90 \
    && update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-13 90 \
    && update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-13 90 \
    && update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-13 90 \
    && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-13 90 \
    && update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-13 90 \
    && update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-13 90 

################################################################################
# Python 包

# PyTorch, xFormers
# 拆分安装步骤，使生成的镜像文件分为更多更小的层，减少单层下载大小。
RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools \
    && pip install \
        --dry-run xformers==0.0.29.post3 torch==2.6.0 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu124

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps torch==2.6.0 \
        --index-url https://download.pytorch.org/whl/cu124

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch==2.6.0 \
        --index-url https://download.pytorch.org/whl/cu124

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        xformers==0.0.29.post3 torch==2.6.0 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu124

# 绑定环境变量 (依赖库 .so 文件)
ENV LD_LIBRARY_PATH="/usr/local/lib64/python3.12/site-packages/torch/lib\
:/usr/local/lib/python3.12/site-packages/cusparselt/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cublas/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cuda_cupti/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cuda_nvrtc/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cuda_runtime/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cudnn/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cufft/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cufile/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/curand/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cusolver/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cusparse/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/cusparselt/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nccl/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nvjitlink/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nvshmem/lib\
:/usr/local/lib/python3.12/site-packages/nvidia/nvtx/lib\
${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

COPY builder-scripts/.  /builder-scripts/

# 安装 ComfyUI 及扩展的依赖项
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak3.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak5.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak7.txt

# 确保依赖项匹配 ComfyUI & Manager
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt \
        -r https://github.com/Comfy-Org/ComfyUI-Manager/raw/refs/heads/main/requirements.txt \
    && pip list

################################################################################

# 使用国内下载源

# Temp fix: 因镜像大面积故障，故指定南京大学源，待清华源等修复后，应改为联合镜像站 https://mirrors.cernet.edu.cn
RUN --mount=type=cache,target=/var/cache/zypp \
    zypper modifyrepo --disable --all \
    && zypper addrepo --check --refresh --gpgcheck \
        'https://mirror.nju.edu.cn/opensuse/tumbleweed/repo/oss/' mirror-oss \
    && zypper addrepo --check --refresh --gpgcheck \
        'https://mirror.nju.edu.cn/opensuse/tumbleweed/repo/non-oss/' mirror-non-oss \
    && zypper addrepo --check --refresh --priority 90 \
        'https://mirror.nju.edu.cn/packman/suse/openSUSE_Tumbleweed/Essentials/' mirror-packman-essentials

ENV PIP_INDEX_URL="https://mirrors.cernet.edu.cn/pypi/web/simple"
        
ENV HF_ENDPOINT="https://hf-mirror.com"

################################################################################

RUN du -ah /root \
    && rm -rf /root/* \
    && rm -rf /root/.[^.]* /root/.??*

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
