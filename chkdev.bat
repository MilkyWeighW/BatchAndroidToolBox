::call chkdev system     rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            recovery   rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            sideload   rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            fastboot   rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            edl        rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            diag901d   rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            sprdboot   rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            mtkbrom    rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            all        rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)

@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%
set "wait=ping 127.0.0.1 -n 3 >nul"

:SYSTEM
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:SYSTEM-1
ECHO.���ڼ���豸����(ϵͳ)... & set try_times=0& adb.exe start-server>nul
:SYSTEM-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto SYSTEM-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}�ж��ADB�豸����! ��Ͽ������豸.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto SYSTEM-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto SYSTEM-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="device" TIMEOUT /T 1 /NOBREAK>nul & goto SYSTEM-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto SYSTEM-1
ECHO.�豸������(ϵͳ),3������ & %wait% 
exit /b 


:RECOVERY
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:RECOVERY-1
ECHO.���ڼ���豸����(Recovery)... & set try_times=0& adb.exe start-server 1>nul
:RECOVERY-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto RECOVERY-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}�ж��ADB�豸����! ��Ͽ������豸.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto RECOVERY-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto RECOVERY-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="recovery" TIMEOUT /T 1 /NOBREAK>nul & goto RECOVERY-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto RECOVERY-1
ECHO.�豸������(Recovery),3������ & %wait%
exit /b 

:SIDELOAD
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:SIDELOAD-1
ECHO.���ڼ���豸����(Sideload)... & set try_times=0& adb.exe start-server 1>nul
:SIDELOAD-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto SIDELOAD-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}�ж��ADB�豸����! ��Ͽ������豸.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto SIDELOAD-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto SIDELOAD-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="sideload" TIMEOUT /T 1 /NOBREAK>nul & goto SIDELOAD-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto SIDELOAD-1
ECHO.�豸������(Sideload),3������ & %wait%
exit /b 

:FASTBOOT
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:FASTBOOT-1
ECHO.���ڼ���豸����(Fastboot)... & set try_times=0
:FASTBOOT-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto FASTBOOT-1
set /a try_times+=1
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a GTR 1 ECHOC {%c_e%}�ж��Fastboot�豸����! ��Ͽ������豸.{%c_i%}{\n}& fastboot.exe devices | find "	" & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto FASTBOOT-1)
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOT-2)
for /f "tokens=2 delims= " %%i in ('fastboot.exe devices ^| find "	"') do (if not "%%i"=="fastboot" TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOT-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto FASTBOOT-1
ECHO.�豸������(Fastboot),3������ & %wait%
exit /b 

:FASTBOOTD
::���ղ���
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::��ʼ
:FASTBOOTD-1
ECHO.���ڼ���豸����(Fastbootd)... & set try_times=0
:FASTBOOTD-2
if %try_times% GTR 30 ECHO.����δ��⵽Ŀ���豸, ����������¼��... & pause>nul & goto FASTBOOTD-1
set /a try_times+=1
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a GTR 1 ECHOC {%c_e%}�ж��Fastboot�豸����! ��Ͽ������豸.{%c_i%}{\n}& fastboot.exe devices | find "	" & ECHOC {%c_h%}����������¼��...{%c_i%}{\n}& pause>nul & goto FASTBOOTD-1)
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOTD-2)
for /f "tokens=2 delims= " %%i in ('fastboot.exe devices ^| find "	"') do (if not "%%i"=="fastboot" TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOTD-2)
::Ŀ���豸�Ѿ���⵽
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%����ٴμ��, ���Ժ�... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto FASTBOOTD-1
ECHO.�豸������(Fastbootd),3������ & %wait%
exit /b 




:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)

