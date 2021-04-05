@echo off

:: Some SVN clients can use localized messages (e.g. SlikSVN), force English
set LC_ALL=C
set svn_revision=
set use_svn_versions=
set version_cpp=

for /f "tokens=2" %%i in ('svn info ^| find /I "Revision:"') do set svn_revision=%%i

if "%svn_revision%"=="" (
  set svn_revision=UNKNOWN
  echo Unknown SVN revision. SVN missing in PATH or not a working copy.
) else (
  echo SVN Revision: %svn_revision%
)
echo.

echo #define SVN_REVISION "%svn_revision%">src\svn_revision.h

:: Get values of USE_SVN_VERSIONS & DEVELOPMENT_VERSION & VERSION
for /f "tokens=3" %%j in ('type src\version.cpp ^| find /I "#define USE_SVN_VERSIONS"') do set use_svn_versions=%%j
for /f "tokens=3" %%k in ('type src\version.cpp ^| find /I "#define DEVELOPMENT_VERSION"') do set development_version=%%k
for /f "tokens=3" %%l in ('type src\version.cpp ^| find /I "#define VERSION"') do set version_cpp=%%l

:: Remove quotes
setlocal enableDelayedExpansion
for /f "delims=" %%A in ("!use_svn_versions!") do endlocal & set "use_svn_versions=%%~A"
setlocal enableDelayedExpansion
for /f "delims=" %%A in ("!development_version!") do endlocal & set "development_version=%%~A"
setlocal enableDelayedExpansion
for /f "delims=" %%A in ("!version_cpp!") do endlocal & set "version_cpp=%%~A"

:: Verify svn revision & version are actually numbers and version has at least ver_major.ver_minor.ver_build
if defined development_version (
  echo %svn_revision%|findstr /r /c:"^[0-9][0-9]*$" >nul
  if errorlevel 1 (set development_version=)
)

if defined version_cpp (
  echo %version_cpp%|findstr /r /c:"^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$" >nul
  if errorlevel 1 (set version_cpp=)
)

if defined version_cpp (
  if [%development_version%]==[1] (
    set "ALL_PKG_VER=%version_cpp%.%svn_revision%"
  ) else (
    set "ALL_PKG_VER=%version_cpp%"
  )
)

set svn_revision=
set development_version=
set use_svn_versions=
set version_cpp=

:parse_version
for /f "tokens=1 delims=." %%j in ("%ALL_PKG_VER%")  do set VER_MAJOR=%%j
for /f "tokens=2 delims=." %%k in ("%ALL_PKG_VER%")  do set VER_MINOR=%%k
for /f "tokens=3 delims=." %%l in ("%ALL_PKG_VER%")  do set VER_BUILD=%%l
for /f "tokens=4 delims=." %%m in ("%ALL_PKG_VER%")  do set VER_REVISION=%%m

echo %VER_MAJOR%|findstr /r /c:"^[0-9][0-9]*$" >nul
if errorlevel 1 (
  echo Invalid version string. VER_MAJOR is not defined or is not a number [#.x.x]
)

echo %VER_MINOR%|findstr /r /c:"^[0-9][0-9]*$" >nul
if errorlevel 1 (
  echo Invalid version string. VER_MINOR is not defined or is not a number [x.#.x]
)
echo %VER_BUILD%|findstr /r /c:"^[0-9][0-9]*$" >nul
if errorlevel 1 (
  echo Invalid version string. VER_BUILD is not defined or is not a number [x.x.#]
)

if defined VER_REVISION (
  echo %VER_REVISION%|findstr /r /c:"^[0-9][0-9]*$" >nul
  if errorlevel 1 (
    echo Invalid version string. VER_REVISION is not a number [x.x.x.#]
  ) else (
    set VER_REV_CMD=/DVER_REVISION=%VER_REVISION% & ver>nul
  )
) else (
  set VER_REV_CMD=
)

@echo on
echo VERSION: %ALL_PKG_VER%
echo VER_MAJOR: %VER_MAJOR%
echo VER_MINOR: %VER_MINOR%
echo VER_BUILD: %VER_BUILD%
echo VER_REVISION: %VER_REVISION%



