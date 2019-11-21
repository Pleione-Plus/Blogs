@echo on
color 0a
title 右键添加新建BAT文件 %data%
echo 正在添加...
::添加BAT格式配置文件
reg add HKCR\.bat\ShellNew /v nullfile /f
reg add HKCR\batfile /ve /d 批处理 /f 
pause

:: 需要管理员权限才能运行