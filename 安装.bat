@echo off
color a
cd /d %~dp0
set unicode=����������ȷ���ַ��������ȴ�3�벢�������˵���
set "wait=ping 127.0.0.1 -n 3 >nul"
set MENU=goto end_pre

title AndroidС����-Steup
echo ****************************
echo ���ڼ���Ƿ�ִ�й��ó���......
echo ****************************
cd %LOCALAPPDATA%\Wangstool || goto Pre
goto end_pre

:Pre
echo ����ȥ����ǰ��û�����й������װ��������ļ���ɾ������Ҫ�����£���װ��������
pause >nul  
ver | find "6.1." && goto 7
goto inst1

:7
bcdedit.exe /set nointegritychecks
goto inst1

:inst1
echo **********
echo ����ִ����
echo **********
mkdir %LOCALAPPDATA%\Wangstool
mkdir %~dp0\output
%wait%
echo �����ж�ϵͳλ��......
if "%PROCESSOR_ARCHITECTURE%"=="x86" goto instx86
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto instx64

:instx86
echo **************
echo ������װ��x86��
echo **************
start %~dp0\drivers\DPInst_x86.exe
start %~dp0\drivers\Qualcomm_HS-USB_Driver.exe
goto inst2

:instx64
echo **************
echo ������װ��x64��
echo **************
start %~dp0\drivers\DPInst_x64.exe
start %~dp0\drivers\Qualcomm_HS-USB_Driver.exe
goto inst2

:inst2
echo ���ڽ�ִ��������װ����һֱ����һ������.
%wait%
%wait%
%wait%
%wait%
%wait%
echo.
echo ����ɣ�2/2����
echo ��ɰ�װ��
goto end_pre

:end_pre
cls
echo ������ɰ�װ����ϲ�� 

title ��ɣ�����ʹ�á�������.bat����!

echo ѡ��һ����Ը�������������:

echo ��1�����adb�豸����״̬.

echo ��2�����fastboot�豸����״̬.

echo ��3��fastboot ������ ϵͳ .

echo ��4���鿴adb��fastboot�汾��.

echo ��5����һ����������ʾ��.

echo ��6��ϵͳ ������ Recovery

echo ��7��ϵͳ ������ fastboot

echo ��8��fastboot ������ edl����ͨ��

echo ��9����⵱ǰӦ��

set choice=
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" goto chkadb
if /i "%choice%"=="2" goto chkfb
if /i "%choice%"=="3" fastboot reboot & echo ��������... & goto finish || echo ����������ο������ĵ�
if /i "%choice%"=="4" goto version
if /i "%choice%"=="5" goto cmd
if /i "%choice%"=="7" adb reboot recovery & echo ��������... & goto finish || echo ����������ο������ĵ�
if /i "%choice%"=="7" adb reboot fastboot & echo ��������... & goto finish || echo ����������ο������ĵ�
if /i "%choice%"=="8" fastboot reboot edl & echo ��������... & goto finish || echo ����������ο������ĵ�
if /i "%choice%"=="9" goto listen0
ECHO.
ECHO. %unicode%
%wait%
ECHO.
%MENU%

rem *********************����һ�������**************************


:chkadb
echo ����ÿ�������鲢��ӡ�豸�б�.
start %~dp0\inst.bat
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

rem *********************����һ�������**************************

:chkfb
echo ����ÿ�������鲢��ӡ�豸�б�.
start %~dp0\inst.bat
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

rem *********************����һ�������**************************

:recc
fastboot reboot Recovery || echo ����ʱ����! && goto err
goto finish
pause

:version
echo adb�汾:
adb version
echo fastboot�汾:
fastboot getver:version
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