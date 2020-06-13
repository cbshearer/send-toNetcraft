## Report phishing URL to Netcraft
## Chris Shearer
## 11-JUN-2020
## Netcraft public API: https://report.netcraft.com/api/v2#tag/report/paths/~1report~1urls/post

## Accept CLI parameters
    param ($u, $e, $r)

## Set TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

## Null some variables
    $Invoke = $null
    $result = $null

## Define possible endpoints, assign the one you want to use
    $test = "https://report.netcraft.com/api/v2/report/urls"
    $prod = "https://report.netcraft.com/api/v2/test/report/urls"
    
    $URI  = $test

## Assign your variables 
    if ($e) {$email = $e}
    else {$email = "you@your.com"}

    if ($r) {$reason = $r}
    else {$reason = "phish"}

## Enter your URLs here unless you're passing from CLI (up to 1000 URLs per submission are permitted)
    if ($u) {$URLs = @($u)}
    else    {$URLs = @("https://badguys.com/fake/o365/login.htm",
                       "https://somethingelse.com/lets/go/phishing.php")}  

## Null out variable, create and assign members, then convert to JSON
    $form = $null
    $form = New-Object -TypeName psobject
    $form | Add-Member -MemberType NoteProperty -Name email  -Value $email
    $form | Add-Member -MemberType NoteProperty -Name reason -Value $reason
    $form | Add-Member -MemberType NoteProperty -Name urls   -Value $URLs
    $form = $form | ConvertTo-Json
 
## Show what you are submitting
    Write-Host "======================="
    Write-Host "Submitting    :"
    foreach ($url in $URLs) {Write-Host -f cyan "  " $url}
    Write-Host "with address  :" $email
    Write-Host "for reason    :" $reason
    Write-Host "======================="

## Submit
    try {
        $Invoke = Invoke-WebRequest -Uri $URI -Method Post -body $form -ContentType "application/json" #-ErrorAction SilentlyContinue
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
                Write-Host "Result Status : " -nonewline; Write-Host -f Green $invoke.StatusCode
                Write-Host "Result Message: " -NoNewline; Write-Host -f Green $result.message
                Write-Host "Result UUID   : " -NoNewline; Write-Host -f Green $result.uuid
                Write-Host "Submission URL: " -NoNewline; Write-Host -f Blue  $ResultURL
        }
    else 
        {
            Write-Host "Result Status : " -nonewline; Write-Host -f Yellow $result.status
            Write-Host "Result Message: " -NoNewline; Write-Host -f Yellow $result.details.message
        }
