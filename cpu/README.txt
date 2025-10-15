Usage:
----
mkdir -p storage

docker run -it --rm \
  --name comfyui-cpu \
  -p 8188:8188 \
  -v "$(pwd)"/storage:/root \
  -e CLI_ARGS="--cpu" \
  yanwk/comfyui-boot:cpu
----
