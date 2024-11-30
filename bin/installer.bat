@echo off

:: 欢迎语
echo ====================================================
echo.一切赞美都归于创造万物的上帝、
echo 而祂自己是未被创造的
echo ====================================================
echo 最新版adb 和 fastboot 安装工具
echo 作者 fawazahmed0 @ xda-developers
echo 汉化 MilkyWeigh
echo ====================================================
:: echo. 可以创建空行
echo.

:: 来源: https://support.microsoft.com/en-us/help/110930/redirecting-error-messages-from-command-prompt-stderr-stdout
:: 来源: https://www.robvanderwoude.com/battech_debugging.php
:: 如果要调试这个脚本的话，把第一行的"@echo off"删掉便是
:: 以管理员身份运行cmd, 然后把这个脚本扔进去运行，
:: 例如："脚本名字.bat > mylog.txt 2>myerror.txt"


:: 来源: https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file
:: 来源: https://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights
:: 如果没有管理员权限，批处理脚本会自动请求
net session >nul 2>&1
if NOT %errorLevel% == 0 (
powershell -executionpolicy bypass start -verb runas '%0' am_admin & exit /b
)


echo 请在 USB 调试模式下连接手机，并选择 MTP 或文件传输选项，
echo 以便正确安装 USB 驱动程序，现在就可以这样做!  [可选步骤，强烈推荐］
echo （10秒后继续）

:: 延时一会儿~
:: 来源: http://blog.bitcollectors.com/adam/2015/06/waiting-in-a-batch-file/
:: 来源: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/start-sleep?view=powershell-6
PowerShell -executionpolicy bypass -Command "Start-Sleep -s 10" > nul 2>&1

echo.
echo 开始安装

:: 来源: https://stackoverflow.com/questions/672693/windows-batch-file-starting-directory-when-run-as-admin
:: 回到脚本所在目录
cd %~dp0

:: 来源: https://serverfault.com/questions/132963/windows-redirect-stdout-and-stderror-to-nothing
:: Null stdout redirection
:: 创建临时目录并使用它
echo 创建临时目录
rmdir /Q /S temporarydir > nul 2>&1
mkdir temporarydir

:: 有点像 cd 命令
:: 来源 : https://stackoverflow.com/questions/17753986/how-to-change-directory-using-windows-command-line
pushd temporarydir

:: 来源: https://stackoverflow.com/questions/4619088/windows-batch-file-file-download-from-a-url
:: 从 google 下载最新平台工具
echo 下载最新版的adb 和 fastboot 工具包中
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://dl.google.com/android/repository/platform-tools-latest-windows.zip', 'adbinstallerpackage.zip')"

echo 下载最新的usb驱动包中
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://dl.google.com/android/repository/latest_usb_driver_windows.zip', 'google_usb_driver.zip')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/google64inf', 'google64inf')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/google86inf', 'google86inf')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/Stringsvals', 'Stringsvals')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/kmdf', 'kmdf')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/Latest ADB Launcherbat', 'Latest ADB Launcher.bat')"

::获取 devcon.exe 和 powershell 脚本
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/fetch_hwidps1', 'fetch_hwid.ps1')"
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/Latest-adb-fastboot-installer-for-windows@master/files/devconexe', 'devcon.exe')"

:: 来源: https://pureinfotech.com/list-environment-variables-windows-10/
:: 为程序文件使用环境变量
:: 如果平台工具的旧版本存在就杀死 adb 实例（假设它们正在运行），并卸载/移除它们 
echo 卸载旧版本中
adb kill-server > nul 2>&1
rmdir /Q /S "%PROGRAMFILES%\platform-tools" > nul 2>&1

:: 来源: https://stackoverflow.com/questions/37814037/how-to-unzip-a-zip-file-with-powershell-version-2-0
:: 来源: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-6
:: 把.zip文件解压到安装目录
echo 安装文件中
PowerShell -executionpolicy bypass -Command "& {$shell_app=new-object -com shell.application; $filename = \"adbinstallerpackage.zip\"; $zip_file = $shell_app.namespace((Get-Location).Path + \"\$filename\"); $destination = $shell_app.namespace($Env:ProgramFiles); $destination.Copyhere($zip_file.items());}"
echo 安装usb驱动中
PowerShell -executionpolicy bypass -Command "& {$shell_app=new-object -com shell.application; $filename = \"google_usb_driver.zip\"; $zip_file = $shell_app.namespace((Get-Location).Path + \"\$filename\"); $destination = $shell_app.namespace((Get-Location).Path); $destination.Copyhere($zip_file.items());}"

:: 来源: https://stackoverflow.com/questions/1804751/use-bat-to-start-powershell-script
:: 调用 powershell 脚本来获取未知的 USB 驱动程序的 硬件 ID ，然后将其插入 inf 文件中
:: 来源: https://stackoverflow.com/questions/19335004/how-to-run-a-powershell-script-from-a-batch-file
:: 来源: https://stackoverflow.com/questions/50370658/bypass-vs-unrestricted-execution-policies
powershell -executionpolicy bypass .\fetch_hwid.ps1

:: 来源: https://github.com/koush/UniversalAdbDriver
:: 来源: https://forum.xda-developers.com/google-nexus-5/development/adb-fb-apx-driver-universal-naked-t2513339
:: 来源: https://stackoverflow.com/questions/60034/how-can-you-find-and-replace-text-in-a-file-using-the-windows-command-line-envir
:: 来源: https://stackoverflow.com/questions/51060976/search-multiline-text-in-a-file-using-powershell
:: 来源: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/add-content?view=powershell-6
:: 合并多个 inf 文件以支持所有设备
powershell -executionpolicy bypass -Command "gc Stringsvals | Add-Content usb_driver\android_winusb.inf"
powershell -executionpolicy bypass -Command "(gc usb_driver\android_winusb.inf | Out-String) -replace '\[Google.NTamd64\]', (gc google64inf | Out-String) | Out-File usb_driver\android_winusb.inf"
powershell -executionpolicy bypass -Command "(gc usb_driver\android_winusb.inf | Out-String) -replace '\[Google.NTx86\]', (gc google86inf | Out-String) | Out-File usb_driver\android_winusb.inf"
powershell -executionpolicy bypass -Command "(gc usb_driver\android_winusb.inf | Out-String) -replace '\[Strings\]', (gc kmdf | Out-String) | Out-File usb_driver\android_winusb.inf"

:: 获取未签名的驱动程序安装工具
echo 正在下载未签名的驱动安装器
PowerShell -executionpolicy bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.jsdelivr.net/gh/fawazahmed0/windows-unsigned-driver-installer@master/unsigned_driver_installerbat', 'usb_driver\unsigned_driver_installer.bat')"

:: 来源: https://stackoverflow.com/questions/1103994/how-to-run-multiple-bat-files-within-a-bat-file
:: https://stackoverflow.com/questions/3583565/how-to-skip-pause-in-batch-file
:: 运行未签名的驱动程序安装工具
pushd usb_driver
echo.
echo | call unsigned_driver_installer.bat >nul
popd

:: 安装 fastboot驱动
:: 来源: https://support.microsoft.com/en-us/help/110930/redirecting-error-messages-from-command-prompt-stderr-stdout
:: 来源: https://stackoverflow.com/questions/7005951/batch-file-find-if-substring-is-in-string-not-in-a-file
:: Checking if usb debugging authorization is required
"%PROGRAMFILES%\platform-tools\adb.exe" reboot bootloader > nul 2> temp.txt
set rbtval=%errorLevel%
:: 来源: https://stackoverflow.com/questions/3068929/how-to-read-file-contents-into-a-variable-in-a-batch-file
:: 来源: http://batcheero.blogspot.com/2007/06/how-to-enabledelayedexpansion.html
:: 来源: https://stackoverflow.com/questions/4367930/errorlevel-inside-if
:: 批处理的工作方式与任何其他编程语言都不一样欸
type temp.txt | findstr /i /C:"unauthorized" 1> NUL

if %errorLevel% == 0 (
echo.
echo 即将开始安装Fastboot驱动
echo.
echo 请在手机显示的确认对话框中按“确定”，
echo 以允许 USB 调试授权
echo 然后按 Enter 键继续
PowerShell -executionpolicy bypass -Command "Start-Sleep -s 3" > nul 2>&1
pause > NUL
"%PROGRAMFILES%\platform-tools\adb.exe" reboot bootloader > nul 2>&1

)
:: %errorLevel% 后不留空格，值将随空格一起分配给 rbtval
if NOT "%rbtval%" == "0" set rbtval=%errorLevel%


if "%rbtval%" == "0" (
echo.
echo 正在安装fastboot驱动，现在设备将重启至fastboot模式

:: 添加超时来等待设备启动fastboot模式
:: 来源: http://blog.bitcollectors.com/adam/2015/06/waiting-in-a-batch-file/
:: 来源: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/start-sleep?view=powershell-6
echo 等待加载fastboot模式...
PowerShell -executionpolicy bypass -Command "Start-Sleep -s 7" > nul 2>&1

:: 来源: https://stackoverflow.com/questions/50370658/bypass-vs-unrestricted-execution-policies
:: 执行 ps1 文件来获取fastboot设备的硬件id
powershell -executionpolicy bypass .\fetch_hwid.ps1

:: 调用驱动安装器
pushd usb_driver
echo.
echo | call unsigned_driver_installer.bat
popd

:: 来源: https://stackoverflow.com/questions/52060842/check-for-empty-string-in-batch-file
:: 在执行"fastboot reboot"前，检测 fastboot 设备 
"%PROGRAMFILES%\platform-tools\fastboot.exe" devices > temp.txt
set /p fbdev=<temp.txt
if defined fbdev ( "%PROGRAMFILES%\platform-tools\fastboot.exe" reboot > nul 2>&1  )
)
:: killing adb server
"%PROGRAMFILES%\platform-tools\adb.exe" kill-server > nul 2>&1


:: 来源: https://stackoverflow.com/questions/51636175/using-batch-file-to-add-to-path-environment-variable-windows-10
:: 来源: https://stackoverflow.com/questions/141344/how-to-check-if-directory-exists-in-path/8046515
:: 来源: https://stackoverflow.com/questions/9546324/adding-directory-to-path-environment-variable-in-windows
:: 设置环境变量
echo.
echo 设置环境变量中
SET Key="HKCU\Environment"
FOR /F "usebackq tokens=2*" %%A IN (`REG QUERY %Key% /v PATH`) DO Set CurrPath=%%B
echo ;%CurrPath%; | find /C /I ";%PROGRAMFILES%\platform-tools;" > temp.txt
set /p VV=<temp.txt
if "%VV%" EQU "0" (
SETX PATH "%PROGRAMFILES%\platform-tools;%CurrPath%" > nul 2>&1
)

:: 清理临时文件
echo 清理临时文件...
popd
rmdir /Q /S temporarydir > nul 2>&1

:: 来源:https://stackoverflow.com/questions/7308586/using-batch-echo-with-special-characters
:: 在 echo 中转义特殊字符
:: 安装完毕
echo.
echo.
echo 好耶！现在可以执行adb和fastboot命令了
echo.
echo 注: 以防万一 ， 如果检测不到Fastboot模式下的设备的话, 把你在
echo fastboot 模式下的手机连接电脑 ，再运行一遍这个程序就行.
echo.
echo 按任意键退出
pause > NUL
