#
# Run script by calling: powershell -ExecutionPolicy Bypass -File GenerateDeployment.ps1
#
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
Add-Type -Assembly "System.IO.Compression.Filesystem"

# TODO: Update PowerToysUrl if there is a newer version of PowerToys with changes to FancyZones under: https://github.com/microsoft/PowerToys/releases
$PowerToysUrl = "https://github.com/microsoft/PowerToys/releases/download/v0.77.0/PowerToysUserSetup-0.77.0-x64.exe"

function MoveItem([string]$Path, [string]$Destination) {
    if (([System.IO.File]::Exists($Path))) {
        $DestinationDir = Split-Path $Destination
        if (!([System.IO.Directory]::Exists($DestinationDir))) { [System.IO.Directory]::CreateDirectory($DestinationDir) | Out-Null }
        Copy-Item $Path $Destination
    }
}

Write-Host "[INFO] Starting deployment to $PSScriptRoot\bin using temp directory $PSScriptRoot\temp"
if (!([System.IO.Directory]::Exists("$PSScriptRoot\temp"))) {
    Write-Host "[INFO] Generating temp directory"
    [System.IO.Directory]::CreateDirectory("$PSScriptRoot\temp") | Out-Null
}

if (!([System.IO.File]::Exists("$PSScriptRoot\temp\wix.zip"))) {
    Write-Host "[INFO] Downloading Wix"
    Invoke-RestMethod "https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311-binaries.zip" -OutFile "$PSScriptRoot\temp\wix.zip"
}

if (!([System.IO.File]::Exists("$PSScriptRoot\temp\ProcessMonitor.zip"))) {
    Write-Host "[INFO] Downloading ProcessMonitor"
    Invoke-RestMethod "https://download.sysinternals.com/files/ProcessMonitor.zip" -OutFile "$PSScriptRoot\temp\ProcessMonitor.zip"
}
if (!([System.IO.Directory]::Exists("$PSScriptRoot\temp\wix"))) {
    Write-Host "[INFO] Extracting Wix"
    [System.IO.Compression.ZipFile]::ExtractToDirectory("$PSScriptRoot\temp\wix.zip", "$PSScriptRoot\temp\wix")
}

if (!([System.IO.Directory]::Exists("$PSScriptRoot\temp\ProcessMonitor"))) {
    Write-Host "[INFO] Extracting ProcessMonitor"
    [System.IO.Compression.ZipFile]::ExtractToDirectory("$PSScriptRoot\temp\ProcessMonitor.zip", "$PSScriptRoot\temp\ProcessMonitor")
}

if (!([System.IO.File]::Exists("$PSScriptRoot\temp\PowerToysUserSetup.exe"))) {
    Write-Host "[INFO] Downloading PowerToys"
    Invoke-RestMethod $PowerToysUrl -OutFile "$PSScriptRoot\temp\PowerToysUserSetup.exe"
}

if (!([System.IO.Directory]::Exists("$PSScriptRoot\temp\PowerToysUserSetup"))) {
    Write-Host "[INFO] Extracting PowerToys bundle"
    . "$PSScriptRoot\temp\wix\dark.exe" -x "$PSScriptRoot\temp\PowerToysUserSetup" "$PSScriptRoot\temp\PowerToysUserSetup.exe" | Out-Null
}

if (!([System.IO.Directory]::Exists("$PSScriptRoot\temp\PowerToysUserSetup\MSI"))) {
    Write-Host "[INFO] Extracting PowerToys MSI"
    $MsiPath = Get-ChildItem "$PSScriptRoot\temp\PowerToysUserSetup\AttachedContainer\PowerToysUserSetup-*-x64.msi" | foreach { $_.FullName }
    Start-Process -FilePath msiexec -ArgumentList "/quiet /a $MsiPath /qn TARGETDIR=$PSScriptRoot\temp\PowerToysUserSetup\MSI" -Wait -PassThru | Out-Null
}

if (!([System.IO.Directory]::Exists("$PSScriptRoot\bin"))) {
    Write-Host "[INFO] Moving extracted files to output location"
    $FancyZonesFiles = Get-Content "$PSScriptRoot\FancyZonesDependencies.txt"
    $FancyZonesFiles += "PowerToys.FancyZones.exe"
    $FancyZonesFiles += "PowerToys.FancyZonesEditor.exe"
    $FancyZonesFiles | foreach { MoveItem "$PSScriptRoot\temp\PowerToysUserSetup\MSI\PowerToys\$($_)" "$PSScriptRoot\bin\$($_)" }

    Write-Host "[INFO] Helper script deployment"
    Copy-Item "$PSScriptRoot\README.md" "$PSScriptRoot\bin\README.md"
    Copy-Item "$PSScriptRoot\FancyZonesDependencies.txt" "$PSScriptRoot\bin\FancyZonesDependencies.txt"
    Copy-Item "$PSScriptRoot\GenerateDeployment.ps1" "$PSScriptRoot\bin\GenerateDeployment.ps1"
    Copy-Item "$PSScriptRoot\PowerToys.FancyZones.Configure.ps1" "$PSScriptRoot\bin\PowerToys.FancyZones.Configure.ps1"
    Copy-Item "$PSScriptRoot\PowerToys.FancyZones.Restart.ps1" "$PSScriptRoot\bin\PowerToys.FancyZones.Restart.ps1"
}

if (!([System.IO.File]::Exists("$PSScriptRoot\PowerToys.FancyZones.zip"))) {
    Write-Host "[INFO] Generating deployment .zip"
    [System.IO.Compression.ZipFile]::CreateFromDirectory("$PSScriptRoot\bin", "$PSScriptRoot\PowerToys.FancyZones.zip")
}

Write-Host "[INFO] Deployment generated under $PSScriptRoot\PowerToys.FancyZones.zip"
Get-FileHash "$PSScriptRoot\PowerToys.FancyZones.zip" | foreach { Write-Host "[INFO] Deployment .zip SHA256 hash : $($_.Hash)" }
