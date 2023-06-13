::Template
@echo off
goto :init

::################# Error handling #################
:: Custom error message
:missing_argument
    call :usage
    echo.
    echo ****                                   ****
    echo ****    MISSING "REQUIRED ARGUMENT"    ****
    echo ****                                   ****
    echo.

    call :use_template
    goto :eof

:usage
:: Help message, how to use the script
    echo USAGE:
    echo   %__BAT_NAME% [flags] "required argument"
    echo.
    echo.  -a,            The First input
    echo.  -b,            The Second input
    goto :eof

:use_template
    echo.
    echo ##################### Example #####################
    echo %__BAT_NAME% -a FirstArgument -b SecondArgument
    echo ###################################################
    echo.
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

    :: The Parsed Variables, First one if detected, Second one to store input
    set "FirstArgument="
    set "__First="
    set "SecondArgument="
    set "__Second="


::################# Process the arguments #################
:parse
    :: Exit when no more arguments are given, repeat until all argument have been parsed
    if "%~1"=="" goto :validate
    
    :: The valid arguments
    if /i "%~1"=="-a"      set "FirstArgument=yes" & shift & goto :parse
    if /i "%~1"=="-b"      set "SecondArgument=yes" & shift & goto :parse

    :: Assign the variables
    :: If -a have been given, check if that argument have been assigned already, if not then assign the variable then go to next argument, else continue
    if %FirstArgument%==yes             if not defined __First      set "__First=%~1"      & shift & goto :parse
    
    :: check the second argument
    if "%SecondArgument%" == "yes"      if not defined __Second     set "__Second=%~1"     & shift & goto :parse
    
    :: Next argument
    shift
    goto :parse



::################# Validate the arguments #################
:: If any arguments are necessary, then the program can be stopped here
:validate
    if not defined FirstArgument call :missing_argument & goto :end
    if not defined SecondArgument call :missing_argument & goto :end

::################# Main Program #####################
:main
    echo %__First%
    echo %__Second%

::################# Exit script #################
:end
    call :cleanup
    exit /B

:cleanup
    :: Zeroes the variables
    :: The cleanup function is only really necessary if you are _not_ using SETLOCAL.
    set "__NAME="
    set "__BAT_NAME="
    
    set "FirstArgument="
    set "__First="
    set "SecondArgument="
    set "__Second="

    goto :eof