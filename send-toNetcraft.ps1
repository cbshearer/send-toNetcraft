## Report phishing URL to Netcraft
## Chris Shearer
## 11-JUN-2020
## Netcraft public API: https://report.netcraft.com/api/v2#tag/report/paths/~1report~1urls/post

## Set TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

## Define possible endpoints, assign the one you want to use
    $test = "https://report.netcraft.com/api/v2/report/urls"
    $prod = "https://report.netcraft.com/api/v2/test/report/urls"
    $URI  = $prod

## Assign your variables 
    $email  = "you@your.com"
    $reason = "phish"

## Enter your URLs here (up to 1000 URLs per submission are permitted)
    $URLs = @(  
                "https://badguys.com/fake/o365/login.htm",
                "https://somethingelse.com/lets/go/phishing.php"
                )

## Null out variable, create and assign members, then convert to JSON
    $form = $null
    $form = New-Object -TypeName psobject
    $form | Add-Member -MemberType NoteProperty -Name email  -Value $email
    $form | Add-Member -MemberType NoteProperty -Name reason -Value $reason
    $form | Add-Member -MemberType NoteProperty -Name urls   -Value $URLs
    $form = $form | ConvertTo-Json
 
## Show what you are submitting
    Write-Host "======================="
    Write-Host "Submitting"
    foreach ($url in $URLs) {write-host -f cyan "  " $url}

## Submit
    $Invoke = Invoke-WebRequest  -Uri $URI -Method Post -body $form -ContentType application/json

## Analyze response
    $result = $Invoke.Content | ConvertFrom-Json

    if ($invoke.StatusCode -eq "200")
        {
            ## Build Result URL
                $ResultURL = "https://report.netcraft.com/submission/" + $result.uuid

            ## Display useful information
                write-host "Result Status : " -nonewline; write-host -f Green $invoke.StatusCode
                write-host "Result Message: " -NoNewline; write-host -f Green $result.message
                write-host "Result UUID   : " -NoNewline; write-host -f Green $result.uuid
                Write-Host "Submission URL: " -NoNewline; write-host -f Green $ResultURL
        }
    else 
        {
            write-host "Result Status : " -nonewline; write-host -f Yellow $invoke.StatusCode
            write-host "Result Message: " -NoNewline; write-host -f Yellow $result.message
        }
