#!/bin/bash

set -euo pipefail

echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

cd /root

set +e

huggingface-cli download "wushuang98/Direct3D-S2" --include "direct3d-s2-v-1-1/*"
huggingface-cli download "ZhengPeng7/BiRefNet"
python3 -c "import torch; torch.hub.load('facebookresearch/dinov2', 'dinov2_vitl14_reg');"

set -e
