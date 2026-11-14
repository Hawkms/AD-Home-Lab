param([Parameter(Mandatory)][string]$Username)

Disable-ADAccount -Identity $Username
Get-ADUser $Username | Move-ADObject -TargetPath 
"OU=Disabled,OU=Company,DC=lab,DC=local"
Write-Host "User $Username has been disabled and moved to the Disabled OU."