# Kernels

**TL;DR:** for most Qualcomm SoCs the kernel is a community fork of
`torvalds/linux`. A few devices can instead use an Android Common
Kernel (ACK) with `gki_defconfig`, which is the easier route when it
works.

The generic kernel build rules are in the common
[kernel page](../../common/docs/KERNEL.md) and
[patches page](../../common/docs/KERNEL_PATCHES.md).

## Community kernels

Synced through `conditional/kernel` of the mainline `local_manifests`.
Each is hardware enablement for one SoC group on top of mainline, and
usually knows nothing about Android.

| Path | SoC group |
|------|-----------|
| `kernel/mainline/msm8916-mainline` | MSM8916 family |
| `kernel/mainline/msm89x7-mainline` | MSM8917, MSM8937 and similar |
| `kernel/mainline/msm8953-mainline` | MSM8953 and SDM450/632 |
| `kernel/mainline/msm8956-mainline` | MSM8956 / 8976 |
| `kernel/mainline/msm8998-mainline` | MSM8998 |
| `kernel/mainline/sdm670-mainline` | SDM670 / SDM710 |
| `kernel/mainline/sm7150-mainline` | SM7150 |

The branch each device uses is in the device README ("Additional
repositories required to build"). Branches move often, so they are not
repeated here.

## Config

| Approach | `TARGET_KERNEL_CONFIG` | `TARGET_KERNEL_CONFIG_EXT` |
|----------|------------------------|----------------------------|
| Community kernel | `defconfig`, then the SoC fragment the fork ships (`sm7150.config`, `sdm670.config`) and optionally `efi.config` | The Android fragments from `kernel/configs` and `kernel/mainline/configs`, then the device fixups |
| ACK | `gki_defconfig` and one device fragment (`mi8953.config`) | Not needed |

`mi8953_a` supports both, switched by `MI8953_USE_ANDROID_COMMON_KERNEL`:

| `MI8953_USE_ANDROID_COMMON_KERNEL` | Kernel | Config |
|------------------------------------|--------|--------|
| not set | `kernel/mainline/msm8953-mainline` | A postmarketOS derived config, `basic.config`, then the Android fragments |
| `true` | `kernel/xiaomi/mi8953-ack` | `gki_defconfig` + `mi8953.config` |

For a community kernel, start from the config that the distributions
use for the device (postmarketOS, in the examples above), as the
common guide recommends.

## Modules

Qualcomm devices load many modules (clocks, interconnect, regulators,
remoteproc, display panels). The lists used by the reference devices:

| File | Content |
|------|---------|
| `modules.load.basic` | Needed early: storage, serial console, display basics and the clock, power and bus drivers they depend on |
| `modules.load.drm`, `modules.load.panel.*`, `modules.load.touchscreen` | Display stack, panel and touch drivers of the device |
| `modules.load.normal` | Everything else, loaded after `post-fs` |
| `modules.blocklist` | Never load |

`modules.load.basic` must include the serial console modules and
whatever they need, such as clock and pinctrl providers. Without them
stage 2 of the bringup has no log.

## Kernel command line

`console=ttyMSM0,115200n8` comes with `MAINLINE_QCOM_KERNEL_PARAMS`;
the SoC families add their own boot device and parameters. See
[NEW_DEVICE.md](NEW_DEVICE.md).
