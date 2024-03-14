@echo off

set DIR=packages

git clone --depth=1 https://github.com/smplayer-dev/smplayer.git %DIR%\smplayer
git clone --depth=1 https://github.com/smplayer-dev/smplayer.git %DIR%\smplayer-portable

git clone --depth=1 https://github.com/smplayer-dev/smplayer-themes.git %DIR%\smplayer-themes
git clone --depth=1 https://github.com/smplayer-dev/smplayer-skins.git %DIR%\smplayer-skins
