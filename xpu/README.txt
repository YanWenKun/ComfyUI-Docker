Usage
-----

1. Check the Linux Kernel Module (driver) for Intel GPU:

      lsmod | grep -i xe

   For desktop distros with rolling-ish kernel updates, xe is usually included already.

2. Search and install `intel-compute-runtime` (or similar) with your host OS' package manager.
   If not found, just ignore it and run directly.

   For Ubuntu, follow this instruction and install the compute-related packages:
       https://dgpu-docs.intel.com/driver/client/overview.html

3. Run the container:

====
mkdir -p \
  storage \
  storage-models/models \
  storage-models/hf-hub \
  storage-models/torch-hub \
  storage-user/input \
  storage-user/output \
  storage-user/workflows

podman run -it --rm \
  --name comfyui-xpu \
  --device=/dev/dri \
  --ipc=host \
  --security-opt label=disable \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/root \
  -v "$(pwd)"/storage-models/models:/root/ComfyUI/models \
  -v "$(pwd)"/storage-models/hf-hub:/root/.cache/huggingface/hub \
  -v "$(pwd)"/storage-models/torch-hub:/root/.cache/torch/hub \
  -v "$(pwd)"/storage-user/input:/root/ComfyUI/input \
  -v "$(pwd)"/storage-user/output:/root/ComfyUI/output \
  -v "$(pwd)"/storage-user/workflows:/root/ComfyUI/user/default/workflows \
  -e CLI_ARGS="--disable-smart-memory --async-offload" \
  yanwk/comfyui-boot:xpu
====

Note:

1. "--disable-smart-memory" is useful for XPU, although it consumes more RAM.
2. "--async-offload" gives subtle improvement and no visible harm.

More CLI_ARGS:

--lowvram
--bf16-unet
--bf16-vae
--bf16-text-enc
--mmap-torch-files
--reserve-vram 1

Check the doc before use:
https://github.com/comfyanonymous/ComfyUI/blob/master/comfy/cli_args.py


Test result on Arc B580
-----------------------

Time on generating one 1024x1024px image (pre-warmed, only infer time)

* SD 1.5 (20-step): OK (5s) | 512x512: GOOD (1s)
* SDXL (28-step): OK (6s)
* SDXL Refiner (20+5-step): OK (4+1s)
* Stable Cascade (20+10-step): FAST (3+3s)
* SD 3.5 large fp8 (20-step): GOOD (26s)
* Flux1 schnell (4-step): GOOD (8s)
* Flux1 dev fp8 (20-step): GOOD (35s)
* Flux1 Krea dev (20-step): OK (46s)

* Hunyuan3D 2.0 (Comfy Repackaged): 'Non-uniform work-groups are not supported by the target device'
* StableZero123: 'Non-uniform work-groups are not supported by the target device'

* Wan 2.2 5B Text to Video (640x352, 121 frames): FAST (60s, very poor quality)
* Wan 2.2 5B Text to Video (960x544, 121 frames): OK (181s, low quality)
* Wan 2.2 5B Text to Video (1280x704, 121 frames): FAILED (OOM)


Notes
--------------

1. Once OOM, ComfyUI won't crash, but GPU will stop responding
   for future prompt (UR_RESULT_ERROR_DEVICE_LOST).
   In that case, you will need to restart ComfyUI.

2. IPEX (Intel Extension for PyTorch) is not included, as most of its features
   have been merged upstream and it is being phased out:
   https://github.com/intel/intel-extension-for-pytorch/releases


For Windows Users
-----------------

Just use Intel AI Playground:
https://game.intel.com/us/stories/introducing-ai-playground/

Or yet another ComfyUI portable:
https://github.com/YanWenKun/ComfyUI-WinPortable-XPU
