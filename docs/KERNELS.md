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

There is no common configuration scheme between the community
kernels. Each fork organizes its configs its own way: some ship a
`defconfig` plus per-SoC fragments, others rely on the config a
distribution maintains. **Look at how the existing Linux distributions
build the kernel for your device** (postmarketOS, for the devices
here), and do the same, then add the Android configuration as in the
common [kernel page](../../common/docs/KERNEL.md).

What the reference devices do, as examples only:

| Device tree | Kernel | Config |
|-------------|--------|--------|
| `mi7150-mainline` | `sm7150-mainline` | `defconfig`, `efi.config`, `sm7150.config` (shipped by the fork), then the Android fragments |
| `mi710-mainline` | `sdm670-mainline` | `defconfig`, `sdm670.config`, then the Android fragments |
| `mi8953_a` (default) | `msm8953-mainline` | A postmarketOS derived config and `basic.config`, then the Android fragments |
| `mi8953_a` with `MI8953_USE_ANDROID_COMMON_KERNEL=true` | `kernel/xiaomi/mi8953-ack` | `gki_defconfig` and `mi8953.config`; the ACK route needs no Android fragments |

Keep the distribution config in the device tree (`kconfigs/`) when the
fork does not ship what you need, so that it can be reviewed and
updated with the kernel.

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
