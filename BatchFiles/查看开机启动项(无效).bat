@echo off
title �鿴����������
color B0
echo -----------------------------------------
echo ��ʼִ�в���...
pause

@echo off
setlocal enabledelayedexpansion
echo ----------------------------------------
echo.
echo         ���������嵥���£�
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