#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Make Windows 10 use Local Time
.DESCRIPTION
    Make Windows 10 use UTC Time.
.NOTES
    File Name      : enable-localtime.ps1
    Author         : Philip Kjærsgaard (pk@lobe.dk)
    Prerequisite   : PowerShell V5 on Win10.
    Copyright 2019 - Philip Kjærsgaard/yosoyphil
.LINK
    Script posted over:
    https://github.com/lobeaps/powershell
.EXAMPLE
    1. Open PowerShell as Admin
    2. Navigate to script folder
    3. Set-ExecutionPolicy Bypass -Scope Process
    4. Run script:
       .\enable-localtime.ps1
#>

# Set TimeZone to Local Time

$RegKey = "HKLM:\System\CurrentControlSet\Control\TimeZoneInformation"
if (-Not(Test-Path "$RegKey")) {
    New-Item -Path $RegKey -Force
}
Set-ItemProperty -Path $RegKey -Name "RealTimeIsUniversal" -Value 1