
$mydir = "C:\Users\mpaga\FA21-SYS-320-02\Week11\homework\results"

function get_info() {
    # 1. Running processes and the path for each process
    #$processes = 
    Get-Process | Select-Object ProcessName, Path | Export-Csv -Path "$mydir\processes.csv"
    Write-Host "Get-Process information saved." 

    # 2. all registered services and the path to the executable controlling the service
    #$regServices = 
    Get-WmiObject -Class Win32_Service | Select-Object name, Path | Export-Csv -Path "$mydir\regServices.csv"
    Write-Host "Registered services information saved."

    # 3. all tcp network sockets
    #$tcpNetworkSockets = 
    Get-NetTCPConnection | Export-Csv -Path "$mydir\tcpNetworkSockets.csv"
    Write-Host "TCP Network Sockets saved."

    # 4. all user account information (use wmi)
    #$userAcctInfo = 
    Get-WmiObject -Class Win32_UserAccount | Select * | Export-Csv -Path "$mydir\userAcctInfo.csv"
    Write-Host "User account information saved."

    # 5. all network adapter configuration information
    #$networkAdaptherInfo = 
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Export-Csv -Path "$mydir\networkAdapterInfo.csv"
    Write-Host "Network Adapter Configuration information saved."

    <#Use Powershell cmdlets to save 4 other artifacts that would be useful in an incident but only use Powershell cmdlets.  
     In your code comment, explain why you selected those four cmdlets and the value it would provide for an incident investigation.
     https://www.hackingarticles.in/incident-response-windows-cheatsheet/
     https://www.securityinbits.com/incident-response/powershell-commands-for-incident-response/#powershell #>

    # 6. File share permissions
    # Looking at whether the file share permissions have been changed or not can help determine the integrity of the system
    #$sharePermissions = 
    Get-SmbShare | Export-Csv -Path "$mydir\sharePermissions.csv"
    Write-Host "File share permissions saved."

    # 7. Firewall Settings
    # Firewall settings are inportant to look at to ensure that malicious and/or unnecessary traffic is reaching your system
    #$firewallSettings = 
    netsh advfirewall show currentprofile | Export-Csv -Path "$mydir\firewallSettings.csv"
    Write-Host "Firewall settings saved."

    # 8. Check for malicious processes - 
    # Get-Wmiobject is deprecated, so this is a better cmdlet to use for incident response
    #$cimInstance = 
    Get-CimInstance -Class Win32_Process | Format-Table -Property ProcessId, ProcessName, CommandLine -AutoSize `
    | Export-Csv -Path "$mydir\cimInstance.csv"
}

# 9. Get-EventLogs
# Looking at the Event Logs will help assist in finding anything out of the ordinary to help diagnose where the problem could have started
function event_logs() {

# List all the available Windows Event logs
Get-EventLog -List

# Create a prompt to allow user to select the log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above."

# Find a string from your event logs to search on
Get-EventLog -LogName $readLog  -Newest 40 | Sort-Object EventID -Unique | Format-Table EventID, Message 

$readPhrase = Read-Host -Prompt "Please specify a keyword or phrase to search."

# Print the results for that log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$readPhrase*"}| Export-Csv -NoTypeInformation `
-Path "$mydir\securityLogs.csv"
}


# Find the Powershell cmdlet that can create a 'FileHash' of the resulting CSV files, create a checksum for each one, and save the results to a file within the results directory.  
# The file containing checksums should have the filename and the corresponding checksum.
function file_hash() {

    cd $mydir

    <#ls C:\Users\mpaga\FA21-SYS-320-02\Week11\homework
    
    $readFile = read-host -Prompt "What file would you like to obtain the hash for? You can press 'q' to quit the program."

    
    # Check if the user wants to quit
    if ($readStatus -match "^[qQ]$") {
        # Stop executing the program and close the script
        break
    }#>

    Clear-Content -Path "$mydir\hashes.txt"
    Get-FileHash -Path "$mydir\processes.csv" -Algorithm MD5 | Add-Content hashes.txt
    Get-FileHash -Path "$mydir\regServices.csv" -Algorithm MD5 | Add-Content hashes.txt
    Get-FileHash -Path "$mydir\tcpNetworkSockets.csv" -Algorithm MD5 | Add-Content hashes.txt    
    Get-FileHash -Path "$mydir\userAcctInfo.csv" -Algorithm MD5 | Add-Content hashes.txt
    Get-FileHash -Path "$mydir\networkAdapterInfo.csv" -Algorithm MD5 | Add-Content hashes.txt
    Get-FileHash -Path "$mydir\sharePermissions.csv" -Algorithm MD5 | Add-Content hashes.txt
    Get-FileHash -Path "$mydir\firewallSettings.csv" -Algorithm MD5 | Add-Content hashes.txt
    Get-FileHash -Path "$mydir\cimInstance.csv" -Algorithm MD5 | Add-Content hashes.txt
    Get-FileHash -Path "$mydir\securityLogs.csv" -Algorithm MD5 | Add-Content hashes.txt



}

# Create a checksum of the zipped file and save it to a file.


# Email zipped file to prof. Be sure your from address is your Champlain email address
function send_mail() {

    # email body
    $msg = "This is an email for Miranda Pagarelski's Week 11 assignment" # Make sure to add zipped file here!!!!!!!!!!

    Write-Host -BackgroundColor Red -ForegroundColor White $msg

    # Email from address
    $fromEmail = "miranda.pagarelski@mymail.champlain.edu"

    # Email To address
    #$toEmail = "jletourneau@champlain.edu"
    $toEmail ="miranda.pagarelski@mymail.champlain.edu"

    # Sending the email
    Send-MailMessage -From $fromEmail -To $toEmail -Subject "Week 11 Assignment" -Body $msg `
    -Attachments "C:\Users\mpaga\Desktop\results.zip","C:\Users\mpaga\Desktop\results_hash.txt" -SmtpServer 192.168.6.71
}

get_info
event_logs
file_hash
cd C:\Users\mpaga\Desktop

# Use the Powershell cmdlet Compress-Archive to zip the directory where the results are stored (ensure it has a .zip file extension).  
# NOTE: You will need to save the zip file outside of the directory where you store the results from the commands above.  
# Otherwise, you will receive an error because as the zip file is being created, it is open, and has a file lock.  You can't zip an open file on Windows.
Compress-Archive C:\Users\mpaga\FA21-SYS-320-02\Week11\homework\results -DestinationPath C:\Users\mpaga\Desktop\results.zip -Force

# Create a checksum of the zipped file and save it to a file.
Get-FileHash -Path "C:\Users\mpaga\Desktop\results.zip" -Algorithm MD5 | Set-Content -Path "C:\Users\mpaga\Desktop\results_hash.txt"

send_mail