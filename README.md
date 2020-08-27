# send-toNetcraft

- Use the NetCraft API to send URLs to Netcraft to report as phishing sites.
- Netcraft [API Documentation](https://report.netcraft.com/api/v2#tag/report/paths/~1report~1urls/post).

## To use the module

- Import the module

```PowerShell
PS C:\temp> Import-Module .\send-toNetcraft.psm1
```

- If you want to install the module for long-term use
  - See [Microsoft documentation](https://docs.microsoft.com/en-us/powershell/scripting/developer/module/installing-a-powershell-module?view=powershell-7).
  - Shortcut - just copy to its own folder in this location: $Env:ProgramFiles\WindowsPowerShell\Modules

```PowerShell
PS C:\temp> copy .\send-toNetcraft.psm1 $Env:ProgramFiles\WindowsPowerShell\Modules\send-toNetcraft\send-toNetcraft.psm1
```

- Change parameters on the following lines:  
  - 51: Default Email address you will submit as
  - 53: Default reason for submitting (phish by default)
  - 67: Pick the $prod or $test URI endpoint ($prod by default)

- Mandatory parameter
  - -u: URL
  - Comma separated for multiple
- Optional parameters - The defaults can be changed in your .psm1 file (lines 51 & 53 as noted above):
  - -e: Email address to report as
  - -r: Reason for reporting  
- Examples:

```PowerShell
send-toNetcraft -u http://superfake.com/really/really/awful.php  
send-toNetcraft -u https://veryphishy.buzz/very/phishy/o365.html -e you@your.com -r phishing  
send-toNetcraft -u https://veryphishy.buzz/very/phishy.zip -r "phishing kit"
send-toNetcraft -u www.badguyz.top/very/badstuff.php,reallylame.xyz/badstuff.asp
```
