@echo off
set path=%path%;%~dp0

set t=%temp%\psx
set d=e:\psx
if exist "%t%" rd "%t%" /Q /S
if not exist "%t%" md %t%
if exist "%d%" rd "%d%" /Q /S
if not exist "%d%" md %d%
dir /b /s > "%~dp0all.lst"
sed -i "/\.7z$/!d" "%~dp0all.lst"
sed -i "s/\d033/\^\d033/g" "%~dp0all.lst"

for /f "tokens=*" %%a in ('type "%~dp0all.lst"') do (
for /f "tokens=*" %%n in ('echo "%%a" ^| sed "s/^.*\\\|\.7z.*$//g"') do (
setlocal EnableDelayedExpansion
echo %%n
"%~dp07z.exe" x "%%a" -o"%t%" > nul 2>&1
if not !errorlevel!==0 echo NOT OK %%n >> error.log
"%~dp0unecm.exe" "%t%\Track 01.bin.ecm" "%d%\%%n.bin" > nul 2>&1
if not !errorlevel!==0 (
echo %%n is probably in "~t7z" direcotry >> error.log
move "%t%\*.bin" "%d%" > nul 2>&1
if exist "%t%" rd "%t%" /Q /S > nul 2>&1
if not exist "%t%" md "%t%" > nul 2>&1
)
del "%t%\Track 01.bin.ecm" /Q /F > nul 2>&1
endlocal
)
)
%systemroot%\System32\shutdown.exe -s -t 0
