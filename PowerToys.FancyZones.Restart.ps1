#
# Run script by calling: powershell -ExecutionPolicy Bypass -File PowerToys.FancyZones.Restart.ps1
#
Get-Process | where { $_.ProcessName -eq "PowerToys.FancyZones" } | Stop-Process
Start-Process "$PSScriptRoot\PowerToys.FancyZones.exe"