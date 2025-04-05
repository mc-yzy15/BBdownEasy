#!/bin/bash
# BBdownEasy一键运行脚本

# 检查是否已安装
if [ ! -f "/opt/bbdowneasy/BBDown" ]; then
    echo "检测到未安装BBdownEasy，正在自动安装..."
    sudo ./bbdownInstall.sh || {
        echo "自动安装失败，请手动运行: sudo ./bbdownInstall.sh"
        exit 1
    }
fi

# 检查参数
if [ $# -eq 0 ]; then
    echo "请输入B站视频URL，例如:"
    echo "./bbdown.sh https://www.bilibili.com/video/BV1xx..."
    exit 1
fi

# 运行下载
echo "开始下载视频..."
/opt/bbdowneasy/BBDown "$@"
