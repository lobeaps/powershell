<#
.SYNOPSIS
    Get all users calendars and adjust default permissions
.DESCRIPTION
    Per default calendar permissions are very limited within an O365 tenant.
    This script is used to get all users via Exchange Online Module v2
.NOTES
    File Name      : O365-set-all-users-calendar-perms.ps1
    Author         : Philip Kjærsgaard (pk@lobe.dk)
    Prerequisite   : PowerShell V5 on Win10.
    Copyright 2020 - Philip Kjærsgaard/yosoyphil
.LINK
    Script posted over:
    https://github.com/lobeaps/powershell
.EXAMPLE
    1. Make sure Exchange Online Module v2 is installed
    2. Navigate to script folder and type:
       .\O365-set-all-users-calendar-perms.ps1
#>

Connect-ExchangeOnline -UserPrincipalName pk@lobe.dk -ShowProgress $false

$Users = Get-EXORecipient -Filter "RecipientTypeDetails -eq 'UserMailbox'"

foreach ($User in $Users) {
    $CalendarOwner = $User.PrimarySmtpAddress.toString()
    $CalendarName = Get-EXOMailboxFolderStatistics -Identity $CalendarOwner -FolderScope calendar | where-object {$_.FolderType -eq "Calendar"}
    $CalendarIdentity = $CalendarOwner + ':\' +$CalendarName.Name
    try {
        Set-MailboxFolderPermission $CalendarIdentity -User Default -AccessRights Reviewer
        Write-Host "$CalendarIdentity - default permisssion has been set to 'Reviewer'"
    } catch {
        Write-Warning "No calendar found for user $User"
    }
}

Get-PSSession | Remove-PSSession