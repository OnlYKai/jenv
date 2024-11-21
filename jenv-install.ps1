if (($PSScriptRoot -ieq $env:TEMP) -or ($PSScriptRoot -ieq "$env:UserProfile\Downloads")) { $installPath = $HOME } else { $installPath = $PSScriptRoot }

if (([System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -notlike "*$installPath\.jenv\links;*") -or ([System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -notlike "*$installPath\.jenv;*")) {
    $currentPrivileges = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    $requiredPrivileges = [Security.Principal.WindowsBuiltInRole]::Administrator
    if (-not $currentPrivileges.IsInRole($requiredPrivileges)) {
        Write-Host "Prompting for administrator privileges." -ForegroundColor DarkYellow
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -Wait
        Write-Host "DONE!" -ForegroundColor Green
        exit
    }
}

Write-Host "Creating folder structure..."
if (-not (Test-Path "$installPath\.jenv\links")) { New-Item -Path "$installPath\.jenv\links" -ItemType Directory >$null }

Write-Host "Downloading files..."
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/java.bat" -OutFile "$installPath\.jenv\java.bat"
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/javaw.bat" -OutFile "$installPath\.jenv\javaw.bat"
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/jenv.bat" -OutFile "$installPath\.jenv\jenv.bat"
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/jenv.ps1" -OutFile "$installPath\.jenv\jenv.ps1"
Unblock-File -Path "$installPath/.jenv/jenv.ps1"

Write-Host "Setting environemnt variables..."
if ([System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -notlike "*$installPath\.jenv\links;*") { [System.Environment]::SetEnvironmentVariable("Path", "$installPath\.jenv\links;" + [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine), [System.EnvironmentVariableTarget]::Machine) }
if ([System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -notlike "*$installPath\.jenv;*") { [System.Environment]::SetEnvironmentVariable("Path", "$installPath\.jenv;" + [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine), [System.EnvironmentVariableTarget]::Machine) }

if (((Split-Path $PSCommandPath -Leaf) -ieq "jenv-install.ps1") -or ($PSScriptRoot -ieq $env:TEMP)) {
    Write-Host "Removing installer..."
    Remove-Item -Path "$PSCommandPath" -Force
}

Write-Host "DONE!" -ForegroundColor Green