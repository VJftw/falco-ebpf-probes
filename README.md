# falco-ebpf-probes

## Future

* Push eBPF probes into repository
* Associate more metadata with eBPF probes to enable us to find the right probe with less information. (e.g. for managed node-pool upgrades, do we know the new AMI ID beforehand? What do we know before we cycle instances.)


# eBPF Probe relationships to metadata

 * 1 eBPF Probe - 1 Driver Version + 1 TargetID + 1 Kernel Release + 1 Kernel Version 
 * 1 eBPF Probe -< Many AMIs

# eBPF Repository on GitHub
 
 * GitHub release (git tag) per Driver Version
 * Push Artefacts under their respective Driver Version (lots of versions)
