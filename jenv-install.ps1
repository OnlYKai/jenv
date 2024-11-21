param (
    [switch]$here
)

Write-Host (-join ((0..((Get-Host).UI.RawUI.WindowSize.Width - 1)) | ForEach-Object { [char]0x2501 }))

if (($PSScriptRoot -ieq $env:TEMP) -or ($PSScriptRoot -ieq "$env:UserProfile\Downloads")) { $installPath = "$HOME\.jenv" } else { $installPath = "$PSScriptRoot\.jenv" }
if ($installPath -like "*\.jenv\.jenv") { $installPath = $installPath -replace "\\\.jenv$", "" }
if ($here) { $installPath = $PSScriptRoot }

if (([System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -notlike "*$installPath\links;*") -or ([System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -notlike "*$installPath;*")) {
    $currentPrivileges = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    $requiredPrivileges = [Security.Principal.WindowsBuiltInRole]::Administrator
    if (-not $currentPrivileges.IsInRole($requiredPrivileges)) {
        Write-Host "Prompting for administrator privileges..." -ForegroundColor DarkYellow
        try {
            if ($here) {
                Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -here" -Verb RunAs -Wait
            } else {
                Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -Wait
            }
            Write-Host "INSTALLATION FINISHED!" -ForegroundColor Green
        } catch {
            Write-Host "INSTALLATION FAILED!" -ForegroundColor Red
            Write-Host "Administrator privileges are needed to add variables to Path." -ForegroundColor Yellow
        }
        exit
    }
}

Write-Host "Installation path: " -NoNewline
Write-Host "$installPath" -ForegroundColor DarkCyan
Write-Host ""

Write-Host "Creating folder structure... " -NoNewline
if (-not (Test-Path "$installPath\links")) {
    New-Item -Path "$installPath\links" -ItemType Directory >$null
    Write-Host "DONE" -ForegroundColor Green
} else {
    Write-Host "Already exists!" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "Downloading files... " -NoNewline
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/java.bat" -OutFile "$installPath\java.bat"
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/javaw.bat" -OutFile "$installPath\javaw.bat"
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/jenv.bat" -OutFile "$installPath\jenv.bat"
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/.jenv/jenv.ps1" -OutFile "$installPath\jenv.ps1"
Write-Host "DONE" -ForegroundColor Green
Write-Host ""

Write-Host "Adding " -NoNewline
Write-Host "'.jenv\links'" -NoNewline -ForegroundColor DarkCyan
Write-Host " to Path... " -NoNewline
if ([System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -notlike "*$installPath\links;*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$installPath\links;" + [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine), [System.EnvironmentVariableTarget]::Machine)
    Write-Host "DONE" -ForegroundColor Green
} else {
    Write-Host "Already in Path!" -ForegroundColor Yellow
}
Write-Host "Adding " -NoNewline
Write-Host "'.jenv'" -NoNewline -ForegroundColor DarkCyan
Write-Host " to Path... " -NoNewline
if ([System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) -notlike "*$installPath;*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$installPath;" + [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine), [System.EnvironmentVariableTarget]::Machine)
    Write-Host "DONE" -ForegroundColor Green
} else {
    Write-Host "Already in Path!" -ForegroundColor Yellow
}
Write-Host ""

if (((Split-Path $PSCommandPath -Leaf) -ieq "jenv-install.ps1") -or ($PSScriptRoot -ieq $env:TEMP)) {
    Write-Host "Removing installer... " -NoNewline
    Remove-Item -Path "$PSCommandPath" -Force
    Write-Host "DONE" -ForegroundColor Green
    Write-Host ""
}

Write-Host "INSTALLATION FINISHED!" -ForegroundColor Green

Write-Host (-join ((0..((Get-Host).UI.RawUI.WindowSize.Width - 1)) | ForEach-Object { [char]0x2501 }))