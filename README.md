# FancyZones
Custom https://github.com/microsoft/PowerToys re-deployment to run FancyZones standalone

# Creating a new deployment
- Open cmd.exe in Git repository location
- Run the `GenerateDeployment.ps1` using command: `powershell -ExecutionPolicy Bypass -File GenerateDeployment.ps1`

# Running the deployment locally
- Download the deployment ZIP from `https://github.com/rolandas-rimkus/FancyZones/releases`
- Extract locally and run `PowerToys.FancyZones.Configure.ps1` to setup the required registry keys and configuration files required for FancyZones to run.
- Run `PowerToys.FancyZonesEditor.exe` to configure the layouts as normal
- Start `PowerToys.FancyZones.exe` manually or restart your computer as the process is setup to start on startup in the background
- Note: once you modify the layout using `PowerToys.FancyZonesEditor.exe` the `PowerToys.FancyZones.exe` running in the background needs to be restarted to pick up the changes.
  Use `PowerToys.FancyZones.Restart.ps1` to do so or manually kill the `PowerToys.FancyZones.exe` using Task Manager and run it again.

# Updating to latest version of PowerToys
- Update PowerToysUrl under GenerateDeployment.ps1 to latest PowerToys with changes to FancyZones
- Run `GenerateDeployment.ps1` using command: `powershell -ExecutionPolicy Bypass -File GenerateDeployment.ps1`
- Run `temp\PowerToysUserSetup\MSI\PowerToys\PowerToys.exe`
- Configure all the FancyZones related settings using the provided UI
- Go to `%localappdata%\Microsoft\PowerToys\FancyZones` using file explorer
- Open `settings.json` and `editor-parameters.json`. Update `PowerToys.FancyZones.Configure.ps1` to reflect the settings PowerToys.exe sets for FancyZones to run properly.
- Run `temp\ProcessMonitor\Procmon64.exe`
- Filter down the events to only include events from `PowerToys.FancyZones.exe` and `PowerToys.FancyZonesEditor.exe`
- Make sure `temp\PowerToysUserSetup\MSI\PowerToys\PowerToys.exe` is not running anymore in the background
- Run `temp\PowerToysUserSetup\MSI\PowerToys\PowerToys.FancyZonesEditor.exe`
- Create new layout and enable it
- Run `temp\PowerToysUserSetup\MSI\PowerToys\PowerToys.FancyZones.exe`
- Drag windows to the created layout to test that Fancy Zones works as expected
- Make sure `temp\PowerToysUserSetup\MSI\PowerToys\PowerToys.FancyZones.exe` is not running anymore in the background
- Check ProcMon output and export the accessed file list using `Tools` > `File Summary`. Update the `FancyZonesDependencies.txt` with new list of files that fancy zones accessed during runtime.
  This list will be used to only deliver the binaries that Fancy Zones requires to work instead of the full PowerToys deployment.
- Delete `temp`, `bin`, `PowerToys.FancyZones.zip` and rerun the deployment
- Test running the FancyZones from the `bin` folder. If everything works properly deploy the ZIP as a new release in GitHub