@echo off
color a
echo.
echo ���濪ʼ����IP...
@echo off

:: Ȩ�޴���
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close) && exit

set ipstr=10.85.0.126
set maskstr=255.255.255.128
set gatewaystr=10.85.0.1
::set /p ipstr=������IP��ַ��
netsh interface ip set address name="��̫��" source=static addr=%ipstr% mask=%maskstr% gateway=%gatewaystr%

set dnsstr1=59.70.159.10
::set /p dnsstr1=��������dns��ַ��
netsh interface ip set dns name="��̫��" source=static addr=%dnsstr1% register=PRIMARY

::set dnsstr2=1.1.1.1
::set /p dnsstr2=�����뱾��dns��ַ��
::netsh interface ip add dns name="��̫��" addr=%dnsstr2%
::netsh interface ip set wins name="��̫��" source=static addr=none


:: ��Ҫ�Թ���ԱȨ������