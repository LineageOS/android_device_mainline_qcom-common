# New device on a supported SoC

**TL;DR:** pick the SoC with `TARGET_QCOM_SOC`, inherit the family
tree, and supply only what is device specific: names, DTBs, firmware,
DSP data. `qcom-common` does the rest.

For the generic parts of a device tree, see the common
[skeleton](../../common/docs/DEVICE_TREE_SKELETON.md).

## What you set

| Item | Where | Notes |
|------|-------|-------|
| SoC | `TARGET_QCOM_SOC` (or `TARGET_QCOM_SOC_FAMILY`) in `device.mk` | Resolved to a family in `optional/options.mk`. Unknown names are an error |
| Hardware name | `androidboot.hardware=<device>` in the cmdline | Selects `fstab.<name>` and the device `init.<name>.rc` |
| DTBs | `TARGET_DTB_LIST_WILDCARD` | Limits the DTBs of a shared SoC kernel to your device(s) |
| Firmware | The device `firmware/` | See [FIRMWARE.md](FIRMWARE.md) |
| DSP data | `/vendor/etc/hexagonrpcd-root/` | See [DSP_AND_SENSORS.md](DSP_AND_SENSORS.md) |
| Audio profile | `TARGET_AUDIO_MAINLINE_UCM_PROFILES` | The UCM profile of the board's codec setup |
| Remoteproc start | `trigger start_all_remoteproc` in the device `init.<name>.rc` | See [REMOTEPROCS.md](REMOTEPROCS.md) |
| Firmware partitions | fstab entries | Notably `/vendor/firmware_mnt` and `/vendor/dsp` |

## What `qcom-common` gives you

### Board

| Item | Value |
|------|-------|
| `TARGET_BOARD_PLATFORM` | `qcom` |
| CPU and ABI | From `soc/<family>/board.mk`, with 32-bit and 64-bit variants |
| Boot device | `androidboot.boot_devices` for the family's storage controller (`MAINLINE_QCOM_SOC_ANDROIDBOOT_PARAMS`) |
| Serial console | `console=ttyMSM0,115200n8` (`MAINLINE_QCOM_KERNEL_PARAMS`) |
| Flash block size | `BOARD_FLASH_BLOCK_SIZE` per family |
| `/firmware` | Symlink to `/vendor/firmware_mnt` |
| Graphics | Mesa `freedreno`; see [GRAPHICS.md](GRAPHICS.md) |
| minigbm platform | `msm` |
| Recovery pixel format | `RGBX_8888` |
| Time | `TimeKeep` package and its sepolicy |
| Properties | `ro.soc.manufacturer`, `ro.vendor.qcom.soc.family`, Bluetooth profile defaults |

### Init

`init.mainline.qcom.rc` is imported by the device init. It provides:

| Piece | What |
|-------|------|
| `/dev/block/bootdevice` | Symlinks to `by-name` and the boot device |
| `init.mainline.qcom.sh` | Reads `/sys/devices/soc0/{family,machine,revision,soc_id}` into `vendor.qcom.soc.*`; sets `ro.soc.model` |
| Persist | Overlayfs on `/mnt/vendor/persist` with its layers in `/mnt/vendor` |
| Modem services | Started when `ro.vendor.qcom.soc.enable_modem_services=1` ([MODEM_STACK.md](MODEM_STACK.md)) |
| `qseecomd` | Started at `post-fs`, see [QSEECOM.md](QSEECOM.md) |
| Remoteproc | `start_all_remoteproc` trigger and `vendor.remoteproc.trigger_start` |
| USB | Controller property forwarding, `init.qcom.usb.rc` |
| SoC specific | `init.mainline.qcom.<family>.rc` from `soc/<family>/init/` |

### Command line variables

Compose your cmdline from these (the rule for `BOARD_BOOTCONFIG` versus
the command line is in the
[common boot page](../../common/docs/BOOT_AND_PARTITIONS.md)):

| Variable | Content |
|----------|---------|
| `MAINLINE_COMMON_ANDROIDBOOT_PARAMS`, `MAINLINE_COMMON_KERNEL_PARAMS` | From `mainline/common` |
| `MAINLINE_QCOM_SOC_ANDROIDBOOT_PARAMS` | Boot device of the family |
| `MAINLINE_QCOM_SOC_KERNEL_PARAMS` | Per-family kernel parameters (for example `clk_ignore_unused`) |
| `MAINLINE_QCOM_KERNEL_PARAMS` | The serial console |

## Options added by this tree

See `optional/README.md`: boot control (`qcom-caf-aidl`) and the QTI
USB HAL, USB gadget HAL and USB init script.

## SELinux

The method is in the common [SEPOLICY](../../common/docs/SEPOLICY.md)
page. Where Qualcomm rules go:

| The rule is about | Put it in |
|-------------------|-----------|
| One SoC family | `soc/<family>/sepolicy/vendor` |
| Any Qualcomm device | `sepolicy/vendor` in this repo (`rmtfs`, `tqftpserv`, `pd-mapper`, `qrtr`, `hexagonrpcd`, ...) |
| One device | The device tree |

## Qualcomm checks

- [ ] `ro.vendor.qcom.soc.family` is set to the expected family
- [ ] `/sys/class/remoteproc/*/state` is `running` for the DSPs you need
- [ ] `/dev/fastrpc-adsp` exists, and `hexagonrpcd` is running
- [ ] With modem services on: `pd-mapper`, `tqftpserv`, `rmtfs` are running
- [ ] Storage is found under the `boot_devices` path in the kernel log
