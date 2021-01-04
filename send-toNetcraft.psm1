## Report phishing URL to Netcraft - the Module
## Chris Shearer
## 3-JAN-2021
## Netcraft public API: https://report.netcraft.com/api/v2#tag/report/paths/~1report~1urls/post
## Github repository for this module: https://github.com/cbshearer/send-toNetcraft

function send-toNetcraft {

    <#
    .Synopsis
    This module sends one or more URLs to Netcraft for analysis.
    .Description
    This module sends one or more URLs to Netcraft for analysis. 
    .Parameter u
    The URL being submitted.
    Multiple URLs may be submitted when comma separated.
    .Parameter e
    The email address to be credited with the submission.
    .Parameter r
    The reason the URL is being submitted.
    Currently (Netcraft) accept reports of phishing, malware, web shell and phishing kit URLs (https://report.netcraft.com/report).
    Default value of "phish" is specified by this module.
    .Inputs
    URL as parameter -u.
    An e-mail address as parameter -e.
    A reason as parameter -r.
    Reason default is 'phish', use 'pk' as an alias for 'phishing kit'
    .Outputs
    Result code of submission.
    Result message of submission.
    Resulting UUID.
    Resulting Analysis URL.
    .Example
     # Submit a URL
     send-toNetcraft -u http://superfake.com/really/really/awful.php
    .Example
     # Submit a URL, also specifying an email address and a reason
     send-toNetcraft -u https://veryphishy.buzz/very/phishy/o365.html -e some@example.com -r phishing
    .Example
     # Submit a URL, specifying only a reason
     send-toNetcraft -u https://veryphishy.buzz/very/phishy.zip -r "phishing kit"
    .Example
     # Submit multiple URLs
     send-toNetcraft -u www.badguyz.top/very/badstuff.php,reallylame.xyz/badstuff.asp
    .Example
     # Submit a URL, using the reason 'pk' as an alias for 'phishing kit'
     send-toNetcraft -u www.scams-r-us.xyz/folder1/folder1.zip -r pk
    #>
    
    ## Accept CLI parameters 
        param (
            # U is the URL which is mandatory
                [Parameter(Mandatory=$true)] [array]$u, 
            # E is for e-mail address, which should be set here by the user so they don't have to enter it every time.
                [string]$e = "you@your.com", 
            # R is for reason, which is set as phish by default
                [string]$r = "phish"
            )
    
    ## Set TLS 1.2
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    ## Null some variables
        $Invoke = $null
        $result = $null
    
    ## Define possible endpoints, assign the one you want to use
        $prod = "https://report.netcraft.com/api/v2/report/urls"
        $test = "https://report.netcraft.com/api/v2/test/report/urls"
        
        $URI  = $prod
    
    ## Assign your variables 
        $email = $e
        if ($r = "pk") {$r = "phishing kit"}
        $reason = $r
    
    ## Enter your URLs here (up to 1000 URLs per submission are permitted). If one is supplied as a parameter, use that, otherwise you can specify arrays for analysis.
        if ($u) {$URLs = @($u)}
        else    {$URLs = @()}
    
    ## Null out variable, create and assign members, then convert to JSON
        $form = $null
        $form = New-Object -TypeName psobject
        $form | Add-Member -MemberType NoteProperty -Name email  -Value $email
        $form | Add-Member -MemberType NoteProperty -Name reason -Value $reason
        $form | Add-Member -MemberType NoteProperty -Name urls   -Value $URLs
        $form = $form | ConvertTo-Json
     
    ## Show what you are submitting
        Write-Host "======================="
        Write-host "URL count     :" $u.count
        Write-Host "Submitting    :"
        foreach ($url in $URLs) {Write-Host -f cyan "  " $url}
        Write-Host "Email address :" $email
        Write-Host "For reason    :" $reason
        Write-Host "======================="
    
    ## Submit
        try {
            $Invoke = Invoke-WebRequest -Uri $URI -Method Post -body $form -ContentType "application/json"
            $result = $Invoke.Content | ConvertFrom-Json
        }
        catch {
            $result = $_.errorDetails | ConvertFrom-Json
        }
        
    ## Analyze response
        if ($invoke.StatusCode -eq "200")
            {
                ## Build Result URL
                    $ResultURL = "https://report.netcraft.com/submission/" + $result.uuid
    
                ## Display useful information
                    Write-Host "Result status : " -nonewline; Write-Host -f Green $invoke.StatusCode
                    Write-Host "Result message: " -NoNewline; Write-Host -f Green $result.message
                    Write-Host "Result UUID   : " -NoNewline; Write-Host -f Green $result.uuid
                    Write-Host "Submission URL: " -NoNewline; Write-Host -f Blue  $ResultURL
            }
        else 
            {
                Write-Host "Result Status : " -nonewline; Write-Host -f Yellow $result.status
                Write-Host "Result Message: " -NoNewline; Write-Host -f Yellow $result.details.message
            }
    
    }
    
    Export-ModuleMember -Function Send-toNetcraft
