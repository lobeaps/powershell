#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Bootstrap Lobe computers with proper orginazational requirements
.DESCRIPTION
    Initialization of host machines throughtout the company.
    Used when employees needs a fresh installation or a new computer.
.NOTES
    File Name      : Lobe-first-boot.ps1
    Author         : Philip Kjærsgaard (pk@lobe.dk)
    Prerequisite   : PowerShell V5 on Win10.
    Copyright 2019 - Philip Kjærsgaard/yosoyphil
.LINK
    Script posted over:
    http://replace-once-repo-is-public
.EXAMPLE
    1. Open PowerShell as Admin
    2. Navigate to script folder and type:
       Set-ExecutionPolicy Bypass -Scope Process
       .\bootstrap-employee-computer.ps1
#>

# What to do about errors?
$ErrorActionPreference = "Continue"

# SID of Administrators group on Win10 systems
$AdminGroupSID = "S-1-5-32-544"

# Get users Office 365 email account
$_mail = Read-Host -Prompt "Office 365 email"

try {
    # Grant local Office 365 user account membership of Administrators
    Add-LocalGroupMember -SID $AdminGroupSID -Member AzureAD\$_mail -ErrorAction Stop
} catch [Microsoft.PowerShell.Commands.MemberExistsException] {
    # Already in group
    Write-Host "[ERROR] User is already member of group!"
} 

# Get user prefix in email for pc name
$seperator = "@"
$_name = $_mail.split($seperator)
$_newName = $_name[0].ToString()

try {
    Rename-Computer -NewName LOBE-$_newName -ErrorAction Stop
} catch {
    # Proper exception handling
    Write-Host "[ERROR]" $PSItem.Exception.Message
} 

# Disable Hyperlink warning in Office 16.0
$RegKey = "HKCU:\Software\Policies\Microsoft\Office\16.0\Common\Security"
if (-Not(Test-Path "$RegKey")) {
    New-Item -Path $RegKey -Force
}
Set-ItemProperty -Path $RegKey -Name "DisableHyperlinkWarning" -Value 1
