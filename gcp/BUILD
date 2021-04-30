subinclude("//build/defs:packer")

cos_versions = [
    "cos-81-12871-1245-7",
    "cos-85-13310-1209-7",
    "cos-85-13310-1209-12",
]

for cos_version in cos_versions:
    packer_artefact(
        name = cos_version,
        template = "gcp.json",
        deps = [
            "//scripts:falco-driver-installer-docker",
        ],
        vars = {
            "gcp_project_id": "vjftw-images",
            "source_image": cos_version,
        },
    )
