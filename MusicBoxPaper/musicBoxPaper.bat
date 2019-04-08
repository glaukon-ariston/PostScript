@echo off
call :generate_pdf
goto :eof

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:generate_pdf
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
gswin64c @ps2pdf-musicBoxPaper.opt -sOutputFile#musicBoxPaper.pdf -fmusicBoxPaper.ps
goto :eof
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

