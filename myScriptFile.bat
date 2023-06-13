@echo off
goto :init

::################# Error handling #################
:missing_argument
    call :usage
    echo.
    echo ****                                   ****
    echo ****    MISSING "REQUIRED ARGUMENT"    ****
    echo ****                                   ****
    echo.
    goto :eof

:usage
    echo USAGE:
    echo   %__BAT_NAME% [flags] "required argument"
    echo.
    echo.  -o,            The Original Path
    echo.  -n,            The New Path
    goto :eof
::################# Init parameters #################
:init
    :: File name (%~n0)
    set "__NAME=%~n0" 
    set "__OGPath="
    set "__NewPath="

    set "__BAT_NAME=%~nx0"

    set "OGPathArgument="
    set "NewPathArgument="

::################# Process the arguments #################
:parse
    :: Exit when no more arguments are given
    if "%~1"=="" goto :validate
    
    :: The valid arguments
    if /i "%~1"=="-o"      set "OGPathArgument=yes" & shift & goto :parse
    if /i "%~1"=="-n"      set "NewPathArgument=yes" & shift & goto :parse

    :: Assign the variables
    if not defined OGPathArgument     set "__OGPath=%~1"     & shift & goto :parse
    if not defined NewPathArgument     set "__NewPath=%~1"     & shift & goto :parse
    
    :: Next argument
    shift
    goto :parse

::################# Validate the arguments #################
:validate
    if not defined OGPathArgument call :missing_argument & goto :end
    if not defined NewPathArgument call :missing_argument & goto :end

::################# Main Program #####################
:main
    echo %__OGPath%
    echo %__NewPath%









::################# Exit script #################
:end
    call :cleanup
    exit /B

:cleanup
    REM The cleanup function is only really necessary if you
    REM are _not_ using SETLOCAL.
    set "__NAME="
    set "__OGPath="
    set "__NewPath="

    set "__BAT_NAME="
    
    set "OGPathArgument="
    set "NewPathArgument="

    goto :eof