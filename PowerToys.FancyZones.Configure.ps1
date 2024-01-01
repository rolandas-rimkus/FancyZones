#
# Run script by calling: powershell -ExecutionPolicy Bypass -File PowerToys.FancyZones.Configure.ps1
#
Write-Host "[INFO] Adding PowerToys.FancyZones.exe to startup apps using HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
if (!(Test-Path ($Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"))) { New-Item $Path -Force | Out-Null }; Set-ItemProperty -Path $Path -Name "FancyZones StandAlone" -Value "$PSScriptRoot\PowerToys.FancyZones.exe"

$LogSettings = @"
{"logLevel":"warn"}
"@

$Settings = @"
{"properties":{"fancyzones_shiftDrag":{"value":true},"fancyzones_mouseSwitch":{"value":false},"fancyzones_mouseMiddleClickSpanningMultipleZones":{"value":false},"fancyzones_overrideSnapHotkeys":{"value":false},"fancyzones_moveWindowAcrossMonitors":{"value":false},"fancyzones_moveWindowsBasedOnPosition":{"value":false},"fancyzones_overlappingZonesAlgorithm":{"value":0},"fancyzones_displayOrWorkAreaChange_moveWindows":{"value":true},"fancyzones_zoneSetChange_moveWindows":{"value":false},"fancyzones_appLastZone_moveWindows":{"value":false},"fancyzones_openWindowOnActiveMonitor":{"value":false},"fancyzones_restoreSize":{"value":false},"fancyzones_quickLayoutSwitch":{"value":true},"fancyzones_flashZonesOnQuickSwitch":{"value":true},"use_cursorpos_editor_startupscreen":{"value":true},"fancyzones_show_on_all_monitors":{"value":false},"fancyzones_span_zones_across_monitors":{"value":false},"fancyzones_makeDraggedWindowTransparent":{"value":false},"fancyzones_allowPopupWindowSnap":{"value":false},"fancyzones_allowChildWindowSnap":{"value":false},"fancyzones_disableRoundCornersOnSnap":{"value":false},"fancyzones_zoneHighlightColor":{"value":"#0078D7"},"fancyzones_highlight_opacity":{"value":50},"fancyzones_editor_hotkey":{"value":{"win":true,"ctrl":false,"alt":false,"shift":true,"code":192,"key":""}},"fancyzones_windowSwitching":{"value":true},"fancyzones_nextTab_hotkey":{"value":{"win":true,"ctrl":false,"alt":false,"shift":false,"code":34,"key":""}},"fancyzones_prevTab_hotkey":{"value":{"win":true,"ctrl":false,"alt":false,"shift":false,"code":33,"key":""}},"fancyzones_excluded_apps":{"value":""},"fancyzones_zoneBorderColor":{"value":"#FFFFFF"},"fancyzones_zoneColor":{"value":"#F5FCFF"},"fancyzones_zoneNumberColor":{"value":"#000000"},"fancyzones_systemTheme":{"value":true},"fancyzones_showZoneNumber":{"value":true}},"name":"FancyZones","version":"1.0"}
"@

$EditorParameters = @"
{"span-zones-across-monitors":true,"monitors":[{"monitor":"","work-area-width":1920,"work-area-height":1080,"monitor-width":1920,"monitor-height":1080,"is-selected":true}]}
"@

Write-Host "[INFO] Deploying settings files to $($env:LOCALAPPDATA)\Microsoft\PowerToys"
Set-Content "$($env:LOCALAPPDATA)\Microsoft\PowerToys\log_settings.json" $LogSettings
Set-Content "$($env:LOCALAPPDATA)\Microsoft\PowerToys\FancyZones\settings.json" $Settings
Set-Content "$($env:LOCALAPPDATA)\Microsoft\PowerToys\FancyZones\editor-parameters.json" $EditorParameters
