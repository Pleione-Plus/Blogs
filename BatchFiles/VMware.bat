@echo off

:::::::::::::::::::::::::::::::::::::::::::::::
:: 作用：
::     -> 开启或关闭VMware服务
:: 功能：
::     -> 显示本机与VMware相关的服务
::     -> 开启或关闭VMware服务
:: 缺点：
::     -> 强制执行既定命令，兼容性不好
:: 
:::::::::::::::::::::::::::::::::::::::::::::::

:: 界面设置
title VMware服务操作
color 06

:: 权限代码
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close) && exit

goto ShowFirst

:ShowFirst
cls
echo 本机中的Vmware服务：
echo ----------------------------------------
echo   -^> 1    VMware Authorization Service
echo   -^> 2    VMware DHCP Service
echo   -^> 3    VMware NAT Service
echo   -^> 4    VMware USB Arbitration Service
echo   -^> 5    VMware Workstation Server
echo ----------------------------------------
echo.
echo 操作说明：
echo ----------------------------------------
echo   -^> 1    启动服务
echo   -^> 0    停止服务
echo ----------------------------------------
echo.
set /p operation=请输入操作符号：[1/0]
if %operation% ==1 goto StartVMware
if %operation% ==0 goto StopVMware
echo 输入错误导致异常退出
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



