# ComfyUI

**[CHECK THE GITHUB REPO](https://github.com/YanWenKun/ComfyUI-Docker)**

**[中文文档在 GITHUB 上](https://github.com/YanWenKun/ComfyUI-Docker/blob/main/README.zh.adoc)** 
| 
**[国内适配镜像点我](https://gitee.com/yanwenkun/ComfyUI-Docker/tree/main/cu124-cn)**

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

  - Recommended for anyone trying ComfyUI for the first time.
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

- `cu124-cn` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu124-cn)

  - For users in mainland China. Using mirror sites for all download links.

- `rocm` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/rocm)

  - For AMD GPU with ROCm.

- `nightly` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/nightly)

  - Using preview version of PyTorch.

- Images dedicated for [ComfyUI-3D-Pack](https://github.com/MrForExample/ComfyUI-3D-Pack):

  - `comfy3d-pt22` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/comfy3d-pt22) Running the [Jun 23, 2024](https://github.com/MrForExample/ComfyUI-3D-Pack/tree/3b4e715939376634c68aa4c1c7d4ea4a8665c098[) version of Comfy3D based on PyTorch 2.2.

  - `comfy3d-pt23` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/comfy3d-pt23) Running the [Oct 18, 2024](https://github.com/MrForExample/ComfyUI-3D-Pack/tree/bdc5e3029ed96d9fa25e651e12fce1553a4422c4) version of Comfy3D based on PyTorch 2.3.

  - `comfy3d-pt25` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/comfy3d-pt25) Running the latest version of Comfy3D based on PyTorch 2.5.


For more detailed docs, check [GitHub Page](https://github.com/YanWenKun/ComfyUI-Docker).
