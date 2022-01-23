#!/usr/bin/env bash

workdir="$(cd "$(dirname "$0")" && pwd)"
make="$workdir/make.sh"
build_dir="$workdir/build"

function pack() {
  echo "======== make $1"
  CGO_ENABLED=0 GOOS="$1" GOARCH=amd64 "$make"

  echo "======== pack $1"
  source="$build_dir/$1"
  dest="$build_dir/lmu-ruijie-login-for-$1.7z"
  [ -f "$dest" ] && rm "$dest"
  7z a "$dest" "$source"
  7z rn "$dest" "$1" "lmu-ruijie"
}

pack windows
pack darwin
pack linux
