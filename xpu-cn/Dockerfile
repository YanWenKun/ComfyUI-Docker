################################################################################
# 用于构建镜像 'yanwk/comfyui-boot:xpu-cn' 的 Dockerfile
# 用于以 Intel GPU 运行 ComfyUI
# 使用 PyTorch 官方仓库的 XPU 二进制包
# 使用 Python 3.14, GCC 15
# 容器内将以 root 用户运行
################################################################################

# 该基础镜像声明不含仓库前缀，因而会优先查找本地镜像
FROM fedora:43

LABEL maintainer="code@yanwk.fun"

################################################################################
# 配置软件源，默认使用国内源，用 GitHub Actions 构建镜像时则使用官方源

ARG USING_GITHUB_ACTIONS=false

# 注意 /root 最终会清空，这里的配置并不影响运行时。
# 运行时的 PyPI 国内源由另外的环境变量控制。
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
            'https://mirrors.cernet.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-43.noarch.rpm' \
        && sed -e 's!^metalink=!#metalink=!g' \
            -e 's!^mirrorlist=!#mirrorlist=!g' \
            -e 's!^#baseurl=!baseurl=!g' \
            -e 's!https\?://download1\.rpmfusion\.org/!https://mirrors.cernet.edu.cn/rpmfusion/!g' \
            -i.bak /etc/yum.repos.d/rpmfusion*.repo ; \
    else \
        dnf install -y --nogpgcheck \
            'https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-43.noarch.rpm' ; \
    fi

################################################################################
# 系统软件包

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf upgrade -y \
    && dnf install -y \
python3.14-devel \
python3-pip \
python3-wheel \
python3-setuptools \
python3-cython \
make \
ninja-build \
python3-cmake

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
ffmpeg \
x264 \
x265 \
default-fonts-cjk

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
mesa-libGL \
mesa-libEGL \
git \
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

# Fedora 43 默认使用 GCC 15
RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
gcc \
gcc-c++

################################################################################
# Python 包 - PyTorch

ARG PIP_ROOT_USER_ACTION='ignore'
ARG PIP_NO_BUILD_ISOLATION=1

RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install --upgrade \
        pip wheel setuptools packaging

# 默认使用南大源，如果遇到下载卡壳，可改为官方源
RUN if [ "${USING_GITHUB_ACTIONS}" = "true" ]; then \
        echo "export PT_INDEX_URL=https://download.pytorch.org/whl/xpu" > /tmp/pt_env; \
    else \
        echo "export PT_INDEX_URL=https://mirrors.nju.edu.cn/pytorch/whl/xpu" > /tmp/pt_env; \
    fi

# 这里单独卸载 torch 是为了减少镜像单层大小，利于拉取时多线程下载
RUN --mount=type=cache,target=/root/.cache/pip \
    source /tmp/pt_env \
    && pip install \
        torch torchvision torchaudio \
        --index-url ${PT_INDEX_URL} \
    && pip uninstall --yes torch

RUN --mount=type=cache,target=/root/.cache/pip \
    source /tmp/pt_env \
    && pip install \
        torch torchvision torchaudio \
        --index-url ${PT_INDEX_URL}

################################################################################
# Python 包 - ComfyUI 自定义节点（插件）依赖项

COPY builder-scripts/.  /builder-scripts/

# 生成版本号约束文件，强制后续安装不得变更 PyTorch 版本
RUN pip list --format=freeze \
        | awk -F== 'BEGIN{want["torch"]=1;want["torchvision"]=1;want["torchaudio"]=1} $1 in want{print $1 "==" $2}' \
        > /builder-scripts/constraints.txt \
    && echo "Pinned PyTorch version:" \
    && cat /builder-scripts/constraints.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak3.txt \
        -c /builder-scripts/constraints.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak5.txt \
        -c /builder-scripts/constraints.txt

# Temp fix for SentencePiece on CMAKE 4+
# 临时修复：解决 CMAKE 4+ 编译 SentencePiece 报错，强制最低版本 3.5
ENV CMAKE_POLICY_VERSION_MINIMUM=3.5

RUN --mount=type=cache,target=/root/.cache/pip \
    if [ "${USING_GITHUB_ACTIONS}" = "false" ]; then \
        pip install -r /builder-scripts/pak7-cn.txt -c /builder-scripts/constraints.txt ; \
    else \
        pip install -r /builder-scripts/pak7.txt -c /builder-scripts/constraints.txt ; \
    fi

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak9.txt \
        -c /builder-scripts/constraints.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pakA.txt \
        -c /builder-scripts/constraints.txt

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
        -r '/default-comfyui-bundle/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt' \
        -c /builder-scripts/constraints.txt

# 确保依赖项匹配
RUN --mount=type=cache,target=/root/.cache/pip \
    source /tmp/pt_env \
    && pip install \
        torch torchvision torchaudio \
        --index-url ${PT_INDEX_URL} \
    && rm -vf /tmp/pt_env \
    && pip list

################################################################################
# 绑定环境变量 (依赖库 .so 文件)

ENV LD_LIBRARY_PATH="/usr/local/lib\
:/usr/local/lib64/python3.14/site-packages/torch/lib/\
${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

################################################################################
# 配置运行时使用国内镜像源

ENV PIP_INDEX_URL="https://mirrors.cernet.edu.cn/pypi/web/simple"
ENV HF_ENDPOINT="https://hf-mirror.com"
ENV GITHUB_ENDPOINT="https://gh-proxy.org/https://github.com"

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
