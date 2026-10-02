# Qualcomm bringup

Everything specific to Qualcomm SoCs. Generic topics (skeleton, kernel
build, partitions, optional modules, SELinux method, debugging) are in
the [common bringup guide](../../common/docs/README.md) and are not
repeated here.

## Pages

| Page | Read it when you need to... |
|------|------------------------------|
| [NEW_DEVICE.md](NEW_DEVICE.md) | Put a device on a supported SoC, and know what `qcom-common` gives you |
| [ADDING_A_SOC.md](ADDING_A_SOC.md) | Support a SoC that is not in `soc/` yet |
| [BOOTLOADERS.md](BOOTLOADERS.md) | Boot with lk2nd or U-Boot, and build the boot image for them |
| [KERNELS.md](KERNELS.md) | Pick a community kernel for the SoC family |
| [FIRMWARE.md](FIRMWARE.md) | Get remote processor firmware to where the kernel looks |
| [REMOTEPROCS.md](REMOTEPROCS.md) | Start DSPs and the modem, and tune them |
| [MODEM_STACK.md](MODEM_STACK.md) | Understand QRTR, `pd-mapper`, `tqftpserv`, `rmtfs`, `qseecomd` |
| [DSP_AND_SENSORS.md](DSP_AND_SENSORS.md) | Make ADSP audio and DSP sensors work |
| [LEGACY_DOWNSTREAM.md](LEGACY_DOWNSTREAM.md) | Deal with pre-GKI downstream blobs and old Adreno parts |

Supported SoC families: `soc/README.md`. Options added by this tree:
`optional/README.md`.

## Layers

```
mainline/common            shared by every mainline device
  └─ mainline/qcom-common  this tree: soc/<family>/, daemons, init
       └─ <vendor>/<soc>-mainline    family tree: kernel, boot image, partitions
            └─ <device>_mainline/    one device: firmware, fstab, DT names
```

| Layer | Example | Holds |
|-------|---------|-------|
| `qcom-common` | `soc/sm7150/` | Arch, boot devices, SoC firmware packages, daemons, init |
| Family tree | `mi7150-mainline` | Kernel and config, boot image rules, partitions, `libinit` |
| Device | `davinci_mainline` | Hardware name, DTBs, firmware, fstab, DSP data |
| Thin device | `pyxis_mainline` | Differences on top of another family tree |

## Reference devices

| Tree | Shows |
|------|-------|
| `device/xiaomi/mi7150-mainline` | Phone family tree: U-Boot and GRUB boot, boot header v4, DSP data, dynamic partitions |
| `device/xiaomi/mi710-mainline` | The same shape, with USB and recovery caveats |
| `device/xiaomi/pyxis_mainline` | A thin device |
| `device/xiaomi/mi89xx-mainline` | lk2nd boot, several devices and kernel forks in one tree |

## Component READMEs

In `hardware/mainline/qcom/`:

| Component | README |
|-----------|--------|
| `hexagonrpc` | `hexagonrpc/README.md` |
| `libsensors_libssc` | `libraries/libsensors_libssc/README.md` |
| `pil-squasher` | `pil-squasher/README.md` |
| `tqftpserv` | `tqftpserv/README.md` |
