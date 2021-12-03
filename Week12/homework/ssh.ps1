cls

# Login to a remote SSH server
#New-SSHSession -ComputerName '192.168.229.141' -Credential (Get-Credential root)

<#
while ($True) {
    # Add a prompt to run commands
    $the_cmd = read-host -Prompt "Please enter a command"

    # Run command on remote SSH server
    (Invoke-SSHCommand -index 0 $the_cmd).Output
}
#>

Set-SCPItem -Computername '192.168.229.141' -Credential (Get-Credential root) `
-Path '.\hi.txt' -Destination '/home/sys320'