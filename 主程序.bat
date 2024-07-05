@echo off
chcp 936
cd /d %~dp0
title 欢迎使用Android小工具V2.
set unicode=【请输入正确的字符,等待5秒并滚回主菜单】
set "wait=ping 127.0.0.1 -n 5 >nul"
set MENU=goto menu
set err=goto err
set partcode=echo **********************************
set deltemp=del /q *.txt
set "choice_end=ECHO. & ECHO. 【请输入正确的字符,等待5秒并滚回主菜单】 & ping 127.0.0.1 -n 5 >nul & ECHO. & %MENU% & cls"
cls

:MENU
%deltemp%
cls
color 3
echo 配合【辅助.bat】及搜索引擎效果更佳.
echo 如果遇到没有【返回主菜单】选项的话,输入一个错误的值即可.
echo 请只连接一个设备,包含模拟器!
%partcode%
echo 选择一个功能以继续.
echo 【1】手机内置分区相关操作.
echo 【2】adb卡刷.
echo 【3】应用管理.
echo 【4】杂项功能.
echo 【5】手机信息查看.
echo 【6】应用安装.
echo 【7】线刷（打开空命令行）.
echo 【8】重启adb服务.
echo 【9】关于.
%partcode%
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto Part_Pre
if "%choice%"=="2" goto sideload
if "%choice%"=="3" echo 请先将设备连接adb & call chkdev.bat system & call 应用管理.bat skipchk
if "%choice%"=="4" goto others
if "%choice%"=="5" goto info
if "%choice%"=="6" goto installapp
if "%choice%"=="7" goto batFlash
if "%choice%"=="8" adb kill-server & adb start-server & echo 重启完毕! & %wait% & %menu%
if "%choice%"=="9" goto credit
%choice_end%

::应用安装
:installapp
echo.
set /p file=拖入apk安装包,然后回车.
echo 开始安装...
adb install %file% || %err%
echo 完成!按任意键继续安装,输入【b】返回.
set choice= 
set /p choice=继续安装就回车吧：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="b" cls & %MENU%
echo.
goto installapp

::映像相关
:Part_Pre
cls
echo 选择一个操作：
echo 【1】擦除 【2】刷入 【3】提取(需root权限)
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" set mode=erase & set mode_name=擦除 & goto part_process
if "%choice%"=="2" set mode=flash & set mode_name=刷入 & goto part_process
if "%choice%"=="3" goto part_output
%choice_end%

:part_process
echo 请先将设备置于fastboot模式中.
call chkdev.bat fastboot
echo 输入要%mode_name%的分区名并回车
set /p partition=
if "%mode%"=="erase" echo 将会擦除手机的【%partition%】分区,确认?
if "%mode%"=="flash" set /p file=拖入要刷入的文件并回车: & echo 将会把【%file%】刷入到手机的【%partition%】分区内,确认?
set file= 
set /p choice=键入单个首字母【Y/N】并回车以继续:
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
set /p partition=分区列表已打印，请键入你想提取的分区:
findstr %partition% after.txt > target.txt
for /f "tokens=2 delims= " %%i in (target.txt) do (
	%partcode%
	setlocal enabledelayedexpansion
	echo 存储于%%i 路径下，正在提取...
	adb shell " su -c 'dd if=%%i of=/sdcard/%partition%.img'" || echo 分区提取失败！ & %err%
	adb pull /sdcard/%partition%.img %~dp0\output
	endlocal
	%partcode%
)
%deltemp%
start %~dp0\output & echo 已打开对应目录!
 echo %partition%分区提取完成,存储于output目录下,按任意键退回主菜单.
pause >nul
%menu%

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

:batFlash
cls
echo 拖入线刷包中的bat脚本并回车.
echo 一般选择【flash_all】即可.
echo 注意不要选带有【lock】字样的bat哦,这会重新锁上你的bootloader!
cd /d "%~dp0"
cmd /k
exit

::杂项功能
:others
echo 选择一个功能以继续.
echo 【1】bootloader解锁 【2】删除手机锁屏密码（需root） 【3】打开adbshell 
echo 【4】网络验证服务器更改【维护中】
set choice=
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto bl_unlock
if "%choice%"=="2" goto crack
if "%choice%"=="3" goto adb_shell
if "%choice%"=="4" %menu%
%choice_end%

:bl_unlock
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
adb shell " su -c 'rm /data/system/locksetting.db'" || echo 删除密码失败！ & %err%
echo 操作成功完成!按任意键返回上级菜单
pause >nul
goto others

:adb_shell
echo 正在打开adbShell...
adb shell || %err%

:info
cls
echo 将打印手机信息,该过程需要连接CAT服务，adb和su...
echo 型号:
%partcode%
adb shell getprop ro.product.model || echo 打印失败!
%partcode%
echo 电池状况:
adb shell dumpsys battery || echo 打印失败!
%partcode%
echo 屏幕分辨率:
adb shell wm size || echo 打印失败!
%partcode%
echo 屏幕密度:
adb shell wm density || echo 打印失败!
%partcode%
echo 显示屏参数:
adb shell dumpsys window displays || echo 打印失败!
%partcode%
echo Android系统版本:
adb shell getprop ro.build.version.release || echo 打印失败!
%partcode%
echo CPU信息:
adb shell cat /proc/cpuinfo || echo 打印失败!
%partcode%
echo 内存信息:
adb shell cat /proc/meminfo || echo 打印失败!
%partcode%
echo.
echo 按任意键返回主菜单...
pause >nul
%menu%

:credit
cls
echo 本程序遵循 AGPL v3 开源协议
echo.
echo Android小工具 V2.0.1  ---BY MilkyWeigh--- 
echo.
echo chkdev.bat 来自BFF ---BY 某贼---
echo Oringal Link : https://gitee.com/mouzei/bff
echo.
echo 感谢你的使用!
pause >nul
%menu%

:err
color c
echo ***********************************************
echo 发生错误.
echo 可以用上方的错误提示结合搜索引擎查找并解决错误.
echo 按任意键返回主菜单.
pause >nul
%menu%

:defalut_over
echo 操作成功完成,按任意键返回主菜单.
pause >nul
%MENU%
