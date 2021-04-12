@echo off

set ROOT=packages
set WD=%cd%

cd %WD%\%ROOT%\smplayer
svn cleanup
svn update

cd %WD%\%ROOT%\smplayer-portable
svn cleanup
svn update

cd %WD%\%ROOT%\smplayer-themes
svn cleanup
svn update

cd %WD%\%ROOT%\smplayer-skins
svn cleanup
svn update

cd %WD%\%ROOT%\smtube
svn cleanup
svn update

cd %WD%\%ROOT%\smtube-portable
svn cleanup
svn update

cd %WD%
