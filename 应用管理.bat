::���������ļ�֧���ⲿ��������
::�÷�	: call Ӧ�ù���.bat [MODE] [FILE]
::
::����	: call Ӧ�ù���.bat skipchk 			������adb�豸����У�顿
::		: call Ӧ�ù���.bat uninstall 1.txt		��ж��1.txt������������
::							disable				ͣ��
::							enable				����

@echo off
color b
chcp 936
cd /d %~dp0
title AndroidС����V2--Ӧ�ù�����
set unicode=����������ȷ���ַ�,�ȴ�5�벢����������
set "wait=ping 127.0.0.1 -n 5 >nul"
set err=goto err
set MENU=call ������.bat
set deltemp=del /q *.txt
set partcode=echo **********************************
set "choice_end=ECHO. & ECHO. ����������ȷ���ַ�,�ȴ�5�벢���������� & ping 127.0.0.1 -n 5 >nul & ECHO. & %MENU% & cls"
set skip=0
cls

::���ܲ���
set command=%1
if "%command%"=="skipchk" ( set skip=1 & goto app ) 
if "%command%"=="uninstall" ( set directly_process=1 & set "mode=uninstall" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 
if "%command%"=="disable" ( set directly_process=1 & set "mode=shell pm disable-user" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 
if "%command%"=="enable" ( set directly_process=1 & set "mode=shell enable" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 


::Ӧ�ù�����
:app
if "%skip%"=="0" ( echo ���Ƚ��豸����adb & call chkdev.bat system & call Ӧ�ù���.bat skipchk)
%deltemp%
cls
echo ����չʾӦ���б�,ѡ��һ��ѡ�����.
echo ��1��չʾ������Ӧ���б�.
echo ��2��չʾϵͳӦ���б�.
echo ��3����ȫ��Ҫ!
set choice= 
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" set listmode=������ & adb shell pm list packages -3 > applist.txt & goto output || %err%
if "%choice%"=="2" set listmode=ϵͳ & adb shell pm list packages -s > applist.txt & goto output || %err%
if "%choice%"=="3" set listmode=ȫ�� & adb shell pm list packages > applist.txt & goto output|| %err%
%choice_end%

::�������ɵ��ı�
:output
(for /f "usebackq delims=" %%i in ("applist.txt")do (
	echo %%i>con
	set h=%%i
	setlocal enabledelayedexpansion
	echo !h:~8!
	endlocal
))>������app�б�.txt
cls
goto app1

::����ʽѡ��
:app1
type ������app�б�.txt
echo. & echo.
echo �Ѵ�ӡ%listmode%Ӧ�õ��б�!��ѡ��һ������.
echo ��1��ж��Ӧ��/������� ��2��ͣ��Ӧ��(����) ��3��ͣ��Ӧ��(����) 
echo ��4������Ӧ��(����)��5������Ӧ��(����)��6����ȡ����Ӧ�ð�װ�� ��7���ص���һ�� ��8���˻����˵�
set choice=
set mode=
set /p choice=�������Ӧ���ֻس���
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

::ж�ص���Ӧ��
:uninstall_clear_app
echo.
echo.$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
echo ѡ��һ������:
echo ��1��ж��һ��Ӧ�ñ�������.
echo ��2��ж��һ��Ӧ�ã����������ݺͻ����ļ�.
echo ��3������ж��
echo ��4������һ��Ӧ�õ�����
set choice= 
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" set mode=  & goto uninstall_clear_app_execute
if "%choice%"=="2" set mode=-k & goto uninstall_clear_app_execute
if "%choice%"=="3" set mode=uninstall & goto uninstall_diable_enable_Multiple
if "%choice%"=="4" goto clearapp
%choice_end%

:uninstall_clear_app_execute
if "%mode%"=="" set mode_name=��ȫж��
if "%mode%"=="-k" set mode_name=ж�أ��������������ݺͻ����ļ�
echo ��ѡ����: %mode_name%
set /p pkgname=����һ����ϵͳӦ�õİ�����س� :
echo ��ʼж��%pkgname%��ȫ��...
adb uninstall %mode% %pkgname% || echo ��Ч�Ĳ���. & %err%
goto fini_uninst

:clearapp
set /p pkgname=����һ����ϵͳӦ�õİ�����س�:
echo ��ʼ����%pkgname%������...
adb clear %pkgname% || echo ��Ч�Ĳ���. & %err%
goto fini_uninst

::����Ӧ�õ���ͣ
:disable_enable_app_Single
if "%mode%"=="shell pm disable-user" set mode_name=ͣ��
if "%mode%"=="shell enable" set mode_name=����
echo ��ѡ���ˣ�%mode_name% ����Ӧ��
set /p pkgname=����һ��Ӧ�õİ�����س�:
echo �����������.
pause >nul
adb %mode% %pkgname% || %err%
echo �����ɹ����!������������ϼ��˵�.
pause >nul
goto app1

::���д�����
:uninstall_diable_enable_Multiple
if "%mode%"=="uninstall" set mode_name=ж��
if "%mode%"=="shell pm disable-user" set mode_name=ͣ��
if "%mode%"=="shell enable" set mode_name=����
echo ���봦�����txt�ļ���������Ҫ���а���,һ��һ������.����%mode_name%ϵͳӦ��
echo ʾ��:
echo example.txt--------���浽���ߵĵط�����txt�ļ�����--------------
echo.
echo com.baoming.baoming
echo.
echo ---�����������ļ���,���򽫻�%mode_name%"com.baoming.baoming"���Ӧ��--
echo ��ʾ:�����ӡ��Ӧ���б����һ��,��������ĸ�Ŀ¼,��������txt�ļ�,ѡ�����ľͿ���.
echo �����Խ�����رպ��б���������Ҫ��Ӧ�õİ���ɾȥ,�����������ҪӦ��.
set /p file=���봦�����txt�ļ�:
goto uninstall_diable_enable_Multiple_excute

:uninstall_diable_enable_Multiple_excute
if "%directly_process%"="1" (echo ���Ƚ��豸����adb & call chkdev.bat system & call Ӧ�ù���.bat skipchk)
set targe=''
setlocal enabledelayedexpansion
for /f  %%i in (%file%)  do (
set target=%%i
adb %mode% !target! || goto err
) 
if "%directly_process%"=="1" goto defalut_over
goto fini_uninst_disable_enable

:fini_uninst_disable_enable
echo ���%mode_name%,��������������ϼ��˵�.
pause >nul
goto app1

::��ȡӦ�ð�װ��
:apkout
setlocal enabledelayedexpansion
set /p app_pkgname=������Ҫ��ȡӦ�õİ���:
for /f "delims=" %%i in ('adb shell pm path %app_pkgname%') do set path_package=%%i 
set path_package=!path_package:~8!
adb pull %path_package% %~dp0output\%app_pkgname%.apk
echo ����ȡ��%app_pkgname%���İ�װ����������outputĿ¼��.
endlocal
pause
cls
goto app1

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
