@echo off
color a
echo.
echo 下面开始设置IP...
@echo off

:: 权限代码
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close) && exit

set ipstr=10.85.0.126
set maskstr=255.255.255.128
set gatewaystr=10.85.0.1
::set /p ipstr=请输入IP地址：
netsh interface ip set address name="以太网" source=static addr=%ipstr% mask=%maskstr% gateway=%gatewaystr%

set dnsstr1=59.70.159.10
::set /p dnsstr1=请输入主dns地址：
netsh interface ip set dns name="以太网" source=static addr=%dnsstr1% register=PRIMARY

::set dnsstr2=1.1.1.1
::set /p dnsstr2=请输入本分dns地址：
::netsh interface ip add dns name="以太网" addr=%dnsstr2%
::netsh interface ip set wins name="以太网" source=static addr=none


:: 需要以管理员权限运行