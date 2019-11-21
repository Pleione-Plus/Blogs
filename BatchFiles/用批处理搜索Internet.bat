@echo off
set a=
set /p a=请输入关键字：
start http://www.baidu.com/s?wd=%a%

:: 会使用默认浏览打开链接