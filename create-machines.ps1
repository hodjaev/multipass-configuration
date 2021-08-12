
#Requires -RunAsAdministrator

function CreateNode {
    param (
        [string] $name,
        [string] $cpus,
        [string] $mem,
        [string] $disk,
        [string] $network,
        [string] $initFile,
        [string] $ip
    )

    Write-Host "Create node $name"
    (Get-Content $initFile).replace('[IP]', $ip) | multipass launch focal --name $name --cpus $cpus --mem $mem --disk $disk --network $network --cloud-init -
}

function DisableDynamicMemory {
    param (
        [string] $name
    )

    try {
      Write-Host "Stopping node $name"
      multipass stop $name
      Write-Host "Disable dynamic memory on $name"
      Set-VMMemory $name -DynamicMemoryEnabled $false
      Write-Host "Starting node $name"
      multipass start --timeout 5 $name
    }
    catch {
    }
}

function DeleteNode {
  param (
    [string] $name
  )

  Write-Host "Delete node $name"
  multipass delete $name
  multipass purge
}

if ($args[0] -eq $null) {
  Write-Error 'Provide json file path' -ErrorAction Stop
}

function RestartICS {
  Start-Process -FilePath powershell.exe -ArgumentList {
      $FileName = "$([System.Environment]::SystemDirectory)\drivers\etc\hosts.ics"
      if (Test-Path $FileName) {
        Remove-Item $FileName
      }
      Stop-Service -Name SharedAccess
    } -verb RunAs
}

if ($args[0] -eq 'restart-ics') {
    RestartICS
    exit 0
}

$data = cat $Args[0] | convertfrom-json

foreach ($i in $data) {
    DeleteNode $i.name
}

foreach ($i in $data) {
  CreateNode $i.name $i.cpus $i.mem $i.disk $i.network $i.initFile $i.ip
}

foreach ($i in $data) {
  DisableDynamicMemory $i.name
}