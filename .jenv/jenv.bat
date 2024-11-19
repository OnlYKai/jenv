@echo off

if /i "%1"=="list" (
    for /f "delims=" %%A in ('dir "C:\Program Files\Java" /ad /b ^| sort /r') do (
        echo %%A
    )
) else if /i "%1"=="global" (
    goto global
) else if /i "%1"=="set" (
    goto global
) else if /i "%1"=="local" (
    goto local
) else if /i "%1"=="use" (
    goto local
) else if /i "%1"=="help" (
    echo jenv list - Lists all folders ^(versions^) in 'C:\Program Files\Java'.
    echo jenv global/set - Sets java version globally ^(JAVA_HOME^). ^("jdk-" can be omitted!^)
    echo jenv local/use - Sets java version for the current shell ^(JAVA_HOME^). ^("jdk-" can be omitted!^)
    echo jenv help - Shows this message.
) else if not "%1"=="" (
    echo Invalid argument. Use 'jenv help'
) else (
    echo No argument provided. Use 'jenv help'
)
goto :eof



:global
if not "%2"=="" (
    if exist "C:\Program Files\Java\%2" (
        setx JAVA_HOME "C:\Program Files\Java\%2" >NUL
        set JAVA_HOME=C:\Program Files\Java\%2
        echo Global set to %2.
    ) else if exist "C:\Program Files\Java\jdk-%2" (
        setx JAVA_HOME "C:\Program Files\Java\jdk-%2" >NUL
        set JAVA_HOME=C:\Program Files\Java\jdk-%2
        echo Global set to jdk-%2.
    ) else (
        echo Version not found. Use 'jenv list'
    )
) else (
    echo No version provided. Use 'jenv list'
)
goto :eof



:local
if not "%2"=="" (
    if exist "C:\Program Files\Java\%2" (
        set JAVA_HOME=C:\Program Files\Java\%2
        echo Shell set to %2.
    ) else if exist "C:\Program Files\Java\jdk-%2" (
        set JAVA_HOME=C:\Program Files\Java\jdk-%2
        echo Shell set to jdk-%2.
    ) else (
        echo Version not found. Use 'jenv list'
    )
) else (
    echo No version provided. Use 'jenv list'
)
goto :eof