#!/bin/bash
# Linux自动安装脚本

echo "正在安装BBdownEasy Linux版本..."

# 检查是否以root运行
if [ "$(id -u)" -ne 0 ]; then
    echo "请使用root权限运行此脚本 (sudo $0)"
    exit 1
fi

# 安装依赖
echo "安装系统依赖..."
if command -v apt-get &> /dev/null; then
    apt-get update
    apt-get install -y ffmpeg wget unzip
elif command -v yum &> /dev/null; then
    yum install -y ffmpeg wget unzip
elif command -v dnf &> /dev/null; then
    dnf install -y ffmpeg wget unzip
else
    echo "不支持的包管理器，请手动安装: ffmpeg wget unzip"
    exit 1
fi

# 创建安装目录
INSTALL_DIR="/opt/bbdowneasy"
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

# 下载BBDown
echo "下载BBDown..."
wget https://github.com/nilaoda/BBDown/releases/latest/download/BBDown.zip -O BBDown.zip
unzip BBDown.zip
chmod +x BBDown

# 创建启动脚本
echo "创建启动脚本..."
cat > /usr/local/bin/bbdown << 'EOF'
#!/bin/bash
/opt/bbdowneasy/BBDown "$@"
EOF

chmod +x /usr/local/bin/bbdown

# 创建快捷方式
echo "创建桌面快捷方式..."
cat > /usr/share/applications/bbdowneasy.desktop << 'EOF'
[Desktop Entry]
Name=BBdownEasy
Comment=B站视频下载工具
Exec=/usr/local/bin/bbdown
Icon=/opt/bbdowneasy/icon.png
Terminal=true
Type=Application
Categories=Network;
EOF

echo "安装完成！"
echo "使用方法: bbdown [视频URL] 或点击桌面图标"
