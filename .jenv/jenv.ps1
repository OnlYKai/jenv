param (
    [string]$action,
    [string]$version
)

if ($action -eq "list") {
    Get-ChildItem "C:\Program Files\Java" -Directory | Sort-Object -Descending | ForEach-Object { Write-Host $_.Name }
} elseif ($action -eq "global" -or $action -eq "set") {
    if ($version -ne "") {
        if (Test-Path "C:\Program Files\Java\$version") {
            setx JAVA_HOME "C:\Program Files\Java\$version" >$null
            $env:JAVA_HOME = "C:\Program Files\Java\$version"
            Write-Host "Global set to $version."
        } elseif (Test-Path "C:\Program Files\Java\jdk-$version") {
            setx JAVA_HOME "C:\Program Files\Java\jdk-$version" >$null
            $env:JAVA_HOME = "C:\Program Files\Java\jdk-$version"
            Write-Host "Global set to jdk-$version."
        } else {
            Write-Host "Version not found. Use 'jenv list'"
        }
    } else {
        Write-Host "No version provided. Use 'jenv list'"
    }
} elseif ($action -eq "local" -or $action -eq "use") {
    if ($version -ne "") {
        if (Test-Path "C:\Program Files\Java\$version") {
            $env:JAVA_HOME = "C:\Program Files\Java\$version"
            Write-Host "Shell set to $version."
        } elseif (Test-Path "C:\Program Files\Java\jdk-$version") {
            $env:JAVA_HOME = "C:\Program Files\Java\jdk-$version"
            Write-Host "Shell set to jdk-$version."
        } else {
            Write-Host "Version not found. Use 'jenv list'"
        }
    } else {
        Write-Host "No version provided. Use 'jenv list'"
    }
} elseif ($action -eq "help") {
    Write-Host "jenv list - Lists all folders (versions) in 'C:\Program Files\Java'."
    Write-Host "jenv global/set - Sets java version globally (JAVA_HOME). (`"jdk-`" can be omitted!)"
    Write-Host "jenv local/use - Sets java version for the current shell (JAVA_HOME). (`"jdk-`" can be omitted!)"
    Write-Host "jenv help - Shows this message."
} elseif ($action -ne "") {
    Write-Host "Invalid Argument. Use 'jenv help'"
} else {
    Write-Host "No argument provided. Use 'jenv help'"
}