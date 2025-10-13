Run the container:

====
mkdir -p storage
mkdir -p storage-models/models
mkdir -p storage-models/hf-hub
mkdir -p storage-models/torch-hub
mkdir -p storage-user/input
mkdir -p storage-user/output
mkdir -p storage-user/workflows

docker run -it --rm \
  --name comfyui \
  --gpus all \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/root \
  -v "$(pwd)"/storage-models/models:/root/ComfyUI/models \
  -v "$(pwd)"/storage-models/hf-hub:/root/.cache/huggingface/hub \
  -v "$(pwd)"/storage-models/torch-hub:/root/.cache/torch/hub \
  -v "$(pwd)"/storage-user/input:/root/ComfyUI/input \
  -v "$(pwd)"/storage-user/output:/root/ComfyUI/output \
  -v "$(pwd)"/storage-user/workflows:/root/ComfyUI/user/default/workflows \
  -e CLI_ARGS="--fast --use-pytorch-cross-attention" \
  yanwk/comfyui-boot:cu129-slim
====

Note for CLI_ARGS:
"--fast" - For 40 series and newer GPUs.
"--use-pytorch-cross-attention" - Disable xFormers. Recommended for Blackwell GPUs.
