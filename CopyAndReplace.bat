@echo off

set OGPath=E:\Git\Batch\Original\
set NewPath=E:\Git\Batch\Kopia\

echo Copy files from OC to New

cd %OGPath%
FOR %%G in (*) do (    
    if exist %NewPath%\%%G call :compareFiles %%G
    if not exist %NewPath%\%%G call :transferFile %%G
)

echo Transfer Done
exit /b

:compareFiles
Fc %OGPath%%1 %NewPath%%1 > nul
if errorlevel 1 call :diffFound %1
exit /b


:diffFound
del %NewPath%%1
call :transferFile %1
exit /b

:transferFile
robocopy %OGPath% %NewPath% %1 > nul
exit /b