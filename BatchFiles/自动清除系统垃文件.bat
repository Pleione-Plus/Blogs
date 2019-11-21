@echo off
title 自动清除系统垃文件
color B0

:: 权限代码
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close) && exit


echo -----------------------------------------
echo 开始清除文件...
pause

cls

@echo off
:: 依次清除系统根目录中的临时文件、临时帮助文件、磁盘检查文件、临时备份文件
del /f /s /q %systemdrive%\*.tmp
del /f /s /q %systemdrive%\*._mp
del /f /s /q %systemdrive%\*.gid
del /f /s /q %systemdrive%\*.chk
del /f /s /q %systemdrive%\*.old
:: 依次清除Windows目录中的临时备份文件、预读文件、临时文件
del /f /s /q %windir%\*.bak
del /f /s /q %windir%\prefetch\*.*
rd /s /q %windir%\temp & mk %windir%\temp
:: 依次清除用户目录下的临时文件
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
del /f /s /q "%userprofile%\Local Setting\Temp\*.*"
rd /s /q "%userprofile%\Local Setting\Temp\" & md "%userprofile%\Local Setting\Temp\"
:: 依次清除用户安装目录下的cookie文件、临时文件
del /f /s /q "%appdata%\Microsoft\Windows\cookies\*.*"
del /f /s /q "%appdata%\Microsoft\Windows\Recent\*.*"

@echo off
cls
color 2E
echo ---------------------系统垃清理完成！！！-----------------------
echo ----------------------------------------------------------------
echo ----------------------------退出--------------------------------
pause
