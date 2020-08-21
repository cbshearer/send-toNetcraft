# send-toNetcraft

- Use the NetCraft API to send URLs to Netcraft to report as phishing sites.
- API Documentation: https://report.netcraft.com/api/v2#tag/report/paths/~1report~1urls/post.

## To use the module

- Import the module

```PowerShell
PS C:\temp> Import-Module .\send-toNetcraft.psm1
```

- Change parameters on the following lines:  
  - 67: Pick the $prod or $test URI endpoint ($prod by default)
  - 51: Default Email address you will submit as
  - 53: Default reason for submitting (phish by default)

- Mandatory parameter
  - -u: URL
  - Comma separated for multiple
- These are considered optional parameters. The defaults can be changed in your .psm1 file (lines 51 & 53 as noted above):
  - -e: Email address to report as
  - -r: Reason for reporting  
- Examples:

```PowerShell
send-toNetcraft -u http://superfake.com/really/really/awful.php  
send-toNetcraft -u https://veryphishy.buzz/very/phishy/o365.html -e you@your.com -r phishing  
send-toNetcraft -u https://veryphishy.buzz/very/phishy.zip -r "phishing kit"
send-toNetcraft -u www.badguyz.top/very/badstuff.php,reallylame.xyz/badstuff.asp
```
