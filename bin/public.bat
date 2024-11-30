set command=%1
goto %command%

:head
@echo off
chcp 936
cd /d %~dp0
set "wait=ping 127.0.0.1 -n 5 >nul"
set MENU=goto menu
set "err=call public.bat err & goto menu"
set "defalut_over=call public.bat defalut_over & goto menu"
set partcode=echo **********************************
set "deltemp=if exist ".\*.txt" (del /f /q .\*.txt)"
set "choice_end=ECHO. & ECHO. 【请输入正确的字符,等待5秒并滚回主菜单】 & ping 127.0.0.1 -n 5 >nul & ECHO. & %MENU% & cls"

if exist ".\temp" (rmdir /s /q temp)
if exist ".\output" (rmdir /s /q output)
mkdir output
mkdir temp
mode con cols=60 lines=30
cls
goto :eof


:err
color c
%partcode%
echo 发生错误.
echo 可以用上方的错误提示结合搜索引擎查找并解决错误.
echo 按任意键返回主菜单.
pause >nul
goto :eof

:defalut_over
echo 操作成功完成,按任意键返回主菜单.
pause >nul
goto :eof 

:getfilename
set filename=
if not "%file%"=="" for %%i in (%file%) do set filename=%%~ni
if not "%binpath%"=="" for %%i in (%binpath%) do set filename=%%~ni
if not "%package%"=="" for %%i in (%package%) do set filename=%%~ni
setlocal enabledelayedexpansion
set a=!date:~0,10!
set filename=!filename!!a:/=!_%time::=%
set filename=!filename:.=!
echo %filename% > filename.txt
endlocal
set /p filename=<filename.txt
del /q filename.txt
set filename=%filename: =%
goto :eof

:pycheck
py -V || goto :eof
set py_status=1
goto :eof

:pyinstall
cls
echo Python未安装!按任意键开始安装.
pause >nul
PowerShell -executionpolicy bypass -Command "(wget -O C:\Python_setup.exe https://www.python.org/ftp/python/3.12.4/python-3.12.4-amd64.exe) ;cmd /c C:\Python_setup.exe /quiet TargetDir=C:\Program Files\Python InstallAllUsers=1 PrependPath=1 Include_test=0"
if %errorlevel%==0 (
        echo 安装成功
) else (
    echo 安装失败！请检查网络连接并确保系统无异常.
)
goto :eof

:get_string_length
@echo off & setlocal enabledelayedexpansion
set arg1=%~2
set count=0
if not defined arg1 goto :eof
:get_string_length_loop
if not "!arg1:~%count%,1!" == "" (
    set /a count+=1
    goto get_string_length_loop
)
echo %count%
goto :eof

:align
@echo off
setlocal enabledelayedexpansion
set input=%2
for /f "tokens=1 delims=" %%i in ('dir /b %input%') do (
    set "input_name=%%i"
)
set /a m=line=1&set "act=set/p=,&set/a m=1"
for %%i in ("%input%") do fsutil file creATenew "%input%.zero" %%~zi >nul
(for /f "tokens=2" %%a in ('fc /b "%input%" "%input%.zero"^|findstr /irc:"[0-9A-F]*: [0-9A-F][0-9A-F] 00"') do (
    if /i "%%a"=="0A" (echo,&set/a m=1,line+=1,col=0) else if /i "%%a"=="0D" (echo,
        for %%l in (!line!) do for /l %%i in (1,1,!col!) do (
            if !C%%i_%%l! gtr !C%%imax! set/a C%%imax=C%%i_%%l
            set "C%%i_%%l="
            ) ) else if /i "%%a"=="20" (%act%) else if /i "%%a"=="09" (%act%) else (
                    set/p=%%a
                    set /a col+=m,m=0
                    set /a C!col!_!line!+=1
                   )
        ))<nul >"%input%.temp"
(for /f "delims=" %%a in (%input%.temp) do (
    set /a col=0
    for %%i in (%%a) do (
        set /a col+=1&set "space="
        set /a size=C!col!max,len=size*2+2
        for /l %%i in (1,1,!size!) do set "space=!space!20"
        set "outstr=%%i!space!"
        for %%i in (!len!) do echo,!outstr:~0,%%i!
        )   
    set /p =0d0a
)   )<nul >".\temp\out_%input_name%"
del /q "%input%.zero" "%input%.temp" 
certutil -decodehex -f ".\temp\out_%input_name%" ".\temp\out_%input_name%" >nul
goto :eof

:combine_2txts
set "file1=%2"
set "file2=%3"
set "output=%4"
@echo off
(for /f "delims=" %%i in ('type %file1%') do (
    setlocal enabledelayedexpansion
    set i=%%i
    set /p str=
    echo !i! !str!
    endlocal
))<%file2% >%output%
goto :eof

:convert_encode_utf82ANSI
::UTF-8 to ANSI
::UTF-8 → Unicode
CHCP 65001
::如果输入的 UTF-8 没有 BOM，%~dpn2_unicode-without-BOM.txt 打开乱码
CMD /D /U /C  TYPE %~2 > %~dpn2_unicode-without-BOM.txt
::取得 Unicode BOM
ECHO.//4=>U.bom
certutil -decode -f U.bom U.bom >NUL
::Unicode → Unicode BOM
CHCP 936 >nul
MOVE /y  U.bom  %~dpn2_Unicode-BOM.txt >NUL
TYPE %~dpn2_unicode-without-BOM.txt >> %~dpn2_Unicode-BOM.txt
::Unicode BOM → ANSI
TYPE %~dpn2_Unicode-BOM.txt > %~dpn2_ANSI.txt
DEL /Q /F %~dpn2_unicode-without-BOM.txt %~dpn2_Unicode-BOM.txt
goto :eof