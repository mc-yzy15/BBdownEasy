@echo off
setlocal enabledelayedexpansion

:: ��ʼ������
title BBDown ���װ� - ���Զ���װ����
if not exist "C:\BiliDownloads" mkdir "C:\BiliDownloads"
cd /d "C:\BiliDownloads"

:: �Զ���װ����
:auto_install
where BBDown >nul 2>&1
if %ERRORLEVEL% equ 0 goto check_update

echo.
echo ��⵽δ��װBBDown�����ڳ����Զ���װ...
echo.

:: ����Ƿ����ԱȨ��
net session >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ��Ҫ����ԱȨ�޽����Զ���װ
    echo ���Ҽ�ѡ��"�Թ���Ա�������"
    pause
    exit /b 1
)

:: ��װChocolatey
echo ���ڰ�װChocolatey��������...
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" || (
    echo Chocolatey��װʧ��
    goto manual_install
)

:: ��װBBDown
echo ���ڰ�װBBDown...
choco install bbdown -y || (
    echo BBDown��װʧ��
    goto manual_install
)

:: ��װFFmpeg
echo ���ڰ�װFFmpeg...
choco install ffmpeg -y

:check_update
echo ���ڼ�����...
for /f "tokens=*" %%i in ('BBDown --version') do set current_ver=%%i
for /f "tokens=*" %%i in ('curl -s https://api.github.com/repos/nilaoda/BBDown/releases/latest ^| findstr "tag_name"') do (
    set latest_ver=%%i
    set latest_ver=!latest_ver:*tag_name: =!
    set latest_ver=!latest_ver:~1,-2!
)

if not "!current_ver!"=="!latest_ver!" (
    echo �����°汾: !latest_ver!
    echo ���ڸ���...
    choco upgrade bbdown -y || (
        echo �Զ�����ʧ��
        goto manual_update
    )
)

:: ��¼��־
echo [%date% %time%] !cmd! >> bdown.log
exit /b 0

:manual_install
echo.
echo �Զ���װʧ�ܣ����ֶ���װ:
echo 1. ����BBDown: https://github.com/nilaoda/BBDown/releases
echo 2. ��ѹ��BBDown.exe����PATHĿ¼
echo 3. ����뱾������ͬĿ¼
pause
exit /b 1

:manual_update
echo.
echo �Զ�����ʧ�ܣ����ֶ�����:
echo https://github.com/nilaoda/BBDown/releases
pause
goto :eof
