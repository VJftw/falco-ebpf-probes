#!/bin/bash

deps="$(dirname $0)"
source "$deps/common/bash/util.sh"

set -euo pipefail

KERNEL_RELEASE="$(</host/lib/modules/KERNEL_RELEASE)"
if util::verlt "$KERNEL_RELEASE" "4.14"; then
  util::error "$KERNEL_RELEASE does not meet the minimum requirement (4.14)"
  exit 0
fi
KERNEL_VERSION="$(</host/lib/modules/KERNEL_VERSION)"
util::success "Kernel Release: ${KERNEL_RELEASE}"
util::success "Kernel Version: ${KERNEL_VERSION}"

export KERNEL_RELEASE
export KERNEL_VERSION

export KERNELDIR="/lib/modules/${KERNEL_RELEASE}/build"

# Remove Falco's discovery of Kernel release and version as we want to build for non-current targets
sed -i '/^KERNEL_RELEASE=/d' /usr/bin/falco-driver-loader
sed -i '/^KERNEL_VERSION=/d' /usr/bin/falco-driver-loader

# Build eBPF probe
export FALCO_BPF_PROBE=""

# Compile eBPF probe
util::info "Building eBPF Probe for ${KERNEL_RELEASE}_${KERNEL_VERSION}"
/docker-entrypoint.sh --compile
util::success "Built eBPF Probe for ${KERNEL_RELEASE}_${KERNEL_VERSION}"

# Copy eBPF probe to out
built_ebpf_probe=$(find /root/.falco -type f -name "*.o" ! -name "falco-bpf.o")
cp "${built_ebpf_probe}" "/tmp/falco/probes/"
util::success "Copied ${built_ebpf_probe} eBPF probe to out"
