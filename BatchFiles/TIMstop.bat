@echo off

start taskkill /f /im TIM.exe
start taskkill /f /im TXPlatform.exe
start taskkill /f /im QQProtect.exe

::实际上是通过“任务管理器”终止的进程来实现的