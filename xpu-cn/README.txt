使用方法
--------

1. 检查 Intel GPU 驱动（Linux 内核模块）：

      lsmod | grep -i xe

   常见桌面发行版基本无需手动安装。如果没有 xe 模块，建议搜索教程／排查错误。

2. 在宿主系统（物理机）上搜索安装 `intel-compute-runtime` 或相似名称的软件包。如果没有，可忽略并执行下一步。

   如使用 Ubuntu, 参照该文档安装计算相关软件包（文档中 "compute-related packages" 部分）：
       https://dgpu-docs.intel.com/driver/client/overview.html

3. 启动容器：

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
  yanwk/comfyui-boot:xpu-cn
====

备注：

1. "--disable-smart-memory" 对 XPU 极其有用，可有效减少显存泄漏的情况，但会占用更多内存。
2. "--async-offload" 会有少量性能提升，且无明显副作用。

更多 CLI_ARGS 参考：

--lowvram
--bf16-unet
--bf16-vae
--bf16-text-enc
--mmap-torch-files
--reserve-vram 1

详细说明：
https://github.com/comfyanonymous/ComfyUI/blob/master/comfy/cli_args.py


部分测试结果，使用 Arc B580
------------------------

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


备注
--------------

1. 一旦显存溢出，ComfyUI 不会崩溃，但 GPU 会拒绝执行后续队列，并报错 UR_RESULT_ERROR_DEVICE_LOST 。
   遇到这种情况，需要重启 ComfyUI 。

2. 镜像中并未预装 IPEX (Intel Extension for PyTorch) ，它的大部分功能已整合至 PyTorch 中，今后将逐渐淡出：
   https://github.com/intel/intel-extension-for-pytorch/releases


如果你正在使用 Windows
--------------------

Intel 官方有一个 AI Playground 应用：
https://game.intel.com/us/stories/introducing-ai-playground/

或者使用我做的 ComfyUI Windows XPU 整合包:
https://github.com/YanWenKun/ComfyUI-WinPortable-XPU
