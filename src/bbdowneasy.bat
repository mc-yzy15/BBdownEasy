@echo off
setlocal enabledelayedexpansion

:: 初始化设置
title BBDown 简易版 - 带自动安装功能
if not exist "J:\video\Bili Downloads" mkdir "J:\video\Bili Downloads"
cd /d "J:\video\Bili Downloads"

:: 自动安装函数
:auto_install
where BBDown >nul 2>&1
if %ERRORLEVEL% equ 0 goto check_update

echo.
echo 检测到未安装BBDown，正在尝试自动安装...
echo.

:: 检查是否管理员权限
net session >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo 需要管理员权限进行自动安装
    echo 请右键选择"以管理员身份运行"
    pause
    exit /b 1
)

:: 安装Chocolatey
echo 正在安装Chocolatey包管理器...
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" || (
    echo Chocolatey安装失败
    goto manual_install
)

:: 安装BBDown
echo 正在安装BBDown...
choco install bbdown -y || (
    echo BBDown安装失败
    goto manual_install
)

:: 安装FFmpeg
echo 正在安装FFmpeg...
choco install ffmpeg -y

:check_update
echo 正在检查更新...
for /f "tokens=*" %%i in ('BBDown --version') do set current_ver=%%i
for /f "tokens=*" %%i in ('curl -s https://api.github.com/repos/nilaoda/BBDown/releases/latest ^| findstr "tag_name"') do (
    set latest_ver=%%i
    set latest_ver=!latest_ver:*tag_name: =!
    set latest_ver=!latest_ver:~1,-2!
)

if not "!current_ver!"=="!latest_ver!" (
    echo 发现新版本: !latest_ver!
    echo 正在更新...
    choco upgrade bbdown -y || (
        echo 自动更新失败
        goto manual_update
    )
)

:: 原有功能
if "%~1"=="" (
    echo.
    echo 使用方法: bdowneasy [视频URL]
    echo 示例: bdowneasy "https://www.bilibili.com/video/BV1xx411c7H2"
    echo.
    BBDown --help
    pause
    exit /b 1
)

BBDown %*

:: 记录日志
echo [%date% %time%] !cmd! >> bdown.log
exit /b 0

:manual_install
echo.
echo 自动安装失败，请手动安装:
echo 1. 下载BBDown: https://github.com/nilaoda/BBDown/releases
echo 2. 解压后将BBDown.exe放入PATH目录
echo 3. 或放入本程序相同目录
pause
exit /b 1

:manual_update
echo.
echo 自动更新失败，请手动下载:
echo https://github.com/nilaoda/BBDown/releases
pause
goto :eof
