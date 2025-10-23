# ComfyUI

**[CHECK THE GITHUB REPO](https://github.com/YanWenKun/ComfyUI-Docker)**

**[中文文档在 GITHUB 上](https://github.com/YanWenKun/ComfyUI-Docker/blob/main/README.zh.adoc)** 
<!-- | 
**[国内适配镜像点我](https://gitee.com/yanwenkun/ComfyUI-Docker/tree/main/cu124-cn)** -->

Docker images for [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - a Stable Diffusion GUI powering node-based workflow.


## Quick Start - NVIDIA GPU

```sh
mkdir -p \
  storage \
  storage-models/models \
  storage-models/hf-hub \
  storage-models/torch-hub \
  storage-user/input \
  storage-user/output \
  storage-user/workflows

docker run -it --rm \
  --runtime nvidia \
  --gpus all \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/root \
  -v "$(pwd)"/storage-models/models:/root/ComfyUI/models \
  -v "$(pwd)"/storage-models/hf-hub:/root/.cache/huggingface/hub \
  -v "$(pwd)"/storage-models/torch-hub:/root/.cache/torch/hub \
  -v "$(pwd)"/storage-user/input:/root/ComfyUI/input \
  -v "$(pwd)"/storage-user/output:/root/ComfyUI/output \
  -v "$(pwd)"/storage-user/workflows:/root/ComfyUI/user/default/workflows \
  -e CLI_ARGS="--disable-xformers" \
  yanwk/comfyui-boot:cu128-slim
```

Once the app is loaded, visit http://localhost:8188/


## CUDA Image Tags - Slim

Start with only ComfyUI and ComfyUI-Manager, yet include many dependencies to make future Custom Node installation easier.
Recommended for beginners.

- `cu126-slim` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu126-slim)
  - Using CUDA 12.6, Python 3.12

- `cu128-slim` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu128-slim) ⭐
  - Using CUDA 12.8, Python 3.12

- `cu130-slim` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu130-slim)
  - Using CUDA 13.0, Python 3.13 (with GIL). No xFormers by default


## CUDA Image Tags - MEGAPAK

All-in-one bundles, including dev kits and many Custom Nodes for ComfyUI.

- `cu126-megapak` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu126-megapak)
  - Using CUDA 12.6, Python 3.12, GCC 13

- `cu128-megapak` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu128-megapak)
  - Using CUDA 12.8, Python 3.12, GCC 14


## More Image Tags

- `rocm` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/rocm)
  - For AMD GPU with ROCm.

- `xpu` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/xpu)
  - For Intel GPU with XPU.

- `cpu` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cpu)
  - For CPU only.

- `nightly` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/nightly)
  - Using preview version of PyTorch (CUDA).

- [archived](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/archived)
  - Archived Dockerfiles of retired image tags.

<!-- 
- `cu124-cn` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu124-cn)

  - For users in mainland China. Using mirror sites for all download links. -->

For more detailed docs, check [GitHub Page](https://github.com/YanWenKun/ComfyUI-Docker).
