@echo off

::::::::::::::::::::::::::::::::::::::::::::::::::
:: ���ã���SQL Serve����������������
:: ���ܣ�
::     -> ������MSSQLSERVER����
::     -> �ر���SQL Server��ص����з���
::     -> ��ʾ��SQL Server��ص����з���
::     -> ����SQL Server�������������
::     -> 
:: ȱ�㣺
::     -> δʵ������ָ������Ĳ���
::     -> δʵ����ʾ��ǰSQL Server�������������
:: �ο����ӣ�
::     -> https://www.cnblogs.com/pingming/p/5108947.html
::     -> https://www.cnblogs.com/wghao/archive/2011/09/23/2187821.html
::::::::::::::::::::::::::::::::::::::::::::::::::

title SQL Server�������������
color 06

:: Ȩ�޴���
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close) && exit


:ShowFirst
cls
echo ����˵����
echo -----------------------------------------
echo   -^> 1    ����SQL Server����(��ȱʡֵ)
echo   -^> 2    ֹͣ����SQL Server����
echo   -^> 3    ��ʾ������SQL Server�����б�
echo   -^> 0    ȡ�����������
echo -----------------------------------------
echo.
set /p operation1=�����������ţ�[1/2/3/0]
if %operation1% ==1 goto StartSQLServer
if %operation1% ==2 goto StopServers
if %operation1% ==3 goto ShowServer
if %operation1% ==0 goto EndApp

:StartSQLServer
net start MSSQLSERVER
goto EndApp

:StopServers
net stop MSSQLSERVER
net stop SQLBrowser
net stop SQLTELEMETRY
net stop SQLWriter
net stop SQLSERVERAGENT
goto EndApp

:ShowServer
cls
echo ������SQL Server�����б�
echo -----------------------------------
echo   -^> 1   �������ƣ�MSSQLSERVER
echo   -^> 2   �������ƣ�SQLBrowser
echo   -^> 3   �������ƣ�SQLTELEMETRY
echo   -^> 4   �������ƣ�SQLWriter
echo   -^> 5   �������ƣ�SQLSERVERAGENT
echo -----------------------------------
echo �������
echo   -^> 1      ��ʾ��ϸ��SQL Server������Ϣ
echo   -^> 2      �ֶ�����SQL Server����
echo   -^> 0      �������������
echo -----------------------------------
echo.
set /p operation2=�����������ţ�[1/2/0]
if %operation2% ==1 goto ShowServerInfo
if %operation2% ==2 goto ConfigSQLServer
if %operation2% ==0 goto EndApp

:ShowServerInfo
cls
echo ��ʾ��ϸ��SQL Server������Ϣ��
echo --------------------------------------------------------------
echo   -^> 1 �������ƣ�MSSQLSERVER
echo         ��ʾ���ƣ�SQL Server (MSSQLSERVER)
echo         ������Ϣ���ṩ���ݵĴ洢��������ܿط��ʣ����ṩ
echo                   ���ٵ�������
echo.
echo   -^> 2 �������ƣ�SQLBrowser
echo         ��ʾ���ƣ�SQL Server Browser
echo         ������Ϣ���� SQL Server ������Ϣ�ṩ���ͻ��˼���
echo                   ����
echo.
echo   -^> 3 �������ƣ�SQLTELEMETRY
echo         ��ʾ���ƣ�SQL Server CEIP service (MSSQLSERVER)
echo         ������Ϣ��CEIP service for Sql server 
echo.
echo   -^> 4 �������ƣ�SQLWriter
echo         ��ʾ���ƣ�SQL Server VSS Writer
echo         ������Ϣ���ṩ����ͨ�� Windows VSS �����ṹ����/
echo                   ��ԭ Microsoft SQL Server �Ľӿڡ�
echo.
echo   -^> 5 �������ƣ�SQLSERVERAGENT
echo         ��ʾ���ƣ�SQL Server ���� (MSSQLSERVER)
echo         ������Ϣ��ִ����ҵ������ SQL Server��������������
echo         �������Զ�ִ��ĳЩ��������
echo.
echo --------------------------------------------------------------
goto EndApp

:ConfigSQLServer
cls
echo �ֶ�����SQL Server����
echo --------------------------------------------------------
echo   -^> 1   �������ƣ�MSSQLSERVER
echo   -^> 2   �������ƣ�SQLBrowser
echo   -^> 3   �������ƣ�SQLTELEMETRY
echo   -^> 4   �������ƣ�SQLWriter
echo   -^> 5   �������ƣ�SQLSERVERAGENT
echo --------------------------------------------------------
echo �������ͣ�
echo   -^> 1   �Զ�
echo   -^> 2   �ֶ�
echo   -^> 0   ����
echo --------------------------------------------------------
echo.
set /p operation3=����������ţ�[1/2/3/4/5]
set /p openfiles4=���������������[1/2/0]
if %operation3% == 1 if %openfiles4% == 1 ( sc config MSSQLSERVER start=AUTO )
if %operation3% == 1 if %openfiles4% == 2 ( sc config MSSQLSERVER start=DEMAND )
if %operation3% == 1 if %openfiles4% == 0 ( sc config MSSQLSERVER start=DISABLED )
if %operation3% == 2 if %openfiles4% == 1 ( sc config SQLBrowser start=AUTO )
if %operation3% == 2 if %openfiles4% == 2 ( sc config SQLBrowser start=DEMAND )
if %operation3% == 2 if %openfiles4% == 0 ( sc config SQLBrowser start=DISABLED )
if %operation3% == 3 if %openfiles4% == 1 ( sc config SQLTELEMETRY start=AUTO )
if %operation3% == 3 if %openfiles4% == 2 ( sc config SQLTELEMETRY start=DEMAND )
if %operation3% == 3 if %openfiles4% == 0 ( sc config SQLTELEMETRY start=DISABLED )
if %operation3% == 4 if %openfiles4% == 1 ( sc config SQLWriter start=AUTO )
if %operation3% == 4 if %openfiles4% == 2 ( sc config SQLWriter start=DEMAND )
if %operation3% == 4 if %openfiles4% == 0 ( sc config SQLWriter start=DISABLED )
if %operation3% == 5 if %openfiles4% == 1 ( sc config SQLSERVERAGENT start=AUTO )
if %operation3% == 5 if %openfiles4% == 2 ( sc config SQLSERVERAGENT start=DEMAND )
if %operation3% == 5 if %openfiles4% == 0 ( sc config SQLSERVERAGENT start=DISABLED )
goto EndApp

:EndApp
set /p var=�Ƿ����������[y/n]
if %var% == y ( 
	goto ShowFirst
	) else (
	exit )

exit
