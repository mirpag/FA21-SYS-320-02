# Storyline: Using the Get-Process and Get-Service
# Get-Process | Select-Object ProcessName, Path, ID | `
# Export-Csv -Path "C:\Users\mpaga\Desktop\myProcesses.csv" -NoTypeInformation
# Get-Process | Get-Member
# Get-Service | Where { $_.Status  -eq "Stopped" }


Get-Process | Select-Object ProcessName, Path, ID | `
Export-Csv -Path "C:\Users\mpaga\FA21-SYS-320-02\Week09\homework\myProcesses.csv" -NoTypeInformation

Get-Service | Where { $_.Status -eq "Running"} | `
Export-Csv -Path "C:\Users\mpaga\FA21-SYS-320-02\Week09\homework\myRunningServices.csv" -NoTypeInformation