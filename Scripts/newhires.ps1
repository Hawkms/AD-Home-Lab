Import-Module ActiveDirectory
$tempPassword = ConvertTo-SecureString "Welcome!2026Lab" -AsPlainText -Force

foreach ($hire in Import-Csv .\newhires.csv) {
    if (Get-ADUser -Filter "SamAccountName -eq '$($hire.Username)'") {
        Write-Host "User $($hire.Username) already exists. Skipping creation."
        continue
    }
    New-ADUSer -Name "$($hire.First) $($hire.Last)" `
        -GivenName $hire.First `
        -Surname $hire.Last `
        -SamAccountName $hire.Username `
        -UserPrincipalName "$($hire.Username)@lab.local" `
        -Path "OU=$($hire.Department),OU=Company,DC=lab,DC=local" `
        -AccountPassword $tempPassword `
        -Enabled $true -ChangePasswordAtLogon $true
    Add-AdGroupMember -Identity "$($hire.Department)-Staff" -Members $($hire.Username)
    Write-Host "User $($hire.Username) created and added to $($hire.Department)-Staff group."
}