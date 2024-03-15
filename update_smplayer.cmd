@echo off

set ROOT=packages
set WD=%cd%

cd %WD%\%ROOT%\smplayer
git pull

cd %WD%\%ROOT%\smplayer-portable
git pull

cd %WD%\%ROOT%\smplayer-themes
git pull

cd %WD%\%ROOT%\smplayer-skins
git pull

cd %WD%
