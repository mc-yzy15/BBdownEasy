@echo off
setlocal enabledelayedexpansion

:: 自动检查并创建目录
if not exist "J:\video\Bili Downloads" (
    mkdir "J:\video\Bili Downloads"
    if errorlevel 1 (
        echo 无法创建目录 J:\video\Bili Downloads
        pause
        exit /b 1
    )
)
cd /d "J:\video\Bili Downloads"

:: 环境检查函数
:check_environment
where BBDown >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo 未检测到BBDown，请手动下载并安装
    echo 下载地址: https://github.com/nilaoda/BBDown/releases
    echo 下载后请将BBDown.exe放入系统PATH目录或本程序目录
    pause
    exit /b 1
)

:: 自动更新检查
:check_update
echo 正在检查BBDown更新...
for /f "tokens=*" %%i in ('BBDown --version') do set current_version=%%i
powershell -Command "(Invoke-WebRequest -Uri 'https://api.github.com/repos/nilaoda/BBDown/releases/latest' -UseBasicParsing).Content" > temp.json
for /f "tokens=*" %%i in ('type temp.json ^| findstr "tag_name"') do (
    set "latest_version=%%i"
    set "latest_version=!latest_version:*tag_name: =!"
    set "latest_version=!latest_version:~1,-2!"
)
del temp.json

if not "!current_version!"=="!latest_version!" (
    echo 发现新版本: !latest_version!
    echo 请手动下载更新: https://github.com/nilaoda/BBDown/releases
    echo 当前版本: !current_version!
    pause
)

:: 原有代码保持不变
if "%~1"=="" (
    echo 错误: 必须提供视频URL或命令
    echo.
    BBDown --help
    pause
    exit /b 1
)

:: 执行下载
BBDown %*

:: 记录日志
echo [%date% %time%] 执行命令: BBDown %* >> bdown.log

:main_menu
cls
echo.
echo ===== BBDown 下载器 v1.6.3 =====
echo 1. 快速下载（默认参数）
echo 2. 高级下载（自定义参数）
echo 3. 账号登录功能
echo 4. 查看帮助文档
echo 5. 退出
echo.
set /p choice=请选择 [1-5]: 

if "%choice%"=="1" goto quick_download
if "%choice%"=="2" goto advanced_download
if "%choice%"=="3" goto login_menu
if "%choice%"=="4" goto show_help
if "%choice%"=="5" exit /b
goto main_menu

:quick_download
cls
echo.
echo === 快速下载模式 ===
echo 提示：可直接拖放视频链接到本窗口
echo 问题反馈: https://github.com/nilaoda/BBDown/issues
echo.
set /p url=请输入视频URL（输入q返回）:
if /i "%url%"=="q" goto main_menu
if "%url%"=="" (
    echo URL不能为空！
    pause
    goto quick_download
)

echo 正在下载...
BBDown "%url%" -mt --force-http --download-danmaku --cover
goto download_complete

:advanced_download
cls
echo.
echo === 高级下载模式 ===
echo 提示：按步骤设置参数，输入q返回主菜单
echo.

:: URL输入
set /p url=请输入视频URL（必填）:
if /i "%url%"=="q" goto main_menu
if "%url%"=="" (
    echo URL不能为空！
    pause
    goto advanced_download
)

:: 参数选择菜单
:param_menu
cls
echo.
echo === 当前参数设置 ===
echo URL: %url%
echo API模式: %api_mode%
echo 画质: %quality%
echo 编码优先级: %encoding%
echo 弹幕: %danmaku%
echo 封面: %cover%
echo 仅信息: %info%
echo 多线程: %multithread%
echo 保存路径: %save_path%
echo.

echo ===== 参数设置 =====
echo 1. 设置API模式
echo 2. 设置画质和编码
echo 3. 设置下载内容
echo 4. 设置保存路径
echo 5. 开始下载
echo 6. 返回主菜单
echo.
set /p param_choice=请选择 [1-6]:

if "%param_choice%"=="1" goto set_api
if "%param_choice%"=="2" goto set_quality
if "%param_choice%"=="3" goto set_content
if "%param_choice%"=="4" goto set_path
if "%param_choice%"=="5" goto start_advanced_download
if "%param_choice%"=="6" goto main_menu
goto param_menu

:set_api
cls
echo.
echo === API模式设置 ===
echo 1. 默认WEB模式
echo 2. TV模式
echo 3. APP模式
echo 4. 国际版模式
echo.
set /p api_mode=请选择API模式 [1-4]:
if "%api_mode%"=="1" set api_mode=
if "%api_mode%"=="2" set api_mode=--use-tv-api
if "%api_mode%"=="3" set api_mode=--use-app-api
if "%api_mode%"=="4" set api_mode=--use-intl-api
goto param_menu

:set_quality
cls
echo.
echo === 画质设置 ===
echo 1. 自动选择最佳画质
echo 2. 交互式选择画质
echo 3. 自定义画质优先级
echo 4. 自定义编码优先级
echo.
set /p quality_choice=请选择 [1-4]:
if "%quality_choice%"=="1" (
    set quality=
    set encoding=
)
if "%quality_choice%"=="2" (
    set quality=--interactive
    goto param_menu
)
if "%quality_choice%"=="3" (
    echo 示例: "8K 超高清, 1080P 高码率, HDR 真彩, 杜比视界"
    set /p quality=请输入画质优先级:
    set quality=--dfn-priority "%quality%"
    goto param_menu
)
if "%quality_choice%"=="4" (
    echo 示例: "hevc,av1,avc"
    set /p encoding=请输入编码优先级:
    set encoding=--encoding-priority "%encoding%"
)
goto param_menu

:set_content
cls
echo.
echo === 下载内容设置 ===
echo 1. 下载弹幕: %danmaku%
echo 2. 下载封面: %cover%
echo 3. 仅显示信息: %info%
echo 4. 多线程下载: %multithread%
echo.
set /p content_choice=请选择 [1-4]:
if "%content_choice%"=="1" (
    if "%danmaku%"=="--download-danmaku" (
        set danmaku=
    ) else (
        set danmaku=--download-danmaku
    )
)
if "%content_choice%"=="2" (
    if "%cover%"=="--cover" (
        set cover=
    ) else (
        set cover=--cover
    )
)
if "%content_choice%"=="3" (
    if "%info%"=="--only-show-info" (
        set info=
    ) else (
        set info=--only-show-info
    )
)
if "%content_choice%"=="4" (
    if "%multithread%"=="--multi-thread" (
        set multithread=
    ) else (
        set multithread=--multi-thread
    )
)
goto param_menu

:set_path
cls
echo.
echo === 保存路径设置 ===
echo 当前路径: J:\video\Bili Downloads
echo 输入自定义路径（留空使用默认）:
set /p save_path=路径:
if not "%save_path%"=="" set save_path=--work-dir "%save_path%"
goto param_menu

:start_advanced_download
cls
echo.
echo === 下载参数确认 ===
echo 即将使用以下参数下载:
echo URL: %url%
echo API模式: %api_mode%
echo 画质: %quality%
echo 编码: %encoding%
echo 弹幕: %danmaku%
echo 封面: %cover%
echo 仅信息: %info%
echo 多线程: %multithread%
echo 保存路径: %save_path%
echo.
set /p confirm=确认开始下载？[Y/n]:
if /i "%confirm%"=="n" goto param_menu

:: 构建命令
set command=BBDown "%url%" %api_mode% %quality% %encoding% %danmaku% %cover% %info% %multithread% %save_path%

echo 正在下载...
%command%

:download_complete
if %ERRORLEVEL% equ 0 (
    echo [成功] 下载完成！
    echo [%date% %time%] %url% >> download_history.log
) else (
    echo [错误] 下载失败！代码: %ERRORLEVEL%
    echo 请查看: https://github.com/nilaoda/BBDown/issues
)
pause
goto main_menu

:login_menu
cls
echo.
echo === 账号登录 ===
echo 1. WEB账号登录
echo 2. TV账号登录
echo 3. 返回主菜单
echo.
set /p login_choice=请选择 [1-3]:
if "%login_choice%"=="1" (
    BBDown login
    pause
    goto main_menu
)
if "%login_choice%"=="2" (
    BBDown logintv
    pause
    goto main_menu
)
if "%login_choice%"=="3" goto main_menu
goto login_menu

:show_help
cls
BBDown --help
echo.
echo 更多帮助请访问: https://github.com/nilaoda/BBDown/issues
pause
goto main_menu