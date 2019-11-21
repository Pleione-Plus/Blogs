@echo off
netstat -a -n > tmp.txt
type tmp.txt | find "7626" && echo "Congratulations! You have infected GLACIER!"
del tmp.txt
pause && exit