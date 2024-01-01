#
# Run script by calling: powershell -ExecutionPolicy Bypass -File PowerToys.FancyZones.Configure.ps1
#
Write-Host "[INFO] Adding PowerToys.FancyZones.exe to startup apps using HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
if (!(Test-Path ($Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"))) { New-Item $Path -Force | Out-Null }; Set-ItemProperty -Path $Path -Name "FancyZones StandAlone" -Value "$PSScriptRoot\PowerToys.FancyZones.exe"

$LogSettings = @"
{"logLevel":"warn"}
"@

$Settings = @"
{"properties":{"fancyzones_shiftDrag":{"value":true},"fancyzones_mouseSwitch":{"value":false},"fancyzones_mouseMiddleClickSpanningMultipleZones":{"value":false},"fancyzones_overrideSnapHotkeys":{"value":false},"fancyzones_moveWindowAcrossMonitors":{"value":false},"fancyzones_moveWindowsBasedOnPosition":{"value":false},"fancyzones_overlappingZonesAlgorithm":{"value":0},"fancyzones_displayOrWorkAreaChange_moveWindows":{"value":true},"fancyzones_zoneSetChange_moveWindows":{"value":false},"fancyzones_appLastZone_moveWindows":{"value":false},"fancyzones_openWindowOnActiveMonitor":{"value":false},"fancyzones_restoreSize":{"value":false},"fancyzones_quickLayoutSwitch":{"value":false},"fancyzones_flashZonesOnQuickSwitch":{"value":true},"use_cursorpos_editor_startupscreen":{"value":true},"fancyzones_show_on_all_monitors":{"value":false},"fancyzones_span_zones_across_monitors":{"value":true},"fancyzones_makeDraggedWindowTransparent":{"value":false},"fancyzones_allowPopupWindowSnap":{"value":false},"fancyzones_allowChildWindowSnap":{"value":true},"fancyzones_disableRoundCornersOnSnap":{"value":false},"fancyzones_zoneHighlightColor":{"value":"#0078D7"},"fancyzones_highlight_opacity":{"value":50},"fancyzones_editor_hotkey":{"value":{"win":true,"ctrl":false,"alt":false,"shift":true,"code":192,"key":""}},"fancyzones_windowSwitching":{"value":false},"fancyzones_nextTab_hotkey":{"value":{"win":true,"ctrl":false,"alt":false,"shift":false,"code":34,"key":""}},"fancyzones_prevTab_hotkey":{"value":{"win":true,"ctrl":false,"alt":false,"shift":false,"code":33,"key":""}},"fancyzones_excluded_apps":{"value":""},"fancyzones_zoneBorderColor":{"value":"#FFFFFF"},"fancyzones_zoneColor":{"value":"#F5FCFF"},"fancyzones_zoneNumberColor":{"value":"#000000"},"fancyzones_systemTheme":{"value":true},"fancyzones_showZoneNumber":{"value":true}},"name":"FancyZones","version":"1.0"}
"@

Add-Type -AssemblyName System.Windows.Forms
$Screens = [System.Windows.Forms.Screen]::AllScreens
$Left =   ($Screens | foreach { $_.Bounds.X } | Measure -Minimum).Minimum
$Top =    ($Screens | foreach { $_.Bounds.Y } | Measure -Minimum).Minimum
$Right =  ($Screens | foreach { $_.Bounds.X + $_.Bounds.Width } | Measure -Maximum).Maximum
$Bottom = ($Screens | foreach { $_.Bounds.Y + $_.Bounds.Height } | Measure -Maximum).Maximum
$Height = $Bottom - $Top
$Width = $Right - $Left

$EditorParameters = @"
{"span-zones-across-monitors":true,"monitors":[{"monitor":"FancyZones","monitor-instance-id":"MultiMonitorDevice","virtual-desktop":"{2BC2C76A-4A1E-42A4-9D5D-8ECD56C25AEA}","top-coordinate":$Top,"left-coordinate":$Left,"work-area-width":$Width,"work-area-height":$Height,"monitor-width":$Width,"monitor-height":$Height,"is-selected":true}]}
"@

Write-Host "[INFO] Deploying settings files to $($env:LOCALAPPDATA)\Microsoft\PowerToys"
if (!([System.IO.Directory]::Exists("$($env:LOCALAPPDATA)\Microsoft\PowerToys\FancyZones"))) { [System.IO.Directory]::CreateDirectory("$($env:LOCALAPPDATA)\Microsoft\PowerToys\FancyZones") | Out-Null }
Set-Content "$($env:LOCALAPPDATA)\Microsoft\PowerToys\log_settings.json" $LogSettings
Set-Content "$($env:LOCALAPPDATA)\Microsoft\PowerToys\FancyZones\settings.json" $Settings
Set-Content "$($env:LOCALAPPDATA)\Microsoft\PowerToys\FancyZones\editor-parameters.json" $EditorParameters
