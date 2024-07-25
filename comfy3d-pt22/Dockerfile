################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:comfy3d-pt22'
# An environment for running ComfyUI with ComfyUI-3D-Pack.
# Using PyTorch 2.2, CUDA 12.1, Python 3.11
# Using Comfy3D Version: https://github.com/MrForExample/ComfyUI-3D-Pack/tree/3b4e715939376634c68aa4c1c7d4ea4a8665c098
################################################################################

# https://gitlab.com/nvidia/container-images/cuda
# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda/tags
FROM nvcr.io/nvidia/cuda:12.1.1-cudnn8-devel-ubi9

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

################################################################################
# Python and tools
# GCC 11 & Make is already included in the base image.

RUN --mount=type=cache,target=/var/cache/dnf \
    set -eu \
    && dnf upgrade -y --disablerepo cuda \
    && dnf install -y \
python3.11-devel \
python3.11-pip \
python3.11-Cython \
python3.11-numpy \
python3.11-requests \
python3.11-scipy \
python3.11-urllib3 \
git \
git-lfs \
less \
mesa-libGL \
mesa-libEGL \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 100 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3.11 100

################################################################################
# Python Packages
# Comfy3D doesn't use ONNX Runtime, so this image skipped it.

RUN --mount=type=cache,target=/root/.cache/pip \
    pip list \
    && pip install \
        --upgrade pip wheel setuptools \
    && pip install \
        xformers==0.0.25.post1 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu121 \
        --extra-index-url https://pypi.org/simple \
    && pip install \
        -r https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/requirements.txt \
        -r https://raw.githubusercontent.com/MrForExample/ComfyUI-3D-Pack/3b4e715939376634c68aa4c1c7d4ea4a8665c098/requirements.txt \
    && pip install \
        https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/diff_gaussian_rasterization-0.0.0-cp311-cp311-linux_x86_64.whl \
        https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/kiui-0.2.7-py3-none-any.whl \
        https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/nvdiffrast-0.3.1-py3-none-any.whl \
        https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/pointnet2_ops-3.0.0-cp311-cp311-linux_x86_64.whl \
        https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/pytorch3d-0.7.6-cp311-cp311-linux_x86_64.whl \
        https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/simple_knn-0.0.0-cp311-cp311-linux_x86_64.whl \
        https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/torch_scatter-2.1.2-cp311-cp311-linux_x86_64.whl \
        https://github.com/YanWenKun/ComfyUI-3D-Pack-LinuxWheels/releases/download/v2/torchmcubes-0.1.0-cp311-cp311-linux_x86_64.whl \
    && pip list

################################################################################

RUN du -ah /root \
    && rm -rf /root/* /root/.*

COPY runner-scripts/.  /runner-scripts/

USER root
VOLUME /root
WORKDIR /root
EXPOSE 8188
ENV CLI_ARGS=""
CMD ["bash","/runner-scripts/entrypoint.sh"]
