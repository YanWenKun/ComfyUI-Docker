################################################################################
# Dockerfile that builds 'yanwk/comfyui-boot:comfy3d-pt23'
# An environment for running ComfyUI with ComfyUI-3D-Pack.
# Using PyTorch 2.3
# Comfy3D Version: https://github.com/MrForExample/ComfyUI-3D-Pack/tree/30bc061d926f660e7f4822f54778df46326a8fec
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
        xformers==0.0.27.post1 torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu121 \
        --extra-index-url https://pypi.org/simple \
    && pip install \
        -r https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt \
        -r https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/requirements.txt \
        -r https://raw.githubusercontent.com/MrForExample/ComfyUI-3D-Pack/3b4e715939376634c68aa4c1c7d4ea4a8665c098/requirements.txt \
    && pip install \
https://data.pyg.org/whl/torch-2.3.0%2Bcu121/torch_scatter-2.1.2%2Bpt23cu121-cp311-cp311-linux_x86_64.whl \
https://raw.githubusercontent.com/MrForExample/Comfy3D_Pre_Builds/b27af1a28d9f194cea1a137750e35ac698406e60/_Build_Wheels/_Wheels_linux_py311_cu121/diff_gaussian_rasterization-0.0.0-cp311-cp311-linux_x86_64.whl \
https://raw.githubusercontent.com/MrForExample/Comfy3D_Pre_Builds/b27af1a28d9f194cea1a137750e35ac698406e60/_Build_Wheels/_Wheels_linux_py311_cu121/kiui-0.2.10-py3-none-any.whl \
https://raw.githubusercontent.com/MrForExample/Comfy3D_Pre_Builds/b27af1a28d9f194cea1a137750e35ac698406e60/_Build_Wheels/_Wheels_linux_py311_cu121/nvdiffrast-0.3.1-py3-none-any.whl \
https://raw.githubusercontent.com/MrForExample/Comfy3D_Pre_Builds/b27af1a28d9f194cea1a137750e35ac698406e60/_Build_Wheels/_Wheels_linux_py311_cu121/pointnet2_ops-3.0.0-cp311-cp311-linux_x86_64.whl \
https://raw.githubusercontent.com/MrForExample/Comfy3D_Pre_Builds/b27af1a28d9f194cea1a137750e35ac698406e60/_Build_Wheels/_Wheels_linux_py311_cu121/pytorch3d-0.7.7-cp311-cp311-linux_x86_64.whl \
https://raw.githubusercontent.com/MrForExample/Comfy3D_Pre_Builds/b27af1a28d9f194cea1a137750e35ac698406e60/_Build_Wheels/_Wheels_linux_py311_cu121/simple_knn-0.0.0-cp311-cp311-linux_x86_64.whl \
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
