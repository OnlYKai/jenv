```pwsh
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser; Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/jenv-install.ps1" -OutFile "$env:TEMP\jenv-install.ps1"; &"$env:TEMP\jenv-install.ps1"
```