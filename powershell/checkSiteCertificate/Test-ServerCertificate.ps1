param(
    [Parameter(Mandatory=$true)]                    # parameter is required
    [ValidateScript({$_.Scheme -eq "https"})]       # no point in accepting http URIs
    [System.URI]$URI,                               # ensures parameter value is a valid URI

    [int]$WarnDaysBeforeExpiry = 30,                # set default value to 30
    [switch]$IgnoreSSLWarnings
)

# ignore warnings only if explicitly set
if ($IgnoreSSLWarnings){
    [Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
}

$request = [System.Net.HttpWebRequest]::Create($uri)

try{
    #Make the request but ignore (dispose it) the response, since we only care about the service point
    $request.GetResponse().Dispose()
}
catch [System.Net.WebException]{
    if ($_.Exception.Status -eq [System.Net.WebExceptionStatus]::TrustFailure){
        # We ignore trust failures, since we only want the certificate, and the service point is still populated at this point
    }
    else{
        # Let other exceptions bubble up, or write-error the exception and return from this method
        throw
    }
}

# The ServicePoint object should now contain the Certificate for the site.
$servicePoint = $request.ServicePoint

# TODO@manjaricode
# validate below call: $servicePoint.Certificate is $null on macOS, might be a Mac thing
# $expiryDate = $servicePoint.Certificate.NotAfter()

# TODO@manjaricode
# test line, remove when above line is tested and working
$expiryDate = (Get-Date -Date "2021-01-01 00:00:00Z")   
$expired = (Get-Date) -gt $expiryDate
$expiresInDays =  ($expiryDate - (Get-Date)).days

# record results and return them
$result = New-Object -Type PSCustomObject
$result | Add-Member -MemberType NoteProperty -Name Expired -Value $expired
$result | Add-Member -MemberType NoteProperty -Name ExpiresInDays -Value $expiresInDays
$result | Add-Member -MemberType NoteProperty -Name Warning -Value $null

if ($expiresInDays -le $WarnDaysBeforeExpiry){
    # TODO@manjaricode
    # get certificate CN for warningMessage below
    $warningMessage = "Certirficate (TODO: CN goes here) expires in $expiresInDays"
    $result.Warning = $warningMessage
    Write-Warning $warningMessage
}

return $result

