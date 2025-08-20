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
  --name comfyui-cu126 \
  --gpus all \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/root \
  -e CLI_ARGS="" \
  yanwk/comfyui-boot:cu126-slim
```

Once the app is loaded, visit http://localhost:8188/

## Image Tags

- `cu121` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu121)

  - Easy for ComfyUI beginners.
  - Starts with ComfyUI, ComfyUI-Manager and the Photon (SD1.5) model.
  - Using a low-privilege user within the container (easy for WSL2 deploy).
  - Using CUDA 12.1 + Python 3.11.

- `cu124-slim` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu124-slim)

  - Similar to `cu121`, equipped with many dependencies, starts with ComfyUI and ComfyUI-Manager only.
  - Downloads less. No SD model included.
  - Using 'root' user within the container (easy for rootless deploy).
  - Using CUDA 12.4 + Python 3.12.

- `cu121-megapak` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu121-megapak)

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

- `comfy3d-pt25` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/comfy3d-pt25)

  - Image dedicated for [ComfyUI-3D-Pack](https://github.com/MrForExample/ComfyUI-3D-Pack).


For more detailed docs, check [GitHub Page](https://github.com/YanWenKun/ComfyUI-Docker).
