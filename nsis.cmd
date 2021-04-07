@echo off

set ROOT=packages
set BUILD_DIR=%ROOT%\BUILD
set WD=%cd%

cd %ROOT%\smplayer\
call %WD%\getversion.cmd
cd %WD%

set DEF_QT5=/DQT5
set DEF_ARCH=
if "%BUILD_ARCH%" == "x64" (
  set DEF_ARCH=/DWIN64
)

mkdir "%BUILD_DIR%\translations"
mkdir "%BUILD_DIR%\output"
copy "%ROOT%\smplayer\setup\translations\*.*" "%BUILD_DIR%\translations"
copy "%ROOT%\smplayer\setup\smplayer*.*" "%BUILD_DIR%\"
copy "%ROOT%\smplayer\setup\license.txt" "%BUILD_DIR%\"

if not defined MAKENSIS_EXE_PATH (
  for %%x in ("%PROGRAMFILES(X86)%\NSIS\Bin\makensis.exe" "%PROGRAMFILES%\NSIS\Bin\makensis.exe") do if exist %%x set MAKENSIS_EXE_PATH=%%x
)

if not defined MAKENSIS_EXE_PATH (
  echo Warning: Unable to locate NSIS in the default path, create the file ^'nsis_path^' with the full correct path
  echo to makensis.exe or the existing ^'nsis_path^' may be incorrect.
  echo.
)

if %VER_REVISION% neq 0 (
  rem %MAKENSIS_EXE_PATH% %DEF_ARCH% %DEF_QT5% /DWITH_MPLAYER /DVER_MAJOR=%VER_MAJOR% /DVER_MINOR=%VER_MINOR% /DVER_BUILD=%VER_BUILD% /DVER_REVISION=%VER_REVISION% %BUILD_DIR%\smplayer.nsi
) else (
  rem %MAKENSIS_EXE_PATH% %DEF_ARCH% %DEF_QT5% /DWITH_MPLAYER /DVER_MAJOR=%VER_MAJOR% /DVER_MINOR=%VER_MINOR% /DVER_BUILD=%VER_BUILD% %BUILD_DIR%\smplayer.nsi
)

if %VER_REVISION% neq 0 (
	set VERSION=%VER_MAJOR%.%VER_MINOR%.%VER_BUILD%.%VER_REVISION%
) else (
	set VERSION=%VER_MAJOR%.%VER_MINOR%.%VER_BUILD%
)
set INSTALLERFILENAME=smplayer-%VERSION%-%BUILD_ARCH%.exe
set INSTALLERPATH=%BUILD_DIR%\output\%INSTALLERFILENAME%
echo %INSTALLERFILENAME%
echo %INSTALLERFILENAME% > %BUILD_DIR%\installer_filename.txt


