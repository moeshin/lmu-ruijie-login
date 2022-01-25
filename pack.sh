#!/usr/bin/env bash

workdir="$(cd "$(dirname "$0")" && pwd)"
make_script="$workdir/make.sh"
build_dir="$workdir/build"
export CGO_ENABLED=0

function make() {
  suffix=$GOOS-$GOARCH
  echo "======== Make $suffix"
  "$make_script" || exit 1
  echo "======== Pack $suffix"
  name="lmu-ruijie-login-$suffix"
  source="$build_dir/$name"
  dest="$source.tar.gz"
  [ -f "$dest" ] && rm "$dest"
  tar -zcvf "$source.tar.gz" -C "$build_dir" "$name" || exit 1
}

function pack() {
  export GOOS=$1
  shift
  if [ $# -eq 0 ]; then
    echo "======== Default GOARCH=amd64"
    export GOARCH=amd64
    make || exit 1
  else
    for GOARCH in "$@"; do
      export GOARCH
      make || exit 1
    done
  fi
}

pack windows 386 amd64 arm arm64 || exit 1
pack linux 386 amd64 arm arm64 || exit 1
pack darwin amd64 arm64 || exit 1
