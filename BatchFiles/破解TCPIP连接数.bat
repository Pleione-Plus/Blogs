echo on
echo By Original
takeown /f %WinDir%\System32\drivers\tcpip.sys 1>nul 2>nul
echo y|cacls %WinDir%\System32\drivers\tcpip.sys /G %username%:F 1>nul 2>nul
replace tcpip.sys %WinDir%\System32\drivers\ 1>nul 2>nul
netsh int tcp set global autotuninglevel=disable 1>nul 2>nul
set /p ConnNum=������ϣ����TCP/IP��������
reg add HKLM\System\CurrentControlSet\Services\Tcpip\Parameters /v TcpNumConnections /t REG_DWORD /d %ConnNum% /f 1>nul 2>nul
echo �޸���ɣ���������˳�...
pause 1>nul