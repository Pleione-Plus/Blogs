@echo off
title 加密文件和文件夹
color B0
echo -----------------------------------------
echo 开始加密...
pause

cd \
h:
if not exist abc (
	  md abc
	)
cd abc
md 1..\
copy \abc\* 1..\
del /q \abc\*



cls
color 2E
echo --------------------加密结束-----------------
echo ---------------------------------------------
echo ----------------------关闭-------------------
pause

:: explorer无法打开名称中含有"\"的文件夹，但在cmd中可以访问该文件夹