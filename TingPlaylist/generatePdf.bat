@echo off
:: Usage
:: generatePdf.bat "Glazbena petica_TextBook" 4

:: Do no harm.
if [%1]==[] (
	echo generatePdf.bat yamlBaseName columnCount
	goto :EOF
)

if [%2]==[] (
	echo generatePdf.bat yamlBaseName columnCount
	goto :EOF
)

call :GetDate year month day
call :GetTime hours mins secs hsecs
set TIMESTAMP=%year%.%month%.%day%-%hours%:%mins%:%secs%
echo #Start %TIMESTAMP%

call :generate_pdf %1 %2

call :GetDate year month day
call :GetTime hours mins secs hsecs
set TIMESTAMP=%year%.%month%.%day%-%hours%:%mins%:%secs%
echo #End %TIMESTAMP%

goto :eof

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:generate_pdf
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
gswin64c @ps2pdf.opt -sOutputFile#pdf/%1.pdf -sinputYaml#%1.ps -dcolumnCount#%2 -ftingPlaylist.ps 
goto :eof
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:getPathLength filePath len
::
:: Returns the lenght of the file path. For NT4/2K/XP
::
:: Args: %1 Var file path
::       %2 Var to receive path length (by ref)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
setlocal EnableDelayedExpansion
	set filePath=%1
	for /L %%n in (1 1 500) do if "!filePath:~%%n,1!" neq "" set /a "len=%%n+1"
endlocal&set %2=%len%&goto :EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:getRelativePath rootPath absPath relPath
::
:: Returns the abspPath relative to rootPath. For NT4/2K/XP
::
:: Args: %1 Var root path
::       %2 Var absolute path
::       %3 Var to receive relative path (by ref)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
setlocal EnableDelayedExpansion
	set "rootPath=%1"
	set "absPath=%2"
	call :getPathLength %rootPath% rootPathLen
	set "relPath=!absPath:~%rootPathLen%!"
endlocal&set %3=%relPath%&goto :EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:GetTime hh nn ss cs
::
:: By:   Ritchie Lawrence, updated 2002-10-30. Version 1.2
:: URL:  http://www.commandline.co.uk/cmdfuncs/dandt/index.html#gettime
::
:: Func: Loads local system time components into args 1 to 4. For NT4/2K/XP
::
:: Args: %1 Var to receive hours, 2 digits, 00 to 23 (by ref)
::       %2 Var to receive minutes, 2 digits, 00 to 59 (by ref)
::       %3 Var to receive seconds, 2 digits, 00 to 59 (by ref)
::       %4 Var to receive centiseconds, 2 digits, 00 to 99 (by ref)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
setlocal ENABLEEXTENSIONS
for /f "tokens=5-8 delims=:,. " %%a in ('echo/^|time') do (
  set hh=%%a&set nn=%%b&set ss=%%c&set cs=%%d)
if 1%hh% LSS 20 set hh=0%hh%
endlocal&set %1=%hh%&set %2=%nn%&set %3=%ss%&set %4=%cs%&goto :EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:GetDate yy mm dd
::
:: By:   Ritchie Lawrence, 2002-06-15. Version 1.0
:: URL:  http://www.commandline.co.uk/cmdfuncs/dandt/index.html#getdate
::
:: Func: Loads local system date components into args 1 to 3. For NT4/2K/XP
::
:: Args: %1 var to receive year, 4 digits (by ref)
::       %2 var to receive month, 2 digits, 01 to 12 (by ref)
::       %3 Var to receive day of month, 2 digits, 01 to 31 (by ref)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
setlocal ENABLEEXTENSIONS
set t=2&if "%date%z" LSS "A" set t=1
for /f "skip=1 tokens=2-4 delims=(-)" %%a in ('echo/^|date') do (
  for /f "tokens=%t%-4 delims=.-/ " %%d in ('date/t') do (
    set %%a=%%d&set %%b=%%e&set %%c=%%f))
endlocal&set %1=%yy%&set %2=%mm%&set %3=%dd%&goto :EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
