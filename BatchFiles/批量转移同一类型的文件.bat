@echo off
title 批量转移同一类型的文件
color B0
echo -----------------------------------------
echo 开始转移文件...
pause

cls

move c:\download\*.jpg d:\images

:: 目的路径必须存在

pause