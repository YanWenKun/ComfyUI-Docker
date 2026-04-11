#!/bin/bash

set -e

echo "########################################"

# 如果工作目录下无 ComfyUI，则从预载目录下复制一份
cd /root
if [ ! -f "/root/ComfyUI/main.py" ] ; then
    mkdir -p /root/ComfyUI
    # 'rsync --archive': 保留文件属性，如时间戳、权限等
    # 'rsync --ignore-existing': 不要覆盖已有文件
    if rsync --archive --ignore-existing --exclude 'custom_nodes/' "/default-comfyui-bundle/ComfyUI/" "/root/ComfyUI/" ; then
        echo "[INFO] 复制预载的 ComfyUI 到工作目录..."
    else
        echo "[ERROR] 复制 ComfyUI 到 '/root/ComfyUI' 失败！" >&2
        exit 1
    fi
else
    echo "[INFO] 使用用户存储的 ComfyUI ..."
fi

# 如果工作目录下无自定义节点（插件），则从预载目录下复制一份
cd /root
if [ ! -f "/root/ComfyUI/custom_nodes/example_node.py.example" ] ; then
    mkdir -p /root/ComfyUI/custom_nodes
    # 'cp --archive': 保留文件属性，如时间戳、权限等
    # 'cp --update=none': 不要覆盖已有文件
    if cp --archive --update=none "/default-comfyui-bundle/ComfyUI/custom_nodes/." "/root/ComfyUI/custom_nodes/" ; then
        echo "[INFO] 复制预载的自定义节点（插件）到工作目录..."
    else
        echo "[ERROR] 复制自定义节点（插件）到 '/root/ComfyUI/custom_nodes' 失败！" >&2
        exit 1
    fi
else
    echo "[INFO] 使用用户存储的自定义节点（插件）..."
fi

# 运行用户的预启动脚本
cd /root
if [ ! -f "/root/user-scripts/pre-start.sh" ] ; then
    mkdir -p /root/user-scripts
    cp /runner-scripts/pre-start.sh.example /root/user-scripts/pre-start.sh
else
    echo "[INFO] 执行预启动脚本……"

    chmod +x /root/user-scripts/pre-start.sh
    source /root/user-scripts/pre-start.sh
fi ;

echo "[INFO] 启动 ComfyUI..."
echo "########################################"

# 使得 .pyc 缓存文件集中保存
export PYTHONPYCACHEPREFIX="/root/.cache/pycache"
# 使得 PIP 安装新包到 /root/.local
export PIP_USER=true
# 添加上述路径到 PATH
export PATH="${PATH}:/root/.local/bin"
# 不再显示警报 [WARNING: Running pip as the 'root' user]
export PIP_ROOT_USER_ACTION=ignore

cd /root

python3 ./ComfyUI/main.py --listen --port 8188 --enable-manager --enable-manager-legacy-ui ${CLI_ARGS}
