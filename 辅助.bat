@echo off
color a
cd /d %~dp0\bin
set "wait=ping 127.0.0.1 -n 3 >nul"
set MENU=goto main
set partcode=echo **********************************
set "choice_end=ECHO. & ECHO. ����������ȷ���ַ�,�ȴ�5�벢�������˵��� & ping 127.0.0.1 -n 5 >nul & ECHO. & %MENU% & cls"
mode con cols=60 lines=30

:main
title ��ӭʹ��AndroidС���ߵĸ���.
echo ѡ��һ����Ը�������������:
%partcode%
echo.
echo ��1����ӡ��ǰ���ӵ�adb�豸.
echo.
echo ��2����ӡ��ǰ���ӵ�fastboot�豸.
echo.
echo ��3���鿴����sdk�汾��.
echo.
echo ��4����һ����������ʾ��.
echo.
echo ��5��fastboot --^> ϵͳ
echo.
echo ��6��ϵͳ --^> Recovery
echo.
echo ��7��ϵͳ --^> bootloader
echo.
echo ��8��fastboot --^> edl����ͨ��
echo.
echo ��9����⵱ǰӦ��
echo.
echo ��a����װ����
echo.
echo ��b���޸�usb3���µĸ�������
echo.
echo ��c����������豸
echo.
%partcode%
set choice=
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" echo ����ÿ�������鲢��ӡ�豸�б�. & goto chkadb
if /i "%choice%"=="2" goto chkfb
if /i "%choice%"=="5" fastboot reboot & echo ��������... & goto finish || goto err
if /i "%choice%"=="3" goto version
if /i "%choice%"=="4" goto cmd
if /i "%choice%"=="6" adb reboot recovery & echo ��������... & goto finish || goto err
if /i "%choice%"=="7" adb reboot bootloader & echo ��������... & goto finish || goto err
if /i "%choice%"=="8" fastboot reboot edl & echo ��������... & goto finish || goto err
if /i "%choice%"=="9" goto listen0
if /i "%choice%"=="a" start .\driver.exe & echo �Ѵ�������װ����! & pause >nul
if /i "%choice%"=="b" call %~dp0\usb3Fix.bat
if /i "%choice%"=="c" goto wireless_connect
ECHO.
ECHO. %unicode%
%wait%
ECHO.
%MENU%

::���adb�豸����
:chkadb
ping -n 5 127.0.0.1>nul
echo.
%partcode%
echo %date%,%time%
%partcode%
for /f "tokens=1" %%a in ('adb devices^|findstr /r /c:"device$"') do (
    set device_name=%%a
    goto adb_connect_device
)
echo ��ǰδ����adb�����ӵ� Android �豸��
echo.
goto chkadb

:adb_connect_device
echo �����ӵ��豸��%device_name%
goto chkadb

::���bootloader�豸����
:chkfb
echo ����ÿ�������鲢��ӡ�豸�б�.
ping -n 5 127.0.0.1>nul
%partcode%
echo %date%,%time%
%partcode%
for /f "tokens=1" %%a in ('fastboot devices^|findstr /r /c:"device$"') do (
    set device_name=%%a
    goto fb_connect_device
)
echo ��ǰδ���������ӵ� Android �豸��
goto chkfb

:fb_connect_device
echo �����ӵ��豸��%device_name%
goto chkfb


:recc
fastboot reboot Recovery || echo ����ʱ����! && goto err
goto finish
pause

:version
echo adb�汾:
adb version
echo fastboot�汾���adb����
pause
goto finish

:finish
echo ���.������������ϼ��˵�.
pause >nul
goto end_pre

:cmd
start cmd /k echo ���!
goto end_pre

:listen0
cls
echo ����ÿ�������鲢��ӡ��ǰӦ��
goto listen

:listen
%wait%
setlocal enabledelayedexpansion
for /f "tokens=3 delims= " %%a in ('adb shell dumpsys window ^| findstr mCurrentFocus') do (
    set "packageName=%%a"
)

for /f "tokens=1 delims=/" %%b in ("%packageName%") do (
    set "packageName=%%b"
)
if %packageName%==NotificationShade} (echo ��ǰ��������״̬! && endlocal && goto listen)
if %packageName%== (echo ���������л�Ӧ�� && endlocal && goto listen)
echo %packageName%
endlocal
goto listen

:wireless_connect
cls
setlocal enabledelayedexpansion
echo.
echo ��ѡ��:
echo.
echo ��1�����
echo.
echo ��2������
set choice=
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" (
    set /p ip=������ip�ż��˿ں�: 
    set /p code=�����������:
    echo �����ԡ�!code!��Ϊ��Կ�롾!ip!�����, �����������.
    pause >nul
    adb pair !ip! !code! || (
        echo ���ʧ��
        goto wireless_connect
    )
    echo ������.
    pause
    endlocal
)

if /i "%choice%"=="2" (
    set /p ip=������ip�ż��˿ں�: 
    echo �����롾!ip!������, �����������.
    pause >nul
    adb connect !ip! || (
        echo ����ʧ��
        goto wireless_connect
    )
    echo ���ӳɹ�
    pause
    endlocal
    goto main
)
goto main

:err
color c
%partcode%
echo ��������.
echo �������Ϸ��Ĵ�����ʾ�������������Ҳ��������.
echo ��������������˵�.
pause >nul
%menu%
