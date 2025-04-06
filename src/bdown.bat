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
bbdown.exe --help
echo.
pause
goto main_menu