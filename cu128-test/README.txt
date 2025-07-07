This Docker image pre-installed PyTorch 2.8 with libs for CUDA 12.8.

Notes:
1. PyTorch, since version 2.7 + CUDA 12.8, had dropped the support for Maxwell, Pascal, and Volta GPUs.
   If you're using one of them, use CUDA 12.6 builds instead.
2. xFormers is not installed, as it doesn't provide official support for test-version of PyTorch.

Usage:
----
mkdir -p storage

docker run -it --rm \
  --name comfyui-cu128 \
  --gpus all \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/root \
  -e CLI_ARGS="--fast" \
  yanwk/comfyui-boot:cu128-test
----
