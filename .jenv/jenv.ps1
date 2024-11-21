param (
    [string]$arg1,
    [string]$arg2,
    [string]$arg3,
    [string]$arg4,
    [switch]$cmd
)

if ($arg1 -ieq "list") {
    Get-ChildItem -Path "C:\Program Files\Java" -Directory | Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(50) }) } | ForEach-Object { Write-Host $_.Name }
} elseif (($arg1 -ieq "global") -or ($arg1 -ieq "set")) {
    if ($arg2 -ne "") {
        $arg2 = $arg2 -replace "/", "\"
        if (($arg2 -like "*\*") -and (Test-Path "$arg2")) {
            setx JAVA_HOME "$arg2" >$null
            $env:JAVA_HOME = "$arg2"
            Write-Host "Global java version set to $arg2."
        } elseif (Test-Path "C:\Program Files\Java\$arg2") {
            setx JAVA_HOME "C:\Program Files\Java\$arg2" >$null
            $env:JAVA_HOME = "C:\Program Files\Java\$arg2"
            Write-Host "Global java version set to $arg2."
        } elseif (Test-Path "C:\Program Files\Java\jdk-$arg2") {
            setx JAVA_HOME "C:\Program Files\Java\jdk-$arg2" >$null
            $env:JAVA_HOME = "C:\Program Files\Java\jdk-$arg2"
            Write-Host "Global java version set to jdk-$arg2."
        } else {
            Write-Host "Version not found. Use 'jenv list'"
        }
    } else {
        Write-Host "No version provided. Use 'jenv list'"
    }
} elseif (($arg1 -ieq "local") -or ($arg1 -ieq "use")) {
    if ($arg2 -ne "") {
        $arg2 = $arg2 -replace "/", "\"
        if (($arg2 -like "*\*") -and (Test-Path "$arg2")) {
            $env:JAVA_HOME = "$arg2"
            Write-Host "Shell set to $arg2."
        } elseif (Test-Path "C:\Program Files\Java\$arg2") {
            $env:JAVA_HOME = "C:\Program Files\Java\$arg2"
            Write-Host "Shell set to $arg2."
        } elseif (Test-Path "C:\Program Files\Java\jdk-$arg2") {
            $env:JAVA_HOME = "C:\Program Files\Java\jdk-$arg2"
            Write-Host "Shell set to jdk-$arg2."
        } else {
            Write-Host "Version not found. Use 'jenv list'"
        }
    } else {
        Write-Host "No version provided. Use 'jenv list'"
    }
} elseif ($arg1 -ieq "link") {
    if ($arg3 -notlike "*w") {
        if ($arg2 -ieq "list") {
            Get-ChildItem -Path "$PSScriptRoot\links" -Exclude "*w.bat" | Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(50) }) } | ForEach-Object {
                Write-Host ($_.Name -replace ".bat$", "") "-" ((Get-Content -Path "$_")[-1] -replace "\\bin\\java`" %\*$", "" -replace "^`"", "" -replace "^C:\\Program Files\\Java\\", "")
            }
        } elseif ($arg2 -ieq "create") {
            if (($arg3 -ne "") -and ($arg4 -ne "")) {
                if (-not (Test-Path "$PSScriptRoot\links\$arg3.bat")) {
                    $arg4 = $arg4 -replace "/", "\"
                    if (($arg4 -like "*\*") -and (Test-Path "$arg4")) {
                        New-Item -Path "$PSScriptRoot\links\$arg3.bat" -ItemType File >$null
                        Set-Content -Path "$PSScriptRoot\links\$arg3.bat" -Value "@echo off"
                        Add-Content -Path "$PSScriptRoot\links\$arg3.bat" -Value "`"$arg4\bin\java`" %*" -NoNewline
                        New-Item -Path "$PSScriptRoot\links\$($arg3)w.bat" -ItemType File >$null
                        Set-Content -Path "$PSScriptRoot\links\$($arg3)w.bat" -Value "@echo off"
                        Add-Content -Path "$PSScriptRoot\links\$($arg3)w.bat" -Value "`"$arg4\bin\javaw`" %*" -NoNewline
                        Write-Host "Created link '$arg3' and '$($arg3)w' for version '$arg4'."
                    } elseif (Test-Path "C:\Program Files\Java\$arg4") {
                        New-Item -Path "$PSScriptRoot\links\$arg3.bat" -ItemType File >$null
                        Set-Content -Path "$PSScriptRoot\links\$arg3.bat" -Value "@echo off"
                        Add-Content -Path "$PSScriptRoot\links\$arg3.bat" -Value "`"C:\Program Files\Java\$arg4\bin\java`" %*" -NoNewline
                        New-Item -Path "$PSScriptRoot\links\$($arg3)w.bat" -ItemType File >$null
                        Set-Content -Path "$PSScriptRoot\links\$($arg3)w.bat" -Value "@echo off"
                        Add-Content -Path "$PSScriptRoot\links\$($arg3)w.bat" -Value "`"C:\Program Files\Java\$arg4\bin\javaw`" %*" -NoNewline
                        Write-Host "Created link '$arg3' and '$($arg3)w' for version '$arg4'."
                    } elseif (Test-Path "C:\Program Files\Java\jdk-$arg4") {
                        New-Item -Path "$PSScriptRoot\links\$arg3.bat" -ItemType File >$null
                        Set-Content -Path "$PSScriptRoot\links\$arg3.bat" -Value "@echo off"
                        Add-Content -Path "$PSScriptRoot\links\$arg3.bat" -Value "`"C:\Program Files\Java\jdk-$arg4\bin\java`" %*" -NoNewline
                        New-Item -Path "$PSScriptRoot\links\$($arg3)w.bat" -ItemType File >$null
                        Set-Content -Path "$PSScriptRoot\links\$($arg3)w.bat" -Value "@echo off"
                        Add-Content -Path "$PSScriptRoot\links\$($arg3)w.bat" -Value "`"C:\Program Files\Java\jdk-$arg4\bin\javaw`" %*" -NoNewline
                        Write-Host "Created link '$arg3' and '$($arg3)w' for version 'jdk-$arg4'."
                    } else {
                        Write-Host "Version not found. Use 'jenv list'"
                    }
                } else {
                    Write-Host "Link '$arg3' already exists!"
                }
            } else {
                Write-Host "Missing argument(s). Use 'jenv help'"
            }
        } elseif ($arg2 -ieq "remove") {
            if ($arg3 -ne "") {
                if (Test-Path "$PSScriptRoot\links\$arg3.bat") {
                    Remove-Item -Path "$PSScriptRoot\links\$arg3.bat" -Force
                    Remove-Item -Path "$PSScriptRoot\links\$($arg3)w.bat" -Force
                    Write-Host "Removed link '$arg3'."
                } else {
                    Write-Host "Link '$arg3' doesn't exists!"
                }
            } else {
                Write-Host "Missing argument. Use 'jenv help'"
            }
        } elseif ($arg2 -ieq "rename") {
            if (($arg3 -ne "") -and ($arg4 -ne "")) {
                if ($arg4 -notlike "*w") {
                    if (Test-Path "$PSScriptRoot\links\$arg3.bat") {
                        if (-not (Test-Path "$PSScriptRoot\links\$arg4.bat")) {
                            Rename-Item -Path "$PSScriptRoot\links\$arg3.bat" -NewName "$arg4.bat" -Force
                            Rename-Item -Path "$PSScriptRoot\links\$($arg3)w.bat" -NewName "$($arg4)w.bat" -Force
                            Write-Host "Renamed link '$arg3' to '$arg4'."
                        } else {
                            Write-Host "Link '$arg4' already exists!"
                        }
                    } else {
                        Write-Host "Link '$arg3' doesn't exists!"
                    }
                } else {
                    Write-Host "Don't create, remove, or rename links ending in 'w'! (Reserved for javaw)"
                }
            } else {
                Write-Host "Missing argument(s). Use 'jenv help'"
            }
        } elseif ($arg2 -ne "") {
            Write-Host "Invalid Argument. Use 'jenv help'"
        } else {
            Write-Host "No arguments provided. Use 'jenv help'"
        }
    } else {
        Write-Host "Don't create, remove, or rename links ending in 'w'! (Reserved for javaw)"
    }
} elseif ($arg1 -ieq "help") {
    #Write-Host ("━" * (Get-Host).UI.RawUI.WindowSize.Width) # This crashes when called from cmd
    Write-Host (-join ((0..((Get-Host).UI.RawUI.WindowSize.Width - 1)) | ForEach-Object { [char]0x2501 }))

    Write-Host "jenv list - Lists all versions (folders) in " -NoNewline
    Write-Host "'C:\Program Files\Java'" -ForegroundColor Yellow -NoNewline
    Write-Host "."

    Write-Host ""
    Write-Host "jenv global/set <version> - Sets java version (JAVA_HOME) " -NoNewline
    Write-Host "globally" -ForegroundColor Yellow -NoNewline
    Write-Host "."
    Write-Host "jenv local/use <version> - Sets java version (JAVA_HOME) for the " -NoNewline
    Write-Host "current shell" -ForegroundColor Yellow -NoNewline
    Write-Host "."

    Write-Host ""
    Write-Host "Links" -ForegroundColor DarkYellow -NoNewline
    Write-Host " - With links you can call a version without changing the local or global variable." -ForegroundColor Yellow
    Write-Host "Example: A link named " -ForegroundColor Yellow -NoNewline
    Write-Host "'java8'" -ForegroundColor DarkYellow -NoNewline
    Write-Host " would be used like " -ForegroundColor Yellow -NoNewline
    Write-Host "'java8 -version'" -ForegroundColor DarkYellow -NoNewline
    Write-Host " (" -ForegroundColor Yellow -NoNewline
    Write-Host "java8w" -ForegroundColor DarkYellow -NoNewline
    Write-Host " for javaw)." -ForegroundColor Yellow

    Write-Host "jenv link list - Lists all existing links."
    Write-Host "jenv link create <name> <version>"
    Write-Host "jenv link remove <name>"
    Write-Host "jenv link rename <name> <new_name>"

    Write-Host ""
    Write-Host "<version>" -ForegroundColor DarkYellow -NoNewline
    Write-Host " can be what is listed by " -ForegroundColor Yellow -NoNewline
    Write-Host "'jenv list'" -ForegroundColor DarkYellow -NoNewline
    Write-Host " (" -ForegroundColor Yellow -NoNewline
    Write-Host "`"jdk-`"" -ForegroundColor DarkYellow -NoNewline
    Write-Host " at the beginning " -ForegroundColor Yellow -NoNewline
    Write-Host "can be omitted" -ForegroundColor DarkYellow -NoNewline
    Write-Host "), " -ForegroundColor Yellow

    Write-Host "          or the " -ForegroundColor Yellow -NoNewline
    Write-Host "full path" -ForegroundColor DarkYellow -NoNewline
    Write-Host " to a java versions folder (" -ForegroundColor Yellow -NoNewline
    Write-Host "NOT" -ForegroundColor DarkYellow -NoNewline
    Write-Host " the " -ForegroundColor Yellow -NoNewline
    Write-Host "'bin'" -ForegroundColor DarkYellow -NoNewline
    Write-Host " folder, it's parent folder)." -ForegroundColor Yellow

    Write-Host "          (In CMD, full path only works for links, not global/local!)" -ForegroundColor DarkYellow
    if ($cmd) { Write-Host "          YOU ARE CURRENTLY USING CMD!" -ForegroundColor Red }

    Write-Host ""
    Write-Host "jenv update - Re-Downloads files."

    Write-Host (-join ((0..((Get-Host).UI.RawUI.WindowSize.Width - 1)) | ForEach-Object { [char]0x2501 }))
} elseif ($arg1 -ieq "update") {
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/OnlYKai/jenv/main/jenv-install.ps1" -OutFile "$PSScriptRoot\jenv-install.ps1"
    &"$PSScriptRoot\jenv-install.ps1" -here
} elseif ($arg1 -ne "") {
    Write-Host "Invalid Argument. Use 'jenv help'"
} else {
    Write-Host "No argument provided. Use 'jenv help'"
}