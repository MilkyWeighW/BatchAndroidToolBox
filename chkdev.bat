::call chkdev system     rechk(可选)  复查前等待秒数(默认3)
::            recovery   rechk(可选)  复查前等待秒数(默认3)
::            sideload   rechk(可选)  复查前等待秒数(默认3)
::            fastboot   rechk(可选)  复查前等待秒数(默认3)
::            edl        rechk(可选)  复查前等待秒数(默认3)
::            diag901d   rechk(可选)  复查前等待秒数(默认3)
::            sprdboot   rechk(可选)  复查前等待秒数(默认3)
::            mtkbrom    rechk(可选)  复查前等待秒数(默认3)
::            all        rechk(可选)  复查前等待秒数(默认3)

@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%
set "wait=ping 127.0.0.1 -n 3 >nul"

:SYSTEM
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:SYSTEM-1
ECHO.正在检查设备连接(系统)... & set try_times=0& adb.exe start-server>nul
:SYSTEM-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto SYSTEM-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}有多个ADB设备连接! 请断开其他设备.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto SYSTEM-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto SYSTEM-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="device" TIMEOUT /T 1 /NOBREAK>nul & goto SYSTEM-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto SYSTEM-1
ECHO.设备已连接(系统),3秒后继续 & %wait% 
exit /b 


:RECOVERY
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:RECOVERY-1
ECHO.正在检查设备连接(Recovery)... & set try_times=0& adb.exe start-server 1>nul
:RECOVERY-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto RECOVERY-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}有多个ADB设备连接! 请断开其他设备.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto RECOVERY-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto RECOVERY-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="recovery" TIMEOUT /T 1 /NOBREAK>nul & goto RECOVERY-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto RECOVERY-1
ECHO.设备已连接(Recovery),3秒后继续 & %wait%
exit /b 

:SIDELOAD
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:SIDELOAD-1
ECHO.正在检查设备连接(Sideload)... & set try_times=0& adb.exe start-server 1>nul
:SIDELOAD-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto SIDELOAD-1
set /a try_times+=1
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a GTR 1 ECHOC {%c_e%}有多个ADB设备连接! 请断开其他设备.{%c_i%}{\n}& adb.exe devices -l | find /v "List of devices attached" | find " " & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto SIDELOAD-1)
for /f %%a in ('adb.exe devices -l ^| find /v "List of devices attached" ^| find /c " "') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto SIDELOAD-2)
for /f "tokens=2 delims= " %%i in ('adb.exe devices -l ^| find /v "List of devices attached"') do (if not "%%i"=="sideload" TIMEOUT /T 1 /NOBREAK>nul & goto SIDELOAD-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto SIDELOAD-1
ECHO.设备已连接(Sideload),3秒后继续 & %wait%
exit /b 

:FASTBOOT
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:FASTBOOT-1
ECHO.正在检查设备连接(Fastboot)... & set try_times=0
:FASTBOOT-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto FASTBOOT-1
set /a try_times+=1
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a GTR 1 ECHOC {%c_e%}有多个Fastboot设备连接! 请断开其他设备.{%c_i%}{\n}& fastboot.exe devices | find "	" & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto FASTBOOT-1)
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOT-2)
for /f "tokens=2 delims= " %%i in ('fastboot.exe devices ^| find "	"') do (if not "%%i"=="fastboot" TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOT-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto FASTBOOT-1
ECHO.设备已连接(Fastboot),3秒后继续 & %wait%
exit /b 

:FASTBOOTD
::接收参数
SETLOCAL
if "%var2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%var3%"=="" (set rechk_wait=%var3%) else (set rechk_wait=3)
::开始
:FASTBOOTD-1
ECHO.正在检查设备连接(Fastbootd)... & set try_times=0
:FASTBOOTD-2
if %try_times% GTR 30 ECHO.本次未检测到目标设备, 按任意键重新检测... & pause>nul & goto FASTBOOTD-1
set /a try_times+=1
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a GTR 1 ECHOC {%c_e%}有多个Fastboot设备连接! 请断开其他设备.{%c_i%}{\n}& fastboot.exe devices | find "	" & ECHOC {%c_h%}按任意键重新检查...{%c_i%}{\n}& pause>nul & goto FASTBOOTD-1)
for /f %%a in ('fastboot.exe devices ^| find /c "	"') do (if %%a LSS 1 TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOTD-2)
for /f "tokens=2 delims= " %%i in ('fastboot.exe devices ^| find "	"') do (if not "%%i"=="fastboot" TIMEOUT /T 1 /NOBREAK>nul & goto FASTBOOTD-2)
::目标设备已经检测到
if "%rechk%"=="y" set rechk=n& ECHO.%rechk_wait%秒后将再次检查, 请稍候... & TIMEOUT /T %rechk_wait% /NOBREAK>nul & goto FASTBOOTD-1
ECHO.设备已连接(Fastbootd),3秒后继续 & %wait%
exit /b 




:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)

