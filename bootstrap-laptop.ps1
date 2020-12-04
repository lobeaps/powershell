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
    https://github.com/lobeaps/powershell
.EXAMPLE
    1. Open PowerShell as Admin
    2. Navigate to script folder and type:
       Set-ExecutionPolicy Bypass -Scope Process
       .\bootstrap-laptop.ps1
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

# Set RealTime to UTC
$RegKey = "HKLM:\System\CurrentControlSet\Control\TimeZoneInformation"
if (-Not(Test-Path "$RegKey")) {
    New-Item -Path $RegKey -Force
}
Set-ItemProperty -Path $RegKey -Name "RealTimeIsUniversal" -Value 1

# Disable Hyperlink warning in Office 16.0
$RegKey = "HKCU:\Software\Policies\Microsoft\Office\16.0\Common\Security"
if (-Not(Test-Path "$RegKey")) {
    New-Item -Path $RegKey -Force
}
Set-ItemProperty -Path $RegKey -Name "DisableHyperlinkWarning" -Value 1


# curl and run silent install
# our curl command, with basic authentication if $credentials provided
function Get-Url {
    param(
        [string]$url, # e.g. "http://dl.google.com/chrome/install/375.126/chrome_installer.exe"
        [string]$filepath, # e.g. "c:\temp\chrome_installer.exe"
        [string]$credentials # e.g. "username:pass"
    )

    $client = New-Object System.Net.WebClient;

    if ($credentials) {
        $credentialsB64 = [System.Text.Encoding]::UTF8.GetBytes($credentials) ;
        $credentialsB64 = [System.Convert]::ToBase64String($credentialsB64) ;    
        $client.Headers.Add("Authorization", "Basic " + $credentialsB64) ;
    }    

    $client.DownloadFile($url, $filepath);
}

Get-Url http://dl.google.com/chrome/install/375.126/chrome_installer.exe c:\temp\chrome_installer.exe
c:\temp\chrome_installer.exe /silent /install


try {
    # Remove local Office 365 user from Administrators
    Remove-LocalGroupMember -SID $AdminGroupSID -Member AzureAD\$_mail -ErrorAction Stop
} catch [Microsoft.PowerShell.Commands.RemoveLocalGroupMemberCommand] {
    # Already in group
    Write-Host "[ERROR] Could not remove user from admin group"
} 

