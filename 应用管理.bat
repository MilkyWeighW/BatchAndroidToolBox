::本批处理文件支持外部参数传递
::用法	: call 应用管理.bat [MODE] [FILE]
::
::例如	: call 应用管理.bat skipchk 			【跳过adb设备连接校验】
::		: call 应用管理.bat uninstall 1.txt		【卸载1.txt中所含包名】
::							disable				停用
::							enable				启用

@echo off
color b
chcp 936
cd /d %~dp0
title Android小工具V2--应用管理部分
set unicode=【请输入正确的字符,等待5秒并滚回主程序】
set "wait=ping 127.0.0.1 -n 5 >nul"
set err=goto err
set MENU=call 主程序.bat
set deltemp=del /q *.txt
set partcode=echo **********************************
set "choice_end=ECHO. & ECHO. 【请输入正确的字符,等待5秒并滚回主程序】 & ping 127.0.0.1 -n 5 >nul & ECHO. & %MENU% & cls"
set skip=0
cls

::接受参数
set command=%1
if "%command%"=="skipchk" ( set skip=1 & goto app ) 
if "%command%"=="uninstall" ( set directly_process=1 & set "mode=uninstall" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 
if "%command%"=="disable" ( set directly_process=1 & set "mode=shell pm disable-user" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 
if "%command%"=="enable" ( set directly_process=1 & set "mode=shell enable" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 


::应用管理部分
:app
if "%skip%"=="0" ( echo 请先将设备连接adb & call chkdev.bat system & call 应用管理.bat skipchk)
%deltemp%
cls
echo 将会展示应用列表,选择一个选项继续.
echo 【1】展示第三方应用列表.
echo 【2】展示系统应用列表.
echo 【3】我全都要!
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" set listmode=第三方 & adb shell pm list packages -3 > applist.txt & goto output || %err%
if "%choice%"=="2" set listmode=系统 & adb shell pm list packages -s > applist.txt & goto output || %err%
if "%choice%"=="3" set listmode=全部 & adb shell pm list packages > applist.txt & goto output|| %err%
%choice_end%

::处理生成的文本
:output
(for /f "usebackq delims=" %%i in ("applist.txt")do (
	echo %%i>con
	set h=%%i
	setlocal enabledelayedexpansion
	echo !h:~8!
	endlocal
))>处理后的app列表.txt
cls
goto app1

::处理方式选择
:app1
type 处理后的app列表.txt
echo. & echo.
echo 已打印%listmode%应用的列表!请选择一个操作.
echo 【1】卸载应用/清除数据 【2】停用应用(单个) 【3】停用应用(批量) 
echo 【4】启用应用(单个)【5】启用应用(批量)【6】提取单个应用安装包 【7】回到上一级 【8】退回主菜单
set choice=
set mode=
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto uninstall_clear_app
if "%choice%"=="2" set "mode=shell pm disable-user" & goto disable_enable_app_Single
if "%choice%"=="3" set "mode=shell pm disable-user" & goto uninstall_diable_enable_Multiple
if "%choice%"=="4" set "mode=shell enable" & goto disable_enable_app_Single
if "%choice%"=="5" set "mode=shell enable" & goto uninstall_diable_enable_Multiple
if "%choice%"=="6" goto apkout
if "%choice%"=="7" goto app
if "%choice%"=="8" %menu%
%choice_end%

::卸载单个应用
:uninstall_clear_app
echo.
echo.$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
echo 选择一个操作:
echo 【1】卸载一个应用本身及缓存.
echo 【2】卸载一个应用，但保留数据和缓存文件.
echo 【3】批量卸载
echo 【4】清理一个应用的数据
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" set mode=  & goto uninstall_clear_app_execute
if "%choice%"=="2" set mode=-k & goto uninstall_clear_app_execute
if "%choice%"=="3" set mode=uninstall & goto uninstall_diable_enable_Multiple
if "%choice%"=="4" goto clearapp
%choice_end%

:uninstall_clear_app_execute
if "%mode%"=="" set mode_name=完全卸载
if "%mode%"=="-k" set mode_name=卸载，但保留保留数据和缓存文件
echo 你选择了: %mode_name%
set /p pkgname=输入一个非系统应用的包名后回车 :
echo 开始卸载%pkgname%的全部...
adb uninstall %mode% %pkgname% || echo 无效的参数. & %err%
goto fini_uninst

:clearapp
set /p pkgname=输入一个非系统应用的包名后回车:
echo 开始清理%pkgname%的数据...
adb clear %pkgname% || echo 无效的参数. & %err%
goto fini_uninst

::单个应用的启停
:disable_enable_app_Single
if "%mode%"=="shell pm disable-user" set mode_name=停用
if "%mode%"=="shell enable" set mode_name=启用
echo 你选择了；%mode_name% 单个应用
set /p pkgname=输入一个应用的包名后回车:
echo 按任意键继续.
pause >nul
adb %mode% %pkgname% || %err%
echo 操作成功完成!按任意键返回上级菜单.
pause >nul
goto app1

::多行处理部分
:uninstall_diable_enable_Multiple
if "%mode%"=="uninstall" set mode_name=卸载
if "%mode%"=="shell pm disable-user" set mode_name=停用
if "%mode%"=="shell enable" set mode_name=启用
echo 拖入处理过的txt文件，文中需要含有包名,一排一个包名.不能%mode_name%系统应用
echo 示例:
echo example.txt--------下面到横线的地方都是txt文件内容--------------
echo.
echo com.baoming.baoming
echo.
echo ---这样在拖入文件后,程序将会%mode_name%"com.baoming.baoming"这个应用--
echo 提示:当你打印完应用列表的那一刻,看看程序的根目录,多了两个txt文件,选择处理后的就可以.
echo 您可以将程序关闭后将列表中您不需要的应用的包名删去,以免错误处理重要应用.
set /p file=拖入处理过的txt文件:
goto uninstall_diable_enable_Multiple_excute

:uninstall_diable_enable_Multiple_excute
if "%directly_process%"="1" (echo 请先将设备连接adb & call chkdev.bat system & call 应用管理.bat skipchk)
set targe=''
setlocal enabledelayedexpansion
for /f  %%i in (%file%)  do (
set target=%%i
adb %mode% !target! || goto err
) 
if "%directly_process%"=="1" goto defalut_over
goto fini_uninst_disable_enable

:fini_uninst_disable_enable
echo 完成%mode_name%,按任意键返回上上级菜单.
pause >nul
goto app1

::提取应用安装包
:apkout
setlocal enabledelayedexpansion
set /p app_pkgname=键入想要提取应用的包名:
for /f "delims=" %%i in ('adb shell pm path %app_pkgname%') do set path_package=%%i 
set path_package=!path_package:~8!
adb pull %path_package% %~dp0output\%app_pkgname%.apk
echo 已提取【%app_pkgname%】的安装包至本程序output目录下.
endlocal
pause
cls
goto app1

:err
color c
echo ***********************************************
echo 发生错误.
echo 可以用上方的错误提示结合搜索引擎查找并解决错误.
echo 按任意键返回主菜单.
pause >nul
%menu%

:defalut_over
echo 操作成功完成,按任意键返回主程序.
pause >nul
%MENU%
