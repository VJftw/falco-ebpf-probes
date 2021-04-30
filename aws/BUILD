subinclude("//build/defs:packer")

amis = [
    "ami-070520b50c0b5b708", # eks/optimized-ami/1.19/amazon-linux-2
    "ami-0e2b2aab71c3e6e06", # eks/optimized-ami/1.16/amazon-linux-2
    "ami-08abbe918497a02f9", # ubuntu/20210426/1.19
]

for ami in amis:
    packer_artefact(
        name = ami,
        template = "aws.json",
        deps = [
            "//scripts:falco-driver-installer-docker",
        ],
        vars = {
            "source_ami": ami,
        },
    )
