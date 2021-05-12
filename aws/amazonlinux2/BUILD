subinclude("//build/defs:falco_ebpf_container")
subinclude ("//third_party/defs:docker")

docker_image(
    name = "fetch_sources_image",
    dockerfile = "fetch-sources.Dockerfile",
    visibility = [],
)

sh_binary(
    name = "fetch_sources",
    main = "fetch-sources.sh",
    deps = ["//common/bash:util"],
)

falco_ebpf_container_build(
    name = "amazonlinux2",
    fetch_sources_script = ":fetch_sources",
    fetch_sources_container = ":fetch_sources_image",
)

sh_cmd(
    name = "generate_targets_list",
    data = ["//third_party/binary:jq"],
    cmd = """
JQ_BIN=$(out_exe //third_party/binary:jq)
set -euo pipefail
versions=(\\\$(docker run --rm amazonlinux:2 yum --showduplicates list kernel-devel | tail -n+3 | awk '{ print \\\$2 }'))
echo "found \\\${#versions[@]} versions"
OUT="plz-out/github/targets/$PKG/$NAME.json"
rm -rf \\\$OUT
mkdir -p \\\$(dirname \\\$OUT)
echo "[]" > \\\$OUT
for v in "\\\${versions[@]}"; do
    jq ". |= . + [\\"//aws/amazonlinux2:amazonlinux2,\\\$v\\"]" \\\$OUT > \\\$OUT.new
    mv \\\$OUT.new \\\$OUT
done
    """,
    shell = "/bin/bash",
    labels = ["generate_targets_list"],
)

# kernel_releases=($(yum --showduplicates list kernel-devel | tail -n+3 | awk '{ $2 }'))
# sh_cmd(
#     name = "gen_versions",
#     data = [":versions"],
#     cmd = """
# set -euo pipefail
# versions=(\\\$(docker run --rm amazonlinux:2 yum --showduplicates list kernel-devel | tail -n+3 | awk '{ print \\\$2 }'))
# echo "found \\\${#versions[@]} versions"
# OUT="$(out_location :versions)"
# echo "versions = [" > \\\$OUT
# for v in "\\\${versions[@]}"; do
#     echo "  \\"\\\$v\\"," >> \\\$OUT
# done
# echo "]" >> \\\$OUT
#     """,
#     shell = "/bin/bash",
# )



# genrule(
#     name = "versions",
#     outs = ["versions"],
#     cmd = "echo versions = [] > $OUTS"
# )

# subinclude(":versions")
# for v in versions:
#     falco_ebpf_container_build(
#         name = "amazonlinux2",
#         fetch_sources_script = ":fetch_sources",
#         fetch_sources_container = ":fetch_sources_image",
#         version = v,
#     )
