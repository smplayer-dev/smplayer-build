@echo off

set build_portable=false
if [%1]==[pe] (
  set build_portable=true
)

set WD=%cd%
set ROOT=packages

if [%build_portable%]==[true] (
  echo Installing portable version...
  set OUTPUT_DIR=%ROOT%\BUILD\smplayer-portable
  set SMPLAYER_DIR=%ROOT%\smplayer-portable
) else (
   echo Installing normal version...
  set OUTPUT_DIR=%ROOT%\BUILD\smplayer-build
  set SMPLAYER_DIR=%ROOT%\smplayer
)

set SMPLAYER_THEMES_DIR=%ROOT%\smplayer-themes
set SMPLAYER_SKINS_DIR=%ROOT%\smplayer-skins

set MPLAYER_DIR=%ROOT%\mplayer
set MPV_DIR=%ROOT%\mpv

cd %SMPLAYER_DIR%
call %WD%\getversion.cmd
cd %WD%

if "%BUILD_ARCH%" == "x64" (
	set MPLAYER_DIR=%ROOT%\mplayer64
	set MPV_DIR=%ROOT%\mpv64
)

:: Qt locations from QMAKE
for /f "tokens=*" %%i in ('qmake -query QT_INSTALL_PREFIX') do set QT_DIR=%%i
for /f "tokens=*" %%i in ('qmake -query QT_VERSION') do set QTVER=%%i
set QT_DIR=%QT_DIR:/=\%

echo.
echo ######      SMPlayer, QT libs      #######
echo.

mkdir %OUTPUT_DIR%

copy %SMPLAYER_DIR%\src\release\smplayer.exe %OUTPUT_DIR%
rem copy %SMPLAYER_DIR%\zlib\zlib1.dll %OUTPUT_DIR%
copy %SMPLAYER_DIR%\*.txt %OUTPUT_DIR%
copy %SMPLAYER_DIR%\webserver\simple_web_server.exe %OUTPUT_DIR%

if %QTVER% geq 5.0.0 (
  copy %QT_DIR%\bin\Qt5Core.dll %OUTPUT_DIR%
  copy %QT_DIR%\bin\Qt5Gui.dll %OUTPUT_DIR%
  copy %QT_DIR%\bin\Qt5Network.dll %OUTPUT_DIR%
  rem copy %QT_DIR%\bin\Qt5Script.dll %OUTPUT_DIR%
  copy %QT_DIR%\bin\Qt5Widgets.dll %OUTPUT_DIR%
  copy %QT_DIR%\bin\Qt5Xml.dll %OUTPUT_DIR%
  copy "%QT_DIR%\bin\libstdc++-6.dll" %OUTPUT_DIR%
  copy %QT_DIR%\bin\libgcc_s_dw2-1.dll %OUTPUT_DIR%
  copy %QT_DIR%\bin\libwinpthread-1.dll %OUTPUT_DIR%
  rem copy "%QT_DIR%\bin\icudt*.dll" "%OUTPUT_DIR%"
  rem copy "%QT_DIR%\bin\icuin*.dll" "%OUTPUT_DIR%"
  rem copy "%QT_DIR%\bin\icuuc*.dll" "%OUTPUT_DIR%"
  copy "%QT_DIR%\bin\libgcc_s_seh-1.dll" %OUTPUT_DIR%
) else (
  copy %QT_DIR%\bin\QtCore4.dll %OUTPUT_DIR%
  copy %QT_DIR%\bin\QtGui4.dll %OUTPUT_DIR%
  copy %QT_DIR%\bin\QtNetwork4.dll %OUTPUT_DIR%
  copy %QT_DIR%\bin\QtXml4.dll %OUTPUT_DIR%
  rem copy %QT_DIR%\bin\QtScript4.dll %OUTPUT_DIR%
  copy %QT_DIR%\bin\QtDBus4.dll %OUTPUT_DIR%
  copy %QT_DIR%\bin\mingwm10.dll %OUTPUT_DIR%
  if %QTVER% geq 4.6.0 (
    copy %QT_DIR%\bin\libgcc_s_dw2-1.dll %OUTPUT_DIR%
  )
  if %QTVER% geq 4.8.0 (
    copy %QT_DIR%\bin\libwinpthread-1.dll %OUTPUT_DIR%
    copy "%QT_DIR%\bin\libstdc++-6.dll" %OUTPUT_DIR%
  )
)

if "%BUILD_ARCH%" == "x64" (
    copy %QT_DIR%\..\..\Tools\OpenSSL\Win_x64\bin\*.dll %OUTPUT_DIR%
) else (
    copy %QT_DIR%\..\..\Tools\OpenSSL\Win_x86\bin\*.dll %OUTPUT_DIR%
)

rem Qt Plugins
mkdir "%OUTPUT_DIR%\imageformats"
if %QTVER% lss 5.0.0 (

  copy "%QT_DIR%\plugins\imageformats\qjpeg4.dll" "%OUTPUT_DIR%\imageformats\"

) else if %QTVER% geq 5.0.0 (

  mkdir "%OUTPUT_DIR%\platforms"
  copy "%QT_DIR%\plugins\imageformats\qjpeg.dll" "%OUTPUT_DIR%\imageformats\"
  copy "%QT_DIR%\plugins\imageformats\qgif.dll" "%OUTPUT_DIR%\imageformats\"
  copy "%QT_DIR%\plugins\platforms\qwindows.dll" "%OUTPUT_DIR%\platforms\"

  mkdir "%OUTPUT_DIR%\styles"
  copy "%QT_DIR%\plugins\styles\*.dll" "%OUTPUT_DIR%\styles\"
)

echo.
echo ######        Translations         #######
echo.

mkdir %OUTPUT_DIR%\translations
copy %SMPLAYER_DIR%\src\translations\*.qm %OUTPUT_DIR%\translations
rem copy %SMPLAYER_DIR%\qt-translations\*.qm %OUTPUT_DIR%\translations

echo.
echo ######       Qt Translations       #######
echo.
copy %QT_DIR%\translations\qt_*.qm %OUTPUT_DIR%\translations
copy %QT_DIR%\translations\qtbase*.qm %OUTPUT_DIR%\translations
del %OUTPUT_DIR%\translations\qt_help_*.qm

echo.
echo ######         Shortcuts           #######
echo.
mkdir %OUTPUT_DIR%\shortcuts
copy %SMPLAYER_DIR%\src\shortcuts\*.keys %OUTPUT_DIR%\shortcuts

echo.
echo ######        Documentation        #######
echo.
rem svn export --force %SMPLAYER_DIR%\docs %OUTPUT_DIR%\docs
xcopy %SMPLAYER_DIR%\docs %OUTPUT_DIR%\docs\ /E

echo.
echo ######         Icon Themes         #######
echo.

mkdir %OUTPUT_DIR%\themes\

if not defined IDOPT_BUILD (
mkdir %OUTPUT_DIR%\themes\Breeze
copy %SMPLAYER_THEMES_DIR%\themes\Breeze\Breeze.rcc %OUTPUT_DIR%\themes\Breeze\
copy %SMPLAYER_THEMES_DIR%\themes\Breeze\README.txt %OUTPUT_DIR%\themes\Breeze\

mkdir %OUTPUT_DIR%\themes\Breeze-dark
copy %SMPLAYER_THEMES_DIR%\themes\Breeze-dark\Breeze-dark.rcc %OUTPUT_DIR%\themes\Breeze-dark\
copy %SMPLAYER_THEMES_DIR%\themes\Breeze-dark\README.txt %OUTPUT_DIR%\themes\Breeze-dark\

mkdir %OUTPUT_DIR%\themes\Faenza
copy %SMPLAYER_THEMES_DIR%\themes\Faenza\Faenza.rcc %OUTPUT_DIR%\themes\Faenza\
copy %SMPLAYER_THEMES_DIR%\themes\Faenza\README.txt %OUTPUT_DIR%\themes\Faenza\

mkdir %OUTPUT_DIR%\themes\Faenza-Darkest
copy %SMPLAYER_THEMES_DIR%\themes\Faenza-Darkest\Faenza-Darkest.rcc %OUTPUT_DIR%\themes\Faenza-Darkest\
copy %SMPLAYER_THEMES_DIR%\themes\Faenza-Darkest\README.txt %OUTPUT_DIR%\themes\Faenza-Darkest\

mkdir %OUTPUT_DIR%\themes\Faenza-Silver
copy %SMPLAYER_THEMES_DIR%\themes\Faenza-Silver\Faenza-Silver.rcc %OUTPUT_DIR%\themes\Faenza-Silver\
copy %SMPLAYER_THEMES_DIR%\themes\Faenza-Silver\README.txt %OUTPUT_DIR%\themes\Faenza-Silver\

mkdir %OUTPUT_DIR%\themes\Gartoon
copy %SMPLAYER_THEMES_DIR%\themes\Gartoon\Gartoon.rcc %OUTPUT_DIR%\themes\Gartoon\
copy %SMPLAYER_THEMES_DIR%\themes\Gartoon\README.txt %OUTPUT_DIR%\themes\Gartoon\

mkdir %OUTPUT_DIR%\themes\Gnome
copy %SMPLAYER_THEMES_DIR%\themes\Gnome\Gnome.rcc %OUTPUT_DIR%\themes\Gnome\
copy %SMPLAYER_THEMES_DIR%\themes\Gnome\README.txt %OUTPUT_DIR%\themes\Gnome\
)

mkdir %OUTPUT_DIR%\themes\Dark
copy %SMPLAYER_THEMES_DIR%\themes\Dark\Dark.rcc %OUTPUT_DIR%\themes\Dark\
copy %SMPLAYER_THEMES_DIR%\themes\Dark\README.txt %OUTPUT_DIR%\themes\Dark\
copy %SMPLAYER_THEMES_DIR%\themes\Dark\style.qss %OUTPUT_DIR%\themes\Dark\

mkdir %OUTPUT_DIR%\themes\Masalla
copy %SMPLAYER_THEMES_DIR%\themes\Masalla\Masalla.rcc %OUTPUT_DIR%\themes\Masalla\
copy %SMPLAYER_THEMES_DIR%\themes\Masalla\README.txt %OUTPUT_DIR%\themes\Masalla\
copy %SMPLAYER_THEMES_DIR%\themes\Masalla\style.qss %OUTPUT_DIR%\themes\Masalla\

if not defined IDOPT_BUILD (
mkdir %OUTPUT_DIR%\themes\Monochrome
copy %SMPLAYER_THEMES_DIR%\themes\Monochrome\Monochrome.rcc %OUTPUT_DIR%\themes\Monochrome\
copy %SMPLAYER_THEMES_DIR%\themes\Monochrome\README.txt %OUTPUT_DIR%\themes\Monochrome\

mkdir %OUTPUT_DIR%\themes\Noia
copy %SMPLAYER_THEMES_DIR%\themes\Noia\Noia.rcc %OUTPUT_DIR%\themes\Noia\
copy %SMPLAYER_THEMES_DIR%\themes\Noia\README.txt %OUTPUT_DIR%\themes\Noia\

mkdir %OUTPUT_DIR%\themes\Numix-remix
copy %SMPLAYER_THEMES_DIR%\themes\Numix-remix\Numix-remix.rcc %OUTPUT_DIR%\themes\Numix-remix\
copy %SMPLAYER_THEMES_DIR%\themes\Numix-remix\README.txt %OUTPUT_DIR%\themes\Numix-remix\

mkdir %OUTPUT_DIR%\themes\Numix-uTouch
copy %SMPLAYER_THEMES_DIR%\themes\Numix-uTouch\Numix-uTouch.rcc %OUTPUT_DIR%\themes\Numix-uTouch\
copy %SMPLAYER_THEMES_DIR%\themes\Numix-uTouch\README.txt %OUTPUT_DIR%\themes\Numix-uTouch\

mkdir %OUTPUT_DIR%\themes\Nuvola
copy %SMPLAYER_THEMES_DIR%\themes\Nuvola\Nuvola.rcc %OUTPUT_DIR%\themes\Nuvola\
copy %SMPLAYER_THEMES_DIR%\themes\Nuvola\README.txt %OUTPUT_DIR%\themes\Nuvola\

mkdir %OUTPUT_DIR%\themes\Oxygen
copy %SMPLAYER_THEMES_DIR%\themes\Oxygen\Oxygen.rcc %OUTPUT_DIR%\themes\Oxygen\
copy %SMPLAYER_THEMES_DIR%\themes\Oxygen\README.txt %OUTPUT_DIR%\themes\Oxygen\

mkdir %OUTPUT_DIR%\themes\Oxygen-Air
copy %SMPLAYER_THEMES_DIR%\themes\Oxygen-Air\Oxygen-Air.rcc %OUTPUT_DIR%\themes\Oxygen-Air\
copy %SMPLAYER_THEMES_DIR%\themes\Oxygen-Air\README.txt %OUTPUT_DIR%\themes\Oxygen-Air\

mkdir %OUTPUT_DIR%\themes\Oxygen-KDE
copy %SMPLAYER_THEMES_DIR%\themes\Oxygen-KDE\Oxygen-KDE.rcc %OUTPUT_DIR%\themes\Oxygen-KDE\
copy %SMPLAYER_THEMES_DIR%\themes\Oxygen-KDE\README.txt %OUTPUT_DIR%\themes\Oxygen-KDE\

mkdir %OUTPUT_DIR%\themes\Oxygen-Refit
copy %SMPLAYER_THEMES_DIR%\themes\Oxygen-Refit\Oxygen-Refit.rcc %OUTPUT_DIR%\themes\Oxygen-Refit\
copy %SMPLAYER_THEMES_DIR%\themes\Oxygen-Refit\README.txt %OUTPUT_DIR%\themes\Oxygen-Refit\

mkdir %OUTPUT_DIR%\themes\Papirus
copy %SMPLAYER_THEMES_DIR%\themes\Papirus\Papirus.rcc %OUTPUT_DIR%\themes\Papirus\
copy %SMPLAYER_THEMES_DIR%\themes\Papirus\README.txt %OUTPUT_DIR%\themes\Papirus\

mkdir %OUTPUT_DIR%\themes\PapirusDark
copy %SMPLAYER_THEMES_DIR%\themes\PapirusDark\PapirusDark.rcc %OUTPUT_DIR%\themes\PapirusDark\
copy %SMPLAYER_THEMES_DIR%\themes\PapirusDark\README.txt %OUTPUT_DIR%\themes\PapirusDark\

mkdir %OUTPUT_DIR%\themes\Silk
copy %SMPLAYER_THEMES_DIR%\themes\Silk\Silk.rcc %OUTPUT_DIR%\themes\Silk\
copy %SMPLAYER_THEMES_DIR%\themes\Silk\README.txt %OUTPUT_DIR%\themes\Silk\

mkdir %OUTPUT_DIR%\themes\Tango
copy %SMPLAYER_THEMES_DIR%\themes\Tango\Tango.rcc %OUTPUT_DIR%\themes\Tango\
copy %SMPLAYER_THEMES_DIR%\themes\Tango\README.txt %OUTPUT_DIR%\themes\Tango\

mkdir %OUTPUT_DIR%\themes\blackPanther-Light
copy %SMPLAYER_THEMES_DIR%\themes\blackPanther-Light\blackPanther-Light.rcc %OUTPUT_DIR%\themes\blackPanther-Light\
copy %SMPLAYER_THEMES_DIR%\themes\blackPanther-Light\README.txt %OUTPUT_DIR%\themes\blackPanther-Light\

mkdir %OUTPUT_DIR%\themes\blackPanther-Real
copy %SMPLAYER_THEMES_DIR%\themes\blackPanther-Real\blackPanther-Real.rcc %OUTPUT_DIR%\themes\blackPanther-Real\
copy %SMPLAYER_THEMES_DIR%\themes\blackPanther-Real\README.txt %OUTPUT_DIR%\themes\blackPanther-Real\

mkdir %OUTPUT_DIR%\themes\blackPanther-VistaLike
copy %SMPLAYER_THEMES_DIR%\themes\blackPanther-VistaLike\blackPanther-VistaLike.rcc %OUTPUT_DIR%\themes\blackPanther-VistaLike\
copy %SMPLAYER_THEMES_DIR%\themes\blackPanther-VistaLike\README.txt %OUTPUT_DIR%\themes\blackPanther-VistaLike\

mkdir %OUTPUT_DIR%\themes\ePapirus
copy %SMPLAYER_THEMES_DIR%\themes\ePapirus\ePapirus.rcc %OUTPUT_DIR%\themes\ePapirus\
copy %SMPLAYER_THEMES_DIR%\themes\ePapirus\README.txt %OUTPUT_DIR%\themes\ePapirus\

echo.
echo ######         Skins Themes         #######
echo.

mkdir %OUTPUT_DIR%\themes\Black
copy %SMPLAYER_SKINS_DIR%\themes\Black\Black.rcc %OUTPUT_DIR%\themes\Black\
copy %SMPLAYER_SKINS_DIR%\themes\Black\main.css %OUTPUT_DIR%\themes\Black\

mkdir %OUTPUT_DIR%\themes\Gonzo
copy %SMPLAYER_SKINS_DIR%\themes\Gonzo\Gonzo.rcc %OUTPUT_DIR%\themes\Gonzo\
copy %SMPLAYER_SKINS_DIR%\themes\Gonzo\main.css %OUTPUT_DIR%\themes\Gonzo\

mkdir %OUTPUT_DIR%\themes\Mac
copy %SMPLAYER_SKINS_DIR%\themes\Mac\Mac.rcc %OUTPUT_DIR%\themes\Mac\
copy %SMPLAYER_SKINS_DIR%\themes\Mac\main.css %OUTPUT_DIR%\themes\Mac\

mkdir %OUTPUT_DIR%\themes\Modern
copy %SMPLAYER_SKINS_DIR%\themes\Modern\Modern.rcc %OUTPUT_DIR%\themes\Modern\
copy %SMPLAYER_SKINS_DIR%\themes\Modern\main.css %OUTPUT_DIR%\themes\Modern\

mkdir %OUTPUT_DIR%\themes\Vista
copy %SMPLAYER_SKINS_DIR%\themes\Vista\Vista.rcc %OUTPUT_DIR%\themes\Vista\
copy %SMPLAYER_SKINS_DIR%\themes\Vista\main.css %OUTPUT_DIR%\themes\Vista\

mkdir %OUTPUT_DIR%\themes\Mint-Y
copy %SMPLAYER_SKINS_DIR%\themes\Mint-Y\Mint-Y.rcc %OUTPUT_DIR%\themes\Mint-Y\
copy %SMPLAYER_SKINS_DIR%\themes\Mint-Y\README.txt %OUTPUT_DIR%\themes\Mint-Y\
copy %SMPLAYER_SKINS_DIR%\themes\Mint-Y\main.css %OUTPUT_DIR%\themes\Mint-Y\

echo.
echo ######           MPlayer           #######
echo.
xcopy %MPLAYER_DIR% %OUTPUT_DIR%\mplayer\ /E
)

echo.
echo ######           MPV               #######
echo.
xcopy %MPV_DIR% %OUTPUT_DIR%\mpv\ /E

echo.
