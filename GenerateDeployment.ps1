#
# Run script by calling: powershell -ExecutionPolicy Bypass -File GenerateDeployment.ps1
#
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

Write-Host "[INFO] Generating temp directory"
mkdir "$PSScriptRoot\temp" | Out-Null

Write-Host "[INFO] Downloading Wix"
Invoke-RestMethod "https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311-binaries.zip" -OutFile "$PSScriptRoot\temp\wix.zip"

Write-Host "[INFO] Extracting Wix"
Add-Type -Assembly "System.IO.Compression.Filesystem"
[System.IO.Compression.ZipFile]::ExtractToDirectory("$PSScriptRoot\temp\wix.zip", "$PSScriptRoot\temp\wix")

Write-Host "[INFO] Downloading PowerToys"
Invoke-RestMethod "https://github.com/microsoft/PowerToys/releases/download/v0.76.2/PowerToysUserSetup-0.76.2-x64.exe" -OutFile "$PSScriptRoot\temp\PowerToysUserSetup.exe"

Write-Host "[INFO] Extracting PowerToys bundle"
. "$PSScriptRoot\temp\wix\dark.exe" -x "$PSScriptRoot\temp\PowerToysUserSetup" "$PSScriptRoot\temp\PowerToysUserSetup.exe" | Out-Null

Write-Host "[INFO] Extracting PowerToys MSI"
Start-Process -FilePath msiexec -ArgumentList "/quiet /a $PSScriptRoot\temp\PowerToysUserSetup\AttachedContainer\PowerToysUserSetup-0.76.2-x64.msi /qn TARGETDIR=$PSScriptRoot\temp\PowerToysUserSetup\MSI" -Wait -PassThru | Out-Null

Write-Host "[INFO] Moving extracted files to output location"
$FancyZoneFiles = @()
$FancyZoneFiles += "clrjit.dll"
$FancyZoneFiles += "ControlzEx.dll"
$FancyZoneFiles += "coreclr.dll"
$FancyZoneFiles += "D3DCompiler_47_cor3.dll"
$FancyZoneFiles += "DirectWriteForwarder.dll"
$FancyZoneFiles += "hostfxr.dll"
$FancyZoneFiles += "hostpolicy.dll"
$FancyZoneFiles += "Ijwhost.dll"
$FancyZoneFiles += "License.rtf"
$FancyZoneFiles += "Microsoft.Win32.Primitives.dll"
$FancyZoneFiles += "Microsoft.Win32.Registry.dll"
$FancyZoneFiles += "Microsoft.Win32.SystemEvents.dll"
$FancyZoneFiles += "Microsoft.Windows.SDK.NET.dll"
$FancyZoneFiles += "ModernWpf.Controls.dll"
$FancyZoneFiles += "ModernWpf.dll"
$FancyZoneFiles += "msvcp140.dll"
$FancyZoneFiles += "PowerToys.Common.UI.dll"
$FancyZoneFiles += "PowerToys.FancyZones.exe"
$FancyZoneFiles += "PowerToys.FancyZonesEditor.dll"
$FancyZoneFiles += "PowerToys.FancyZonesEditor.exe"
$FancyZoneFiles += "PowerToys.GPOWrapper.dll"
$FancyZoneFiles += "PowerToys.GPOWrapperProjection.dll"
$FancyZoneFiles += "PowerToys.Interop.dll"
$FancyZoneFiles += "PowerToys.ManagedCommon.dll"
$FancyZoneFiles += "PowerToys.ManagedTelemetry.dll"
$FancyZoneFiles += "PresentationCore.dll"
$FancyZoneFiles += "PresentationFramework.Aero2.dll"
$FancyZoneFiles += "PresentationFramework.dll"
$FancyZoneFiles += "PresentationFramework-SystemXml.dll"
$FancyZoneFiles += "PresentationNative_cor3.dll"
$FancyZoneFiles += "System.Collections.Concurrent.dll"
$FancyZoneFiles += "System.Collections.dll"
$FancyZoneFiles += "System.Collections.NonGeneric.dll"
$FancyZoneFiles += "System.Collections.Specialized.dll"
$FancyZoneFiles += "System.ComponentModel.dll"
$FancyZoneFiles += "System.ComponentModel.EventBasedAsync.dll"
$FancyZoneFiles += "System.ComponentModel.Primitives.dll"
$FancyZoneFiles += "System.ComponentModel.TypeConverter.dll"
$FancyZoneFiles += "System.Configuration.ConfigurationManager.dll"
$FancyZoneFiles += "System.Diagnostics.Debug.dll"
$FancyZoneFiles += "System.Diagnostics.FileVersionInfo.dll"
$FancyZoneFiles += "System.Diagnostics.Process.dll"
$FancyZoneFiles += "System.Diagnostics.StackTrace.dll"
$FancyZoneFiles += "System.Diagnostics.TextWriterTraceListener.dll"
$FancyZoneFiles += "System.Diagnostics.TraceSource.dll"
$FancyZoneFiles += "System.Diagnostics.Tracing.dll"
$FancyZoneFiles += "System.Drawing.Primitives.dll"
$FancyZoneFiles += "System.IO.Abstractions.dll"
$FancyZoneFiles += "System.IO.Packaging.dll"
$FancyZoneFiles += "System.Linq.dll"
$FancyZoneFiles += "System.Linq.Expressions.dll"
$FancyZoneFiles += "System.Memory.dll"
$FancyZoneFiles += "System.Net.Primitives.dll"
$FancyZoneFiles += "System.Net.Requests.dll"
$FancyZoneFiles += "System.Net.WebClient.dll"
$FancyZoneFiles += "System.Net.WebHeaderCollection.dll"
$FancyZoneFiles += "System.Numerics.Vectors.dll"
$FancyZoneFiles += "System.ObjectModel.dll"
$FancyZoneFiles += "System.Private.CoreLib.dll"
$FancyZoneFiles += "System.Private.Uri.dll"
$FancyZoneFiles += "System.Private.Xml.dll"
$FancyZoneFiles += "System.Reflection.Emit.dll"
$FancyZoneFiles += "System.Reflection.Emit.ILGeneration.dll"
$FancyZoneFiles += "System.Reflection.Emit.Lightweight.dll"
$FancyZoneFiles += "System.Reflection.Primitives.dll"
$FancyZoneFiles += "System.Runtime.CompilerServices.Unsafe.dll"
$FancyZoneFiles += "System.Runtime.CompilerServices.VisualC.dll"
$FancyZoneFiles += "System.Runtime.dll"
$FancyZoneFiles += "System.Runtime.Extensions.dll"
$FancyZoneFiles += "System.Runtime.InteropServices.dll"
$FancyZoneFiles += "System.Runtime.Intrinsics.dll"
$FancyZoneFiles += "System.Runtime.Loader.dll"
$FancyZoneFiles += "System.Security.AccessControl.dll"
$FancyZoneFiles += "System.Security.Cryptography.Algorithms.dll"
$FancyZoneFiles += "System.Security.Cryptography.dll"
$FancyZoneFiles += "System.Text.Encoding.Extensions.dll"
$FancyZoneFiles += "System.Text.Encodings.Web.dll"
$FancyZoneFiles += "System.Text.Json.dll"
$FancyZoneFiles += "System.Threading.dll"
$FancyZoneFiles += "System.Threading.Thread.dll"
$FancyZoneFiles += "System.Threading.ThreadPool.dll"
$FancyZoneFiles += "System.Windows.Controls.Ribbon.dll"
$FancyZoneFiles += "System.Windows.Extensions.dll"
$FancyZoneFiles += "System.Xaml.dll"
$FancyZoneFiles += "System.Xml.ReaderWriter.dll"
$FancyZoneFiles += "UIAutomationProvider.dll"
$FancyZoneFiles += "UIAutomationTypes.dll"
$FancyZoneFiles += "vcruntime140.dll"
$FancyZoneFiles += "vcruntime140_1.dll"
$FancyZoneFiles += "WindowsBase.dll"
$FancyZoneFiles += "WindowsFormsIntegration.dll"
$FancyZoneFiles += "WinRT.Runtime.dll"
$FancyZoneFiles += "wpfgfx_cor3.dll"

function ForceMoveItem([string]$Path, [string]$Destination) {
    $DestinationDir = Split-Path $destination
    if (!([System.IO.Directory]::Exists($DestinationDir))) { [System.IO.Directory]::CreateDirectory($DestinationDir) | Out-Null }
    Move-Item $path $destination
}

$FancyZoneFiles | foreach { ForceMoveItem "$PSScriptRoot\temp\PowerToysUserSetup\MSI\PowerToys\$($_)" "$PSScriptRoot\bin\$($_)" }

Write-Host "[INFO] Temp directory cleanup"
Remove-Item -Recurse -Force "$PSScriptRoot\temp" | Out-Null

Write-Host "[INFO] Helper script deployment"
Copy-Item "$PSScriptRoot\GenerateDeployment.ps1" "$PSScriptRoot\bin\GenerateDeployment.ps1"
Copy-Item "$PSScriptRoot\PowerToys.FancyZones.Configure.ps1" "$PSScriptRoot\bin\PowerToys.FancyZones.Configure.ps1"
Copy-Item "$PSScriptRoot\PowerToys.FancyZones.Restart.ps1" "$PSScriptRoot\bin\PowerToys.FancyZones.Restart.ps1"

Write-Host "[INFO] Generating deployment .zip"
[System.IO.Compression.ZipFile]::CreateFromDirectory("$PSScriptRoot\bin", "$PSScriptRoot\PowerToys.FancyZones.zip")
Get-FileHash "$PSScriptRoot\PowerToys.FancyZones.zip" | foreach { Write-Host "[INFO] Deployment .zip SHA256 hash : $($_.Hash)" }
