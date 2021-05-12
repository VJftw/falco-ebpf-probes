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

BUILD_ID=""
if [ -v VERSION ]; then
    BUILD_ID="$VERSION"
elif [ -v 1 ]; then
    BUILD_ID="$1"
else
    util::error "VERSION not given"
    exit 1;
fi


# /etc/os-release
mkdir -p "/host/etc"
cat <<EOF | tee "/host/etc/os-release" >/dev/null
NAME="Container-Optimized OS"
KERNEL_COMMIT_ID=91ad9955f2152c8ac3f4cfc94a934033cff8ced7
GOOGLE_CRASH_ID=Lakitu
VERSION_ID=77
BUG_REPORT_URL="https://cloud.google.com/container-optimized-os/docs/resources/support-policy#contact_us"
PRETTY_NAME="Container-Optimized OS from Google"
VERSION=77
GOOGLE_METRICS_PRODUCT_ID=26
HOME_URL="https://cloud.google.com/container-optimized-os/docs"
ID=cos
BUILD_ID=${BUILD_ID}
EOF

util::success "configured cos ${BUILD_ID}"

# /host/lib/modules/{KERNEL_RELEASE}
mkdir -p "/tmp/cos-kernel-headers/${BUILD_ID}"
curl --fail \
    -L "https://storage.googleapis.com/cos-tools/${BUILD_ID}/kernel-headers.tgz" \
    -o "/tmp/cos-kernel-headers/${BUILD_ID}.tgz"
util::success "Downloaded kernel headers for ${BUILD_ID}"
# Extract kernel headers
tar -xzf "/tmp/cos-kernel-headers/${BUILD_ID}.tgz" --directory "/tmp/cos-kernel-headers/${BUILD_ID}"
util::success "Extracted kernel headers for ${BUILD_ID}"

# Find the base of the kernel headers directory, it gets extracted as /usr/src/...
export KERNELHEADERSDIR="$(find "/tmp/cos-kernel-headers/${BUILD_ID}" -type d -name 'linux-headers-*')"
# Determine the Kernel Release from the headers

export KERNEL_RELEASE="$(cd "$KERNELHEADERSDIR" && make kernelrelease)"
util::info "cos build ${BUILD_ID} uses kernel ${KERNEL_RELEASE}"
if [ -z "${KERNEL_RELEASE}" ]; then
    util::error "could not determine kernel release"
    export KERNEL_RELEASE="0.0"
fi

# /host/lib/modules/KERNEL_RELEASE
mkdir -p "/host/lib/modules"
echo "${KERNEL_RELEASE}" > "/host/lib/modules/KERNEL_RELEASE"

if util::verlte "$KERNEL_RELEASE" "4.19"; then
  util::warn "$KERNEL_RELEASE does not meet the minimum (4.19)"
  exit 0
fi

echo "1" | sed 's/#\([[:digit:]]\+\).*/\1/' > "/host/lib/modules/KERNEL_VERSION"
# Copy the kernel headers into a place where falco looks for them
mkdir -p "/host/lib/modules/${KERNEL_RELEASE}"
cp -a ${KERNELHEADERSDIR}/. "/host/lib/modules/${KERNEL_RELEASE}"
# Use the .config from the kernel headers as the kernelconfig
cp "/host/lib/modules/${KERNEL_RELEASE}/.config" "/host/lib/modules/${KERNEL_RELEASE}/config"

util::success "Prepared sources for cos ${BUILD_ID}"
