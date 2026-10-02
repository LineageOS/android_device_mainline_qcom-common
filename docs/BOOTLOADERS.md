# Bootloaders

**TL;DR:** Follow how the device's Linux port boots it. For Qualcomm
that usually means lk2nd, or U-Boot in the boot partition.
The boot image rules come from what the bootloader supports.

| Bootloader | Example | Boot image |
|------------|---------|------------|
| lk2nd | `mi89xx-mainline` | Android boot image header v2, with lk2nd in front of it |
| U-Boot, then GRUB | `mi7150-mainline` | Header v4; its specification depends on what GRUB supports |
| Stock bootloader | Possible | Depends on the kernel porter's choices; follow the Linux port |

## lk2nd

lk2nd is a secondary bootloader that runs on top of the stock one and
can boot a mainline kernel.

| Item | Detail |
|------|--------|
| Source | `external/lk2nd` |
| Build | `m lk2nd`; produces `lk2nd.img`. Needs `TARGET_LK2ND_PLATFORM` |
| Build flags | `TARGET_LK2ND_MAKE_FLAGS`, for example `OSVERSION_IN_BOOTIMAGE=1`, `ANDROID_USES_RECOVERY_AS_BOOT=1` |
| Prebuilt | If `external/lk2nd` is absent, the device's `prebuilts/lk2nd-<platform>.img` is used |
| Command line | `lk2nd.*` parameters (for example `lk2nd.pass-simplefb`, `lk2nd.pass-ramoops`) are normally only used by lk2nd itself, to decide what it does or passes on. The kernel does not need them |
| Build task | `build/tasks/lk2nd.mk` in this tree |

### Boot image layout

The boot partition holds `lk2nd.img`, padded with zeros up to
`TARGET_LK2ND_ACTUAL_BOOTIMG_OFFSET`, followed by the normal Android
boot image. The device's `mkbootimg.mk` does this
(`build-lk2nd-boot-image`) and fails the build if lk2nd does not fit
in the gap.

| Variable | Meaning |
|----------|---------|
| `TARGET_LK2ND_ACTUAL_BOOTIMG_OFFSET` | Where the Android image starts. Default `524288` in `qcom-common` |

The offset follows lk2nd's current behavior. It usually does not need
to be set per device; change it only if lk2nd itself changes.

A device with lk2nd typically also sets:

| Setting | Why |
|---------|-----|
| `BOARD_BOOT_HEADER_VERSION := 2` | The header version lk2nd handles |
| `BOARD_CUSTOM_BOOTIMG` and `BOARD_CUSTOM_BOOTIMG_MK` | Use the device's `mkbootimg.mk` |
| `BOARD_INCLUDE_DTB_IN_BOOTIMG := true` | Put the DTBs into the boot image |
| `BOARD_USES_RECOVERY_AS_BOOT := true` with the lk2nd flag `ANDROID_USES_RECOVERY_AS_BOOT=1` | The boot image is built from the recovery image (`daisy_mainline`, `tissot_mainline`) |

Because header v2 cannot carry bootconfig, a device like this puts
all `androidboot.*` parameters in `BOARD_KERNEL_CMDLINE`.

## U-Boot and GRUB

`mi7150-mainline` flashes a U-Boot build to the `boot` partition. U-Boot
runs GRUB, and GRUB loads the Android boot image. The boot image
specification therefore follows GRUB's support, with header v4
(`BOARD_BOOT_HEADER_VERSION := 4`), which allows `BOARD_BOOTCONFIG`.

| Item | Detail |
|------|--------|
| U-Boot builds | Per SoC community (see the device README) |
| Before flashing | Erase `dtbo`; the device README lists the exact steps |
| `fastboot-info.txt` | `TARGET_BOARD_FASTBOOT_INFO_FILE` |

## Device README

Everything a user must do before flashing belongs in the device
README (see the common
[README template](../../common/docs/DEVICE_README_TEMPLATE.md)):
the bootloader build, `dtbo` and `vbmeta` steps, partition notes.
