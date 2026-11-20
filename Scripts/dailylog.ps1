$date = Get-Date -Format yyyy-MM-dd

Search-ADAccount -LockedOut -UsersOnly |
    Select-Object Name, SamAccountName, LockedOut, LastLogonDate |
    Export-Csv ".\locked_users_$date.csv" -NoTypeInformation

Search-ADAccount -AccountInactive -TimeSpan (New-TimeSpan -Days 90) -UsersOnly |
    Select-Object Name, SamAccountName, LastLogonDate |
    Export-Csv ".\inactive_users_$date.csv" -NoTypeInformation