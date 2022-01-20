#!/usr/bin/env bash

version='1.0.0'

workdir="$(cd "$(dirname "$0")" && pwd)"

base_dir="$workdir/build"

if [[ -z "$GOOS" ]]; then
  is_local=true
  build_dir="$base_dir/local"
  uname="$(uname)"
  case "$uname" in
  CYGWIN* | MINGW* | MSYS* | Windows* )
    platform='windows'
    ;;
  Darwin* )
    platform='darwin'
    ;;
  Linux* )
    if getprop >/dev/null 2>&1 && [ "$(getprop net.bt.name)" ==  'Android' ]; then
      platform='android'
    else
      platform='linux'
    fi
    ;;
  esac
else
  build_dir="$base_dir/$GOOS"
  platform="$GOOS"
fi

mkdir -p "$build_dir"

exec_path="$build_dir/login"

if [[ "$platform" == "windows" ]]; then
  exec_path="$exec_path.exe"
fi

go build -ldflags "-s -w -X main._VERSION_=$version" -o "$exec_path"

echo "输出文件夹: $build_dir"

config="$build_dir/config.ini"
if [ -z $is_local ] || [ ! -e "$config" ]; then
  cp "$workdir/config-sample.ini" "$config"
fi

case "$platform" in
windows | darwin | linux )
  cp "$workdir/services/$platform/"* "$build_dir"
  ;;
esac
