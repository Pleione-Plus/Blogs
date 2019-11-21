@echo off
title 查看开机启动项
color B0
echo -----------------------------------------
echo 开始执行操作...
pause

@echo off
setlocal enabledelayedexpansion
echo ----------------------------------------
echo.
echo         开机启动清单如下：
echo.
echo ----------------------------------------
echo.
pause
for /f "skip=4 tokens=1* delims=:* %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run') do (
	  set str=%%i
	  set var=%%j
	  set "var=!var:"=!"
	  if not "!var:~-1!"=="=" echo !str:~-1!:!var!
	)
pause