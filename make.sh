#!/usr/bin/env bash

version="$(git describe --tags)"

workdir="$(cd "$(dirname "$0")" && pwd)"

base_dir="$workdir/build"

if [ -z "$GOOS" ]; then
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
  if [ -z "$GOARCH" ]; then
    export GOARCH=amd64
  fi
  build_dir="$base_dir/lmu-ruijie-login-$GOOS-$GOARCH"
  platform="$GOOS"
fi

mkdir -p "$build_dir"

exec_path="$build_dir/lmu-ruijie-login"

if [[ "$platform" == "windows" ]]; then
  exec_path="$exec_path.exe"
fi

go build -ldflags "-s -w -X main._VERSION_=$version" -o "$exec_path"

echo "Out: $build_dir"

config="$build_dir/config.ini"
if [ -z $is_local ] || [ ! -e "$config" ]; then
  cp "$workdir/config-sample.ini" "$config"
fi

case "$platform" in
windows | darwin | linux )
  cp "$workdir/scripts/$platform/"* "$build_dir"
  ;;
esac
