@echo off
call :generate_pdf
goto :eof

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:generate_pdf
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
gswin64c @ps2pdf-photoCollage.opt -sOutputFile#photoCollage.pdf -fphotoCollage.ps
goto :eof
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

