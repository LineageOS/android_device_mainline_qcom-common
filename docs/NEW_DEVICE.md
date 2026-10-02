# New Qualcomm device on a supported SoC

**TL;DR:** Pick a family tree (or make one), add a thin per-device
directory, and set `TARGET_QCOM_SOC`.

## Layers

```
mainline/common            shared by every mainline device
  └─ mainline/qcom-common  Qualcomm: daemons, soc/<family>/
       └─ <vendor>/<soc>-mainline    family tree (kernel, partitions)
            └─ <device>_mainline/    one device (fstab, firmware, init)
```

| Layer | Example | Holds |
|-------|---------|-------|
| `qcom-common` | `soc/sm7150/` | Arch, boot devices, SoC firmware, daemons |
| Family tree | `mi7150-mainline` | Kernel source and config, bootimage args, dynamic partitions, `libinit` |
| Device | `davinci_mainline` | `androidboot.hardware`, fstab, firmware, lunch targets, screen size |
| Thin device | `pyxis_mainline` | Inherits another family tree, only differences |

## Start from the existing Linux port

Find how Linux distributions that already support the device do it
(for example postmarketOS). Follow them for the kernel source and
config, DTB names, firmware list, and bootloader steps. Skip what only
works on GNU/Linux. The kernel configs of the family trees (`kconfigs/`)
come from such ports.

## Names

Qualcomm devices almost always have a downstream-kernel Android port,
so add the `mainline` suffix: family tree `<soc>-mainline`, device
`<device>_mainline` (for example `mi7150-mainline`, `pyxis_mainline`).

## Steps

| # | Do | Where |
|---|----|-------|
| 1 | Check the SoC is in `soc/` | `soc/README.md` |
| 2 | Choose or create the family tree | Copy `mi7150-mainline` |
| 3 | Set `TARGET_QCOM_SOC` (or `TARGET_QCOM_SOC_FAMILY`) in `device.mk` | `davinci_mainline/device.mk` |
| 4 | Set `androidboot.hardware=<device>` | Device `BoardConfig.mk` |
| 5 | Add DTBs: `TARGET_DTB_LIST_WILDCARD` | `pyxis_mainline/BoardConfig.mk` |
| 6 | Add fstab and init for the device | `fstab/`, `init/` |
| 7 | Get firmware | See below |
| 8 | Add lunch targets | `AndroidProducts.mk`, `aosp_*.mk`, `lineage_*.mk` |

## Per-device checklist

| Area | What to set |
|------|-------------|
| Boot | `androidboot.hardware`, `BOARD_BOOT_HEADER_VERSION`, bootimage partition size |
| Partitions | `BOARD_SUPER_PARTITION_*` sizes, cache, `TARGET_RECOVERY_FSTAB` |
| Display | `TARGET_SCREEN_WIDTH`, `TARGET_SCREEN_HEIGHT`, `TARGET_SCREEN_DENSITY` |
| OTA | `TARGET_OTA_ASSERT_DEVICE` |
| Audio | `TARGET_AUDIO_MAINLINE_UCM_PROFILES` for the device's sound card |
| Firmware | Device `firmware/` and `PRODUCT_PACKAGES` entries |

## Firmware and remote processors

| Piece | Source |
|-------|--------|
| Common firmware (GPU, Wi-Fi) | `PRODUCT_PACKAGES` from `external/linux-firmware-mainline`, see `soc/*/product.mk` |
| Device firmware (modem, DSP, IPA) | Borrow from the downstream `vendor/` tree of the device; install under `/odm/firmware/` (or `/vendor/firmware/`) |
| `/vendor/firmware_mnt` | Mountpoint of the device's **firmware partition**. Never install files into it |
| Starting remoteprocs | `init.mainline.qcom.start_remoteproc.sh`, trigger `start_all_remoteproc` |
| Daemons | `rmtfs`, `tqftpserv`, `pd-mapper`, `qrtr-cfg` (from `hardware/mainline/qcom`) |
| ADSP audio and sensors | `hexagonrpcd` with files in `/vendor/etc/hexagonrpcd-root/` |

Do not commit firmware you may not redistribute. For extracting files
from a vendor tree, see `tools/extract-utils` at the LineageOS root.

## Boot and kernel

| Topic | Qualcomm specifics |
|-------|--------------------|
| Bootloader | Follow the Linux port of the device. Some stock bootloaders can boot mainline, it depends on the kernel porter's choices. Others need U-Boot or lk2nd (`external/lk2nd`). Steps go in the device README |
| Boot image | Depends on what the bootloader supports. `mi7150-mainline` has U-Boot in the `boot` partition, which uses GRUB to load the boot image, so its boot header version follows GRUB support |
| lk2nd offset differs | `TARGET_LK2ND_ACTUAL_BOOTIMG_OFFSET` |
| Needs a vbmeta or dtbo step | Put it in the device README (e.g. erase `dtbo`) |
| Kernel cmdline | Start from `$(MAINLINE_COMMON_KERNEL_PARAMS) $(MAINLINE_QCOM_KERNEL_PARAMS)`; the latter has the serial console (`console=ttyMSM0,115200n8`) |
| Boot params | `$(MAINLINE_COMMON_ANDROIDBOOT_PARAMS) $(MAINLINE_QCOM_SOC_ANDROIDBOOT_PARAMS)` in `BOARD_BOOTCONFIG` |
| Partitions | Dynamic partitions with a `super` group, see `mi7150-mainline` |
| Boot control (A/B) | With `AB_OTA_UPDATER`, `TARGET_BOOT_HAL` defaults to `qcom-caf-aidl` |
| firmware dirs | `firmware_directories` in `ueventd.<device>.rc` can list the mounted firmware partition (read only use) and `/odm/firmware/` |

## Options added by this tree

See `optional/README.md`: boot control (`qcom-caf-aidl`), USB HAL, USB
gadget HAL and USB init script from QTI. The generic rules for picking
options apply: mainline by default, generic for bringup, mature to
finish (`device/mainline/common/docs/CHOOSING_OPTIONAL_MODULES.md`).

## SELinux

| The rule is about | Put it in |
|-------------------|-----------|
| One SoC family | `soc/<family>/sepolicy/vendor` |
| Qualcomm devices in general | `sepolicy/` in this repo |
| One device | The device tree |

## Check

- [ ] `TARGET_QCOM_SOC` resolves to a family (no `$(error ...)`)
- [ ] Kernel log shows UFS/eMMC probed under the `boot_devices` path
- [ ] `rmtfs` and `pd-mapper` start (see `logcat` / `dmesg`)
