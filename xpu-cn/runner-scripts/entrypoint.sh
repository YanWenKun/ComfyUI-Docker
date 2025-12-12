#!/bin/bash

set -e

echo "########################################"

# 运行用户的配置代理脚本
cd /root
if [ ! -f "/root/user-scripts/set-proxy.sh" ] ; then
    mkdir -p /root/user-scripts
    cp /runner-scripts/set-proxy.sh.example /root/user-scripts/set-proxy.sh
else
    echo "[INFO] 执行配置代理脚本……"

    chmod +x /root/user-scripts/set-proxy.sh
    source /root/user-scripts/set-proxy.sh
fi ;

# 如果工作目录下无 ComfyUI，则从预载目录下复制一份
cd /root
if [ ! -f "/root/ComfyUI/main.py" ] ; then
    mkdir -p /root/ComfyUI
    # 'cp --archive': 保留文件属性，如时间戳、权限等
    # 'cp --update=none': 不要覆盖已有文件
    if cp --archive --update=none "/default-comfyui-bundle/ComfyUI/." "/root/ComfyUI/" ; then
        echo "[INFO] 复制预载的 ComfyUI 到工作目录..."
    else
        echo "[ERROR] 复制 ComfyUI 到 '/root/ComfyUI' 失败！" >&2
        exit 1
    fi
else
    echo "[INFO] 使用用户存储的 ComfyUI ..."
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

python3 ./ComfyUI/main.py --listen --port 8188 --enable-manager ${CLI_ARGS}
