#!/bin/bash
# 1) fetch-sources
# > outputs:
#   - /host/etc/os-release
#   - /host/lib/modules/{KERNEL_RELEASE}
#   - /host/lib/modules/KERNEL_RELEASE
#   - /host/lib/modules/KERNEL_VERSION TODO: determine correct kernel version

deps="$(dirname $0)"
source "$deps/common/bash/util.sh"

set -euo pipefail
KERNEL_RELEASE=""
if [ -v VERSION ]; then
    KERNEL_RELEASE="$VERSION"
elif [ -v 1 ]; then
    KERNEL_RELEASE="$1"
else
    echo "VERSION not given"
    exit 1;
fi

util::info "Installing kernel headers for ${KERNEL_RELEASE}"

yum -y install \
    kernel-devel-${KERNEL_RELEASE} \
    kernel=${KERNEL_RELEASE}

util::success "Installed kernel headers for ${KERNEL_RELEASE}"

cp -a /lib/modules/. /host/lib/modules/

util::success "Copied kernel headers for ${KERNEL_RELEASE}"

mkdir -p /host/lib/modules/${KERNEL_RELEASE}

find /usr/src/kernels -maxdepth 1 -mindepth 1 -type d -exec cp -a {} /host/lib/modules/${KERNEL_RELEASE}/build \;
cp /etc/os-release /host/etc/os-release

echo "${KERNEL_RELEASE}" > "/host/lib/modules/KERNEL_RELEASE"
echo "1" > "/host/lib/modules/KERNEL_VERSION"

util::success "Prepared sources for amazonlinux2 ${KERNEL_RELEASE}"
