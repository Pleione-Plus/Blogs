@echo off
title 显示启动项的程序
color B0
echo -----------------------------------------
echo 开始...
pause

@echo off
for /f "tokens=2 delims=:" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run') do echo %systemDerive% %%i

pause