@echo on
color 0a
title �Ҽ�����½�BAT�ļ� %data%
echo �������...
::���BAT��ʽ�����ļ�
reg add HKCR\.bat\ShellNew /v nullfile /f
reg add HKCR\batfile /ve /d ������ /f 
pause

:: ��Ҫ����ԱȨ�޲�������