#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://download.docker.com"
TOOL_NAME="docker-client"
TOOL_TEST="docker --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_all_versions() {
  curl "${curl_opts[@]}" "${GH_REPO}/linux/static/stable/x86_64/" |
    grep -o 'docker-[0-9]*\.[0-9]*\.[0-9]*\.tgz' |
    sed 's/docker-\(.*\)\.tgz/\1/'
}

get_platform() {
  local platform
  platform=$(uname -s | tr '[:upper:]' '[:lower:]')
  case $platform in
    darwin)
      echo "linux"  # Use Linux binaries for macOS
      ;;
    linux)
      echo "linux"
      ;;
    *)
      fail "Platform $platform is not supported"
      ;;
  esac
}

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
      fail "Architecture $arch is not supported"
      ;;
  esac
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  local platform arch
  platform="$(get_platform)"
  arch="$(get_arch)"
  url="${GH_REPO}/${platform}/static/stable/${arch}/docker-${version}.tgz"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH/docker/docker" "$install_path"
    chmod +x "$install_path/docker"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
