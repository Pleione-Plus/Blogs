@echo off
title ��ʾ�������ļ���չ��
color B0
echo -----------------------------------------
echo ��ʼִ�в���...
pause

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t reg_dword /d 00000000 /f
:: ��ֵΪ1���أ���ֵΪ0��ʾ


cls
color 2E
echo --------------------��������-----------------
echo ---------------------------------------------
echo ----------------------�ر�-------------------
pause