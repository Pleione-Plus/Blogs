@echo off

:::::::::::::::::::::::::::::::::::::::::::::::
:: ���ã�
::     -> ������ر�VMware����
:: ���ܣ�
::     -> ��ʾ������VMware��صķ���
::     -> ������ر�VMware����
:: ȱ�㣺
::     -> ǿ��ִ�мȶ���������Բ���
:: 
:::::::::::::::::::::::::::::::::::::::::::::::

:: ��������
title VMware�������
color 06

:: Ȩ�޴���
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close) && exit

goto ShowFirst

:ShowFirst
cls
echo �����е�Vmware����
echo ----------------------------------------
echo   -^> 1    VMware Authorization Service
echo   -^> 2    VMware DHCP Service
echo   -^> 3    VMware NAT Service
echo   -^> 4    VMware USB Arbitration Service
echo   -^> 5    VMware Workstation Server
echo ----------------------------------------
echo.
echo ����˵����
echo ----------------------------------------
echo   -^> 1    ��������
echo   -^> 0    ֹͣ����
echo ----------------------------------------
echo.
set /p operation=������������ţ�[1/0]
if %operation% ==1 goto StartVMware
if %operation% ==0 goto StopVMware
echo ����������쳣�˳�
pause

:StartVMware
cls
start "" "C:\Program Files (x86)\VMware\VMware Workstation\vmware-tray.exe"
net start VMAuthdService
net start VMnetDHCP
net start "VMware NAT Service"
net start VMUSBArbService
net start VMwareHostd
goto EndApp

:StopVMware
cls
taskkill /f /t /im vmware-tray.exe
net stop /y VMwareHostd
net stop /y VMAuthdService
net stop /y VMnetDHCP
net stop /y "VMware NAT Service"
net stop /y VMUSBArbService
goto EndApp

:EndApp
exit



