# Modem and IPC stack

The modem and the other cores talk to Linux over QRTR (Qualcomm IPC
Router). A set of small daemons answers their requests. This page
describes the daemons and how `qcom-common` runs them. (QSEECOM is a
different interface: see [QSEECOM.md](QSEECOM.md).) The sources are
in `hardware/mainline/qcom/`.

**TL;DR:** set `ro.vendor.qcom.soc.enable_modem_services=1` (the SoC
`product.mk` does, once tested) and `qcom-common` starts `qrtr-cfg`, `pd-mapper`,
`tqftpserv` and `rmtfs` at `boot`.

## Daemons

| Service | Binary | What it does |
|---------|--------|--------------|
| `qrtr-cfg` | `/vendor/bin/qrtr-cfg` | Sets the QRTR node id. Run once as `exec` (`qrtr-cfg 1`) |
| `vendor.pd-mapper` | `/vendor/bin/pd-mapper` | Protection domain mapper: tells the remote cores which services run on which domain |
| `vendor.tqftpserv` | `/vendor/bin/tqftpserv` | TFTP server over QRTR: serves firmware and temp files to the remote cores |
| `vendor.rmtfs` | `/vendor/bin/rmtfs -o /dev/block/by-name -P -r -s` | Remote filesystem: gives the modem access to its raw storage partitions (EFS) |

All run in class `core` as `root`, group `system`, and log to the
kernel log. `pd-mapper`, `tqftpserv` and `rmtfs` are started on `boot`
when `ro.vendor.qcom.soc.enable_modem_services=1`, and `rmtfs` is
stopped on `shutdown`.

## Start sequence

On `boot`, if the property is `1`:

1. `qrtr-cfg 1`
2. `start vendor.pd-mapper`
3. Create the `tqftpserv` directories in `/data/vendor`
4. `write /sys/class/firmware/timeout 1`
5. `start vendor.tqftpserv`
6. `start vendor.rmtfs`

The firmware loader's sysfs fallback timeout is set to 1 second.

## `rmtfs` options

| Option | Meaning |
|--------|---------|
| `-o <dir>` | With `-P`: the directory where raw EFS partitions are found by name |
| `-P` | Use raw EFS partitions instead of image files |
| `-r` | Read-only: never write to storage |
| `-s` | Also sync with the modem remoteproc instance |

The command line in `rmtfs.rc` uses all of them: the partitions are
used by name and are not written.

## `tqftpserv` paths

| Request prefix | Android path |
|----------------|--------------|
| `/readonly/firmware/image/` | Translated against `/vendor/firmware/`, taking the remoteproc `firmware-name` into account (also handles `.zst`) |
| `/readwrite/` | `/data/vendor/tmp/tqftpserv` |

The init rc creates these directories under `/data/vendor`:
`tmp/tqftpserv`, `readonly/firmware/image`, `readwrite`.
Where the firmware goes: [FIRMWARE.md](FIRMWARE.md).

## Properties and files

| Item | Meaning |
|------|---------|
| `ro.vendor.qcom.soc.enable_modem_services` | `1` to run the stack; set by the SoC `product.mk` |
| `ro.vendor.qcom.soc.family` | Family, set from `TARGET_QCOM_SOC_FAMILY` |
| `/dev/qcom_rmtfs_mem*` | rmtfs shared memory, label `rmtfs_device` |
| `/dev/fastrpc-*` | FastRPC nodes, `0600 system system` |

SELinux: `rmtfs.te`, `tqftpserv.te`, `pd_mapper.te`, `qrtr.te` and
`file_contexts` are under `sepolicy/vendor` of this tree.

## Enabling it for a SoC family

`soc/<family>/product.mk` sets `ro.vendor.qcom.soc.enable_modem_services`.
Add it for a family only after the modem stack has been tested on
hardware of that family. Today `msm8998` and `sm7150` have it.

## Not covered

The RIL and the telephony side live above this stack and are not part
of `qcom-common`.

## Troubleshooting

| Symptom | Check |
|---------|-------|
| Modem never comes up | [REMOTEPROCS.md](REMOTEPROCS.md): is the modem remoteproc `running`? |
| Repeated `tqftpserv` requests for missing files | The firmware layout in [FIRMWARE.md](FIRMWARE.md) |
| `rmtfs` exits | The raw EFS partitions exist under `/dev/block/by-name` |
| AVC denials for these daemons | The domains named above, in `sepolicy/vendor` |
