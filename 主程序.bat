@echo off
chcp 936
cd /d %~dp0
title ��ӭʹ��AndroidС����V2.
set unicode=����������ȷ���ַ�,�ȴ�5�벢�������˵���
set "wait=ping 127.0.0.1 -n 5 >nul"
set MENU=goto menu
set err=goto err
set partcode=echo **********************************
set deltemp=del /q *.txt
set "choice_end=ECHO. & ECHO. ����������ȷ���ַ�,�ȴ�5�벢�������˵��� & ping 127.0.0.1 -n 5 >nul & ECHO. & %MENU% & cls"
cls

:MENU
%deltemp%
cls
color 3
echo ��ϡ�����.bat������������Ч������.
echo �������û�С��������˵���ѡ��Ļ�,����һ�������ֵ����.
echo ��ֻ����һ���豸,����ģ����!
%partcode%
echo ѡ��һ�������Լ���.
echo ��1���ֻ����÷�����ز���.
echo ��2��adb��ˢ.
echo ��3��Ӧ�ù���.
echo ��4�������.
echo ��5���ֻ���Ϣ�鿴.
echo ��6��Ӧ�ð�װ.
echo ��7����ˢ���򿪿������У�.
echo ��8������adb����.
echo ��9������.
%partcode%
set choice= 
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto Part_Pre
if "%choice%"=="2" goto sideload
if "%choice%"=="3" echo ���Ƚ��豸����adb & call chkdev.bat system & call Ӧ�ù���.bat skipchk
if "%choice%"=="4" goto others
if "%choice%"=="5" goto info
if "%choice%"=="6" goto installapp
if "%choice%"=="7" goto batFlash
if "%choice%"=="8" adb kill-server & adb start-server & echo �������! & %wait% & %menu%
if "%choice%"=="9" goto credit
%choice_end%

::Ӧ�ð�װ
:installapp
echo.
set /p file=����apk��װ��,Ȼ��س�.
echo ��ʼ��װ...
adb install %file% || %err%
echo ���!�������������װ,���롾b������.
set choice= 
set /p choice=������װ�ͻس��ɣ�
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="b" cls & %MENU%
echo.
goto installapp

::ӳ�����
:Part_Pre
cls
echo ѡ��һ��������
echo ��1������ ��2��ˢ�� ��3����ȡ(��rootȨ��)
set choice= 
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" set mode=erase & set mode_name=���� & goto part_process
if "%choice%"=="2" set mode=flash & set mode_name=ˢ�� & goto part_process
if "%choice%"=="3" goto part_output
%choice_end%

:part_process
echo ���Ƚ��豸����fastbootģʽ��.
call chkdev.bat fastboot
echo ����Ҫ%mode_name%�ķ��������س�
set /p partition=
if "%mode%"=="erase" echo ��������ֻ��ġ�%partition%������,ȷ��?
if "%mode%"=="flash" set /p file=����Ҫˢ����ļ����س�: & echo ����ѡ�%file%��ˢ�뵽�ֻ��ġ�%partition%��������,ȷ��?
set file= 
set /p choice=���뵥������ĸ��Y/N�����س��Լ���:
if "%choice%"=="Y" fastboot %mode% %partition% %file% & goto defalut_over|| %err%
if "%choice%"=="N" goto Part_Pre
%choice_end%

:part_output
%deltemp%
call chkdev.bat system
adb shell ls -al /dev/block/bootdevice/by-name > origin.txt
for /f "tokens=8,10 delims= " %%i in (origin.txt) do (
    echo %%i %%j >> after.txt
	echo %%i 
)
set partition=
set /p partition=�����б��Ѵ�ӡ�������������ȡ�ķ���:
findstr %partition% after.txt > target.txt
for /f "tokens=2 delims= " %%i in (target.txt) do (
	%partcode%
	setlocal enabledelayedexpansion
	echo �洢��%%i ·���£�������ȡ...
	adb shell " su -c 'dd if=%%i of=/sdcard/%partition%.img'" || echo ������ȡʧ�ܣ� & %err%
	adb pull /sdcard/%partition%.img %~dp0\output
	endlocal
	%partcode%
)
%deltemp%
start %~dp0\output & echo �Ѵ򿪶�ӦĿ¼!
 echo %partition%������ȡ���,�洢��outputĿ¼��,��������˻����˵�.
pause >nul
%menu%

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

:batFlash
cls
echo ������ˢ���е�bat�ű����س�.
echo һ��ѡ��flash_all������.
echo ע�ⲻҪѡ���С�lock��������batŶ,��������������bootloader!
cd /d "%~dp0"
cmd /k
exit

::�����
:others
echo ѡ��һ�������Լ���.
echo ��1��bootloader���� ��2��ɾ���ֻ��������루��root�� ��3����adbshell 
echo ��4��������֤���������ġ�ά���С�
set choice=
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto bl_unlock
if "%choice%"=="2" goto crack
if "%choice%"=="3" goto adb_shell
if "%choice%"=="4" %menu%
%choice_end%

:bl_unlock
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
adb shell " su -c 'rm /data/system/locksetting.db'" || echo ɾ������ʧ�ܣ� & %err%
echo �����ɹ����!������������ϼ��˵�
pause >nul
goto others

:adb_shell
echo ���ڴ�adbShell...
adb shell || %err%

:info
cls
echo ����ӡ�ֻ���Ϣ,�ù�����Ҫ����CAT����adb��su...
echo �ͺ�:
%partcode%
adb shell getprop ro.product.model || echo ��ӡʧ��!
%partcode%
echo ���״��:
adb shell dumpsys battery || echo ��ӡʧ��!
%partcode%
echo ��Ļ�ֱ���:
adb shell wm size || echo ��ӡʧ��!
%partcode%
echo ��Ļ�ܶ�:
adb shell wm density || echo ��ӡʧ��!
%partcode%
echo ��ʾ������:
adb shell dumpsys window displays || echo ��ӡʧ��!
%partcode%
echo Androidϵͳ�汾:
adb shell getprop ro.build.version.release || echo ��ӡʧ��!
%partcode%
echo CPU��Ϣ:
adb shell cat /proc/cpuinfo || echo ��ӡʧ��!
%partcode%
echo �ڴ���Ϣ:
adb shell cat /proc/meminfo || echo ��ӡʧ��!
%partcode%
echo.
echo ��������������˵�...
pause >nul
%menu%

:credit
cls
echo ��������ѭ AGPL v3 ��ԴЭ��
echo.
echo AndroidС���� V2.0.1  ---BY MilkyWeigh--- 
echo.
echo chkdev.bat ����BFF ---BY ĳ��---
echo Oringal Link : https://gitee.com/mouzei/bff
echo.
echo ��л���ʹ��!
pause >nul
%menu%

:err
color c
echo ***********************************************
echo ��������.
echo �������Ϸ��Ĵ�����ʾ�������������Ҳ��������.
echo ��������������˵�.
pause >nul
%menu%

:defalut_over
echo �����ɹ����,��������������˵�.
pause >nul
%MENU%
