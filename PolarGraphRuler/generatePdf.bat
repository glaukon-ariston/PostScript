@echo off
call :generate_pdf
goto :eof

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:generate_pdf
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set INPUT=polarGraphRuler
set PDFFILE=%INPUT%.pdf
gswin64c @ps2pdf-polar.opt -sOutputFile#%PDFFILE% -f%INPUT%.ps
if %errorlevel% neq 0 (goto :eof)
start "" /max "%PDFFILE%"
goto :eof
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

