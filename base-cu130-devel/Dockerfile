################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:base-cu130-devel'
# Using:
# - glibc 2.39 (from Rocky Linux 10)
# - GCC 14 (from Rocky Linux 10)
# - CUDA Toolkit devel 13.0.2
#
# Note:
# cuDNN and NCCL version depends on the PyTorch version
# (PyTorch is not using the exact version as in NVIDIA's images),
# so they are not installed in this image.
################################################################################

# Registry mirror
ARG REGISTRY=docker.io
#ARG REGISTRY=m.daocloud.io/docker.io

FROM ${REGISTRY}/rockylinux/rockylinux:10

LABEL maintainer="code@yanwk.fun"

ARG USING_GITHUB_ACTIONS=false

################################################################################
# NVIDIA CUDA devel

# "base"
RUN --mount=type=cache,target=/var/cache/dnf \
    printf "\
[cuda-rhel10-x86_64]\n\
name=cuda-rhel10-x86_64\n\
baseurl=https://developer.download.nvidia.com/compute/cuda/repos/rhel10/x86_64\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://developer.download.nvidia.com/compute/cuda/repos/rhel10/x86_64/CDF6BA43.pub\n" \
    > /etc/yum.repos.d/cuda.repo \
    && dnf upgrade -y \
    && dnf install -y \
cuda-cudart-13-0 \
cuda-compat-13-0

# "runtime"
# Exclude libnccl
RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
libcublas-13-0

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
libcusolver-13-0 \
libcusparse-13-0 \
libnpp-13-0

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
cuda-nvtx-13-0 \
cuda-libraries-13-0

# "devel"
# Exclude libnccl-devel
RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
cuda-command-line-tools-13-0 \
cuda-cudart-devel-13-0 \
cuda-nvml-devel-13-0 \
libcublas-devel-13-0

# this will install gcc-c++ & make as well
RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
cuda-minimal-build-13-0 \
libnpp-devel-13-0

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
cuda-nsight-compute-13-0

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
libcusolver-devel-13-0 \
libcusparse-devel-13-0

RUN --mount=type=cache,target=/var/cache/dnf \
    dnf install -y \
cuda-libraries-devel-13-0

# Note: there are some compatibility fixes in NVIDIA's images
# https://gitlab.com/nvidia/container-images/cuda/-/work_items/47
# But we are building for new platforms so only new things here.

ENV CUDA_VERSION="13.0.2" \
    PATH="/usr/local/cuda-13.0/bin:${PATH}" \
    LD_LIBRARY_PATH="/usr/local/cuda-13.0/lib64:/usr/lib64" \
    LIBRARY_PATH="/usr/local/cuda-13.0/lib64/stubs" \
    CUDA_HOME="/usr/local/cuda-13.0" \
    NVIDIA_VISIBLE_DEVICES="all" \
    NVIDIA_DRIVER_CAPABILITIES="compute,utility"
