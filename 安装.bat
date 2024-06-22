@echo off
color a
cd /d %~dp0
set unicode=【请输入正确的字符，奖励等待3秒并滚回主菜单】
set "wait=ping 127.0.0.1 -n 3 >nul"
set MENU=goto end_pre

title Android小工具-Steup
echo ****************************
echo 正在检查是否执行过该程序......
echo ****************************
cd %LOCALAPPDATA%\Wangstool || goto Pre
goto end_pre

:Pre
echo 看上去您先前并没有运行过这个安装程序或者文件被删除，需要（重新）安装，继续？
pause >nul  
ver | find "6.1." && goto 7
goto inst1

:7
bcdedit.exe /set nointegritychecks
goto inst1

:inst1
echo **********
echo 正在执行中
echo **********
mkdir %LOCALAPPDATA%\Wangstool
mkdir %~dp0\output
%wait%
echo 正在判断系统位数......
if "%PROCESSOR_ARCHITECTURE%"=="x86" goto instx86
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto instx64

:instx86
echo **************
echo 驱动安装【x86】
echo **************
start %~dp0\drivers\DPInst_x86.exe
start %~dp0\drivers\Qualcomm_HS-USB_Driver.exe
goto inst2

:instx64
echo **************
echo 驱动安装【x64】
echo **************
start %~dp0\drivers\DPInst_x64.exe
start %~dp0\drivers\Qualcomm_HS-USB_Driver.exe
goto inst2

:inst2
echo 现在将执行驱动安装程序，一直点下一步即可.
%wait%
%wait%
%wait%
%wait%
%wait%
echo.
echo 已完成（2/2）！
echo 完成安装！
goto end_pre

:end_pre
cls
echo 您已完成安装，恭喜！ 

title 完成！可以使用【主程序.bat】了!

echo 选择一项功能以辅佐主程序运行:

echo 【1】检查adb设备连接状态.

echo 【2】检查fastboot设备连接状态.

echo 【3】fastboot 重启到 系统 .

echo 【4】查看adb和fastboot版本号.

echo 【5】打开一个空命令提示符.

echo 【6】系统 重启到 Recovery

echo 【7】系统 重启到 fastboot

echo 【8】fastboot 重启到 edl【高通】

echo 【9】监测当前应用

set choice=
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" goto chkadb
if /i "%choice%"=="2" goto chkfb
if /i "%choice%"=="3" fastboot reboot & echo 正在重启... & goto finish || echo 遇到错误，请参考帮助文档
if /i "%choice%"=="4" goto version
if /i "%choice%"=="5" goto cmd
if /i "%choice%"=="7" adb reboot recovery & echo 正在重启... & goto finish || echo 遇到错误，请参考帮助文档
if /i "%choice%"=="7" adb reboot fastboot & echo 正在重启... & goto finish || echo 遇到错误，请参考帮助文档
if /i "%choice%"=="8" fastboot reboot edl & echo 正在重启... & goto finish || echo 遇到错误，请参考帮助文档
if /i "%choice%"=="9" goto listen0
ECHO.
ECHO. %unicode%
%wait%
ECHO.
%MENU%

rem *********************这是一个代码块**************************


:chkadb
echo 将会每隔五秒检查并打印设备列表.
start %~dp0\inst.bat
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

rem *********************这是一个代码块**************************

:chkfb
echo 将会每隔五秒检查并打印设备列表.
start %~dp0\inst.bat
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

rem *********************这是一个代码块**************************

:recc
fastboot reboot Recovery || echo 重启时出错! && goto err
goto finish
pause

:version
echo adb版本:
adb version
echo fastboot版本:
fastboot getver:version
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