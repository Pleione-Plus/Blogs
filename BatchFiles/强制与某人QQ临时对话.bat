@echo off

:send
set /p num=请输入对方的QQ号码:
if /I "%num%"=="n" exit
start tencent://Message/?Uin=%num%
cls
goto send

:: 启用陌生人临时会话可以
:: 只对QQ号有用，群聊失效