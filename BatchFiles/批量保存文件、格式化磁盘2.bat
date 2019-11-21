rem ---------------------------
rem 批量保存文件、格式化磁盘2.bat
rem ---------------------------
@echo off
::format d: /q
echo 格式化完成
pause
cls

copy e:\tmp\*.htm d:
d:
ren *.htm *.html
echo 重命名完成
pause
cls
