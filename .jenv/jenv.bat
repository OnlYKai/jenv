@echo off

if /i "%~1"=="list" (
    powershell -File "%~dp0jenv.ps1" %* -cmd
) else if /i "%~1"=="global" (
    goto global
) else if /i "%~1"=="set" (
    goto global
) else if /i "%~1"=="local" (
    goto local
) else if /i "%~1"=="use" (
    goto local
) else if /i "%~1"=="link" (
    powershell -File "%~dp0jenv.ps1" %* -cmd
) else if /i "%~1"=="help" (
    powershell -File "%~dp0jenv.ps1" %* -cmd
) else if /i "%~1"=="update" (
    powershell -File "%~dp0jenv.ps1" %* -cmd
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