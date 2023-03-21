#!/bin/bash

set -eu

echo "########################################"
echo "Updating ComfyUI..."
echo "########################################"

cd "/home/runner/ComfyUI" && git pull

echo "########################################"
echo "Updating Custom Nodes..."
echo "########################################"

# '&' will run command in background, effectively parallel.
cd "/home/runner/ComfyUI/custom_nodes" &&
for D in *; do
    if [ -d "${D}" ]; then
        git -C "${D}" pull && echo "Done Updating: ${D}" &
    fi
done
wait $(jobs -p)

echo "Update complete."
exit 0
