# falco-ebpf-probes

**Currently**: Messy, but functional eBPF probe building for arbitrary AMI IDs from the following:
* GCP GKE (`cos` [Container-OS](https://cloud.google.com/container-optimized-os/docs)) nodes
* AWS EKS (`amazonlinux2` (https://aws.amazon.com/amazon-linux-2/)) nodes

# GCP GKE

* Pick COS versions from: https://cloud.google.com/kubernetes-engine/docs/release-notes#current_versions


# AWS EKS

* Pick Amazon Linux 2 versions from: https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
* Pick Ubuntu from: https://cloud-images.ubuntu.com/aws-eks/


# Usage
1. `./pleasew run --include packer-artefact //...`
2. eBPF probes are copied into into `plz-out/<csp>/<ami>/`

## Future

* Push eBPF probes into repository
* Associate more metadata with eBPF probes to enable us to find the right probe with less information. (e.g. for managed node-pool upgrades, do we know the new AMI ID beforehand? What do we know before we cycle instances.)
