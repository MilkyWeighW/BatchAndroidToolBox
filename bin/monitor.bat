@REM ���÷���
@REM call monitor [����] [����]
@REM             chkdev              ��������豸����״̬    ��������:���������
@REM             get_deviceinfo_adb  ��adb״̬������豸��Ϣ ��������:���������
@REM             listen              ����ǰ̨Ӧ��           ��������:���������

@REM             listapp             ���ϵͳ�͵�����Ӧ��    ��������:�ı��ļ� [.\output\app_processed.txt]
@REM                      -s         ���ϵͳӦ��
@REM                      -3         ���������Ӧ��

call public head
color a

set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
if "%var1%"=="" (
    set "adb_target=set status=1 & goto MENU"
    set "fb_target=set status=2 & goto MENU"
    goto chkdev
) else (
    if "%var1%"=="chkdev" (
        set "adb_target=echo 5s���ٴμ�� & %wait% & goto chkdev"
        set "fb_target=echo 5s���ٴμ�� & %wait% & goto chkdev"
        goto %var1%
    ) else (
        goto %var1%
    )
)

:chkdev
title �豸���Ӽ�����
echo.
%partcode%
echo %date%,%time%
%partcode%
for /f "tokens=1" %%a in ('adb devices^|findstr /r /c:"device$"') do (
    setlocal enabledelayedexpansion
    call chkdev system
    set device_name=%%a
    echo �����ӵ��豸��!device_name!
    endlocal
    %adb_target%
)
for /f "tokens=1" %%a in ('fastboot devices^|findstr /r /c:"device$"') do (
    setlocal enabledelayedexpansion
    call chkdev fastboot
    set device_name=%%a
    echo �����ӵ��豸��!device_name!
    endlocal
    %fb_target%
)
echo ��ǰδ�����κ������ӵ��豸��
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
title ������ - adb�豸����״̬
cls
echo.
%partcode%
echo.
echo. ��ѡ����Ҫ���ӵ�����:
echo.
echo ��1���������������豸���
echo.
echo ��2���������ӵ�ǰӦ��
echo.
echo ��3����ӡ��ǰӦ���б�
echo.
echo ��4��adb����Ϣ
echo.
%partcode%
echo.
set choice= 
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" start monitor chkdev & goto MENU_adb
if "%choice%"=="2" start monitor listen & goto MENU_adb
if "%choice%"=="3" goto listapp & goto MENU_adb
if "%choice%"=="4" (
    echo ��ȡ�豸��Ϣ��������...�������Ⱥ� 
    call :get_deviceinfo_adb > .\output\%devname%_info.txt
    echo ���ڴ�...
    start cmd /k type .\output\%devname%_info.txt
    goto adb_defalutover
)
%choice_end%

:get_deviceinfo_adb
::�ɱ��ⲿ���õ�ģ��
title adb״̬-��ȡ�豸��Ϣ
if "%var1%" == "" (
    echo.
) else (
    call chkdev system >nul
)

%partcode%
echo %date%,%time%
%partcode%
echo.
echo ----------Ӳ����Ϣ----------
set /p="�豸����    "<nul & adb shell getprop ro.product.name
set /p="���쳧��    "<nul & adb shell getprop ro.product.brand
set /p="�豸�ͺ�    "<nul & adb shell getprop ro.product.model
echo.
set /p="CPU����    "<nul & adb shell getprop ro.soc.manufacturer
set /p="--CPU�ͺ�  "<nul & adb shell getprop ro.board.platform
set /p="--ָ�:   "<nul & adb shell getprop ro.product.cpu.abilist
echo.
set /p="��������    "<nul & adb shell getprop ro.baseband
set /p="--SIM������ "<nul & adb shell getprop gsm.sim.operator.iso-country
set /p="--��Ӫ��    "<nul & adb shell getprop gsm.sim.operator.alpha
echo.
set /p="GPU����    "<nul & adb shell getprop ro.hardware
set /p="--OpenGL��Ⱦ�� "<nul & adb shell getprop ro.hardware.egl
set /p="--Vulkan��Ⱦ�� "<nul & adb shell getprop ro.hardware.vulkan
::������
echo.
echo ���״̬
for /f "tokens=1 delims=" %%a in ('adb shell dumpsys battery') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:false=��!
    set a=!a:true=��!
    set a=!a:Current Battery Service state:=---------!
    set a=!a: powered=����!
    set a=!a:AC=ֱ��!
    set a=!a:Dock=����!
    set a=!a:Wireless=����!
    set a=!a:Max charging current=���ʱ������[��A]!
    set a=!a:Max charging voltage=���ʱ����ѹ[��V]!
    set a=!a:Charge counter=˲ʱ�������[uA-h]!
    set a=!a:present=��װ���!
    set a=!a:level=��ǰ����!
    set a=!a:scale=�������!
    set a=!a:voltage=˲ʱ��ѹ[��V]!
    set a=!a:status=��ǰ״̬!
    set a=!a:health=����״̬!
    set a=!a:temperature=�¶�[?/10��C]!
    set a=!a:technology=����!
    set a=!a:Charging state=���״̬!
    set a=!a:Charging policy=���Э��! 
    echo --!a!
    endlocal
)
echo.
echo.
echo ��Ļ���
echo -----------
echo.
for /f "tokens=1 delims=" %%a in ('adb shell wm size') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Physical size=--����ֱ���!
    set a=!a:Override size=--ϵͳ��Ⱦ�ֱ���!
    echo !a!
    endlocal
)
echo.
for /f "tokens=1 delims=" %%a in ('adb shell wm density') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Physical density=--����DPI!
    set a=!a:Override density=--ϵͳ��ȾDPI!
    echo !a!
    endlocal
)
echo.
echo ----------�����Ϣ----------
echo.
set /p="ϵͳ�汾:   Android "<nul & adb shell getprop ro.system.build.version.release 
echo.
set /p="����SDK�汾:    "<nul & adb shell getprop ro.system.build.version.sdk 
set /p="���֧�ֵ�SDK�汾:  "<nul & adb shell getprop ro.build.version.min_supported_target_sdk
set /p="--ϵͳ��������: "<nul & adb shell getprop ro.build.type
set /p="--ϵͳ����ʱ��: "<nul & adb shell getprop ro.build.date
set /p="--��ȫ��������: "<nul & adb shell getprop ro.build.version.security_patch
set /p="--�ں˰汾: "<nul & adb shell getprop ro.kernel.version
set /p="--Selinux״̬:  "<nul & adb shell getenforce
echo.
echo �ֻ����ô洢��sdcard��״̬:
echo -----------------------------
echo.
for /f "tokens=5 delims= " %%a in ('adb shell df -h /sdcard') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Use^%=����!
    echo !a!
    endlocal
)
echo.
for /f "tokens=2 delims= " %%a in ('adb shell df -h /sdcard') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Size=�ܴ�С!
    echo !a!
    endlocal
)
echo.
for /f "tokens=1 delims= " %%a in ('adb shell df -h /sdcard') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Filesystem=�ļ�ϵͳ!
    echo !a!
    endlocal
)
echo.
for /f "tokens=6 delims= " %%a in ('adb shell df -h /sdcard') do (
    setlocal enabledelayedexpansion
    set a=%%a 
    set a=!a:Mounted=������!
    echo !a!
    endlocal
)
echo.
%partcode%
goto :eof

:listen
::�ɱ��ⲿ���õ�ģ��
title adb״̬-Ӧ�ü�����
call chkdev system >nul
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
if /i "%packageName%"=="NotificationShade}" ( echo ��ǰ��������/״̬��! & %wait% & endlocal & goto listen)
if /i "%packageName%"=="" ( echo ��ǰ�����л�Ӧ��! & %wait% & endlocal & goto listen )
echo ��ǰӦ�õİ���Ϊ:%packageName%
%wait%
endlocal
goto listen

:listapp
echo.
echo ѡ��һ��ѡ�����.
echo.
echo ��1��������Ӧ���б�.
echo ��2��ϵͳӦ���б�.
echo ��3������Ӧ���б�.
echo ��4����ȫ��Ҫ!
echo.
set choice= 
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
set fini=
if "%choice%"=="1" (
    call monitor applist_output -3 
    start cmd /k type .\output\*.txt || %err%
    goto adb_defalutover
)
if "%choice%"=="2" (
    call monitor applist_output -s 
    start cmd /k type .\output\*.txt || %err%
    goto adb_defalutover
)
if "%choice%"=="3" (
    call monitor applist_output -d 
    start cmd /k type .\output\*.txt || %err%
    goto adb_defalutover
)
if "%choice%"=="4" (
    call monitor applist_output
    start cmd /k type .\output\*.txt || %err%
    goto adb_defalutover
)
%choice_end%

:applist_output
::�ɱ��ⲿ���õ�ģ��
title adb״̬-Ӧ���б��ӡ��
call chkdev system >nul
set "listmode=%2"
for /f "tokens=1 delims=" %%a in ('Adb shell getprop ro.product.model') do (
    set "device_name=%%a"
)
echo.
echo ���Ե�,���ڴ���Ӧ�ü����б�...
echo �������Ҫ�ϳ�ʱ��
echo.

::���Ӧ�ð����б���packageǰ׺��
adb shell pm list packages %listmode% > .\temp\app.txt
(for /f "usebackq delims=" %%i in (".\temp\app.txt")do (
	set pkgname=%%i
	setlocal enabledelayedexpansion
    ::ȥ��ǰ���"package:"
	echo !pkgname:~8!
	endlocal
))>.\output\app_pkgname.txt 

::���Ӧ�ð�����Ӧ�İ�װ��·��
(for /f "usebackq delims=" %%a in (".\output\app_pkgname.txt")do (
    setlocal enabledelayedexpansion
    set "pkgname=%%a"
    adb shell pm path !pkgname! > .\temp\app_path_temp.txt
    ::��ȡ��һ��,������г���
    set /p line=<.\temp\app_path_temp.txt
    echo !line:~8!
    endlocal          
))>.\temp\app_path.txt

::��ȡӦ����(!!��Ҫ32λ֧��)
echo ���ڷ��͹��߰�...
echo.
@adb push aapt2-arm64 /data/local/tmp && echo ���ͳɹ�
@adb shell chmod 0755 /data/local/tmp/aapt2-arm64 && echo ��Ȩ�ɹ�

(for /f "usebackq delims=" %%a in (".\temp\app_path.txt")do (
    setlocal enabledelayedexpansion
    set "pkgpath=%%a"
    adb shell /data/local/tmp/aapt2-arm64 d badging !pkgpath! > .\temp\app_det_info.txt
    ::�Ҳ���Ӧ��������=������ת��
    type .\temp\app_det_info.txt | findstr /c:"application-label:" || echo =Noname=
    endlocal          
))>.\temp\app_label.txt
::ת�����룬�����������
call public convert_encode_utf82ANSI .\temp\app_label.txt
    for /f "usebackq delims=" %%a in (".\temp\app_label_ANSI.txt")do (
    setlocal enabledelayedexpansion
    set "appName=%%a"
    if "!appName!"=="=Noname=" (
        echo !appName:Noname=��Ӧ����!
    ) else (
        ::ȥ������Ԫ��
        set appName=!appName:'=! 
        set appName=!appName: =! 
        echo !appName:~18!  
    )
    endlocal
)>>.\temp\appName.txt
call public combine_2txts .\temp\appName.txt .\output\app_pkgname.txt .\temp\app_processed_before.txt
::�������б�ʶ��ͬ����һ������
(echo Ӧ������ ����
echo.
type .\temp\app_processed_before.txt
)>.\temp\app_processed.txt
::���ļ�����
call public align .\temp\app_processed.txt
@copy .\temp\out_app_processed.txt .\output\
call public getfilename
::�������ļ�
rename .\output\out_app_processed.txt [%device_name%]app_combined%listmode%_%filename%.txt
rename .\output\app_pkgname.txt [%device_name%]app_pkgname%listmode%_%filename%.txt
cls
echo Ӧ���б��ļ��ѱ�����outputĿ¼��
::�������������
set device_name= & set listmode=  & set filename=
@rmdir /s /q temp
@mkdir temp
echo.
goto :eof

:adb_defalutover
echo �����������.
pause>nul
goto :MENU_adb

:MENU_fastboot
echo ������...��������˳�
pause >nul
exit