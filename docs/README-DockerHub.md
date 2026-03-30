# ComfyUI

**[CHECK THE GITHUB REPO](https://github.com/YanWenKun/ComfyUI-Docker)**

**[中文文档在 GITHUB 上](https://github.com/YanWenKun/ComfyUI-Docker/blob/main/README.zh.adoc)** 
<!-- | 
**[国内适配镜像点我](https://gitee.com/yanwenkun/ComfyUI-Docker/tree/main/cu124-cn)** -->

Docker images for [ComfyUI](https://github.com/Comfy-Org/ComfyUI) - an AIGC GUI powering node-based workflow.


## Quick Start - NVIDIA GPU

```sh
mkdir -p \
  storage-cache/dot-cache \
  storage-cache/dot-config \
  storage-nodes/dot-local \
  storage-nodes/custom_nodes \
  storage-models/models \
  storage-models/hf-hub \
  storage-models/torch-hub \
  storage-user/input \
  storage-user/output \
  storage-user/user-profile \
  storage-user/user-scripts

# Add sudo if needed
docker run -it --rm \
  --name comfyui-cu130 \
  --pull=always \
  --runtime=nvidia \
  --gpus all \
  -p 8188:8188 \
  -v "$(pwd)"/storage-cache/dot-cache:/root/.cache \
  -v "$(pwd)"/storage-cache/dot-config:/root/.config \
  -v "$(pwd)"/storage-nodes/dot-local:/root/.local \
  -v "$(pwd)"/storage-nodes/custom_nodes:/root/ComfyUI/custom_nodes \
  -v "$(pwd)"/storage-models/models:/root/ComfyUI/models \
  -v "$(pwd)"/storage-models/hf-hub:/root/.cache/huggingface/hub \
  -v "$(pwd)"/storage-models/torch-hub:/root/.cache/torch/hub \
  -v "$(pwd)"/storage-user/input:/root/ComfyUI/input \
  -v "$(pwd)"/storage-user/output:/root/ComfyUI/output \
  -v "$(pwd)"/storage-user/user-profile:/root/ComfyUI/user \
  -v "$(pwd)"/storage-user/user-scripts:/root/user-scripts \
  -e CLI_ARGS="" \
  yanwk/comfyui-boot:cu130-slim-v2
```

Once the app is loaded, visit http://localhost:8188/


## CUDA Image Tags - Slim

Start with only ComfyUI and ComfyUI-Manager, yet include many dependencies to make future Custom Node installation easier.
Recommended for beginners.

- `cu130-slim-v2` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu130-slim-v2) ⭐
  - Using CUDA 13.0, Python 3.13 (with GIL). No xFormers by default

- `cu128-slim` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu128-slim)
  - Using CUDA 12.8, Python 3.12

- `cu126-slim` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu126-slim)
  - Using CUDA 12.6, Python 3.12


## CUDA Image Tags - MEGAPAK

All-in-one bundles, including dev kits and many Custom Nodes for ComfyUI.

- `cu130-megapak-pt211` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu130-megapak-pt211)
  - Using CUDA 13.0, Python 3.13 (with GIL), GCC 14, PyTorch 2.11.0

- `cu128-megapak` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu128-megapak)
  - Using CUDA 12.8, Python 3.12, GCC 14, PyTorch 2.11.0

- `cu126-megapak` [\[doc\]](https://github.com/YanWenKun/ComfyUI-Docker/tree/main/cu126-megapak)
  - Using CUDA 12.6, Python 3.12, GCC 13, PyTorch 2.9.1


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
