# ComfyUI

[![GitHub Workflow Status](https://github.com/YanWenKun/ComfyUI-Docker/actions/workflows/build-regular.yml/badge.svg)](https://github.com/YanWenKun/ComfyUI-Docker/actions/workflows/build-regular.yml)

**[CHECK THE GITHUB REPO](https://github.com/YanWenKun/ComfyUI-Docker)**

**[中文文档在 GITHUB 上](https://github.com/YanWenKun/ComfyUI-Docker/blob/main/README.zh.adoc)**

Docker image for [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - a Stable Diffusion GUI powering node-based workflow.

## Usage - NVIDIA GPU

```sh
git clone https://github.com/YanWenKun/ComfyUI-Docker.git

cd ComfyUI-Docker

docker compose up --detach

# Update image (only when Python components is outdated)
git pull
docker compose pull
docker compose up --detach --remove-orphans
docker image prune
```

## Usage - AMD GPU (Experimental)

```sh
git clone https://github.com/YanWenKun/ComfyUI-Docker.git

cd ComfyUI-Docker

docker compose -f docker-compose-rocm.yml up --detach

# Update image (only when Python components is outdated)
git pull
docker compose -f docker-compose-rocm.yml pull
docker compose -f docker-compose-rocm.yml up --detach --remove-orphans
docker image prune
```

## More

Once the app is loaded, visit http://localhost:8188/

For detailed `docker run` commands, check the doc on [GitHub repo](https://github.com/YanWenKun/ComfyUI-Docker).
