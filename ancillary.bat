call public.bat head

:menu
color a
title ��ӭʹ�ù��߰��ĸ���.
%partcode%
echo.
echo ��1����һ����������ʾ��.
echo.
echo ��2�������˵�
echo.
echo ��3���鿴����sdk�汾��.
echo.
echo ��4����װ����
echo.
echo ��5���޸�usb3���µĸ�������
echo.
echo ��6����������豸
echo.
%partcode%
set choice=
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" echo ���! & start cmd /k 
if /i "%choice%"=="2" goto reboot_menu

if /i "%choice%"=="3" (
    adb version
    pause
    %defalut_over%
)
if /i "%choice%"=="4" start https://www.123pan.com/s/on0rVv-zhhV.html & echo �Ѵ���ҳ�����������ذ�װ! & pause >nul & %menu%
if /i "%choice%"=="5" call %~dp0\usb3Fix.bat
if /i "%choice%"=="6" goto wireless_connect
ECHO.
ECHO. %unicode%
%wait%
ECHO.
%MENU%

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
