@REM 调用方法
@REM call monitor [功能] [参数]
@REM             chkdev              持续检查设备连接状态    返回类型:命令行输出
@REM             get_deviceinfo_adb  在adb状态下输出设备信息 返回类型:命令行输出
@REM             listen              监听前台应用           返回类型:命令行输出

@REM             listapp             输出系统和第三方应用    返回类型:文本文件 [.\output\app_processed.txt]
@REM                      -s         输出系统应用
@REM                      -3         输出第三方应用

call public head
color a

set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
if "%var1%"=="" (
    set "adb_target=set status=1 & goto MENU"
    set "fb_target=set status=2 & goto MENU"
    goto chkdev
) else (
    if "%var1%"=="chkdev" (
        set "adb_target=echo 5s后再次检查 & %wait% & goto chkdev"
        set "fb_target=echo 5s后再次检查 & %wait% & goto chkdev"
        goto %var1%
    ) else (
        goto %var1%
    )
)

:chkdev
title 设备连接监视器
echo.
%partcode%
echo %date%,%time%
%partcode%
for /f "tokens=1" %%a in ('adb devices^|findstr /r /c:"device$"') do (
    setlocal enabledelayedexpansion
    call chkdev system
    set device_name=%%a
    echo 已连接的设备：!device_name!
    endlocal
    %adb_target%
)
for /f "tokens=1" %%a in ('fastboot devices^|findstr /r /c:"device$"') do (
    setlocal enabledelayedexpansion
    call chkdev fastboot
    set device_name=%%a
    echo 已连接的设备：!device_name!
    endlocal
    %fb_target%
)
echo 当前未发现任何已连接的设备。
%wait%
goto chkdev

:MENU
if not defined status (
    call monitor chkdev
) else (
    if "%status%"=="1" goto MENU_adb
    if "%status%"=="2" goto MENU_fb
)

:MENU_adb
title 监视器 - adb设备就绪状态
cls
echo.
%partcode%
echo.
echo. 请选择需要监视的类型:
echo.
echo 【1】继续持续进行设备检测
echo.
echo 【2】持续监视当前应用
echo.
echo 【3】打印当前应用列表
echo.
echo 【4】adb读信息
echo.
%partcode%
echo.
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" start monitor chkdev & goto MENU_adb
if "%choice%"=="2" start monitor listen & goto MENU_adb
if "%choice%"=="3" goto listapp & goto MENU_adb
if "%choice%"=="4" (
    echo 读取设备信息并保存中...请稍作等候 
    call :get_deviceinfo_adb > .\output\%devname%_info.txt
    echo 正在打开...
    start cmd /k type .\output\%devname%_info.txt
    goto adb_defalutover
)
%choice_end%

:get_deviceinfo_adb
::可被外部调用的模块
title adb状态-读取设备信息
if "%var1%" == "" (
    echo.
) else (
    call chkdev system >nul
)

%partcode%
echo %date%,%time%
%partcode%
echo.
echo ----------硬件信息----------
set /p="设备名称    "<nul & adb shell getprop ro.product.name
set /p="制造厂商    "<nul & adb shell getprop ro.product.brand
set /p="设备型号    "<nul & adb shell getprop ro.product.model
echo.
set /p="CPU厂商    "<nul & adb shell getprop ro.soc.manufacturer
set /p="--CPU型号  "<nul & adb shell getprop ro.board.platform
set /p="--指令集:   "<nul & adb shell getprop ro.product.cpu.abilist
echo.
set /p="基带厂商    "<nul & adb shell getprop ro.baseband
set /p="--SIM卡属国 "<nul & adb shell getprop gsm.sim.operator.iso-country
set /p="--运营商    "<nul & adb shell getprop gsm.sim.operator.alpha
echo.
set /p="GPU厂商    "<nul & adb shell getprop ro.hardware
set /p="--OpenGL渲染器 "<nul & adb shell getprop ro.hardware.egl
set /p="--Vulkan渲染器 "<nul & adb shell getprop ro.hardware.vulkan
::电池相关
echo.
echo 电池状态
for /f "tokens=1 delims=" %%a in ('adb shell dumpsys battery') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:false=否!
    set a=!a:true=是!
    set a=!a:Current Battery Service state:=---------!
    set a=!a: powered=供电!
    set a=!a:AC=直流!
    set a=!a:Dock=底座!
    set a=!a:Wireless=无线!
    set a=!a:Max charging current=充电时最大电流[μA]!
    set a=!a:Max charging voltage=充电时最大电压[μV]!
    set a=!a:Charge counter=瞬时电池容量[uA-h]!
    set a=!a:present=安装电池!
    set a=!a:level=当前电量!
    set a=!a:scale=满电电量!
    set a=!a:voltage=瞬时电压[μV]!
    set a=!a:status=当前状态!
    set a=!a:health=健康状态!
    set a=!a:temperature=温度[?/10°C]!
    set a=!a:technology=技术!
    set a=!a:Charging state=充电状态!
    set a=!a:Charging policy=充电协议! 
    echo --!a!
    endlocal
)
echo.
echo.
echo 屏幕相关
echo -----------
echo.
for /f "tokens=1 delims=" %%a in ('adb shell wm size') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Physical size=--物理分辩率!
    set a=!a:Override size=--系统渲染分辫率!
    echo !a!
    endlocal
)
echo.
for /f "tokens=1 delims=" %%a in ('adb shell wm density') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Physical density=--物理DPI!
    set a=!a:Override density=--系统渲染DPI!
    echo !a!
    endlocal
)
echo.
echo ----------软件信息----------
echo.
set /p="系统版本:   Android "<nul & adb shell getprop ro.system.build.version.release 
echo.
set /p="构建SDK版本:    "<nul & adb shell getprop ro.system.build.version.sdk 
set /p="最低支持的SDK版本:  "<nul & adb shell getprop ro.build.version.min_supported_target_sdk
set /p="--系统构建类型: "<nul & adb shell getprop ro.build.type
set /p="--系统构建时间: "<nul & adb shell getprop ro.build.date
set /p="--安全补丁日期: "<nul & adb shell getprop ro.build.version.security_patch
set /p="--内核版本: "<nul & adb shell getprop ro.kernel.version
set /p="--Selinux状态:  "<nul & adb shell getenforce
echo.
echo 手机内置存储（sdcard）状态:
echo -----------------------------
echo.
for /f "tokens=5 delims= " %%a in ('adb shell df -h /sdcard') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Use^%=用量!
    echo !a!
    endlocal
)
echo.
for /f "tokens=2 delims= " %%a in ('adb shell df -h /sdcard') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Size=总大小!
    echo !a!
    endlocal
)
echo.
for /f "tokens=1 delims= " %%a in ('adb shell df -h /sdcard') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Filesystem=文件系统!
    echo !a!
    endlocal
)
echo.
for /f "tokens=6 delims= " %%a in ('adb shell df -h /sdcard') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Mounted=挂载于!
    echo !a!
    endlocal
)
echo.
%partcode%
goto :eof

:listen
::可被外部调用的模块
title adb状态-应用监听器
if "%var1%" == "" (
    echo.
) else (
    call chkdev system >nul
)

echo.
echo --%date%,%time%--
setlocal enabledelayedexpansion
for /f "tokens=3 delims= " %%a in ('adb shell dumpsys window ^| findstr mCurrentFocus') do (
    set "packageName=%%a"
)

for /f "tokens=1 delims=/" %%b in ("%packageName%") do (
    set "packageName=%%b"
)
if not %errorlevel%==0 (%err%) 
if /i "%packageName%"=="NotificationShade}" ( echo 当前正在锁屏/状态栏! & %wait% & endlocal & goto listen)
if /i "%packageName%"=="" ( echo 当前正在切换应用! & %wait% & endlocal & goto listen )
echo 当前应用的包名为:%packageName%
%wait%
endlocal
goto listen

:listapp
echo.
echo 将会输出应用列表,选择一个选项继续.
echo.
echo 【1】展示第三方应用列表.
echo 【2】展示系统应用列表.
echo 【3】我全都要!
echo.
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" (
    call monitor applist_output -3 
    start cmd /k type %~dp0output\app_processed.txt 
    goto adb_defalutover
)
if "%choice%"=="2" (
    call monitor applist_output -s 
    start cmd /k type %~dp0output\app_processed.txt 
    goto adb_defalutover
)
if "%choice%"=="3" (
    call monitor applist_output
    start cmd /k type %~dp0output\app_processed.txt 
    goto adb_defalutover
)
%choice_end%

:applist_output
::可被外部调用的模块
title adb状态-应用列表打印器
if "%var1%" == "" (
    echo.
) else (
    call chkdev system >nul
)

set "listmode=%2"
adb shell pm list packages %listmode% > .\temp\app.txt
echo.
echo 请稍等,正在处理应用及其列表...
echo 这可能需要较长时间
echo.
(for /f "usebackq delims=" %%i in (".\temp\app.txt")do (
	set pkgname=%%i
	setlocal enabledelayedexpansion
    ::去除前面的"package:"
	echo !pkgname:~8!
	endlocal
))>.\temp\app_pkgname.txt
del /f /q .\temp\app.txt
(for /f "usebackq delims=" %%a in (".\temp\app_pkgname.txt")do (
    setlocal enabledelayedexpansion
    set "pkgname=%%a"
    adb shell pm path !pkgname!
    endlocal          
))>.\temp\app.txt
(for /f "usebackq delims=" %%a in (".\temp\app.txt")do (
    setlocal enabledelayedexpansion
    set "pkgpath=%%a"
    echo !pkgpath:~8!
    endlocal          
))>.\temp\app_path.txt
del /f /q .\temp\app.txt
::获取应用名
echo 正在发送工具包...
adb push aapt2-arm64 /data/local/tmp >nul
adb shell chmod 0755 /data/local/tmp/aapt2-arm64 >nul
for /f "usebackq delims=" %%a in (".\temp\app_path.txt")do (
    setlocal enabledelayedexpansion
    set "pkgpath=%%a"
    adb shell /data/local/tmp/aapt2-arm64 d badging !pkgpath! | findstr /c:"application-label:" >> .\temp\app_label.txt
    endlocal          
)
call public convert_encode_utf82ANSI .\temp\app_label.txt
for /f "usebackq delims=" %%a in (".\temp\app_label_ANSI.txt")do (
    set "appName=%%a"
    setlocal enabledelayedexpansion
    set appName=!appName:'=! 
    echo !appName:~18!
    endlocal          
)>>.\temp\appName.txt
call public combine_2txts .\temp\appName.txt .\temp\app_pkgname.txt .\output\app_processed.txt
@rmdir /s /q temp
@mkdir temp
echo.
cls
echo 应用列表文件已保存于
echo 【%~dp0output\app_processed.txt】.
goto :eof

:adb_defalutover
echo 按任意键返回.
pause>nul
goto :MENU_adb

:MENU_fastboot
echo 开发中...按任意键退出
pause >nul
exit