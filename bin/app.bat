::本批处理文件支持外部参数传递
::用法	: call app.bat [MODE] [FILE]
::		: call app.bat uninstall 1.txt	    【卸载1.txt中所含包名】
::					   disable			   【卸载1.txt中所含包名】
::					   enable			   【卸载1.txt中所含包名】
call public.bat head

::接受参数
set command=%1
if "%command%"=="uninstall" ( set directly_process=1 & set "mode=uninstall" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 
if "%command%"=="disable" ( set directly_process=1 & set "mode=shell pm disable-user" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 
if "%command%"=="enable" ( set directly_process=1 & set "mode=shell enable" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 


::应用管理部分

::处理方式选择
:menu
color 3
title 应用管理
echo. 
echo 请选择一个操作.
echo.
echo 【0】输出应用列表
echo.
echo 【1】卸载应用/清除数据 
echo.
echo 【2】停用应用(单个) 【3】停用应用(批量) 
echo.
echo 【4】启用应用(单个) 【5】启用应用(批量) 
echo.
echo 【6】提取单个应用安装包 
echo.
echo 【7】安装应用(单个) 【8】安装应用(批量)
echo.
set choice=
set mode=
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="0" goto applist_output
if "%choice%"=="1" goto uninstall_clear_app
if "%choice%"=="2" set "mode=shell pm disable-user" & goto disable_enable_app_Single
if "%choice%"=="3" set "mode=shell pm disable-user" & goto uninstall_diable_enable_Multiple
if "%choice%"=="4" set "mode=shell enable" & goto disable_enable_app_Single
if "%choice%"=="5" set "mode=shell enable" & goto uninstall_diable_enable_Multiple
if "%choice%"=="6" goto apkout
if "%choice%"=="7" goto installapp_single
if "%choice%"=="8" goto installapp_batch
%choice_end%

:installapp_batch
set /p path=拖入含有apk文件的文件夹:
%partcode%
echo 所有文件如下:
dir %path% /b > apks.txt
type apks.txt
%partcode%
echo 将会安装这些文件，按任意键继续
pause
for /f "tokens=1 delims=. " %%i in (apks.txt) do (
    setlocal enabledelayedexpansion
    %partcode%
    echo 正在安装%%i...
    set "file=%path%\%%i.apk"
    adb install !file!
    endlocal
)
echo 安装完成,按任意键返回主程序
pause >nul
%menu%

:installapp_single
echo.
set file=
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

:applist_output
title 应用管理
echo.
echo 选择一个选项继续.
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
    goto menu
)
if "%choice%"=="2" (
    call monitor applist_output -s 
    start cmd /k type %~dp0output\app_processed.txt 
    goto menu
)
if "%choice%"=="3" (
    call monitor applist_output
    start cmd /k type %~dp0output\app_processed.txt 
    goto menu
)
%choice_end%

::卸载单个应用
:uninstall_clear_app
echo.
%partcode%
echo 选择一个操作:
echo.
echo 【1】卸载一个应用本身及缓存.
echo.
echo 【2】卸载一个应用，但保留数据和缓存文件.
echo.
echo 【3】批量卸载
echo.
echo 【4】清理一个应用的数据
echo.
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
adb uninstall %mode% %pkgname% || %err%
goto fini_uninst

:clearapp
set /p pkgname=输入一个非系统应用的包名后回车:
echo 开始清理%pkgname%的数据...
adb clear %pkgname% || %err%
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
goto menu

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
echo 提示:当你打印完应用列表的那一刻,看看程序的bin目录,多了两个txt文件,选择处理后的就可以.
echo 您可以将程序关闭后将列表中您不需要的应用的包名删去,以免错误处理重要应用.
set /p file=拖入处理过的txt文件:
goto uninstall_diable_enable_Multiple_excute

:uninstall_diable_enable_Multiple_excute
set targe=''
setlocal enabledelayedexpansion
for /f  %%i in (%file%)  do (
set target=%%i
adb %mode% !target! || goto err
) 
if "%directly_process%"=="1" %defalut_over%
goto fini_uninst_disable_enable

:fini_uninst_disable_enable
echo 完成%mode_name%,按任意键返回上上级菜单.
pause >nul
goto menu

::提取应用安装包
:apkout
setlocal enabledelayedexpansion
set /p app_pkgname=键入想要提取应用的包名:
for /f "delims=" %%i in ('adb shell pm path %app_pkgname%') do set path_package=%%i 
set path_package=!path_package:~8!
echo.
echo 正在提取，请稍等...
adb pull %path_package% %~dp0output\%app_pkgname%.apk >nul
echo.
echo 已提取【%app_pkgname%】的安装包至
echo %~dp0output目录下. & start %~dp0output 
endlocal
pause
cls
goto menu


