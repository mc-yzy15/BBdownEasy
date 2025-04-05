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
echo Description:
echo BBDown是一个免费且便捷高效的哔哩哔哩下载/解析软件.
echo.
echo Usage:
echo  bbdown <url> [command] [options]
echo.
echo Arguments:
echo  <url>  视频地址 或 av|bv|BV|ep|ss
echo.
echo Options:
echo  -tv, --use-tv-api                              使用TV端解析模式
echo  -app, --use-app-api                            使用APP端解析模式
echo  -intl, --use-intl-api                          使用国际版(东南亚视频)解析模式
echo  --use-mp4box                                   使用MP4Box来混流
echo  -e, --encoding-priority <encoding-priority>    视频编码的选择优先级, 用逗号分割 例: "hevc,av1,avc"
echo  -q, --dfn-priority <dfn-priority>              画质优先级,用逗号分隔 例: "8K 超高清, 1080P 高码率, HDR 真彩, 杜比视界"
echo  -info, --only-show-info                        仅解析而不进行下载
echo  --show-all                                     展示所有分P标题
echo  -aria2, --use-aria2c                           调用aria2c进行下载(你需要自行准备好二进制可执行文件)
echo  -ia, --interactive                             交互式选择清晰度
echo  -hs, --hide-streams                            不要显示所有可用音视频流
echo  -mt, --multi-thread                            使用多线程下载(默认开启)
echo  --video-only                                   仅下载视频
echo  --audio-only                                   仅下载音频
echo  --danmaku-only                                 仅下载弹幕
echo  --sub-only                                     仅下载字幕
echo  --cover-only                                   仅下载封面
echo  --debug                                        输出调试日志
echo  --skip-mux                                     跳过混流步骤
echo  --skip-subtitle                                跳过字幕下载
echo  --skip-cover                                   跳过封面下载
echo  --force-http                                   下载音视频时强制使用HTTP协议替换HTTPS(默认开启)
echo  -dd, --download-danmaku                        下载弹幕
echo  --skip-ai                                      跳过AI字幕下载(默认开启)
echo  --video-ascending                              视频升序(最小体积优先)
echo  --audio-ascending                              音频升序(最小体积优先)
echo  --allow-pcdn                                   不替换PCDN域名, 仅在正常情况与--upos-host均无法下载时使用
echo  -F, --file-pattern <file-pattern>              使用内置变量自定义单P存储文件名:
echo.
echo                                                 <videoTitle>: 视频主标题
echo                                                 <pageNumber>: 视频分P序号
echo                                                 <pageNumberWithZero>: 视频分P序号(前缀补零)
echo                                                 <pageTitle>: 视频分P标题
echo                                                 <bvid>: 视频BV号
echo                                                 <aid>: 视频aid
echo                                                 <cid>: 视频cid
echo                                                 <dfn>: 视频清晰度
echo                                                 <res>: 视频分辨率
echo                                                 <fps>: 视频帧率
echo                                                 <videoCodecs>: 视频编码
echo                                                 <videoBandwidth>: 视频码率
echo                                                 <audioCodecs>: 音频编码
echo                                                 <audioBandwidth>: 音频码率
echo                                                 <ownerName>: 上传者名称
echo                                                 <ownerMid>: 上传者mid
echo                                                 <publishDate>: 收藏夹/番剧/合集发布时间
echo                                                 <videoDate>: 视频发布时间(分p视频发布时间与<publishDate>相同)
echo                                                 <apiType>: API类型(TV/APP/INTL/WEB)
echo.
echo                                                 默认为: <videoTitle>
echo  -M, --multi-file-pattern <multi-file-pattern>  使用内置变量自定义多P存储文件名:
echo.
echo                                                 默认为: <videoTitle>/[P<pageNumberWithZero>]<pageTitle>
echo  -p, --select-page <select-page>                选择指定分p或分p范围: (-p 8 或 -p 1,2 或 -p 3-5 或 -p ALL 或 -p LAST 或 -p
echo                                                 3,5,LATEST)
echo  --language <language>                          设置混流的音频语言(代码), 如chi, jpn等
echo  -ua, --user-agent <user-agent>                 指定user-agent, 否则使用随机user-agent
echo  -c, --cookie <cookie>                          设置字符串cookie用以下载网页接口的会员内容
echo  -token, --access-token <access-token>          设置access_token用以下载TV/APP接口的会员内容
echo  --aria2c-args <aria2c-args>                    调用aria2c的附加参数(默认参数包含"-x16 -s16 -j16 -k 5M", 使用时注意字符串转义)
echo  --work-dir <work-dir>                          设置程序的工作目录
echo  --ffmpeg-path <ffmpeg-path>                    设置ffmpeg的路径
echo  --mp4box-path <mp4box-path>                    设置mp4box的路径
echo  --aria2c-path <aria2c-path>                    设置aria2c的路径
echo  --upos-host <upos-host>                        自定义upos服务器
echo  --force-replace-host                           强制替换下载服务器host(默认开启)
echo  --save-archives-to-file                        将下载过的视频记录到本地文件中, 用于后续跳过下载同个视频
echo  --delay-per-page <delay-per-page>              设置下载合集分P之间的下载间隔时间(单位: 秒, 默认无间隔)
echo  --host <host>                                  指定BiliPlus host(使用BiliPlus需要access_token, 不需要cookie,
echo                                                 解析服务器能够获取你账号的大部分权限!)
echo  --ep-host <ep-host>                            指定BiliPlus EP host(用于代理api.bilibili.com/pgc/view/web/season,
echo                                                 大部分解析服务器不支持代理该接口)
echo  --area <area>                                  (hk|tw|th) 使用BiliPlus时必选, 指定BiliPlus area
echo  --config-file <config-file>                    读取指定的BBDown本地配置文件(默认为: BBDown.config)
echo  --version                                      Show version information
echo  -?, -h, --help                                 Show help and usage information
echo.
echo Commands:
echo  login    通过APP扫描二维码以登录您的WEB账号
echo  logintv  通过APP扫描二维码以登录您的TV账号
echo  serve    以服务器模式运行
echo.
pause
goto main_menu