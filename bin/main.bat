call public.bat head

:MENU
title ��ӭʹ��AndroidС����V2.
%deltemp%
cls
color b
echo �������û�С��������˵���ѡ��Ļ�,����һ�������ֵ����.
echo ��ֻ����һ���豸,����ģ����!
echo.
echo ѡ��һ�������Լ���.
echo.
echo ��0����������豸
echo.
echo ��1��������
echo.
echo ��2��������
echo.
echo ��3��Ӧ�ù���
echo.
echo ��4�������
echo.
echo ��5����װ����
echo.
echo ��6�������˵�
echo.
echo ��7���򿪿�������
echo.
echo ��8������adb����
echo.
echo ��9������
echo.
set choice= 
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="0" goto wireless_connect
if "%choice%"=="1" start image.bat & %menu%
if "%choice%"=="2" start monitor.bat & %menu%
if "%choice%"=="3" start app.bat & %menu%
if "%choice%"=="4" goto others
if "%choice%"=="5" start https://www.123pan.com/s/on0rVv-zhhV.html & echo �Ѵ���ҳ�����������ذ�װ! & pause >nul & %menu%
if "%choice%"=="6" goto reboot_menu
if "%choice%"=="7" (
    cls
    echo ���
    cd /d "%~dp0"
    cmd /k
    %MENU%
)
if "%choice%"=="8" adb kill-server & adb start-server & echo �������! & %wait% & %menu%
if "%choice%"=="9" goto about
%choice_end%

:wireless_connect
cls
setlocal enabledelayedexpansion
echo.
echo ��ѡ��:
echo.
echo ��1�����
echo.
echo ��2������
echo.
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
    goto menu
)
goto menu

::ˢ��
:sideload
echo ���Ƚ��豸����Recoveryģʽ��,���ҿ�����adb��ˢ/sideload��ģʽ.
echo ��ͬRecovery�з����ܲ�ͬ,������ڡ��߼���ѡ����,����ȥ����.
call chkdev.bat sideload
set /p file=����Ҫˢ����ļ����س�:
echo �������ˢ��.
pause >nul
adb sideload %file% || %err%
echo �����ɹ����,�����ʽ��data��ȷ���ɾ�ˢ��
echo ��������������˵�.
pause >nul
%MENU%

::�����
:others
%partcode%
echo ѡ��һ�������Լ���.
echo.
echo ��1��bootloader���� 
echo.
echo ��2��ɾ���ֻ��������루��root�� 
echo.
echo ��3����adbshell 
echo.
echo ��4��������֤����������
echo.
echo ��5���޸�usb3���µĸ�������
echo.
echo.
set choice=
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto bl_unlock
if "%choice%"=="2" goto crack
if "%choice%"=="3" (
    echo ���ڴ�adbShell...
    call chkdev.bat system
    adb shell || %err%
)
if "%choice%"=="4" goto Internet_verify_change
if "%choice%"=="5" (
    call %~dp0\usb3Fix.bat
    goto others
)
%choice_end%

:bl_unlock
call chkdev.bat fastboot
fastboot getvar all >> %oem_Info%
if findstr "unlocked:yes" %oem_Info%(
	echo �豸�ѽ�������������������˵�
	pause >nul
	%menu%
)
echo ȷ���ڲ��ֻ������ѿ���OEM��������.
set /p key=���������(������):
echo ��ʼ����...
if "%key%"==" " fastboot flashing unlock
fastboot oem unlock %key% || %err%
echo �����ɹ����!������������ϼ����˵�
pause >nul
goto others

:crack
echo �ó���ͨ��ɾ��/data/system/locksetting.db��ʵ��.
echo �����������ִ��.
pause >nul
call chkdev.bat system
adb shell " su -c 'rm /data/system/locksetting.db'" || echo ɾ������ʧ�ܣ� && %err%
echo �����ɹ����!������������ϼ��˵�
pause >nul
goto others

:Internet_verify_change
pause
call chkdev.bat system
adb shell settings put global captive_portal_http_url http://developers.google.cn/generate_204
adb shell settings put global captive_portal_https_url https://developers.google.cn/generate_204
adb shell settings put global ntp_server time.asia.apple.com
echo �������.��������������˵�
pause >nul
%menu%

:about
cls
echo adb�����Ϣ---
adb version
%partcode%
echo ��������ѭ AGPL v3 ��ԴЭ��,�������������Ⱥ�
echo.
echo chkdev.bat ����BFF ---BY ĳ��---
echo Oringal Link : https://gitee.com/mouzei/bff
echo.
echo.payload-dumper-go.exe ---BY ssut---
echo.Oringal Link : https://github.com/ssut/payload-dumper-go
echo.
echo brotli 
echo Oringal Link : https://github.com/google/brotli
echo.
echo ImgExtractor version 1.3.6 
echo <Created by And_PDA (Based on sources ext4_unpacker)>
echo.
echo sdat2img.py
echo AUTHORS: xpirt - luxi78 - howellzhu
echo Oringal Link : https://github.com/xpirt/sdat2img
echo.
echo AndroidС���� V2.1.0  ---BY MilkyWeigh--- 
echo.
echo ��л���ʹ��!
pause >nul
%menu%

