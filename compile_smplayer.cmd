rem @echo off

call version.cmd

set WD=%cd%
set ROOT=packages

cd %ROOT%\smplayer
call compile_windows.cmd nosmtube
cd %WD%
