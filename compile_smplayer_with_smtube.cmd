@echo off

set WD=%cd%
set ROOT=packages

cd %ROOT%\smtube
call compile_smtubelib.cmd
cd %WD%

mkdir %ROOT%\smplayer\smtube
copy %ROOT%\smtube\src\browserwindow.h %ROOT%\smplayer\smtube\
copy %ROOT%\smtube\src\hcplayer.h %ROOT%\smplayer\smtube\
copy %ROOT%\smtube\src\release\libsmtube.a %ROOT%\smplayer\smtube\
copy %ROOT%\smtube\src\translations\*.qm %ROOT%\smplayer\src\translations\

cd %ROOT%\smplayer
call compile_windows smtubelib nosmtube
cd %WD%
