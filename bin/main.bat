call public.bat head

:MENU
%deltemp%
color b
cls
echo 配合【辅助.bat】效果更佳.
echo 如果遇到没有【返回主菜单】选项的话,输入一个错误的值即可.
echo 请只连接一个设备,包含模拟器!
%partcode%
echo 选择一个功能以继续.
echo.
echo 【1】分区与镜像相关操作.
echo.
echo 【2】adb卡刷.
echo.
echo 【3】应用管理.
echo.
echo 【4】杂项功能.
echo.
echo 【5】手机信息查看.
echo.
echo 【6】单个应用安装.
echo.
echo 【7】线刷（打开空命令行）.
echo.
echo 【8】重启adb服务.
echo.
echo 【9】关于.
echo.
%partcode%
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" call image.bat
if "%choice%"=="2" goto sideload
if "%choice%"=="3" echo 请先将设备连接adb & call call chkdev.bat system & call app.bat skipchk
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
%partcode%
echo 选择一个功能以继续.
echo 【1】bootloader解锁 
echo.
echo 【2】删除手机锁屏密码（需root） 
echo.
echo 【3】打开adbshell 
echo.
echo 【4】网络验证服务器更改
echo.
set choice=
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto bl_unlock
if "%choice%"=="2" goto crack
if "%choice%"=="3" goto adb_shell
if "%choice%"=="4" goto Internet_verify_change
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

:adb_shell
echo 正在打开adbShell...
call chkdev.bat system
adb shell || %err%

:Internet_verify_change
pause
call chkdev.bat system
adb shell settings put global captive_portal_http_url http://developers.google.cn/generate_204
adb shell settings put global captive_portal_https_url https://developers.google.cn/generate_204
adb shell settings put global ntp_server time.asia.apple.com
echo 更改完成.按任意键返回主菜单
pause >nul
%menu%

:info
cls
echo 将打印手机信息,该过程需要连接CAT服务，adb和su...
call chkdev.bat system
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
echo Android小工具 V2.1.0  ---BY MilkyWeigh--- 
echo.
echo chkdev.bat 来自BFF ---BY 某贼---
echo Oringal Link : https://gitee.com/mouzei/bff
echo.
echo.payload-dumper-go.exe ---BY ssut---
echo.Oringal Link : https://github.com/ssut/payload-dumper-go
echo 感谢你的使用!
pause >nul
%menu%

