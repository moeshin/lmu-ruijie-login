@echo off

chcp 65001 >nul
set dir=%~dp0

where nssma >nul 2>&1
if "%errorLevel%" neq "0" (
    echo 需要 NSSM https://nssm.cc/download
    goto :EOF
)

net session >nul 2>&1
if "%errorLevel%" neq "0" (
    echo 需要管理员权限
    goto :EOF
)

set name=lum-ruijie
nssm install "%name%" "%dir%login.exe" ping
nssm set %name% AppStdout "%dir%log.txt"
nssm set %name% AppStdoutCreationDisposition 2
nssm set %name% Description "黎明大学-锐捷自动登录"
nssm set %name% DisplayName LMU-RuiJie
