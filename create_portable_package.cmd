@echo off

set ROOT=packages
set BUILD_DIR=%ROOT%\BUILD
set WD=%cd%

cd %ROOT%\smplayer-portable\
call %WD%\getversion.cmd
cd %WD%

set PORTABLE_PATH=%BUILD_DIR%\smplayer-portable

rem mkdir "%PORTABLE_PATH%\screenshots"
rem echo [%%General]> "%PORTABLE_PATH%\smplayer.ini"
rem echo screenshot_directory=.\\screenshots>> "%PORTABLE_PATH%\smplayer.ini"
rem echo.>> "%PORTABLE_PATH%\smplayer.ini"
rem echo [smplayer]>> "%PORTABLE_PATH%\smplayer.ini"
rem echo check_if_upgraded=false>> "%PORTABLE_PATH%\smplayer.ini"
rem copy "%PORTABLE_PATH%\smplayer.ini" "%PORTABLE_PATH%\smplayer_orig.ini"

set PACKAGEFILENAME=smplayer-portable-%VER_MAJOR%.%VER_MINOR%.%VER_BUILD%.%VER_REVISION%-%BUILD_ARCH%.7z

cd %BUILD_DIR%
%WD%\7za a -t7z "output\%PACKAGEFILENAME%" "smplayer-portable" -mx9
cd %WD%

echo %PACKAGEFILENAME%
echo %PACKAGEFILENAME%>%BUILD_DIR%\portable_filename.txt
