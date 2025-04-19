This Docker image pre-installed PyTorch 2.7 with libs for CUDA 12.8.

Note that xFormers is not installed, as it doesn't provide official support for test-version of PyTorch.

Usage

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
