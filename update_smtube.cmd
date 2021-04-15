@echo off

set ROOT=packages
set WD=%cd%

cd %WD%\%ROOT%\smtube
svn cleanup
svn update

cd %WD%\%ROOT%\smtube-portable
svn cleanup
svn update

cd %WD%
