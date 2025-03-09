Under Construction...

Tested on an Intel Arc B580 GPU:

* SD 1.5: OK
* SDXL: GOOD
* Stable Cascade: FAST
* Flux1: FAILED
* SD 3.5: FAILED

Usage:

You need to install Intel GPU drivers on your host OS.

You may also need to install `intel-compute-runtime` (or equivalent) on your host OS.
If not found, just ignore it and run directly.

----
mkdir -p storage

podman run -it --rm \
  --name comfyui-xpu \
  --device=/dev/dri \
  --ipc=host \
  --security-opt label=disable \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/root \
  -e CLI_ARGS="" \
  yanwk/comfyui-boot:xpu
----
