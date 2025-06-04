Docker image for running Direct3D-S2
https://github.com/DreamTechAI/Direct3D-S2

Need GPU ≥ Turing (RTX 20 series / GTX 16 series).
Need at least 12GB VRM (recommend 16GB).

USAGE

A. For RTX 20 series / GTX 16 series:

----
mkdir -p storage

podman run -it \
  --name direct3ds2-demo \
  --device nvidia.com/gpu=all \
  --security-opt label=disable \
  -p 7860:7860 \
  -v "$(pwd)"/storage:/root \
  -e TORCH_CUDA_ARCH_LIST="7.5+PTX" \
  -e ATTN_BACKEND="xformers" \
  -e SPARSE_ATTN_BACKEND="xformers" \
  -e SPARSE_BACKEND="torchsparse" \
  -e GRADIO_SERVER_NAME="0.0.0.0" \
  docker.io/yanwk/comfyui-boot:direct3ds2
----

B. For 30 series (Ampere) and later:

----
mkdir -p storage

podman run -it \
  --name direct3ds2-demo \
  --device nvidia.com/gpu=all \
  --security-opt label=disable \
  -p 7860:7860 \
  -v "$(pwd)"/storage:/root \
  -e TORCH_CUDA_ARCH_LIST="8.6+PTX" \
  -e ATTN_BACKEND="flash_attn" \
  -e SPARSE_ATTN_BACKEND="flash_attn" \
  -e SPARSE_BACKEND="torchsparse" \
  -e GRADIO_SERVER_NAME="0.0.0.0" \
  docker.io/yanwk/comfyui-boot:direct3ds2
----
