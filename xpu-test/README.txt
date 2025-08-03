Tested on an Intel Arc B580 GPU:

(PyTorch 2.8 RC, No IPEX)

* SD 1.5: OK
* SDXL: GOOD
* Stable Cascade: FAST
* Flux1: OK
* SD 3.5: OK


Run the container:

====
mkdir -p storage

podman run -it --rm \
  --name comfyui-xpu-test \
  --device=/dev/dri \
  --ipc=host \
  --security-opt label=disable \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/root \
  -e CLI_ARGS="" \
  yanwk/comfyui-boot:xpu-test
====
