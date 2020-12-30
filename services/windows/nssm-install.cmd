@echo off

chcp 65001 >nul
set dir=%~dp0

where nssm >nul 2>&1
if "%errorLevel%" neq "0" (
    echo 需要 NSSM https://nssm.cc/download
    goto :EOF
)

net session >nul 2>&1
if "%errorLevel%" neq "0" (
    echo 需要管理员权限
    goto :EOF
)

set name=lmu-ruijie
nssm install "%name%" "%dir%login.exe" ping

nssm "set" "%name%" DisplayName "LMU RuiJie"
nssm "set" "%name%" Description "黎明大学-锐捷自动登录"

nssm "set" "%name%" AppStdout "%dir%log.txt"
nssm "set" "%name%" AppStderr "%dir%log.txt"

nssm "set" "%name%" AppExit Default Exit
nssm "set" "%name%" AppThrottle 0

nssm "set" "%name%" DependOnService nsi
