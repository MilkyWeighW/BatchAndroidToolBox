call public.bat head

:menu
color a
title 欢迎使用工具包的辅助.
%partcode%
echo.
echo 【1】打开一个空命令提示符.
echo.
echo 【2】重启菜单
echo.
echo 【3】查看内置sdk版本号.
echo.
echo 【4】安装驱动
echo.
echo 【5】修复usb3导致的各种问题
echo.
echo 【6】无线配对设备
echo.
%partcode%
set choice=
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" echo 完成! & start cmd /k 
if /i "%choice%"=="2" goto reboot_menu

if /i "%choice%"=="3" (
    adb version
    pause
    %defalut_over%
)
if /i "%choice%"=="4" start https://www.123pan.com/s/on0rVv-zhhV.html & echo 已打开网页，请自行下载安装! & pause >nul & %menu%
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
echo 请选择:
echo.
echo 【1】配对
echo.
echo 【2】连接
echo.
set choice=
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" (
    set /p ip=请输入ip号及端口号: 
    set /p code=请输入配对码:
    echo 将会以【!code!】为密钥与【!ip!】配对, 按任意键继续.
    pause >nul
    adb pair !ip! !code! || (
        echo 配对失败
        goto wireless_connect
    )
    echo 配对完成.
    pause
    endlocal
)
if /i "%choice%"=="2" (
    set /p ip=请输入ip号及端口号: 
    echo 将会与【!ip!】连接, 按任意键继续.
    pause >nul
    adb connect !ip! || (
        echo 连接失败
        goto wireless_connect
    )
    echo 连接成功
    pause
    endlocal
    goto menu
)
goto menu
