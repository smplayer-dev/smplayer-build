rem @echo off

set WD=%cd%
set ROOT=packages

cd %ROOT%\smplayer\
call %WD%\getversion.cmd
call compile_windows.cmd nosmtube
cd %WD%
