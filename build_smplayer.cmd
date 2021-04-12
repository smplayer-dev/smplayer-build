@echo off

set build_portable=false
if [%1]==[pe] (
  set build_portable=true
)

rem call update
call compile_smplayer.cmd %1
call install %1

if [%build_portable%]==[true] (
  call create_portable_package.cmd
) else (
  call nsis.cmd
)
