@echo off
set /p partition=�����б��Ѵ�ӡ����������뱸�ݵķ���:
findstr %partition% after.txt || echo �������������������� & goto part_backup
pause