@echo off
:: Batch script to automate Windows setup tasks using winget

:: Request administrative privileges
:: Check if the script is running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrative privileges.
) else (
    echo Requesting administrative privileges...
    :: Re-run the script with administrative privileges
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Disable OneDrive
echo Disabling OneDrive...
taskkill /f /im OneDrive.exe
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f

:: Uninstall OneDrive
echo Uninstalling OneDrive...
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall

:: Disable Microsoft Edge (not recommended, use with caution)
echo Disabling Microsoft Edge...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Edge" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1 /f

:: Run Windows updates
echo Running Windows updates...
start ms-settings:windowsupdate-action

:: Wait for user to manually complete updates and restart
echo Please complete Windows updates and restart your computer.
pause

:: After restart, check for updates again
echo Checking for updates again...
start ms-settings:windowsupdate-action

:: Wait for user to confirm updates are complete
echo Please confirm Windows updates are complete.
pause

:: Install Firefox using winget
echo Installing Firefox...
winget install Mozilla.Firefox

:: Install Firefox extensions using winget
echo Installing Firefox extensions...
winget install uBlockOrigin.uBlockOrigin
winget install SkipRedirect.SkipRedirect
winget install DarkReader.DarkReader
winget install SponsorBlock.SponsorBlock
winget install DeArrow.DeArrow

echo Setup complete!
pause
