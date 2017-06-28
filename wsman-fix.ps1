<#
.SYNOPSIS
    Register PowerShell WSMan Plugins.
.DESCRIPTION
    Register PowerShell WSMan Plugins.
.NOTES
    Author:  Stefan M. Werner
    Website: http://getninjad.com
#>

Param ( 
    [Parameter(Position=0, Mandatory=$false, HelpMessage="Path to target file for processing. Defaults to computers.txt.")] [string]$File = 'computers.txt',
    [Parameter(Position=1, Mandatory=$false, HelpMessage="Computer name for processing. Cannot be combined with file switch.")] [string]$ComputerName	
)

$scriptpath = $MyInvocation.MyCommand.Path
$currentdir = Split-Path $scriptpath

$VerbosePreference = 'continue'

Function LogWrite
{
    Param ([string]$logstring)
    Write-Verbose $logstring
}

$a = Get-Date
LogWrite "-- Starting Sript -- $a"
LogWrite "Current Dir: $currentdir"

$command = $currentdir + "\psservice.exe"

# Get computer name(s) for processing
If ($ComputerName)
{
    $computers = $ComputerName
}
Else
{
    $computers = Get-Content $currentdir\$File
}

$ErrorActionPreference = "Continue"

foreach ($computer in $computers) {
    LogWrite "Processing $computer"
	
      if (Test-Connection -ComputerName $computer -Quiet -Count 1) {
          LogWrite "-- Register PSSession Configuration"
        
          winrs /r:$computer powershell -noprofile -command {register-pssessionconfiguration microsoft.powershell -NoServiceRestart -Force}
          winrs /r:$computer powershell -noprofile -command {register-pssessionconfiguration microsoft.powershell32 -NoServiceRestart -Force}
          
          LogWrite "-- Restarting WinRM Service"
          
          $service =  Get-WmiObject -ComputerName $computer -Class win32_Service -Filter 'name="winrm"'
          $service.StopService()
          Start-Sleep -Seconds 2
          $service.StartService()
          
          LogWrite "--- Completed Computer: $computer"
      } else {
          LogWrite "-- The system is offline"
      }
}

LogWrite "DONE"
$VerbosePreference = "silentlycontinue"
