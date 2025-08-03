Under Construction...

Tested on an Intel Arc B580 GPU:

* SD 1.5: OK
* SDXL: GOOD
* Stable Cascade: FAST
* Flux1: FAILED
* SD 3.5: OK


Usage
-----

1. Check if the Linux Kernel Module for Intel GPU is installed:

   lsmod | grep -i xe

For a modern desktop distro with a 2025 Kernel, it should be already included.
If you are using an older Linux kernel, you may need to install Intel GPU drivers on your host OS.

iGPUs are not supported, per the Intel doc:
https://pytorch-extension.intel.com/installation?platform=gpu&version=v2.7.10%2Bxpu&os=linux%2Fwsl2&package=pip

2. You may also need to install `intel-compute-runtime` (or equivalent) on your host OS.
If not found, just ignore it and run directly.

3. Run the container:

====
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
====


Notes
-----

1. Disabling IPEX may work if you have compatibility issues.
   But most of time this just downgrade performance.

  -e CLI_ARGS="--disable-ipex-optimize" \

2. In some cases, using fp8 models could cause compatibility issues.
   Try fp16 as a back up resort.

3. Comfy-Org integrated single model files (all-in-one safetensors)
   may not always work on XPU. Sometimes you have to use 'exploded' workflows
   (e.g. UNET workflow).


For Windows Users
-----------------

Just use Intel AI Playground:
https://game.intel.com/us/stories/introducing-ai-playground/

Or yet another ComfyUI portable:
https://github.com/YanWenKun/ComfyUI-WinPortable-XPU
