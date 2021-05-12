for build_def in glob(["**.build_defs"]):
    export_file(
        name = basename(build_def).split(".")[0],
        src = build_def,
        visibility = ["PUBLIC"],
    )

sh_binary(
    name = "build-falco-ebpf-probe",
    main = "build-falco-ebpf-probe.sh",
    deps = ["//common/bash:util"],
    visibility = ["PUBLIC"],
)
