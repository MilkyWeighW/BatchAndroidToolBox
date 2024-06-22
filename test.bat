@echo off
set /p partition=分区列表已打印，请键入你想备份的分区:
findstr %partition% after.txt || echo 分区名错误，请重新输入 & goto part_backup
pause