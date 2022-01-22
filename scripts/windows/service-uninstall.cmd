@echo off

chcp 65001 >nul
set dir=%~dp0

where nssm >nul 2>&1
if "%errorLevel%" neq "0" (
    echo 需要 NSSM https://github.com/moeshin/nssm
    goto :EOF
)

net session >nul 2>&1
if "%errorLevel%" neq "0" (
    echo 需要管理员权限
    goto :EOF
)

set name=lmu-ruijie
nssm stop "%name%"
nssm remove "%name%" confirm
