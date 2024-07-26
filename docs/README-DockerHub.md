# ComfyUI

**[CHECK THE GITHUB REPO](https://github.com/YanWenKun/ComfyUI-Docker)**

**[中文文档在 GITHUB 上](https://github.com/YanWenKun/ComfyUI-Docker/blob/main/README.zh.adoc)**

Docker images for [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - a Stable Diffusion GUI powering node-based workflow.

## Quick Start - NVIDIA GPU

```sh
mkdir -p storage

docker run -it --rm \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/home/runner \
  -e CLI_ARGS="" \
  yanwk/comfyui-boot:cu121
```

Once the app is loaded, visit http://localhost:8188/

## More Usage

- [AMD GPU with ROCm](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/rocm)

- ["Megapak" (all-in-one bundle)](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu121-megapak)

- For docs and image detail, check [GitHub Page](https://github.com/YanWenKun/ComfyUI-Docker).
