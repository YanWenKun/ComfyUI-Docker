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

## Image Tags

- `cu121`, `latest` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu121)

  - Recommended for those trying ComfyUI for the first time.
  - Equipped with many dependencies. Starts with ComfyUI core only.
  - Using a low-privilege user within the container (easy for WSL2 deploy).
  - Using CUDA 12.1 + Python 3.11.

- `cu121-megapak`, `megapak` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu121-megapak)

  - All-in-one bundle, including dev kits.
  - Using 'root' user within the container (easy for rootless deploy).
  - Using CUDA 12.1 + Python 3.11.

- `cu124-megapak` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu124-megapak)

  - All-in-one bundle, including dev kits.
  - Using 'root' user within the container (easy for rootless deploy).
  - Using CUDA 12.4 + Python 3.12. May perform better on newer GPUs.

- `rocm` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/rocm)

  - For AMD GPU with ROCm.

- `comfy3d-pt22` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/comfy3d-pt22)

  - Dedicated for [ComfyUI-3D-Pack](https://github.com/MrForExample/ComfyUI-3D-Pack).
  - Running a classic version of Comfy3D based on PyTorch 2.2.

- `comfy3d-pt23` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/comfy3d-pt23)

  - Dedicated for [ComfyUI-3D-Pack](https://github.com/MrForExample/ComfyUI-3D-Pack).
  - Running a newer version of Comfy3D based on PyTorch 2.3.

For more detailed docs, check [GitHub Page](https://github.com/YanWenKun/ComfyUI-Docker).
