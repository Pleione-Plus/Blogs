@echo off

::::::::::::::::::::::::::::::::::::::::::::::::::
:: 作用：对SQL Serve服务进行配置与操作
:: 功能：
::     -> 仅开启MSSQLSERVER服务
::     -> 关闭与SQL Server相关的所有服务
::     -> 显示与SQL Server相关的所有服务
::     -> 配置SQL Server服务的启动类型
::     -> 
:: 缺点：
::     -> 未实现自由指定服务的操作
::     -> 未实现显示当前SQL Server服务的启动类型
:: 参考链接：
::     -> https://www.cnblogs.com/pingming/p/5108947.html
::     -> https://www.cnblogs.com/wghao/archive/2011/09/23/2187821.html
::::::::::::::::::::::::::::::::::::::::::::::::::

title SQL Server服务配置与操作
color 06

:: 权限代码
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close) && exit


:ShowFirst
cls
echo 操作说明：
echo -----------------------------------------
echo   -^> 1    开启SQL Server服务(以缺省值)
echo   -^> 2    停止所有SQL Server服务
echo   -^> 3    显示本机的SQL Server服务列表
echo   -^> 0    取消批处理操作
echo -----------------------------------------
echo.
set /p operation1=请输入操作编号：[1/2/3/0]
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
echo 本机的SQL Server服务列表：
echo -----------------------------------
echo   -^> 1   服务名称：MSSQLSERVER
echo   -^> 2   服务名称：SQLBrowser
echo   -^> 3   服务名称：SQLTELEMETRY
echo   -^> 4   服务名称：SQLWriter
echo   -^> 5   服务名称：SQLSERVERAGENT
echo -----------------------------------
echo 操作命令：
echo   -^> 1      显示详细的SQL Server服务信息
echo   -^> 2      手动配置SQL Server服务
echo   -^> 0      结束批处理操作
echo -----------------------------------
echo.
set /p operation2=请输入操作编号：[1/2/0]
if %operation2% ==1 goto ShowServerInfo
if %operation2% ==2 goto ConfigSQLServer
if %operation2% ==0 goto EndApp

:ShowServerInfo
cls
echo 显示详细的SQL Server服务信息：
echo --------------------------------------------------------------
echo   -^> 1 服务名称：MSSQLSERVER
echo         显示名称：SQL Server (MSSQLSERVER)
echo         描述信息：提供数据的存储、处理和受控访问，并提供
echo                   快速的事务处理。
echo.
echo   -^> 2 服务名称：SQLBrowser
echo         显示名称：SQL Server Browser
echo         描述信息：将 SQL Server 连接信息提供给客户端计算
echo                   机。
echo.
echo   -^> 3 服务名称：SQLTELEMETRY
echo         显示名称：SQL Server CEIP service (MSSQLSERVER)
echo         描述信息：CEIP service for Sql server 
echo.
echo   -^> 4 服务名称：SQLWriter
echo         显示名称：SQL Server VSS Writer
echo         描述信息：提供用于通过 Windows VSS 基础结构备份/
echo                   还原 Microsoft SQL Server 的接口。
echo.
echo   -^> 5 服务名称：SQLSERVERAGENT
echo         显示名称：SQL Server 代理 (MSSQLSERVER)
echo         描述信息：执行作业、监视 SQL Server、激发警报，以
echo         及允许自动执行某些管理任务。
echo.
echo --------------------------------------------------------------
goto EndApp

:ConfigSQLServer
cls
echo 手动配置SQL Server服务：
echo --------------------------------------------------------
echo   -^> 1   服务名称：MSSQLSERVER
echo   -^> 2   服务名称：SQLBrowser
echo   -^> 3   服务名称：SQLTELEMETRY
echo   -^> 4   服务名称：SQLWriter
echo   -^> 5   服务名称：SQLSERVERAGENT
echo --------------------------------------------------------
echo 启动类型：
echo   -^> 1   自动
echo   -^> 2   手动
echo   -^> 0   禁用
echo --------------------------------------------------------
echo.
set /p operation3=请输入服务编号：[1/2/3/4/5]
set /p openfiles4=请输入操作动作：[1/2/0]
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
set /p var=是否继续操作：[y/n]
if %var% == y ( 
	goto ShowFirst
	) else (
	exit )

exit
