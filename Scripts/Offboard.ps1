param([Parameter(Mandatory)][string]$Username)

Disable-ADAccount -Identity $Username

Get-ADUser $Username | Move-ADObject -TargetPath "OU=Disabled,OU=Company,DC=lab,DC=local"

$user = Get-ADUser $Username -Properties Enabled
if ($user.Enabled -eq $false -and $user.DistinguishedName -like "*OU=Disabled,*") {
    Write-Host "$Username has been disabled and moved to the Disabled OU." -ForegroundColor Green
}
else {
    Write-Host "Offboarding did not finish for $Username." -ForegroundColor Red
    Write-Host "Enabled: $($user.Enabled)"
    Write-Host "Location: $($user.DistinguishedName)"
}