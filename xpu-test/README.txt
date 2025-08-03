Tested on an Intel Arc B580 GPU:
--------------------------------
(PyTorch 2.8 RC, No IPEX)

Time generating one 1024x1024px image (pre-warmed, only infer time)

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

To run the container:
---------------------

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


What's not OK
-------------

1. Once OOM, ComfyUI won't crash, but GPU will stop responding
   for future prompt (UR_RESULT_ERROR_DEVICE_LOST).
   In that case, you need to restart ComfyUI.

2. On Linux, I have no idea how to monitor VRAM usage. The xpu-smi
   only works for enterprise GPUs.
