param(
    [Parameter(Mandatory=$true)]                # parameter is required
    [ValidateScript({Test-Path $_})]            # validates that path exists
    [System.IO.FileInfo]$ConfigFilePath         # ensures parameter value is a valid path string
)

return Get-Content -Path $ConfigFilePath | ConvertFrom-Json

