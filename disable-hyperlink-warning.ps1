#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Disable hyperlinks warnings for entire Office 16.0
.DESCRIPTION
    Disable hyperlinks warnings for entire Office 16.0.
    Used when employees has a fresh installation or a new computer.
.NOTES
    File Name      : Lobe-disable-hyperlink-warning.ps1
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
       .\Lobe-disable-hyperlink-warning.ps1
#>

# Disable Hyperlink warning in Office 16.0
$RegKey = "HKCU:\Software\Policies\Microsoft\Office\16.0\Common\Security"
if (-Not(Test-Path "$RegKey")) {
    New-Item -Path $RegKey -Force
}
Set-ItemProperty -Path $RegKey -Name "DisableHyperlinkWarning" -Value 1