@echo off
title ��ʾ������ĳ���
color B0
echo -----------------------------------------
echo ��ʼ...
pause

@echo off
for /f "tokens=2 delims=:" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run') do echo %systemDerive% %%i

pause