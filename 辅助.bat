@echo off
color a
cd /d %~dp0
set unicode=����������ȷ���ַ�,�ȴ�5�벢�������˵���
set "wait=ping 127.0.0.1 -n 3 >nul"
set MENU=goto main

:main
title ��ӭʹ��AndroidС���ߵĸ���.
echo ѡ��һ����Ը�������������:
echo ��1����ӡ��ǰ���ӵ�adb�豸.
echo ��2����ӡ��ǰ���ӵ�fastboot�豸.
echo ��3���鿴adb��fastboot�汾��.
echo ��4����һ����������ʾ��.
echo ��5��fastboot --^> ϵͳ
echo ��6��ϵͳ --^> Recovery
echo ��7��ϵͳ --^> bootloader
echo ��8��fastboot --^> edl����ͨ��
echo ��9����⵱ǰӦ��
echo ��a����װ����
echo ��b���޸�usb3���µĸ�������

set choice=
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" goto chkadb
if /i "%choice%"=="2" goto chkfb
if /i "%choice%"=="5" fastboot reboot & echo ��������... & goto finish || goto err
if /i "%choice%"=="3" goto version
if /i "%choice%"=="4" goto cmd
if /i "%choice%"=="7" adb reboot recovery & echo ��������... & goto finish || goto err
if /i "%choice%"=="7" adb reboot bootloader & echo ��������... & goto finish || goto err
if /i "%choice%"=="8" fastboot reboot edl & echo ��������... & goto finish || goto err
if /i "%choice%"=="9" goto listen0
if /i "%choice%"=="a" start %~dp0\driver.exe & echo �Ѵ�������װ����! & pause >nul
if /i "%choice%"=="b" call %~dp0\usb3Fix.bat
ECHO.
ECHO. %unicode%
%wait%
ECHO.
%MENU%

::���adb�豸����
:chkadb
echo ����ÿ�������鲢��ӡ�豸�б�.
ping -n 5 127.0.0.1>nul
echo *************
echo %date%,%time%
echo *************
for /f "tokens=1" %%a in ('adb devices^|findstr /r /c:"device$"') do (
    set device_name=%%a
    goto adb_connect_device
)
echo ��ǰδ����adb�����ӵ� Android �豸��
goto chkadb

:adb_connect_device
echo �����ӵ��豸���ƣ�%device_name%
goto chkadb

::���bootloader�豸����
:chkfb
echo ����ÿ�������鲢��ӡ�豸�б�.
ping -n 5 127.0.0.1>nul
echo *************
echo %date%,%time%
echo *************
for /f "tokens=1" %%a in ('fastboot devices^|findstr /r /c:"device$"') do (
    set device_name=%%a
    goto fb_connect_device
)
echo ��ǰδ���������ӵ� Android �豸��
goto chkfb

:fb_connect_device
echo �����ӵ��豸���ƣ�%device_name%
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

:err
color c
echo ***********************************************
echo ��������.
echo �������Ϸ��Ĵ�����ʾ�������������Ҳ��������.
echo ��������������˵�.
pause >nul
%menu%
