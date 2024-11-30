call public.bat head

:MENU
title 欢迎使用Android小工具V2.
%deltemp%
cls
color b
echo 如果遇到没有【返回主菜单】选项的话,输入一个错误的值即可.
echo 请只连接一个设备,包含模拟器!
echo.
echo 选择一个功能以继续.
echo.
echo 【0】无线配对设备
echo.
echo 【1】镜像处理
echo.
echo 【2】监视器
echo.
echo 【3】应用管理
echo.
echo 【4】杂项功能
echo.
echo 【5】安装驱动
echo.
echo 【6】重启菜单
echo.
echo 【7】打开空命令行
echo.
echo 【8】重启adb服务
echo.
echo 【9】关于
echo.
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%

if "%choice%"=="0" goto wireless_connect
if "%choice%"=="1" start image.bat & %menu%
if "%choice%"=="2" start monitor.bat & %menu%
if "%choice%"=="3" start app.bat & %menu%
if "%choice%"=="4" goto others
if "%choice%"=="5" start https://www.123pan.com/s/on0rVv-zhhV.html & echo 已打开网页，请自行下载安装! & pause >nul & %menu%
if "%choice%"=="6" goto reboot_menu
if "%choice%"=="7" (
    cls
    echo 完成
    cd /d "%~dp0"
    cmd /k
    %MENU%
)
if "%choice%"=="8" adb kill-server & adb start-server & echo 重启完毕! & %wait% & %menu%
if "%choice%"=="9" goto about
%choice_end%

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

::刷机
:sideload
echo 请先将设备置于Recovery模式中,并且开启【adb线刷/sideload】模式.
echo 不同Recovery叫法可能不同,但大多在【高级】选项中,不妨去看看.
call chkdev.bat sideload
set /p file=拖入要刷入的文件并回车:
echo 按任意键刷入.
pause >nul
adb sideload %file% || %err%
echo 操作成功完成,建议格式化data以确保干净刷入
echo 按任意键返回主菜单.
pause >nul
%MENU%

::杂项功能
:others
%partcode%
echo 选择一个功能以继续.
echo.
echo 【1】bootloader解锁 
echo.
echo 【2】删除手机锁屏密码（需root） 
echo.
echo 【3】打开adbshell 
echo.
echo 【4】网络验证服务器更改
echo.
echo 【5】修复usb3导致的各种问题
echo.
echo.
set choice=
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto bl_unlock
if "%choice%"=="2" goto crack
if "%choice%"=="3" (
    echo 正在打开adbShell...
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
	echo 设备已解锁！按任意键返回主菜单
	pause >nul
	%menu%
)
echo 确保在部分机型上已开启OEM解锁开关.
set /p key=键入解锁码(可留空):
echo 开始解锁...
if "%key%"==" " fastboot flashing unlock
fastboot oem unlock %key% || %err%
echo 操作成功完成!按任意键返回上级主菜单
pause >nul
goto others

:crack
echo 该程序通过删除/data/system/locksetting.db来实现.
echo 按下任意键来执行.
pause >nul
call chkdev.bat system
adb shell " su -c 'rm /data/system/locksetting.db'" || echo 删除密码失败！ && %err%
echo 操作成功完成!按任意键返回上级菜单
pause >nul
goto others

:Internet_verify_change
pause
call chkdev.bat system
adb shell settings put global captive_portal_http_url http://developers.google.cn/generate_204
adb shell settings put global captive_portal_https_url https://developers.google.cn/generate_204
adb shell settings put global ntp_server time.asia.apple.com
echo 更改完成.按任意键返回主菜单
pause >nul
%menu%

:about
cls
echo adb相关信息---
adb version
%partcode%
echo 本程序遵循 AGPL v3 开源协议,以下排名不分先后
echo.
echo chkdev.bat 来自BFF ---BY 某贼---
echo Oringal Link : https://gitee.com/mouzei/bff
echo.
echo.payload-dumper-go.exe ---BY ssut---
echo.Oringal Link : https://github.com/ssut/payload-dumper-go
echo.
echo brotli 
echo Oringal Link : https://github.com/google/brotli
echo.
echo ImgExtractor version 1.3.6 
echo ^<Created by And_PDA (Based on sources ext4_unpacker)^>
echo.
echo sdat2img.py
echo AUTHORS: xpirt - luxi78 - howellzhu
echo Oringal Link : https://github.com/xpirt/sdat2img
echo.
echo Android小工具 V2.1.0  ---BY MilkyWeigh--- 
echo.
echo 感谢你的使用!
pause >nul
%menu%

