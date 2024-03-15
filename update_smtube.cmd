@echo off

set ROOT=packages
set WD=%cd%

cd %WD%\%ROOT%\smtube
git pull

cd %WD%\%ROOT%\smtube-portable
git pull

cd %WD%
