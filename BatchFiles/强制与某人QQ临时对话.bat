@echo off

:send
set /p num=������Է���QQ����:
if /I "%num%"=="n" exit
start tencent://Message/?Uin=%num%
cls
goto send

:: ����İ������ʱ�Ự����
:: ֻ��QQ�����ã�Ⱥ��ʧЧ