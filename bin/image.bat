call public.bat head 

:menu
%deltemp%
color e
cls
%partcode%
echo 选择一个操作：
echo. 
echo 【1】擦除
echo. 
echo 【2】单个刷入  
echo. 
echo 【3】启动（部分机型不生效） 
echo. 
echo 【4】批量刷入 
echo. 
echo 【5】提取镜像 
echo. 
echo 【6】镜像解包
echo.
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" set mode=erase & set mode_name=擦除 & goto part_process
if "%choice%"=="2" set mode=flash & set mode_name=刷入 & goto part_process
if "%choice%"=="3" set mode=boot & set mode_name=启动 & goto part_process
if "%choice%"=="4" goto batchflash
if "%choice%"=="5" goto part_output_pre
if "%choice%"=="6" goto img_unpack_pre
%choice_end%

::【4】批量刷入
:batchflash
set /p path=拖入含有img文件的文件夹:
%partcode%
echo 所有文件如下:
dir %path% /b > img.txt
type img.txt
%partcode%
echo 将会根据文件名作为分区名刷入，按任意键继续
pause
for /f "tokens=1 delims=. " %%i in (img.txt) do (
    setlocal enabledelayedexpansion
    %partcode%
    echo 正在刷入%%i分区...
    set "file=%path%\%%i.img"
    fastboot flash %%i !file!
    endlocal
)
echo 刷写完成,按任意键返回主程序
pause >nul
%menu%

::【1】擦除 【2】单个刷入 【3】启动（部分机型不生效）
:part_process
set partition=
set file= 
echo 请先将设备置于fastboot模式中.
call chkdev.bat fastboot
if "%mode%"=="erase" set /p partition=输入要擦除的分区名并回车 & echo 将会擦除手机的【%partition%】分区,确认?
if "%mode%"=="flash" set /p partition=输入要刷入的分区名并回车 & set /p file=拖入要刷入的文件并回车: & echo 将会把【%file%】刷入到手机的【%partition%】分区内,确认?
if "%mode%"=="boot" set /p file=拖入要启动的文件并回车: & echo 将会把【%file%】临时启动,确认?
set choice=
set /p choice=键入单个首字母【Y/N】并回车以继续:
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="Y" fastboot %mode% %partition% %file% & %defalut_over% || %err%
if "%choice%"=="N" goto menu
%choice_end%

::【5】提取镜像
:part_output_pre
%partcode%
echo.
echo 选择一个操作：
echo.
echo 【1】从手机中提取（需要root权限）
echo.
echo 【2】从含有payload.bin的卡刷包中提取 
echo.
echo 【3】直接提取payload.bin中的镜像
echo.
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto part_output_adb
if "%choice%"=="2" goto unzip
if "%choice%"=="3" (
        setlocal enabledelayedexpansion
        set /p binpath=请拖入想要解包的bin文件:
        set a=!date:~0,10!
        set filename=payload_!a:/=_!_%time::=_%
        echo 按任意键继续.
        pause >nul
        set a= 
        goto binunpack
)
%choice_end%

::从手机中提取
:part_output_adb
%deltemp%
echo 请先将设备连接adb，并允许adb的root授权
call chkdev.bat system
adb shell ls -al /dev/block/bootdevice/by-name > original.txt
for /f "tokens=8,10 delims= " %%i in (original.txt) do (
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
	adb shell " su -c 'dd if=%%i of=/sdcard/%partition%.img'" || echo 分区提取失败！ && %err%
	adb pull /sdcard/%partition%.img %~dp0\output\partition_readback
	endlocal
	%partcode%
)
%deltemp%
start %~dp0\output\partition_readback & echo 已打开提取目录!
 echo %partition%分区提取完成,存储于output目录下,按任意键退回主菜单.
pause >nul
%menu%

::解压卡刷包文件
:unzip
cls 
echo.本程序可以提取卡刷包中含有payload.bin的镜像文件
set /p package=拖入卡刷包zip文件以继续:
for %%i in (%package%) do set filename=%%~ni
if exist .\output\%filename% (rmdir /s /q .\output\%filename%)
%partcode%
7z x %package% -ooutput\%filename% 
%partcode%
echo 解压完成
for /r ".\output\%filename%" %%a in (*.bin) do (
    echo bin文件路径: %%a
    set binpath=%%a
    )
goto binunpack

::解包bin文件
:binunpack
cls
%partcode%
payload-dumper-go.exe -l %binpath%
%partcode%
echo 已打印卡刷包内镜像列表
echo 请选择操作:
echo 【1】提取指定镜像【2】全部提取
set mode= 
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto binunpack_sigle
if "%choice%"=="2" goto binunpack_all
%choice_end%

:binunpack_sigle
CLS
payload-dumper-go.exe -l %binpath%
set partition=
set /p partition=请键入想要提取的分区:
echo 正在提取...
mkdir .\output\%filename%\img
payload-dumper-go.exe -p %partition% -o .\output\%filename%\img %binpath%
start .\output\%filename%\img
endlocal
cls
set choice= 
set /p choice=提取完成!已打开提取目录,继续提取就回车吧，输入b键返回主菜单：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="b" cls & %MENU%
echo.
goto binunpack_sigle

:binunpack_all
call public.bat getfilename
echo 按任意键开始提取.
pause >nul
payload-dumper-go.exe -o .\output\all_unpack\img %binpath%
start .\output\unpackimg\img
echo 提取完成!已打开提取目录
pause >nul
%menu%

:img_unpack_pre
cls
echo.
echo 选择一个操作：
echo.
echo 【1】.br转.dat
echo.
echo 【2】.dat转.img
echo.
echo 【3】.img解包
echo.
echo 【4】直接解包.br
echo.
set choice= 
set /p choice=请输入对应数字回车：
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto br2dat
if "%choice%"=="2" goto dat2img
if "%choice%"=="3" goto img_unpack
if "%choice%"=="4" goto br_unpack
%choice_end%

:br2dat
set /p file=拖入有效的.br文件并回车:
call public.bat getfilename
pause
echo 正在转换，请等待...
brotli.exe -d %file% -o .\output\rename.dat
%wait%
ren .\output\rename.dat "%filename%.dat"
start .\output\
echo 已打开转换目录
%defalut_over%

:dat2img
set /p file=拖入有效的.dat文件并回车:
call public.bat getfilename
set /p listfile=拖入与之对应的.list文件并回车:
pause
echo 正在转换，请等待...
sdat2img.exe %file% %listfile% .\output\rename.img
ren .\output\rename.dat "%filename%.dat"
start .\output\
echo 已打开转换目录
%defalut_over%

:img_unpack
set /p file=拖入有效的.img文件并回车:
call public.bat getfilename
pause
echo 正在转换，请等待...
mkdir .\output\%filename%
Imgextractor.exe %file% .\output\%filename%\ >nul
start .\output\%filename%\
echo 已打开转换目录
%defalut_over%

:br_unpack
set /p file=拖入有效的.br文件并回车:
call public.bat getfilename
set /p listfile=拖入与之对应的.list文件并回车:
pause
echo 正在转换，请等待...
if not exist .\TEMP (mkdir TEMP)
brotli.exe -d %file% -o .\TEMP\tmp.dat
echo 已完成(1/3)
set file=.\TEMP\tmp.dat
sdat2img.exe %file% %listfile% .\TEMP\tmp.img
echo 已完成(2/3)
set file=.\TEMP\tmp.img
Imgextractor.exe %file% .\output\%filename%\ >nul
echo 已完成(3/3)
start .\output\%filename%\
echo 已打开转换目录
rmdir /s /q .\TEMP
%defalut_over%

