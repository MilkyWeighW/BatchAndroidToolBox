@echo off

:: ��ӭ��
echo ====================================================
echo.һ�����������ڴ���������ϵۡ�
echo ���k�Լ���δ�������
echo ====================================================
echo ���°�adb �� fastboot ��װ����
echo ���� fawazahmed0 @ xda-developers
echo ���� MilkyWeigh
echo ====================================================
:: echo. ���Դ�������
echo.

:: ��Դ: https://support.microsoft.com/en-us/help/110930/redirecting-error-messages-from-command-prompt-stderr-stdout
:: ��Դ: https://www.robvanderwoude.com/battech_debugging.php
:: ���Ҫ��������ű��Ļ����ѵ�һ�е�"@echo off"ɾ������
:: �Թ���Ա�������cmd, Ȼ�������ű��ӽ�ȥ���У�
:: ���磺"�ű�����.bat > mylog.txt 2>myerror.txt"


:: ��Դ: https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file
:: ��Դ: https://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights
:: ���û�й���ԱȨ�ޣ�������ű����Զ�����
net session >nul 2>&1
if NOT %errorLevel% == 0 (
powershell -executionpolicy bypass start -verb runas '%0' am_admin & exit /b
)


echo ���� USB ����ģʽ�������ֻ�����ѡ�� MTP ���ļ�����ѡ�
echo �Ա���ȷ��װ USB �����������ھͿ���������!  [��ѡ���裬ǿ���Ƽ���
echo ��10��������

:: ��ʱһ���~
:: ��Դ: http://blog.bitcollectors.com/adam/2015/06/waiting-in-a-batch-file/
:: ��Դ: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/start-sleep?view=powershell-6
PowerShell -executionpolicy bypass -Command "Start-Sleep -s 10" > nul 2>&1

echo.
echo ��ʼ��װ

:: ��Դ: https://stackoverflow.com/questions/672693/windows-batch-file-starting-directory-when-run-as-admin
:: �ص��ű�����Ŀ¼
cd %~dp0

:: ��Դ: https://serverfault.com/questions/132963/windows-redirect-stdout-and-stderror-to-nothing
:: Null stdout redirection
:: ������ʱĿ¼��ʹ����
echo ������ʱĿ¼
rmdir /Q /S temporarydir > nul 2>&1
mkdir temporarydir

:: �е��� cd ����
:: ��Դ : https://stackoverflow.com/questions/17753986/how-to-change-directory-using-windows-command-line
pushd temporarydir

:: ��Դ: https://stackoverflow.com/questions/4619088/windows-batch-file-file-download-from-a-url
:: �� google ��������ƽ̨����
echo �������°��adb �� fastboot ���߰���
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://dl.google.com/android/repository/platform-tools-latest-windows.zip', 'adbinstallerpackage.zip')"

echo �������µ�usb��������
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://dl.google.com/android/repository/latest_usb_driver_windows.zip', 'google_usb_driver.zip')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/google64inf', 'google64inf')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/google86inf', 'google86inf')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/Stringsvals', 'Stringsvals')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/kmdf', 'kmdf')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/Latest ADB Launcherbat', 'Latest ADB Launcher.bat')"

::��ȡ devcon.exe �� powershell �ű�
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/fetch_hwidps1', 'fetch_hwid.ps1')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/devconexe', 'devcon.exe')"

:: ��Դ: https://pureinfotech.com/list-environment-variables-windows-10/
:: Ϊ�����ļ�ʹ�û�������
:: ���ƽ̨���ߵľɰ汾���ھ�ɱ�� adb ʵ�������������������У�����ж��/�Ƴ����� 
echo ж�ؾɰ汾��
adb kill-server > nul 2>&1
rmdir /Q /S "%PROGRAMFILES%\platform-tools" > nul 2>&1

:: ��Դ: https://stackoverflow.com/questions/37814037/how-to-unzip-a-zip-file-with-powershell-version-2-0
:: ��Դ: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-6
:: ��.zip�ļ���ѹ����װĿ¼
echo ��װ�ļ���
PowerShell -executionpolicy bypass -Command "& {$shell_app=new-object -com shell.application; $filename = \"adbinstallerpackage.zip\"; $zip_file = $shell_app.namespace((Get-Location).Path + \"\$filename\"); $destination = $shell_app.namespace($Env:ProgramFiles); $destination.Copyhere($zip_file.items());}"
echo ��װusb������
PowerShell -executionpolicy bypass -Command "& {$shell_app=new-object -com shell.application; $filename = \"google_usb_driver.zip\"; $zip_file = $shell_app.namespace((Get-Location).Path + \"\$filename\"); $destination = $shell_app.namespace((Get-Location).Path); $destination.Copyhere($zip_file.items());}"

:: ��Դ: https://stackoverflow.com/questions/1804751/use-bat-to-start-powershell-script
:: ���� powershell �ű�����ȡδ֪�� USB ��������� Ӳ�� ID ��Ȼ������� inf �ļ���
:: ��Դ: https://stackoverflow.com/questions/19335004/how-to-run-a-powershell-script-from-a-batch-file
:: ��Դ: https://stackoverflow.com/questions/50370658/bypass-vs-unrestricted-execution-policies
powershell -executionpolicy bypass .\fetch_hwid.ps1

:: ��Դ: https://github.com/koush/UniversalAdbDriver
:: ��Դ: https://forum.xda-developers.com/google-nexus-5/development/adb-fb-apx-driver-universal-naked-t2513339
:: ��Դ: https://stackoverflow.com/questions/60034/how-can-you-find-and-replace-text-in-a-file-using-the-windows-command-line-envir
:: ��Դ: https://stackoverflow.com/questions/51060976/search-multiline-text-in-a-file-using-powershell
:: ��Դ: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/add-content?view=powershell-6
:: �ϲ���� inf �ļ���֧�������豸
powershell -executionpolicy bypass -Command "gc Stringsvals | Add-Content usb_driver\android_winusb.inf"
powershell -executionpolicy bypass -Command "(gc usb_driver\android_winusb.inf | Out-String) -replace '\[Google.NTamd64\]', (gc google64inf | Out-String) | Out-File usb_driver\android_winusb.inf"
powershell -executionpolicy bypass -Command "(gc usb_driver\android_winusb.inf | Out-String) -replace '\[Google.NTx86\]', (gc google86inf | Out-String) | Out-File usb_driver\android_winusb.inf"
powershell -executionpolicy bypass -Command "(gc usb_driver\android_winusb.inf | Out-String) -replace '\[Strings\]', (gc kmdf | Out-String) | Out-File usb_driver\android_winusb.inf"

:: ��ȡδǩ������������װ����
echo ��������δǩ����������װ��
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/windows-unsigned-driver-installer@master/unsigned_driver_installerbat', 'usb_driver\unsigned_driver_installer.bat')"

:: ��Դ: https://stackoverflow.com/questions/1103994/how-to-run-multiple-bat-files-within-a-bat-file
:: https://stackoverflow.com/questions/3583565/how-to-skip-pause-in-batch-file
:: ����δǩ������������װ����
pushd usb_driver
echo.
echo | call unsigned_driver_installer.bat >nul
popd

:: ��װ fastboot����
:: ��Դ: https://support.microsoft.com/en-us/help/110930/redirecting-error-messages-from-command-prompt-stderr-stdout
:: ��Դ: https://stackoverflow.com/questions/7005951/batch-file-find-if-substring-is-in-string-not-in-a-file
:: Checking if usb debugging authorization is required
"%PROGRAMFILES%\platform-tools\adb.exe" reboot bootloader > nul 2> temp.txt
set rbtval=%errorLevel%
:: ��Դ: https://stackoverflow.com/questions/3068929/how-to-read-file-contents-into-a-variable-in-a-batch-file
:: ��Դ: http://batcheero.blogspot.com/2007/06/how-to-enabledelayedexpansion.html
:: ��Դ: https://stackoverflow.com/questions/4367930/errorlevel-inside-if
:: ������Ĺ�����ʽ���κ�����������Զ���һ���G
type temp.txt | findstr /i /C:"unauthorized" 1> NUL

if %errorLevel% == 0 (
echo.
echo ������ʼ��װFastboot����
echo.
echo �����ֻ���ʾ��ȷ�϶Ի����а���ȷ������
echo ������ USB ������Ȩ
echo Ȼ�� Enter ������
PowerShell -executionpolicy bypass -Command "Start-Sleep -s 3" > nul 2>&1
pause > NUL
"%PROGRAMFILES%\platform-tools\adb.exe" reboot bootloader > nul 2>&1

)
:: %errorLevel% �����ո�ֵ����ո�һ������ rbtval
if NOT "%rbtval%" == "0" set rbtval=%errorLevel%


if "%rbtval%" == "0" (
echo.
echo ���ڰ�װfastboot�����������豸��������fastbootģʽ

:: ��ӳ�ʱ���ȴ��豸����fastbootģʽ
:: ��Դ: http://blog.bitcollectors.com/adam/2015/06/waiting-in-a-batch-file/
:: ��Դ: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/start-sleep?view=powershell-6
echo �ȴ�����fastbootģʽ...
PowerShell -executionpolicy bypass -Command "Start-Sleep -s 7" > nul 2>&1

:: ��Դ: https://stackoverflow.com/questions/50370658/bypass-vs-unrestricted-execution-policies
:: ִ�� ps1 �ļ�����ȡfastboot�豸��Ӳ��id
powershell -executionpolicy bypass .\fetch_hwid.ps1

:: ����������װ��
pushd usb_driver
echo.
echo | call unsigned_driver_installer.bat
popd

:: ��Դ: https://stackoverflow.com/questions/52060842/check-for-empty-string-in-batch-file
:: ��ִ��"fastboot reboot"ǰ����� fastboot �豸 
"%PROGRAMFILES%\platform-tools\fastboot.exe" devices > temp.txt
set /p fbdev=<temp.txt
if defined fbdev ( "%PROGRAMFILES%\platform-tools\fastboot.exe" reboot > nul 2>&1  )
)
:: killing adb server
"%PROGRAMFILES%\platform-tools\adb.exe" kill-server > nul 2>&1


:: ��Դ: https://stackoverflow.com/questions/51636175/using-batch-file-to-add-to-path-environment-variable-windows-10
:: ��Դ: https://stackoverflow.com/questions/141344/how-to-check-if-directory-exists-in-path/8046515
:: ��Դ: https://stackoverflow.com/questions/9546324/adding-directory-to-path-environment-variable-in-windows
:: ���û�������
echo.
echo ���û���������
SET Key="HKCU\Environment"
FOR /F "usebackq tokens=2*" %%A IN (`REG QUERY %Key% /v PATH`) DO Set CurrPath=%%B
echo ;%CurrPath%; | find /C /I ";%PROGRAMFILES%\platform-tools;" > temp.txt
set /p VV=<temp.txt
if "%VV%" EQU "0" (
SETX PATH "%PROGRAMFILES%\platform-tools;%CurrPath%" > nul 2>&1
)

:: ������ʱ�ļ�
echo ������ʱ�ļ�...
popd
rmdir /Q /S temporarydir > nul 2>&1

:: ��Դ:https://stackoverflow.com/questions/7308586/using-batch-echo-with-special-characters
:: �� echo ��ת�������ַ�
:: ��װ���
echo.
echo.
echo ��Ү�����ڿ���ִ��adb��fastboot������
echo.
echo ע: �Է���һ �� �����ⲻ��Fastbootģʽ�µ��豸�Ļ�, ������
echo fastboot ģʽ�µ��ֻ����ӵ��� ��������һ������������.
echo.
echo ��������˳�
pause > NUL
