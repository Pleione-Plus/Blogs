@echo off
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::       ���оٴ��ڵķ�����Ȼ�������ɾ���Է���������Ĺ���
::       ͨ���޸�ע����ֹadmin$�������´ο���ʱ���¼��أ�
::       IPC$������ҪadministratorȨ�޲��ܳɹ�ɾ����
::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

title Ĭ�Ϲ���ɾ����
echo.
echo ------------------------------------------------------------
echo.
echo ��ʼɾ��ÿ�������µ�Ĭ�Ϲ���...
echo.
for %%a in (C D E F G H I G K L M N O P Q R S T U V W X Y Z) do @(
	if exist %%a:\nul (
		net share %%a$ /delete > nul 2 > nul && echo �ɹ�ɾ����Ϊ%%a$��Ĭ�Ϲ��� || echo ��Ϊ%%a$��Ĭ�Ϲ�������
	)
)

:: >nul 2>nul������������
net share admin$ /delete > nul 2 > nul && echo �ɹ�ɾ����Ϊadmin$��Ĭ�Ϲ��� || echo ��Ϊadmin$��Ĭ�Ϲ�������
net share IPC$ /delete > nul 2 > nul && echo �ɹ�ɾ����ΪIPC$��Ĭ�Ϲ��� || echo ��ΪIPC$��Ĭ�Ϲ�������
echo.
echo --------------------------------------------------------------
echo.
net stop Server > nul 2 > nul && echo Server������ֹͣ
net start Server > nul 2 > nul && echo Server����������
echo.
echo --------------------------------------------------------------
echo.
echo �޸�ע����Ը���ϵͳĬ������
echo.
echo ���ڴ���ע����ļ�
echo Windows Registry Editor Version 5.00 > C:\delshare.reg
:: ͨ��ע����ֹAdmin$�����Է�ֹ�������ٴμ���
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters]>>c:\delshare.reg
echo "AutoShareWks"=dwork:00000000 >> c:\delshare.reg
echo "AutoShareServer"=dwork:00000000 >> c:\delshare.reg
:: ɾ��IPC$������������ҪadministratorȨ�޲��ܳɹ�ɾ��
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa] >> c:\delshare.reg
echo "restrictanonymous"=dwork:00000001 >> c:\delshare.reg
echo ���ڵ���ע����ļ��Ը���ϵͳĬ������
regedit /s c:\delshare.reg
del c:\delshare.reg && echo ��ʱ�ļ��Ѿ�ɾ��
echo.
echo ---------------------------------------------------------------
echo.
echo �����Ѿ��ɹ�ɾ�����е�Ĭ�Ϲ���
echo.
echo ��������˳�
pause>nul

:: �������ٴγ���Ĭ�Ϲ���