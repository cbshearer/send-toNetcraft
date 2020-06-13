# send-toNetcraft
Use the NetCraft API to send URLs to Netcraft to report as phishing sites (https://report.netcraft.com/api/v2#tag/report/paths/~1report~1urls/post).  
Change parameters on the following lines:  
- 20: $prod or $test
- 24: email address you are submitting as
- 27: reason for submitting
  
> Currently we accept reports of phishing, malware, web shell and phishing kit URLs.  

https://report.netcraft.com/report  

To use from CLI:  
- Mandatory parameter
  - -u: URL
- These are considered optional parameters because they can be hard-coded in your .ps1 file: 
  - -e: Email address to report as
  - -r: Reason for reporting  
- Examples:   
>  .\send-toNetcraft.ps1 -u https://superfake.com/really/really/awful.php  
>  .\send-toNetcraft.ps1 -u https://veryphishy.buzz/very/phishy/o365.html -e you@your.com -r phishing  
>  .\send-toNetcraft.ps1 -u https://veryphishy.buzz/very/phishy.zip -e you@your.com -r "phishing kit"
