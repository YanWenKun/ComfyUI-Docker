################################################################################
# 用于构建镜像 'yanwk/comfyui-boot:xpu-cn' 的 Dockerfile
# 用于以 Intel GPU 运行 ComfyUI
# 使用 PyTorch 官方仓库的 XPU 二进制包，且不使用 IPEX（Intel Extension for PyTorch）
# 使用 Python 3.13, GCC 14
# 容器内将以 root 用户运行
################################################################################

# 该基础镜像声明不含仓库前缀，因而会优先查找本地镜像
FROM fedora:42

LABEL maintainer="code@yanwk.fun"

RUN set -eu

################################################################################
# 配置软件源，默认使用国内源，用 GitHub Actions 构建镜像时则使用官方源

ARG USING_GITHUB_ACTIONS=false

RUN if [ "${USING_GITHUB_ACTIONS}" = "false" ]; then \
        mkdir -p /root/.config/pip \
        && echo '[global]' > /root/.config/pip/pip.conf \
        && echo 'index-url=https://mirrors.cernet.edu.cn/pypi/web/simple' >> /root/.config/pip/pip.conf ; \
    fi

RUN --mount=type=cache,target=/var/cache/dnf \
    if [ "${USING_GITHUB_ACTIONS}" = "false" ]; then \
        sed -e 's|^metalink=|#metalink=|g' \
            -e 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.cernet.edu.cn/fedora|g' \
            -i.bak \
            /etc/yum.repos.d/fedora.repo \
            /etc/yum.repos.d/fedora-updates.repo \
        && dnf config-manager setopt fedora-cisco-openh264.enabled=0 \
        && dnf install -y --nogpgcheck \
            'https://mirrors.cernet.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-42.noarch.rpm' \
        && sed -e 's!^metalink=!#metalink=!g' \
            -e 's!^mirrorlist=!#mirrorlist=!g' \
            -e 's!^#baseurl=!baseurl=!g' \
            -e 's!https\?://download1\.rpmfusion\.org/!https://mirrors.cernet.edu.cn/rpmfusion/!g' \
            -i.bak /etc/yum.repos.d/rpmfusion*.repo ; \
    else \
        dnf install -y --nogpgcheck \
            'https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-42.noarch.rpm' ; \
    fi

################################################################################
# 安装 Python 及工具

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf upgrade -y \
    && dnf install -y \
python3.13-devel \
python3-pip \
python3-wheel \
python3-setuptools \
python3-cython \
make \
ninja \
python3-cmake

# RUN --mount=type=cache,target=/var/cache/dnf \
#     dnf install -y \
# python3-matplotlib \
# python3-mpmath \
# python3-numpy \
# python3-onnx

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
ffmpeg \
x264 \
x265 \
default-fonts-cjk

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
python3-opencv \
python3-cairo

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
mesa-libGL \
mesa-libEGL \
# python3-GitPython \
git \
# python3-pandas \
# python3-scikit-build-core \
# python3-scikit-image \
# python3-scikit-learn \
fish \
aria2 \
fd-find \
vim \
which

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
intel-compute-runtime \
intel-level-zero \
intel-level-zero-devel \
oneapi-level-zero \
oneapi-level-zero-devel \
intel-ocloc \
intel-opencl \
intel-igc \
clinfo \
openssl

################################################################################
# GCC 14
# （Fedora 42 默认使用 GCC 15）

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
gcc14 \
gcc14-c++ \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-14 90 \
    && update-alternatives --install /usr/bin/cc  cc  /usr/bin/gcc-14 90 \
    && update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-14 90 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 90 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 90 \
    && update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-14 90 \
    && update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-14 90 \
    && update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-14 90 \
    && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-14 90 \
    && update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-14 90 \
    && update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-14 90 

# ################################################################################
# PyTorch （无 IPEX）
# 如果官方源下载缓慢，可搜索替换为南大源： https://mirrors.nju.edu.cn/pytorch/whl/xpu

ARG PIP_ROOT_USER_ACTION='ignore'
ARG PIP_NO_BUILD_ISOLATION=1

RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --dry-run torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/xpu \
    && pip install \
        --no-deps torch \
        --index-url https://download.pytorch.org/whl/xpu

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/xpu

# 安装 ComfyUI 及扩展所需依赖项
COPY builder-scripts/.  /builder-scripts/

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak3.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak5.txt

# Temp fix for SentencePiece on CMAKE 4+
# 临时修复：解决 CMAKE 4+ 编译 SentencePiece 报错，强制最低版本 3.5
ENV CMAKE_POLICY_VERSION_MINIMUM=3.5

RUN --mount=type=cache,target=/root/.cache/pip \
    if [ "${USING_GITHUB_ACTIONS}" = "false" ]; then \
        pip install -r /builder-scripts/pak7-cn.txt ; \
    else \
        pip install -r /builder-scripts/pak7.txt ; \
    fi

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak9.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pakA.txt

# 确保依赖项匹配
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/xpu

################################################################################
# 预载 ComfyUI 及扩展，并根据预载的 ComfyUI 版本安装依赖项（确保前后端版本匹配）

WORKDIR /default-comfyui-bundle

RUN if [ "${USING_GITHUB_ACTIONS}" = "false" ]; then \
        bash /builder-scripts/preload-cache-cn.sh ; \
    else \
        bash /builder-scripts/preload-cache.sh ; \
    fi

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r '/default-comfyui-bundle/ComfyUI/requirements.txt' \
        -r '/default-comfyui-bundle/ComfyUI/manager_requirements.txt' \
    && pip list

################################################################################
# 绑定环境变量 (依赖库 .so 文件)

ENV LD_LIBRARY_PATH="/usr/local/lib\
:/usr/local/lib64/python3.13/site-packages/torch/lib/\
${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

################################################################################
# 配置运行时使用国内镜像源

ENV PIP_INDEX_URL="https://mirrors.cernet.edu.cn/pypi/web/simple"
ENV HF_ENDPOINT="https://hf-mirror.com"

RUN if [ "${USING_GITHUB_ACTIONS}" = "true" ]; then \
        sed -e 's|^metalink=|#metalink=|g' \
            -e 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.cernet.edu.cn/fedora|g' \
            -i.bak \
            /etc/yum.repos.d/fedora.repo \
            /etc/yum.repos.d/fedora-updates.repo \
        && sed -e 's!^metalink=!#metalink=!g' \
            -e 's!^mirrorlist=!#mirrorlist=!g' \
            -e 's!^#baseurl=!baseurl=!g' \
            -e 's!https\?://download1\.rpmfusion\.org/!https://mirrors.cernet.edu.cn/rpmfusion/!g' \
            -i.bak /etc/yum.repos.d/rpmfusion*.repo \
        && dnf config-manager setopt fedora-cisco-openh264.enabled=0 ; \
    fi

################################################################################
# 收尾工作

RUN df -h \
    && du -ah /root \
    && find /root/ -mindepth 1 -delete

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
