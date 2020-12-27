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
nssm remove "%name%" confirm
