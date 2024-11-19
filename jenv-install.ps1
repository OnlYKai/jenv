$currentPrivileges = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$requiredPrivileges = [Security.Principal.WindowsBuiltInRole]::Administrator
if (-not $currentPrivileges.IsInRole($requiredPrivileges)) {
    Write-Host "Prompting administrator privileges." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoProfile -File `"$PSCommandPath`"" -Verb RunAs -Wait
    Write-Host "DONE!" -ForegroundColor Green
    exit
}

Write-Host "Downloading..."
if (-not (Test-Path "$HOME\.jenv")) { New-Item -Path "$HOME\.jenv" -ItemType Directory }
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/java.bat" -OutFile "$HOME\.jenv\java.bat"
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/javaw.bat" -OutFile "$HOME\.jenv\javaw.bat"
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/jenv.bat" -OutFile "$HOME\.jenv\jenv.bat"
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/jenv.ps1" -OutFile "$HOME\.jenv\jenv.ps1"

Write-Host "Installing..."
if ([System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -notlike "*$HOME\.jenv;*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$HOME\.jenv;" + [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine), [System.EnvironmentVariableTarget]::Machine)
}
Unblock-File $HOME/.jenv/jenv.ps1

Write-Host "Cleaning..."
Remove-Item -Path $env:TEMP\jenv-install.ps1 -Force
Write-Host "DONE!" -ForegroundColor Green