@echo off

set WD=%cd%
set ROOT=packages

echo Building portable version...
cd "%ROOT%\smtube-portable"
call compile_windows_portable.cmd -portable -noupdate
cd %WD%

mkdir "%ROOT%\smtube\setup\portable"
copy /y "%ROOT%\smtube-portable\src\release\smtube.exe" "%ROOT%\smtube\setup\portable\smtube-portable.exe"

echo Building normal version...
cd "%ROOT%\smtube"
call compile_windows.cmd -noupdate -makeinst
cd %WD%
