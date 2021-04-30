FALCO_VERSION = "0.28.0"

remote_file(
    name = "falco-driver-loader",
    binary = True,
    url = f"https://raw.githubusercontent.com/falcosecurity/falco/{FALCO_VERSION}/scripts/falco-driver-loader",
    hashes = ["02c6bd85922f3bd6251708c6e2cf1b3e7b09b2e9757099baece8858d6f28e45e"],
    visibility = ["PUBLIC"],
)

PACKER_VERSION = "1.7.2"

remote_file(
    name = "packer",
    binary = True,
    extract = True,
    url = f"https://releases.hashicorp.com/packer/{PACKER_VERSION}/packer_{PACKER_VERSION}_{CONFIG.OS}_{CONFIG.ARCH}.zip",
    hashes = [],
    visibility = ["PUBLIC"],
)
