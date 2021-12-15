<#
    .Synopsis
        Script to parse the latest NVD dataset feed.

    .Description
        This file will parse a JSON file and return the results as a csv file.
    
    .Example
        .\Week15.ps1 -y "2020" -k "cisco" -f "nvd-data.cs"
   
    .Example
        .\Week15.ps1 -y "2020" -k "java" -f "nvd-data.csv"
 
    .Notes 
        Created by Miranda Pagarelski December 14, 2021
#>
param(

    [alias("y")]
    [Parameter (Mandatory=$true)]
    [int]$year,

    [alias("k")]
    [Parameter (Mandatory=$true)]
    [string]$keyword,

    [alias("f")]
    [Parameter (Mandatory=$true)]
    [string]$filename
)

cls

# convert Json file into powershell object
$nvd_vulns = (Get-Content -Raw -Path ".\nvdcve-1.1-$year.json" | `
ConvertFrom-Json) | select CVE_Items 

#csv file
$filename = "nvd-data.csv"

#headers for the csv file
Set-Content -Value "`"PublishDate`", `"Description`", `"Impact`", `"CVE`"" $filename

# Array to store the data
$theV = @()

foreach ($vuln in $nvd_vulns.CVE_Items) {
    # Vuln Description
    $descript = $vuln.cve.description.description_data

    #$keyword = "java"

    # Search for the keyword
    if ($descript -imatch "$keyword") {

        #Published date
        $pubDate = $vuln.publishedDate

        #description
        $z = $descript | select value
        $description = $z.value
        
        #impact
        $y = $vuln.impact
        $impact = $y.baseMetricV2.severity
        
        #cve number
        $cve = $vuln.cve.CVE_data_meta.ID

        #format the csv file
        $theV += "`"$pubDate`", `"$description`", `"$impact`", `"$cve`"`n"
    
    }

} #end foreach loop

#convert the array to a string to a string and append to the csv file
"$theV" | Add-Content -path $filename