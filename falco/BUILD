subinclude ("//third_party/defs:docker")

docker_image(
    name = "driver-compiler",
    dockerfile = "driver-compiler.Dockerfile",
    visibility = ["PUBLIC"],
)

genrule(
    name = "probes",
    outs = ["probes"],
    cmd = "mkdir $OUTS",
    visibility = ["PUBLIC"],
)
