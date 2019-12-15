@echo off
setlocal enabledelayedexpansion
SET skip=1

REM for all the directories indicated to contain core repositories
FOR /F "skip=%skip% delims=" %%i IN (demo.txt) DO (
    SET TgtDir=%%i
	SET TT = "123"
    echo !TgtDir!
	)
pause>nul