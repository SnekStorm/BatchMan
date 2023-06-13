@echo off
goto :init

::################# Error handling #################
:missing_argument
    echo *******************************************
    echo ****                                   ****
    echo ****    MISSING "REQUIRED ARGUMENT"    ****
    echo ****                                   ****
    echo *******************************************
    call :usage
    goto :eof

:header
    echo.
    echo    Info about: %__NAME%
    echo    Traverses through %__OriginPath% and compare its files to the files in %__CopyPath%  
    echo    If files differ then copy over the files
    echo.
    echo    The -copy argument have to be used to initialize the Copy of the files!
    echo.    
    goto :eof

:usage
:: Help message, how to use the script
    echo USAGE:
    echo   %__BAT_NAME% [flags] "required argument"
    echo.
    echo.  -copy,           Initializes the Copying of the files!
    echo.  -h,              Help message
    goto :eof

::################# Init parameters #################
:: Initializes the variables used in the script
:init
    :: The name of the File (%~n0)
    set "__NAME=%~n0" 
    :: The name of the File with the extension .bat (%~nx0)
    set "__BAT_NAME=%~nx0"
    :: The File path
    set "__Directory=%~dp0"


    set "__OriginFolder=Original"
    set "__CopyFolder=Kopia"

    set "__OriginPath="
    set "__CopyPath="


    set "FirstArgument="
    set "SecondArgument="


::################# Process the arguments #################
:parse
    :: Exit when no more arguments are given
    if "%~1"=="" goto :validate
    
    :: The valid arguments
    if /i "%~1"=="-copy"      set "FirstArgument=yes" & shift & goto :parse
    if /i "%~1"=="-h"      call :header "%~2" & goto :end

    :: Next argument
    shift
    goto :parse

::################# Validate the arguments #################
:validate

    if not defined FirstArgument    call :missing_argument & goto :end

    set "__OriginPath=%__Directory%%__OriginFolder%\"
    set "__CopyPath=%__Directory%%__CopyFolder%\"
    goto :main
    


::################# Main Program #####################
:main
    echo Copy files from %__OriginPath% to %__CopyPath%

    cd %__OriginPath%
    FOR %%G in (*) do (    
        if exist %__CopyPath%\%%G call :compareFiles %%G
        if not exist %__CopyPath%\%%G call :transferFile %%G
    )

    echo Transfer Done
    goto :end
::################# Main Functions #####################
:compareFiles
    Fc %__OriginPath%%1 %__CopyPath%%1 > nul
    if errorlevel 1 call :diffFound %1
    exit /b


:diffFound
    del %__CopyPath%%1
    call :transferFile %1
    exit /b

:transferFile
    robocopy %__OriginPath% %__CopyPath% %1 > nul
    exit /b




::################# Exit script #################
:end
    cd %__Directory%
    call :cleanup
    exit /B

:cleanup
    :: Zeroes the variables
    :: The cleanup function is only really necessary if you are _not_ using SETLOCAL.

    set "__NAME=" 
    set "__BAT_NAME="
    set "__Directory="


    set "__OriginFolder="
    set "__CopyFolder="

    set "__OriginPath="
    set "__CopyPath="


    set "FirstArgument="
    set "SecondArgument="
    goto :eof