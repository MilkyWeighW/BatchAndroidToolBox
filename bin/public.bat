set var1=%1
goto %var1%

:head
@echo off
chcp 936
cd /d %~dp0
title ��ӭʹ��AndroidС����V2.
set "wait=ping 127.0.0.1 -n 5 >nul"
set MENU=goto menu
set "err=call public.bat err & goto menu"
set "defalut_over=call public.bat defalut_over & goto menu"
set partcode=echo **********************************
set "deltemp=if exist ".\*.txt" (del /f /q .\*.txt)"
set "choice_end=ECHO. & ECHO. ����������ȷ���ַ�,�ȴ�5�벢�������˵��� & ping 127.0.0.1 -n 5 >nul & ECHO. & %MENU% & cls"
if not exist .\output (mkdir output)
mode con cols=60 lines=30
cls
goto :eof

:err
color c
%partcode%
echo ��������.
echo �������Ϸ��Ĵ�����ʾ�������������Ҳ��������.
echo ��������������˵�.
pause >nul
goto :eof

:defalut_over
echo �����ɹ����,��������������˵�.
pause >nul
goto :eof 

:getfilename
for %%i in (%file%) do set filename=%%~ni
setlocal enabledelayedexpansion
set a=!date:~0,10!
set filename=!filename!_!a:/=_!_%time::=_%
set filename=!filename:.=_!
echo %filename% > filename.txt
endlocal
set /p filename=<filename.txt
del /q filename.txt
goto :eof

