@echo off
title 显示或隐藏文件扩展名
color B0
echo -----------------------------------------
echo 开始执行操作...
pause

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t reg_dword /d 00000000 /f
:: 键值为1隐藏；键值为0显示


cls
color 2E
echo --------------------操作结束-----------------
echo ---------------------------------------------
echo ----------------------关闭-------------------
pause