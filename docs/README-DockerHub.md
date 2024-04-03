# ComfyUI

[![GitHub Workflow Status](https://github.com/YanWenKun/ComfyUI-Docker/actions/workflows/build-latest.yml/badge.svg)](https://github.com/YanWenKun/ComfyUI-Docker/actions/workflows/build-latest.yml)
[![GitHub Workflow Status](https://github.com/YanWenKun/ComfyUI-Docker/actions/workflows/build-rocm.yml/badge.svg)](https://github.com/YanWenKun/ComfyUI-Docker/actions/workflows/build-rocm.yml)

**[CHECK THE GITHUB REPO](https://github.com/YanWenKun/ComfyUI-Docker)**

**[中文文档在 GITHUB 上](https://github.com/YanWenKun/ComfyUI-Docker/blob/main/README.zh.adoc)**

Docker images for [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - a Stable Diffusion GUI powering node-based workflow.

## Usage - NVIDIA GPU

```sh
mkdir -p storage

docker run -it --rm \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/home/runner \
  -e CLI_ARGS="" \
  yanwk/comfyui-boot:latest
```

## Usage - AMD GPU (Experimental)

```sh
mkdir -p storage

docker run -it --rm \
  --name comfyui-root \
  --device=/dev/kfd --device=/dev/dri \
  --group-add=video --ipc=host --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  --security-opt label=disable \
  -p 8188:8188 \
  --env CLI_ARGS="--use-pytorch-cross-attention" \
  --user root --workdir /root \
  -v "$(pwd)"/storage:/root \
  yanwk/comfyui-boot:rocm \
  /bin/bash /home/scripts/root-wrapper.sh
```

## More

Once the app is loaded, visit http://localhost:8188/

For detailed `docker run` commands, check the doc on [GitHub repo](https://github.com/YanWenKun/ComfyUI-Docker).
