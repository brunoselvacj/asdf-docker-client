#!/usr/bin/env bash

get_arch() {
  local arch
  arch=$(uname -m)
  case $arch in
    x86_64)
      echo "x86_64"
      ;;
    arm64|aarch64)
      echo "aarch64"
      ;;
    *)
      echo "Architecture $arch is not supported" >&2
      exit 1
      ;;
  esac
}

get_platform() {
  local platform
  platform=$(uname -s | tr '[:upper:]' '[:lower:]')
  case $platform in
    darwin)
      echo "mac"
      ;;
    linux)
      echo "linux"
      ;;
    *)
      echo "Platform $platform is not supported" >&2
      exit 1
      ;;
  esac
}
