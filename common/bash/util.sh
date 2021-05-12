#!/bin/bash
deps="$(dirname $0)"
source "$deps/third_party/bash/ansi"

set -Eeuo pipefail

function cleanup {
  set +x
}

trap cleanup EXIT

clear_remainder="\033[0K"

util::info() {
    printf "$(ansi::resetColor)$(ansi::magentaIntense)💡 %s$(ansi::resetColor)\n" "$@"
}

util::warn() {
  printf "$(ansi::resetColor)$(ansi::yellowIntense)⚠️  %s$(ansi::resetColor)\n" "$@"
}

util::error() {
  printf "$(ansi::resetColor)$(ansi::bold)$(ansi::redIntense)❌ %s$(ansi::resetColor)\n" "$@"
}

util::success() {
  printf "$(ansi::resetColor)$(ansi::greenIntense)✅ %s$(ansi::resetColor)\n" "$@"
}

util::retry() {
  "${@}" || sleep 1; "${@}" || sleep 5; "${@}"
}

util::verlte() {
    [  "$1" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}

util::verlt() {
    [ "$1" = "$2" ] && return 1 || util::verlte $1 $2
}
