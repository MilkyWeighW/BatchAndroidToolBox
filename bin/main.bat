call public.bat head

:MENU
%deltemp%
color b
cls
echo ��ϡ�����.bat��Ч������.
echo �������û�С��������˵���ѡ��Ļ�,����һ�������ֵ����.
echo ��ֻ����һ���豸,����ģ����!
%partcode%
echo ѡ��һ�������Լ���.
echo.
echo ��1�������뾵����ز���.
echo.
echo ��2��adb��ˢ.
echo.
echo ��3��Ӧ�ù���.
echo.
echo ��4�������.
echo.
echo ��5���ֻ���Ϣ�鿴.
echo.
echo ��6������Ӧ�ð�װ.
echo.
echo ��7����ˢ���򿪿������У�.
echo.
echo ��8������adb����.
echo.
echo ��9������.
echo.
%partcode%
set choice= 
set /p choice=�������Ӧ���ֻس���
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="1" call image.bat
if "%choice%"=="2" goto sideload
if "%choice%"=="3" echo ���Ƚ��豸����adb & call call chkdev.bat system & call app.bat skipchk
if "%choice%"=="4" goto others
if "%choice%"=="5" goto info
if "%choice%"=="6" goto installapp
if "%choice%"=="7" goto batFlash
if "%choice%"=="8" adb kill-server & adb start-server & echo �������! & %wait% & %menu%
if "%choice%"=="9" goto credit
%choice_end%

::Ӧ�ð�װ
:installapp
echo.
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

::ˢ��
:sideload
echo ���Ƚ��豸����Recoveryģʽ��,���ҿ�����adb��ˢ/sideload��ģʽ.
echo ��ͬRecovery�з����ܲ�ͬ,������ڡ��߼���ѡ����,����ȥ����.
call chkdev.bat sideload
set /p file=����Ҫˢ����ļ����س�:
echo �������ˢ��.
pause >nul
adb sideload %file% || %err%
echo �����ɹ����,�����ʽ��data��ȷ���ɾ�ˢ��
echo ��������������˵�.
pause >nul
%MENU%

:batFlash
cls
echo ������ˢ���е�bat�ű����س�.
echo һ��ѡ��flash_all������.
echo ע�ⲻҪѡ���С�lock��������batŶ,��������������bootloader!
cd /d "%~dp0"
cmd /k
exit

::�����
:others
%partcode%
echo ѡ��һ�������Լ���.
echo ��1��bootloader���� 
echo.
echo ��2��ɾ���ֻ��������루��root�� 
echo.
echo ��3����adbshell 
echo.
echo ��4��������֤����������
echo.
set choice=
set /p choice=�������Ӧ���ֻس���
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
	echo �豸�ѽ�������������������˵�
	pause >nul
	%menu%
)
echo ȷ���ڲ��ֻ������ѿ���OEM��������.
set /p key=���������(������):
echo ��ʼ����...
if "%key%"==" " fastboot flashing unlock
fastboot oem unlock %key% || %err%
echo �����ɹ����!������������ϼ����˵�
pause >nul
goto others

:crack
echo �ó���ͨ��ɾ��/data/system/locksetting.db��ʵ��.
echo �����������ִ��.
pause >nul
call chkdev.bat system
adb shell " su -c 'rm /data/system/locksetting.db'" || echo ɾ������ʧ�ܣ� && %err%
echo �����ɹ����!������������ϼ��˵�
pause >nul
goto others

:adb_shell
echo ���ڴ�adbShell...
call chkdev.bat system
adb shell || %err%

:Internet_verify_change
pause
call chkdev.bat system
adb shell settings put global captive_portal_http_url http://developers.google.cn/generate_204
adb shell settings put global captive_portal_https_url https://developers.google.cn/generate_204
adb shell settings put global ntp_server time.asia.apple.com
echo �������.��������������˵�
pause >nul
%menu%

:info
cls
echo ����ӡ�ֻ���Ϣ,�ù�����Ҫ����CAT����adb��su...
call chkdev.bat system
echo �ͺ�:
%partcode%
adb shell getprop ro.product.model || echo ��ӡʧ��!
%partcode%
echo ���״��:
adb shell dumpsys battery || echo ��ӡʧ��!
%partcode%
echo ��Ļ�ֱ���:
adb shell wm size || echo ��ӡʧ��!
%partcode%
echo ��Ļ�ܶ�:
adb shell wm density || echo ��ӡʧ��!
%partcode%
echo ��ʾ������:
adb shell dumpsys window displays || echo ��ӡʧ��!
%partcode%
echo Androidϵͳ�汾:
adb shell getprop ro.build.version.release || echo ��ӡʧ��!
%partcode%
echo CPU��Ϣ:
adb shell cat /proc/cpuinfo || echo ��ӡʧ��!
%partcode%
echo �ڴ���Ϣ:
adb shell cat /proc/meminfo || echo ��ӡʧ��!
%partcode%
echo.
echo ��������������˵�...
pause >nul
%menu%

:credit
cls
echo ��������ѭ AGPL v3 ��ԴЭ��
echo.
echo AndroidС���� V2.1.0  ---BY MilkyWeigh--- 
echo.
echo chkdev.bat ����BFF ---BY ĳ��---
echo Oringal Link : https://gitee.com/mouzei/bff
echo.
echo.payload-dumper-go.exe ---BY ssut---
echo.Oringal Link : https://github.com/ssut/payload-dumper-go
echo ��л���ʹ��!
pause >nul
%menu%

