# BBDown简易版（BBdownEasy）
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## 项目简介
这是一个基于BBDown的B站视频下载工具增强版，提供以下核心功能：
- 自动检测并安装BBDown及依赖组件
- 图形化交互界面简化操作
- 支持快速下载与高级参数自定义
- 自动版本更新检测
- 多线程下载与格式选择

---

## 功能特性

### 1. 自动安装与更新
- 首次运行时自动检测BBDown安装状态
- 通过Chocolatey包管理器自动安装：
  - BBDown下载器
  - FFmpeg编码器
- 定期检查GitHub最新版本并自动更新

### 2. 交互式下载界面
提供菜单式操作选择：
- **快速下载模式**：一键下载视频（含弹幕/封面）
- **高级下载模式**：自定义以下参数：
  - API模式（Web/TV/APP/国际版）
  - 视频清晰度优先级
  - 编码格式优先级（HEVC/AV1等）
  - 是否包含弹幕/封面
  - 自定义保存路径
  - 多线程下载控制

### 3. 登录支持
- 支持B站Web端/TV端账号登录
- 自动保存登录状态

---

## 使用说明

### 安装步骤
1. 双击运行 `bbdownInstall.bat`（需管理员权限）
2. 系统将自动：
   - 创建下载目录 `C:\BiliDownloads`
   - 安装Chocolatey包管理器
   - 下载BBDown及FFmpeg
   - 完成环境配置

### 运行方式
1. 双击运行 `BBdownEasy.bat` 进入主界面
2. 或通过命令行直接下载：

#### 快速下载模式
- 输入视频URL后，系统将自动选择最佳画质并下载。
- 默认下载弹幕和封面。

#### 高级下载模式
- 提供以下参数设置：
  - **API模式**：选择Web/TV/APP/国际版API
  - **画质优先级**：手动指定画质顺序
  - **编码优先级**：指定HEVC/AV1等编码格式
  - **下载内容**：选择是否下载弹幕、封面、字幕等
  - **保存路径**：自定义下载目录
  - **分P选择**：选择特定分P下载
  - **高级选项**：启用调试模式、跳过混流等

---

## 参数说明
- `--use-tv-api`：使用TV端API
- `--use-app-api`：使用APP端API
- `--use-intl-api`：使用国际版API
- `--multi-thread`：启用多线程下载
- `--download-danmaku`：下载弹幕
- `--cover`：下载封面
- `--only-show-info`：仅显示视频信息
- `--select-page`：选择特定分P下载
