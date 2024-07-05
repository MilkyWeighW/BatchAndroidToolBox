@echo off
color a
cd /d %~dp0
set unicode=【请输入正确的字符,等待5秒并滚回主菜单】
set "wait=ping 127.0.0.1 -n 3 >nul"
set MENU=goto main

:main
title 欢迎使用Android小工具的辅助.
echo 选择一项功能以辅佐主程序运行:
echo 【1】打印当前连接的adb设备.
echo 【2】打印当前连接的fastboot设备.
echo 【3】查看adb和fastboot版本号.
echo 【4】打开一个空命令提示符.
echo 【5】fastboot --^> 系统
echo 【6】系统 --^> Recovery
echo 【7】系统 --^> bootloader
echo 【8】fastboot --^> edl【高通】
echo 【9】监测当前应用
echo 【a】安装驱动
echo 【b】修复usb3导致的各种问题

set choice=
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" goto chkadb
if /i "%choice%"=="2" goto chkfb
if /i "%choice%"=="5" fastboot reboot & echo 正在重启... & goto finish || goto err
if /i "%choice%"=="3" goto version
if /i "%choice%"=="4" goto cmd
if /i "%choice%"=="7" adb reboot recovery & echo 正在重启... & goto finish || goto err
if /i "%choice%"=="7" adb reboot bootloader & echo 正在重启... & goto finish || goto err
if /i "%choice%"=="8" fastboot reboot edl & echo 正在重启... & goto finish || goto err
if /i "%choice%"=="9" goto listen0
if /i "%choice%"=="a" start %~dp0\driver.exe & echo 已打开驱动安装程序! & pause >nul
if /i "%choice%"=="b" call %~dp0\usb3Fix.bat
ECHO.
ECHO. %unicode%
%wait%
ECHO.
%MENU%

::检查adb设备连接
:chkadb
echo 将会每隔五秒检查并打印设备列表.
ping -n 5 127.0.0.1>nul
echo *************
echo %date%,%time%
echo *************
for /f "tokens=1" %%a in ('adb devices^|findstr /r /c:"device$"') do (
    set device_name=%%a
    goto adb_connect_device
)
echo 当前未发现adb已连接的 Android 设备。
goto chkadb

:adb_connect_device
echo 已连接的设备名称：%device_name%
goto chkadb

::检查bootloader设备连接
:chkfb
echo 将会每隔五秒检查并打印设备列表.
ping -n 5 127.0.0.1>nul
echo *************
echo %date%,%time%
echo *************
for /f "tokens=1" %%a in ('fastboot devices^|findstr /r /c:"device$"') do (
    set device_name=%%a
    goto fb_connect_device
)
echo 当前未发现已连接的 Android 设备。
goto chkfb

:fb_connect_device
echo 已连接的设备名称：%device_name%
goto chkfb


:recc
fastboot reboot Recovery || echo 重启时出错! && goto err
goto finish
pause

:version
echo adb版本:
adb version
echo fastboot版本与该adb配套
pause
goto finish

:finish
echo 完成.按任意键返回上级菜单.
pause >nul
goto end_pre

:cmd
start cmd /k echo 完成!
goto end_pre

:listen0
cls
echo 将会每隔三秒检查并打印当前应用
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
if %packageName%==NotificationShade} (echo 当前正在锁屏状态! && endlocal && goto listen)
if %packageName%== (echo 现在正在切换应用 && endlocal && goto listen)
echo %packageName%
endlocal
goto listen

:err
color c
echo ***********************************************
echo 发生错误.
echo 可以用上方的错误提示结合搜索引擎查找并解决错误.
echo 按任意键返回主菜单.
pause >nul
%menu%
