@echo off
chcp 936
cd /d %~dp0
title AndoridС����v2--������
set "wait=ping 127.0.0.1 -n 5 >nul"
set MENU=call main.bat
set err=goto err
set partcode=echo **********************************
set "deltemp=if exist ".\*.txt" (del /f /q .\*.txt)"
set "choice_end=ECHO. & ECHO. ����������ȷ���ַ�,�ȴ�5�벢���������� & ping 127.0.0.1 -n 5 >nul & ECHO. & %MENU% & cls"
if not exist .\output (mkdir output)
mode con cols=60 lines=30
cls

:Part_Pre
%deltemp%
color e
cls
%partcode%
echo ѡ��һ��������
echo. 
echo ��1������
echo. 
echo ��2������ˢ��  
echo. 
echo ��3�����������ֻ��Ͳ���Ч�� 
echo. 
echo ��4������ˢ�� 
echo. 
echo ��5����ȡ���� 
echo. 
set choice= 
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" set mode=erase & set mode_name=���� & goto part_process
if "%choice%"=="2" set mode=flash & set mode_name=ˢ�� & goto part_process
if "%choice%"=="3" set mode=boot & set mode_name=���� & goto part_process
if "%choice%"=="4" goto batchflash
if "%choice%"=="5" goto part_output_pre
%choice_end%

::��4������ˢ��
:batchflash
set /p path=���뺬��img�ļ����ļ���:
%partcode%
echo �����ļ�����:
dir %path% /b > img.txt
type img.txt
%partcode%
echo ��������ļ�����Ϊ������ˢ�룬�����������
pause
for /f "tokens=1 delims=. " %%i in (img.txt) do (
    setlocal enabledelayedexpansion
    %partcode%
    echo ����ˢ��%%i����...
    set "file=%path%\%%i.img"
    fastboot flash %%i !file!
    endlocal
)
echo ˢд���,�����������������
pause >nul
%menu%

::��1������ ��2������ˢ�� ��3�����������ֻ��Ͳ���Ч��
:part_process
set partition=
set file= 
echo ���Ƚ��豸����fastbootģʽ��.
call chkdev.bat fastboot
if "%mode%"=="erase" set /p partition=����Ҫ�����ķ��������س� & echo ��������ֻ��ġ�%partition%������,ȷ��?
if "%mode%"=="flash" set /p partition=����Ҫˢ��ķ��������س� & set /p file=����Ҫˢ����ļ����س�: & echo ����ѡ�%file%��ˢ�뵽�ֻ��ġ�%partition%��������,ȷ��?
if "%mode%"=="boot" set /p file=����Ҫ�������ļ����س�: & echo ����ѡ�%file%����ʱ����,ȷ��?
set choice=
set /p choice=���뵥������ĸ��Y/N�����س��Լ���:
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="Y" fastboot %mode% %partition% %file% & goto defalut_over|| %err%
if "%choice%"=="N" goto Part_Pre
%choice_end%

::��5����ȡ����
:part_output_pre
%partcode%
echo.
echo ѡ��һ��������
echo.
echo ��1�����ֻ�����ȡ����ҪrootȨ�ޣ�
echo.
echo ��2���Ӻ���payload.bin�Ŀ�ˢ������ȡ 
echo.
echo ��3��ֱ����ȡpayload.bin�еľ���
echo.
set choice= 
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto part_output_adb
if "%choice%"=="2" goto unzip
if "%choice%"=="3" (
        setlocal enabledelayedexpansion
        set /p binpath=��������Ҫ�����bin�ļ�:
        set a=!date:~0,10!
        set filename=payload_!a:/=_!_%time::=_%
        echo �����������.
        pause >nul
        set a= 
        goto binunpack
)
%choice_end%

::���ֻ�����ȡ
:part_output_adb
%deltemp%
echo ���Ƚ��豸����adb��������adb��root��Ȩ
call chkdev.bat system
adb shell ls -al /dev/block/bootdevice/by-name > original.txt
for /f "tokens=8,10 delims= " %%i in (original.txt) do (
    echo %%i %%j >> after.txt
	echo %%i 
)
set partition=
set /p partition=�����б��Ѵ�ӡ�������������ȡ�ķ���:
findstr %partition% after.txt > target.txt
for /f "tokens=2 delims= " %%i in (target.txt) do (
	%partcode%
	setlocal enabledelayedexpansion
	echo �洢��%%i ·���£�������ȡ...
	adb shell " su -c 'dd if=%%i of=/sdcard/%partition%.img'" || echo ������ȡʧ�ܣ� & %err%
	adb pull /sdcard/%partition%.img %~dp0\output\partition_readback
	endlocal
	%partcode%
)
%deltemp%
start %~dp0\output\partition_readback & echo �Ѵ���ȡĿ¼!
 echo %partition%������ȡ���,�洢��outputĿ¼��,��������˻����˵�.
pause >nul
%menu%

::��ѹ��ˢ���ļ�
:unzip
cls 
echo.�����������ȡ��ˢ���к���payload.bin�ľ����ļ�
set /p package=���뿨ˢ��zip�ļ��Լ���:
for %%i in (%package%) do set filename=%%~ni
if exist .\output\%filename% (rmdir /s /q .\output\%filename%)
%partcode%
7z x %package% -ooutput\%filename% 
%partcode%
echo ��ѹ���
for /r ".\output\%filename%" %%a in (*.bin) do (
    echo bin�ļ�·��: %%a
    set binpath=%%a
    )
goto binunpack

::���bin�ļ�
:binunpack
cls
%partcode%
payload-dumper-go.exe -l %binpath%
%partcode%
echo �Ѵ�ӡ��ˢ���ھ����б�
echo ��ѡ�����:
echo ��1����ȡָ������2��ȫ����ȡ
set mode= 
set choice= 
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" goto binunpack_sigle
if "%choice%"=="2" goto binunpack_all
%choice_end%

:binunpack_sigle
CLS
payload-dumper-go.exe -l %binpath%
set partition=
set /p partition=�������Ҫ��ȡ�ķ���:
echo ������ȡ...
mkdir .\output\%filename%\img
payload-dumper-go.exe -p %partition% -o .\output\%filename%\img %binpath%
start .\output\%filename%\img
endlocal
cls
set choice= 
set /p choice=��ȡ���!�Ѵ���ȡĿ¼,������ȡ�ͻس��ɣ�����b������������
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="b" cls & %MENU%
echo.
goto binunpack_sigle

:binunpack_all
echo ���������ʼ��ȡ.
pause >nul
payload-dumper-go.exe -o .\output\unpackimg\img %binpath%
start .\output\unpackimg\img
echo ��ȡ���!�Ѵ���ȡĿ¼
pause >nul
%menu%

:
:err
color c
echo ***********************************************
echo ��������.
echo �������Ϸ��Ĵ�����ʾ�������������Ҳ��������.
echo ��������������˵�.
pause >nul
%menu%

:defalut_over
echo �����ɹ����,�����������������.
pause >nul
%MENU%


