::���������ļ�֧���ⲿ��������
::�÷�	: call app.bat [MODE] [FILE]
::		: call app.bat uninstall 1.txt	    ��ж��1.txt������������
::					   disable			   ��ж��1.txt������������
::					   enable			   ��ж��1.txt������������
call public.bat head

::���ܲ���
set command=%1
if "%command%"=="uninstall" ( set directly_process=1 & set "mode=uninstall" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 
if "%command%"=="disable" ( set directly_process=1 & set "mode=shell pm disable-user" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 
if "%command%"=="enable" ( set directly_process=1 & set "mode=shell enable" & set file=%2 & goto uninstall_diable_enable_Multiple_excute ) 


::Ӧ�ù�����

::����ʽѡ��
:menu
color 3
title Ӧ�ù���
echo. 
echo ��ѡ��һ������.
echo.
echo ��0�����Ӧ���б�
echo.
echo ��1��ж��Ӧ��/������� 
echo.
echo ��2��ͣ��Ӧ��(����) ��3��ͣ��Ӧ��(����) 
echo.
echo ��4������Ӧ��(����) ��5������Ӧ��(����) 
echo.
echo ��6����ȡ����Ӧ�ð�װ�� 
echo.
echo ��7����װӦ��(����) ��8����װӦ��(����)
echo.
set choice=
set mode=
set /p choice=�������Ӧ���ֻس���
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
set /p path=���뺬��apk�ļ����ļ���:
%partcode%
echo �����ļ�����:
dir %path% /b > apks.txt
type apks.txt
%partcode%
echo ���ᰲװ��Щ�ļ��������������
pause
for /f "tokens=1 delims=. " %%i in (apks.txt) do (
    setlocal enabledelayedexpansion
    %partcode%
    echo ���ڰ�װ%%i...
    set "file=%path%\%%i.apk"
    adb install !file!
    endlocal
)
echo ��װ���,�����������������
pause >nul
%menu%

:installapp_single
echo.
set file=
set /p file=����apk��װ��,Ȼ��س�.
echo ��ʼ��װ...
adb install %file% || %err%
echo ���!�������������װ,���롾b������.
set choice= 
set /p choice=������װ�ͻس��ɣ�
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="b" cls & %MENU%
echo.
goto installapp

:applist_output
title Ӧ�ù���
echo.
echo ѡ��һ��ѡ�����.
echo.
echo ��1��չʾ������Ӧ���б�.
echo ��2��չʾϵͳӦ���б�.
echo ��3����ȫ��Ҫ!
echo.
set choice= 
set /p choice=�������Ӧ���ֻس���
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

::ж�ص���Ӧ��
:uninstall_clear_app
echo.
%partcode%
echo ѡ��һ������:
echo.
echo ��1��ж��һ��Ӧ�ñ�������.
echo.
echo ��2��ж��һ��Ӧ�ã����������ݺͻ����ļ�.
echo.
echo ��3������ж��
echo.
echo ��4������һ��Ӧ�õ�����
echo.
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
adb uninstall %mode% %pkgname% || %err%
goto fini_uninst

:clearapp
set /p pkgname=����һ����ϵͳӦ�õİ�����س�:
echo ��ʼ����%pkgname%������...
adb clear %pkgname% || %err%
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
goto menu

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
echo ��ʾ:�����ӡ��Ӧ���б����һ��,���������binĿ¼,��������txt�ļ�,ѡ�����ľͿ���.
echo �����Խ�����رպ��б���������Ҫ��Ӧ�õİ���ɾȥ,�����������ҪӦ��.
set /p file=���봦�����txt�ļ�:
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
echo ���%mode_name%,��������������ϼ��˵�.
pause >nul
goto menu

::��ȡӦ�ð�װ��
:apkout
setlocal enabledelayedexpansion
set /p app_pkgname=������Ҫ��ȡӦ�õİ���:
for /f "delims=" %%i in ('adb shell pm path %app_pkgname%') do set path_package=%%i 
set path_package=!path_package:~8!
echo.
echo ������ȡ�����Ե�...
adb pull %path_package% %~dp0output\%app_pkgname%.apk >nul
echo.
echo ����ȡ��%app_pkgname%���İ�װ����
echo %~dp0outputĿ¼��. & start %~dp0output 
endlocal
pause
cls
goto menu


