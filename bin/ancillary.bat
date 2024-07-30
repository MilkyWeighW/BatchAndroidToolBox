call public.bat head

:menu
cls
color a
title 欢迎使用Android小工具的辅助.
echo 选择一项功能以辅佐主程序运行:
%partcode%
echo.
echo 【1】监测当前连接的adb设备.
echo.
echo 【2】监测当前连接的fastboot设备.
echo.
echo 【3】监测当前应用
echo.
echo 【4】打开一个空命令提示符.
echo.
echo 【5】fastboot --^> 系统
echo.
echo 【6】系统 --^> Recovery
echo.
echo 【7】系统 --^> bootloader
echo.
echo 【8】fastboot --^> edl【高通】
echo.
echo 【9】查看内置sdk版本号.
echo.
echo 【a】安装驱动
echo.
echo 【b】修复usb3导致的各种问题
echo.
echo 【c】无线配对设备
echo.
%partcode%
set choice=
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" echo 将会每隔五秒检查并打印设备列表. & goto chkadb
if /i "%choice%"=="2" echo 将会每隔五秒检查并打印设备列表. & goto chkfb
if /i "%choice%"=="3" cls & echo 将会每隔5秒检查并打印当前应用 & goto listen
if /i "%choice%"=="4" echo 完成! & start cmd /k 
if /i "%choice%"=="5" fastboot reboot & echo 正在重启... & goto finish || %err%
if /i "%choice%"=="6" adb reboot recovery & echo 正在重启... & goto finish || %err%
if /i "%choice%"=="7" adb reboot bootloader & echo 正在重启... & goto finish || %err%
if /i "%choice%"=="8" fastboot reboot edl & echo 正在重启... & goto finish || %err%
if /i "%choice%"=="9" goto version
if /i "%choice%"=="a" start "https://1drv.ms/u/c/9ce6a0c8705151c1/EeOBVkvHweBLuMczO_ApvUABD1gUqwPdvd_u5D-cbIe2SA?e=bzwbF7" & echo 已打开网页，请自行下载安装! & pause >nul
if /i "%choice%"=="b" call %~dp0\usb3Fix.bat
if /i "%choice%"=="c" goto wireless_connect
ECHO.
ECHO. %unicode%
%wait%
ECHO.
%MENU%

::检查adb设备连接
:chkadb
%wait%
echo.
%partcode%
echo %date%,%time%
%partcode%
for /f "tokens=1" %%a in ('adb devices^|findstr /r /c:"device$"') do (
    setlocal enabledelayedexpansion
    set device_name=%%a
    echo 已连接的设备：!device_name!
    goto chkadb
    endlocal
)
echo 当前未发现adb已连接的 Android 设备。
echo.
goto chkadb

::检查bootloader设备连接
:chkfb
%wait%
%partcode%
echo %date%,%time%
%partcode%
for /f "tokens=1" %%a in ('fastboot devices^|findstr /r /c:"device$"') do (
    setlocal enabledelayedexpansion
    set device_name=%%a
    echo 已连接的设备：!device_name!
    goto chkf
    endlocal
)
echo 当前未发现已连接的 Android 设备。
goto chkfb

:version
echo adb版本:
echo.
adb version
echo.
echo fastboot版本与该adb配套
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
if /i "%packageName%"=="NotificationShade}" ( echo 当前正在锁屏/状态栏! && endlocal && goto listen)
if /i "%packageName%"=="" ( echo 当前正在切换应用! && endlocal && goto listen )
echo 当前包名为:%packageName%
endlocal
goto listen

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
    %menu%
)
%menu%

