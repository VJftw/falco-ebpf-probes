#/bin/sh -e

# From https://docs.sysdig.com/en/kernel-header-troubleshooting.html#UUID-f119625c-cab0-3eda-b954-8eae5fb33cdf_UUID-c3ad4c77-aa6c-169e-a725-003093cb8603
if command -v yum; then
    sudo yum -y install kernel-devel-$(uname -r)
fi

if command -v apt-get; then
    sudo apt-get -y install linux-headers-$(uname -r)
fi

docker run --rm \
    --privileged \
    -e FALCO_BPF_PROBE="" \
    -v "/tmp/$SOURCE_IMAGE":/root/.falco \
    -v /proc:/host/proc:ro \
    -v /boot:/host/boot:ro \
    -v /lib/modules:/host/lib/modules:ro \
    -v /usr:/host/usr:ro \
    -v /etc:/host/etc:ro \
    falcosecurity/falco-driver-loader:latest \
    --compile

rm -f "/tmp/$SOURCE_IMAGE"/falco-bpf.o
