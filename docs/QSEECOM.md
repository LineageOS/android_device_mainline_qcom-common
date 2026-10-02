# QSEECOM

QSEECOM is the interface to Qualcomm's trusted execution environment
(QSEE). Vendor blobs use it to load and talk to trusted applications,
for example the downstream hardware-backed keymaster and gatekeeper.
It is not part of the [modem stack](MODEM_STACK.md).

**TL;DR:** the kernel needs the QSEECOM driver, `qseecomd` runs from
the vendor tree, and `qcom-common` provides the device nodes and the
service. It is only needed for downstream blobs that talk to the TEE.

## What `qcom-common` provides

| Piece | Detail |
|-------|--------|
| Service | `vendor.qseecomd`, `/vendor/bin/qseecomd`, class `core`, user and group `root`, started at `post-fs` |
| `/dev/qseecom` | `0660 system drmrpc`, label `tee_device` |
| `/dev/dma_heap/qseecom` | `0444 system system` |
| `qseecomd` label | `tee_exec` |
| Binary | From the downstream vendor tree; not built here |

## What the device provides

| Item | Where |
|------|-------|
| Kernel driver | The device kernel config enables `CONFIG_QSEECOM` (and the dma-buf heaps) |
| Blobs | The vendor tree: `qseecomd` and the trusted applications it loads |
| Security HALs | `TARGET_SUPPORTS_HARDWARE_BACKED_SECURITY := true` when a hardware-backed keymaster and gatekeeper are used. Otherwise the common options use the software ones |

## Related

| Topic | Page |
|-------|------|
| Legacy ION and old blobs | [LEGACY_DOWNSTREAM.md](LEGACY_DOWNSTREAM.md) |
| The security HAL options | `device/mainline/common/optional/README.md` |
