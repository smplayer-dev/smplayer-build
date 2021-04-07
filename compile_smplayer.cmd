@echo off

set build_portable=false
if [%1]==[pe] (
  set build_portable=true
)

set WD=%cd%
set ROOT=packages

if [%build_portable%]==[true] (
  echo Building portable version...
  cd %ROOT%\smplayer-portable\
  call %WD%\getversion.cmd
  call compile_windows.cmd nosmtube pe
) else (
  echo Building normal version...
  cd %ROOT%\smplayer\
  call %WD%\getversion.cmd
  call compile_windows.cmd nosmtube
)
cd %WD%
