# Storyline: view the event logs, check for a valid log, and print the results

function select_status() {

    cls
    
    #$theLogs = Get-Service | Sort-Object Status -Unique | Select Status
    #$theLogs | Out-Host

    # initialize the array to store the logs
    $arrStatus = @('all', 'stopped', 'running')
    #$arrStatus = @('all')

    # $theLogs

    #foreach($tempLog in $theLogs) {
        
        # Add each log to the array
        # Note: these are stored to the array as a hashtable in the format:
        # @(Log=LOGNAME)
        #$arrLog += $tempLog

    #} #end foreach
    
    # Test to make sure array is being populated
    $arrStatus

    # Prompt the user for the log to view or quit
    $readStatus = read-host -Prompt "Please enter a log from the list above or 'q' to quit the program"

    # Check if the user wants to quit
    if ($readStatus -match "^[qQ]$") {

        #Stop executing the program and close the script
        break

    }

    status_check -statusToSearch $readStatus


} # ends select_log()

function status_check() {

    # String the user types in within the select_status function
    Param([string]$statusToSearch)

    $theStatus = "^@{Status=" + $statusToSearch + "}$"

    # Format the user input
    # Example: @{Log=Security}
    $theStatus = $statusToSearch


    # Search the array for the exact hashtable string
    # Note: unsure as to why an invalid entry still passes rather than going to the else, but it is still corrected later in the code
    if ($arrStatus -match $theStatus){
       
        write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the services"
        sleep 2

        # Call the function to view the log
        view_status -statusToSearch $statusToSearch

    } else {

        write-host -BackgroundColor Red -ForegroundColor white "The status specified doesn't exist."

        sleep 2

        select_status


    } # end else

} # ends status_check()

function view_status() {
   
    #cls
    #$statusToSearch

    # write-host "VIEW STATUS"

    # Get the logs
    if (($statusToSearch -match "running") -or ($statusToSearch -match "stopped")) {
        Get-Service | Where { $_.Status -eq $statusToSearch }
    } elseif ($statusToSearch -match "all") {
        Get-Service
    } else {
        write-host -BackgroundColor Red -ForegroundColor white "The status specified doesn't exist."

        sleep 2

        select_status
    }

    # Pause the screen and wait until the user is ready to proceed.
    read-host -Prompt "Press enter when you are done."

    # Go back to select_status
    select_status

} # ends view_status()

# Runs the select_status  as the first function
select_status