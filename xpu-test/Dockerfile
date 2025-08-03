################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:xpu-test'
# Using Python 3.11, GCC 11, PyTorch Test (Release Candidate).
# Using 'root' inside the container.
################################################################################

FROM docker.io/opensuse/leap:15.6

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

RUN set -eu

################################################################################
# OS Packages

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper addrepo --check --refresh --priority 90 \
        'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_15.6/Essentials/' packman-essentials \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python311-devel \
python311-pip \
python311-wheel \
python311-setuptools \
python311-Cython \
python311-matplotlib \
python311-scikit-build

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
python311-opencv \
opencv \
Mesa-libGL1 \
libgthread-2_0-0

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
ffmpeg \
x264 \
x265 \
python311-GitPython \
python311-pygit2 \
git

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
make \
cmake \
ninja \
aria2 \
findutils \
fish \
fd \
fuse \
vim \
which \
google-noto-sans-fonts \
    && rm -v /usr/lib64/python3.11/EXTERNALLY-MANAGED \
    # Ensure default Python version
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 100

################################################################################
# GCC 11 

RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --gpg-auto-import-keys \
        install --no-confirm --auto-agree-with-licenses \
gcc11 \
gcc11-c++ \
cpp11 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-11 90 \
    && update-alternatives --install /usr/bin/cc  cc  /usr/bin/gcc-11 90 \
    && update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-11 90 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 90 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 90 \
    && update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-11 90 \
    && update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-11 90 \
    && update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-11 90 \
    && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-11 90 \
    && update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-11 90 \
    && update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-11 90 

################################################################################
# Python Packages

# Use Intel accelerated NumPy, SciPy
# Potential performance gain, marginal for Stable Diffusion.
# https://www.intel.com/content/www/us/en/developer/tools/oneapi/distribution-for-python.html
RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --force-reinstall numpy scipy dpnp dpctl tbb4py \
        --index-url https://software.repos.intel.com/python/pypi

# PyTorch (No IPEX for test version)
# Break down the steps, so we have more but smaller image layers.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --upgrade pip wheel setuptools \
    && pip install \
        --dry-run torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/test/xpu

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --no-deps torch \
        --index-url https://download.pytorch.org/whl/test/xpu

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/test/xpu

# Deps for ComfyUI & custom nodes
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

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r /builder-scripts/pak9.txt

# Make sure the deps fit the needs for ComfyUI & Manager
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        -r https://github.com/comfyanonymous/ComfyUI/raw/refs/heads/master/requirements.txt \
        -r https://github.com/Comfy-Org/ComfyUI-Manager/raw/refs/heads/main/requirements.txt \
    && pip list

################################################################################

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
