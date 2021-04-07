@echo off

set WD=%cd%
set ROOT=packages

cd %ROOT%\smplayer-themes
cd themes
mingw32-make
cd %WD%

cd %ROOT%\smplayer-skins
cd themes
mingw32-make
cd %WD%
