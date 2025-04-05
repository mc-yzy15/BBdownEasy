@echo off
setlocal enabledelayedexpansion

:: �Զ���鲢����Ŀ¼
if not exist "J:\video\Bili Downloads" (
    mkdir "J:\video\Bili Downloads" || (
        echo �޷�����Ŀ¼ J:\video\Bili Downloads
        pause
        exit /b 1
    )
)

cd /d "J:\video\Bili Downloads"

:: �򻯻������
where BBDown >nul 2>&1 || (
    echo ����: δ�ҵ�BBDown
    echo ��ȷ��BBDown.exeλ��PATH��ǰĿ¼
    pause
    exit /b 1
)

:: ֱ�ӽ������˵�
:main_menu
cls
echo.
echo ===== BBDown ������ v1.6.3 =====
echo 1. �������أ�Ĭ�ϲ�����
echo 2. �߼����أ��Զ��������
echo 3. �˺ŵ�¼����
echo 4. �鿴�����ĵ�
echo 5. �˳�
echo.
set /p choice=��ѡ�� [1-5]: 

if "%choice%"=="1" goto quick_download
if "%choice%"=="2" goto advanced_download
if "%choice%"=="3" goto login_menu
if "%choice%"=="4" goto show_help
if "%choice%"=="5" exit /b
goto main_menu

:quick_download
cls
echo.
echo === ��������ģʽ ===
echo ��ʾ����ֱ���Ϸ���Ƶ���ӵ�������
echo.
set /p url=��������ƵURL������q���أ�:
if /i "%url%"=="q" goto main_menu
if "%url%"=="" (
    echo URL����Ϊ�գ�
    pause
    goto quick_download
)

echo ��������...
BBDown "%url%"
goto download_complete

:advanced_download
cls
echo.
echo === �߼�����ģʽ ===
echo ��ʾ�����������ò���������q�������˵�
echo.

:: URL����
set /p url=��������ƵURL�����:
if /i "%url%"=="q" goto main_menu
if "%url%"=="" (
    echo URL����Ϊ�գ�
    pause
    goto advanced_download
)

:: ����ѡ��˵�
:param_menu
cls
echo.
echo === ��ǰ�������� ===
echo URL: %url%
echo APIģʽ: %api_mode%
echo ����: %quality%
echo �������ȼ�: %encoding%
echo ��Ļ: %danmaku%
echo ����: %cover%
echo ����Ϣ: %info%
echo ���߳�: %multithread%
echo ����·��: %save_path%
echo.

echo ===== �������� =====
echo 1. ����APIģʽ
echo 2. ���û��ʺͱ���
echo 3. ������������
echo 4. ���ñ���·��
echo 5. ��ʼ����
echo 6. �������˵�
echo.
set /p param_choice=��ѡ�� [1-6]:

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
echo === APIģʽ���� ===
echo 1. Ĭ��WEBģʽ
echo 2. TVģʽ
echo 3. APPģʽ
echo 4. ���ʰ�ģʽ
echo.
set /p api_mode=��ѡ��APIģʽ [1-4]:
if "%api_mode%"=="1" set api_mode=
if "%api_mode%"=="2" set api_mode=--use-tv-api
if "%api_mode%"=="3" set api_mode=--use-app-api
if "%api_mode%"=="4" set api_mode=--use-intl-api
goto param_menu

:set_quality
cls
echo.
echo === �������� ===
echo 1. �Զ�ѡ����ѻ���
echo 2. ������ʱ����ʽѡ����
echo.
set /p quality_choice=��ѡ�� [1-2]:
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
echo === ������������ ===
echo 1. ���ص�Ļ: %danmaku%
echo 2. ���ط���: %cover%
echo 3. ����ʾ��Ϣ: %info%
echo 4. ���߳�����: %multithread%
echo.
set /p content_choice=��ѡ�� [1-4]:
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
echo === ����·������ ===
echo ��ǰ·��: J:\video\Bili Downloads
echo �����Զ���·��������ʹ��Ĭ�ϣ�:
set /p save_path=·��:
if not "%save_path%"=="" set save_path=--work-dir "%save_path%"
goto param_menu

:start_advanced_download
cls
echo.
echo === ���ز���ȷ�� ===
echo ����ʹ�����²�������:
echo URL: %url%
echo APIģʽ: %api_mode%
echo ����: %quality%
echo ����: %encoding%
echo ��Ļ: %danmaku%
echo ����: %cover%
echo ����Ϣ: %info%
echo ���߳�: %multithread%
echo ����·��: %save_path%
echo.
set /p confirm=ȷ�Ͽ�ʼ���أ�[Y/n]:
if /i "%confirm%"=="n" goto param_menu

:: ��������
set command=BBDown "%url%" %api_mode% %quality% %encoding% %danmaku% %cover% %info% %multithread% %save_path%

echo ��������...
%command%

:download_complete
if %ERRORLEVEL% equ 0 (
    echo [�ɹ�] ������ɣ�
    echo [%date% %time%] %url% >> download_history.log
) else (
    echo [����] ����ʧ�ܣ�����: %ERRORLEVEL%
)
pause
goto main_menu

:login_menu
cls
echo.
echo === �˺ŵ�¼ ===
echo 1. WEB�˺ŵ�¼
echo 2. TV�˺ŵ�¼
echo 3. �������˵�
echo.
set /p login_choice=��ѡ���¼��ʽ [1-3]: 

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
echo === BBDown �����ĵ� ===
echo �汾: 1.6.3
echo Bilibili ����/��������
echo.
echo �������������Ȳ���:
echo https://github.com/nilaoda/BBDown/issues
echo.
echo �����÷�:
echo   bbdown.exe <��ƵURL> [ѡ��]
echo.
echo ����ѡ��:
echo   -tv       ʹ��TV�˽���ģʽ
echo   -app      ʹ��APP�˽���ģʽ
echo   -intl     ʹ�ù��ʰ����ģʽ
echo   -mt       ���߳�����(Ĭ�Ͽ���)
echo   -dd       ���ص�Ļ
echo   -info     ������������
echo   -aria2    ʹ��aria2c����
echo   -F        �Զ����ļ�����ʽ
echo.
echo ����ѡ�
echo BBDown version 1.6.3, Bilibili Downloader.
echo �������������ȵ����µ�ַ�������������Ϣ��
echo https://github.com/nilaoda/BBDown/issues
echo.
echo Description:
echo BBDown��һ������ұ�ݸ�Ч��������������/�������.
echo.
echo Usage:
echo  bbdown <url> [command] [options]
echo.
echo Arguments:
echo  <url>  ��Ƶ��ַ �� av|bv|BV|ep|ss
echo.
echo Options:
echo  -tv, --use-tv-api                              ʹ��TV�˽���ģʽ
echo  -app, --use-app-api                            ʹ��APP�˽���ģʽ
echo  -intl, --use-intl-api                          ʹ�ù��ʰ�(��������Ƶ)����ģʽ
echo  --use-mp4box                                   ʹ��MP4Box������
echo  -e, --encoding-priority <encoding-priority>    ��Ƶ�����ѡ�����ȼ�, �ö��ŷָ� ��: "hevc,av1,avc"
echo  -q, --dfn-priority <dfn-priority>              �������ȼ�,�ö��ŷָ� ��: "8K ������, 1080P ������, HDR ���, �ű��ӽ�"
echo  -info, --only-show-info                        ������������������
echo  --show-all                                     չʾ���з�P����
echo  -aria2, --use-aria2c                           ����aria2c��������(����Ҫ����׼���ö����ƿ�ִ���ļ�)
echo  -ia, --interactive                             ����ʽѡ��������
echo  -hs, --hide-streams                            ��Ҫ��ʾ���п�������Ƶ��
echo  -mt, --multi-thread                            ʹ�ö��߳�����(Ĭ�Ͽ���)
echo  --video-only                                   ��������Ƶ
echo  --audio-only                                   ��������Ƶ
echo  --danmaku-only                                 �����ص�Ļ
echo  --sub-only                                     ��������Ļ
echo  --cover-only                                   �����ط���
echo  --debug                                        ���������־
echo  --skip-mux                                     ������������
echo  --skip-subtitle                                ������Ļ����
echo  --skip-cover                                   ������������
echo  --force-http                                   ��������Ƶʱǿ��ʹ��HTTPЭ���滻HTTPS(Ĭ�Ͽ���)
echo  -dd, --download-danmaku                        ���ص�Ļ
echo  --skip-ai                                      ����AI��Ļ����(Ĭ�Ͽ���)
echo  --video-ascending                              ��Ƶ����(��С�������)
echo  --audio-ascending                              ��Ƶ����(��С�������)
echo  --allow-pcdn                                   ���滻PCDN����, �������������--upos-host���޷�����ʱʹ��
echo  -F, --file-pattern <file-pattern>              ʹ�����ñ����Զ��嵥P�洢�ļ���:
echo.
echo                                                 <videoTitle>: ��Ƶ������
echo                                                 <pageNumber>: ��Ƶ��P���
echo                                                 <pageNumberWithZero>: ��Ƶ��P���(ǰ׺����)
echo                                                 <pageTitle>: ��Ƶ��P����
echo                                                 <bvid>: ��ƵBV��
echo                                                 <aid>: ��Ƶaid
echo                                                 <cid>: ��Ƶcid
echo                                                 <dfn>: ��Ƶ������
echo                                                 <res>: ��Ƶ�ֱ���
echo                                                 <fps>: ��Ƶ֡��
echo                                                 <videoCodecs>: ��Ƶ����
echo                                                 <videoBandwidth>: ��Ƶ����
echo                                                 <audioCodecs>: ��Ƶ����
echo                                                 <audioBandwidth>: ��Ƶ����
echo                                                 <ownerName>: �ϴ�������
echo                                                 <ownerMid>: �ϴ���mid
echo                                                 <publishDate>: �ղؼ�/����/�ϼ�����ʱ��
echo                                                 <videoDate>: ��Ƶ����ʱ��(��p��Ƶ����ʱ����<publishDate>��ͬ)
echo                                                 <apiType>: API����(TV/APP/INTL/WEB)
echo.
echo                                                 Ĭ��Ϊ: <videoTitle>
echo  -M, --multi-file-pattern <multi-file-pattern>  ʹ�����ñ����Զ����P�洢�ļ���:
echo.
echo                                                 Ĭ��Ϊ: <videoTitle>/[P<pageNumberWithZero>]<pageTitle>
echo  -p, --select-page <select-page>                ѡ��ָ����p���p��Χ: (-p 8 �� -p 1,2 �� -p 3-5 �� -p ALL �� -p LAST �� -p
echo                                                 3,5,LATEST)
echo  --language <language>                          ���û�������Ƶ����(����), ��chi, jpn��
echo  -ua, --user-agent <user-agent>                 ָ��user-agent, ����ʹ�����user-agent
echo  -c, --cookie <cookie>                          �����ַ���cookie����������ҳ�ӿڵĻ�Ա����
echo  -token, --access-token <access-token>          ����access_token��������TV/APP�ӿڵĻ�Ա����
echo  --aria2c-args <aria2c-args>                    ����aria2c�ĸ��Ӳ���(Ĭ�ϲ�������"-x16 -s16 -j16 -k 5M", ʹ��ʱע���ַ���ת��)
echo  --work-dir <work-dir>                          ���ó���Ĺ���Ŀ¼
echo  --ffmpeg-path <ffmpeg-path>                    ����ffmpeg��·��
echo  --mp4box-path <mp4box-path>                    ����mp4box��·��
echo  --aria2c-path <aria2c-path>                    ����aria2c��·��
echo  --upos-host <upos-host>                        �Զ���upos������
echo  --force-replace-host                           ǿ���滻���ط�����host(Ĭ�Ͽ���)
echo  --save-archives-to-file                        �����ع�����Ƶ��¼�������ļ���, ���ں�����������ͬ����Ƶ
echo  --delay-per-page <delay-per-page>              �������غϼ���P֮������ؼ��ʱ��(��λ: ��, Ĭ���޼��)
echo  --host <host>                                  ָ��BiliPlus host(ʹ��BiliPlus��Ҫaccess_token, ����Ҫcookie,
echo                                                 �����������ܹ���ȡ���˺ŵĴ󲿷�Ȩ��!)
echo  --ep-host <ep-host>                            ָ��BiliPlus EP host(���ڴ���api.bilibili.com/pgc/view/web/season,
echo                                                 �󲿷ֽ�����������֧�ִ���ýӿ�)
echo  --area <area>                                  (hk|tw|th) ʹ��BiliPlusʱ��ѡ, ָ��BiliPlus area
echo  --config-file <config-file>                    ��ȡָ����BBDown���������ļ�(Ĭ��Ϊ: BBDown.config)
echo  --version                                      Show version information
echo  -?, -h, --help                                 Show help and usage information
echo.
echo Commands:
echo  login    ͨ��APPɨ���ά���Ե�¼����WEB�˺�
echo  logintv  ͨ��APPɨ���ά���Ե�¼����TV�˺�
echo  serve    �Է�����ģʽ����
echo.
pause
goto main_menu