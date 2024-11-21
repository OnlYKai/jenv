@echo off

if /i "%~1"=="list" (
    powershell -File "%~dp0jenv.ps1" %*
) else if /i "%~1"=="global" (
    goto global
) else if /i "%~1"=="set" (
    goto global
) else if /i "%~1"=="local" (
    goto local
) else if /i "%~1"=="use" (
    goto local
) else if /i "%~1"=="link" (
    powershell -File "%~dp0jenv.ps1" %*
) else if /i "%~1"=="help" (
    echo jenv list - Lists all versions ^(folders^) in 'C:\Program Files\Java'.
    echo.
    echo jenv global/set ^<version^> - Sets java version ^(JAVA_HOME^) globally.
    echo jenv local/use ^<version^> - Sets java version ^(JAVA_HOME^) for the current shell.
    echo.
    echo Links - With links you can call a version without changing the local or global variable.
    echo Example: A link named 'java8' would be used like 'java8 -version' ^(java8w for javaw^).
    echo jenv link list - Lists all existing links.
    echo jenv link create ^<name^> ^<version^>
    echo jenv link remove ^<name^>
    echo jenv link rename ^<name^> ^<new_name^>
    echo.
    powershell -Command "Write-Host '*<version> can be what is listed in ''jenv list'' (\"jdk-\" at the beginning can be omitted), ' -ForegroundColor Yellow"
    powershell -Command "Write-Host '           or a full path to a java versions folder (NOT the ''bin'' folder, it''s parent folder).' -ForegroundColor Yellow"
    powershell -Command "Write-Host '           (In CMD, full path only works for links, not global/local!)' -ForegroundColor DarkYellow"
    powershell -Command "Write-Host '           YOU ARE CURRENTLY IN CMD!' -ForegroundColor Red"
) else if not "%~1"=="" (
    echo Invalid argument. Use 'jenv help'
) else (
    echo No argument provided. Use 'jenv help'
)
goto :eof



:global
if not "%~2"=="" (
    if exist "C:\Program Files\Java\%~2" (
        setx JAVA_HOME "C:\Program Files\Java\%~2" >NUL
        set JAVA_HOME=C:\Program Files\Java\%~2
        echo Global java version set to %~2.
    ) else if exist "C:\Program Files\Java\jdk-%~2" (
        setx JAVA_HOME "C:\Program Files\Java\jdk-%~2" >NUL
        set JAVA_HOME=C:\Program Files\Java\jdk-%~2
        echo Global java version set to jdk-%~2.
    ) else (
        echo Version not found. Use 'jenv list'
    )
) else (
    echo No version provided. Use 'jenv list'
)
goto :eof



:local
if not "%~2"=="" (
    if exist "C:\Program Files\Java\%~2" (
        set JAVA_HOME=C:\Program Files\Java\%~2
        echo Shell set to %~2.
    ) else if exist "C:\Program Files\Java\jdk-%~2" (
        set JAVA_HOME=C:\Program Files\Java\jdk-%~2
        echo Shell set to jdk-%~2.
    ) else (
        echo Version not found. Use 'jenv list'
    )
) else (
    echo No version provided. Use 'jenv list'
)
goto :eof