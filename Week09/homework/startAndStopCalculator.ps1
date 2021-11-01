# Write a program that can start and stop the Windows Calculator only using Powershell 
# and using only the process name for the Windows calculator (to start and stop it)


Start-Process win32calc 
Start-Sleep 5
Stop-Process -Name win32calc