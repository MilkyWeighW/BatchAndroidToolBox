call public.bat head

:menu
cls
color a
title ��ӭʹ��AndroidС���ߵĸ���.
echo ѡ��һ����Ը�������������:
%partcode%
echo.
echo ��1����⵱ǰ���ӵ�adb�豸.
echo.
echo ��2����⵱ǰ���ӵ�fastboot�豸.
echo.
echo ��3����⵱ǰӦ��
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
echo ��9���鿴����sdk�汾��.
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
if /i "%choice%"=="2" echo ����ÿ�������鲢��ӡ�豸�б�. & goto chkfb
if /i "%choice%"=="3" cls & echo ����ÿ��5���鲢��ӡ��ǰӦ�� & goto listen
if /i "%choice%"=="4" echo ���! & start cmd /k 
if /i "%choice%"=="5" fastboot reboot & echo ��������... & goto finish || %err%
if /i "%choice%"=="6" adb reboot recovery & echo ��������... & goto finish || %err%
if /i "%choice%"=="7" adb reboot bootloader & echo ��������... & goto finish || %err%
if /i "%choice%"=="8" fastboot reboot edl & echo ��������... & goto finish || %err%
if /i "%choice%"=="9" goto version
if /i "%choice%"=="a" start "https://1drv.ms/u/c/9ce6a0c8705151c1/EeOBVkvHweBLuMczO_ApvUABD1gUqwPdvd_u5D-cbIe2SA?e=bzwbF7" & echo �Ѵ���ҳ�����������ذ�װ! & pause >nul
if /i "%choice%"=="b" call %~dp0\usb3Fix.bat
if /i "%choice%"=="c" goto wireless_connect
ECHO.
ECHO. %unicode%
%wait%
ECHO.
%MENU%

::���adb�豸����
:chkadb
%wait%
echo.
%partcode%
echo %date%,%time%
%partcode%
for /f "tokens=1" %%a in ('adb devices^|findstr /r /c:"device$"') do (
    setlocal enabledelayedexpansion
    set device_name=%%a
    echo �����ӵ��豸��!device_name!
    goto chkadb
    endlocal
)
echo ��ǰδ����adb�����ӵ� Android �豸��
echo.
goto chkadb

::���bootloader�豸����
:chkfb
%wait%
%partcode%
echo %date%,%time%
%partcode%
for /f "tokens=1" %%a in ('fastboot devices^|findstr /r /c:"device$"') do (
    setlocal enabledelayedexpansion
    set device_name=%%a
    echo �����ӵ��豸��!device_name!
    goto chkf
    endlocal
)
echo ��ǰδ���������ӵ� Android �豸��
goto chkfb

:version
echo adb�汾:
echo.
adb version
echo.
echo fastboot�汾���adb����
%partcode%
%defalut_over%


:listen
%wait%
echo.
%partcode%
echo %date%,%time%
%partcode%
echo.
setlocal enabledelayedexpansion
for /f "tokens=3 delims= " %%a in ('adb shell dumpsys window ^| findstr mCurrentFocus') do (
    set "packageName=%%a"
)

for /f "tokens=1 delims=/" %%b in ("%packageName%") do (
    set "packageName=%%b"
)
if /i "%packageName%"=="NotificationShade}" ( echo ��ǰ��������/״̬��! && endlocal && goto listen)
if /i "%packageName%"=="" ( echo ��ǰ�����л�Ӧ��! && endlocal && goto listen )
echo ��ǰ����Ϊ:%packageName%
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
    %menu%
)
%menu%

