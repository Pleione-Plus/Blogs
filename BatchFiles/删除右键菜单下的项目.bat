@echo off
:: 
:: 
mode con lines=25
title ���½����˵�����ɾ����
color 1f

:input
cls
call :display
echo
echo.
echo.
set input=
set /p input=           �������׺����
if "%input%"=="" goto input
if "%input%"=="0" exit
if "%input%"=="1" goto fouce
for /f %%i ("%input%") do (reg delete HKCR\.%%i\ShellNew /f)
goto continue

:fouce
cls
call :display
set input=
set /p input=           �������׺��(ǿ��ɾ��):
if "%input%"=="" goto fouce
if "%input%"=="0" exit
for /f %%i in ("%input%") do (reg delete HKCR\.%%i /f)

:continue
cls
call :display
echo.
set choice=
set /p choice=           ��Ҫ���������?��y/n��
if "%choice%"=="" goto continue
if "%choice%"=="y" goto input
if "%choice%"=="n" goto :eof

:display
echo.
echo.
echo.
echo.
echo.
echo.
echo         ��������ɾ���Ҽ��˵��С��½�����Ŀ�µĶ������ݣ�Ϊ���½����˵����ʣ�
echo.
echo            �������ĳ�����͵��ļ����ٳ������Ҽ��ġ��½����˵��У���ֱ��
echo.
echo                       ������ļ����͵ĺ�׺��������rar��
echo.
echo                                             �˳���ѡ0
echo.

:: ��Ҫ����ԱȨ�޲�������