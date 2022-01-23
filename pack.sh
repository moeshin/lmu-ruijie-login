#!/usr/bin/env bash

workdir="$(cd "$(dirname "$0")" && pwd)"
make_script="$workdir/make.sh"
build_dir="$workdir/build"
export CGO_ENABLED=0

function make() {
  suffix=$GOOS-$GOARCH
  echo "======== Make $suffix"
  "$make_script"
  echo "======== Pack $suffix"
  name="lmu-ruijie-login-$suffix"
  source="$build_dir/$name"
  dest="$source.tar.gz"
  [ -f "$dest" ] && rm "$dest"
  tar -zcvf "$source.tar.gz" -C "$build_dir" "$name"
}

function pack() {
  export GOOS=$1
  shift
  if [ $# -eq 0 ]; then
    echo "======== Default GOARCH=amd64"
    export GOARCH=amd64
    make
  else
    for GOARCH in "$@"; do
      export GOARCH
      make
    done
  fi
}

pack windows 386 amd64 arm arm64
pack linux 386 amd64 arm arm64
pack darwin amd64 arm64
