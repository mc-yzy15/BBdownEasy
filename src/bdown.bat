@echo off
setlocal enabledelayedexpansion

:: 自动检查并创建目录
if not exist "J:\video\Bili Downloads" (
    mkdir "J:\video\Bili Downloads" || (
        echo 无法创建目录 J:\video\Bili Downloads
        pause
        exit /b 1
    )
)

cd /d "J:\video\Bili Downloads"

:: 简化环境检查
where BBDown >nul 2>&1 || (
    echo 错误: 未找到BBDown
    echo 请确保BBDown.exe位于PATH或当前目录
    pause
    exit /b 1
)

:: 直接进入主菜单
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
echo.
set /p url=请输入视频URL（输入q返回）:
if /i "%url%"=="q" goto main_menu
if "%url%"=="" (
    echo URL不能为空！
    pause
    goto quick_download
)

echo 正在下载...
BBDown "%url%"
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
echo 2. 在下载时交互式选择画质
echo.
set /p quality_choice=请选择 [1-2]:
if "%quality_choice%"=="1" (
    set quality=
    set encoding=
)
if "%quality_choice%"=="2" (
    set quality=--interactive
    goto param_menu
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
set /p login_choice=请选择登录方式 [1-3]: 

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
echo.
echo === BBDown 帮助文档 ===
echo 版本: 1.6.3
echo Bilibili 下载/解析工具
echo.
echo 遇到问题请首先查阅:
echo https://github.com/nilaoda/BBDown/issues
echo.
echo 基本用法:
echo   bbdown.exe <视频URL> [选项]
echo.
echo 常用选项:
echo   -tv       使用TV端解析模式
echo   -app      使用APP端解析模式
echo   -intl     使用国际版解析模式
echo   -mt       多线程下载(默认开启)
echo   -dd       下载弹幕
echo   -info     仅解析不下载
echo   -aria2    使用aria2c下载
echo   -F        自定义文件名格式
echo.
echo 所有选项：
echo BBDown version 1.6.3, Bilibili Downloader.
echo 遇到问题请首先到以下地址查阅有无相关信息：
echo https://github.com/nilaoda/BBDown/issues
echo.
bbdown.exe --help
echo.
pause
goto main_menu