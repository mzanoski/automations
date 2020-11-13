# Check Server Certificate

## Expiry Date
__Test-ServerCertificateExpiry.ps1__ checks the SSL certificate expiry date and returns values as follows:

~~~~powershell
Name          MemberType   Definition
----          ----------   ----------
Equals        Method       bool Equals(System.Object obj)
GetHashCode   Method       int GetHashCode()
GetType       Method       type GetType()
ToString      Method       string ToString()
Expired       NoteProperty bool Expired=False
ExpiresInDays NoteProperty int ExpiresInDays=30
Warning       NoteProperty object Warning=null
~~~~

Example
~~~~powershell
> ./Test-ServerCertificate.ps1 -URI "https://www.facebook.com"

Expired ExpiresInDays Warning
------- ------------- -------
  False            48

> ./Test-ServerCertificate.ps1 -URI "https://www.facebook.com" -WarnDaysBeforeExpiry 50
WARNING: Certirficate (TODO: CN goes here) expires in 48

Expired ExpiresInDays Warning
------- ------------- -------
  False            48 Certirficate (TODO: CN goes here) expires in 48

> $serverCert = ./Test-ServerCertificate.ps1 -URI "https://www.facebook.com"
> $serverCert.Expired
False
> $serverCert.ExpiresInDays
48
~~~~