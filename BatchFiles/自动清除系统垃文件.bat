@echo off
title �Զ����ϵͳ���ļ�
color B0

:: Ȩ�޴���
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close) && exit


echo -----------------------------------------
echo ��ʼ����ļ�...
pause

cls

@echo off
:: �������ϵͳ��Ŀ¼�е���ʱ�ļ�����ʱ�����ļ������̼���ļ�����ʱ�����ļ�
del /f /s /q %systemdrive%\*.tmp
del /f /s /q %systemdrive%\*._mp
del /f /s /q %systemdrive%\*.gid
del /f /s /q %systemdrive%\*.chk
del /f /s /q %systemdrive%\*.old
:: �������WindowsĿ¼�е���ʱ�����ļ���Ԥ���ļ�����ʱ�ļ�
del /f /s /q %windir%\*.bak
del /f /s /q %windir%\prefetch\*.*
rd /s /q %windir%\temp & mk %windir%\temp
:: ��������û�Ŀ¼�µ���ʱ�ļ�
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
del /f /s /q "%userprofile%\Local Setting\Temp\*.*"
rd /s /q "%userprofile%\Local Setting\Temp\" & md "%userprofile%\Local Setting\Temp\"
:: ��������û���װĿ¼�µ�cookie�ļ�����ʱ�ļ�
del /f /s /q "%appdata%\Microsoft\Windows\cookies\*.*"
del /f /s /q "%appdata%\Microsoft\Windows\Recent\*.*"

@echo off
cls
color 2E
echo ---------------------ϵͳ��������ɣ�����-----------------------
echo ----------------------------------------------------------------
echo ----------------------------�˳�--------------------------------
pause
