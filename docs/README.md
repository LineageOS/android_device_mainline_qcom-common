# Qualcomm bringup

Extra pages for Qualcomm devices. Read the generic
[bringup guide](../../common/docs/README.md) first.

| Page | Read it when you need to... |
|------|------------------------------|
| [NEW_DEVICE.md](NEW_DEVICE.md) | Bring up a device whose SoC is already supported |
| [ADDING_A_SOC.md](ADDING_A_SOC.md) | Support a SoC that is not in `soc/` yet |

Supported SoC families: `soc/README.md`.
Options specific to Qualcomm: `optional/README.md`.

## Reference devices

| Tree | Why look at it |
|------|----------------|
| `device/xiaomi/mi7150-mainline` | Mature phone family tree: `libinit`, kconfig fixups, dynamic partitions |
| `device/xiaomi/mi710-mainline` | Same shape, with USB/recovery caveats |
| `device/xiaomi/pyxis_mainline` | Thin device on a shared family tree |
| `device/xiaomi/mi89xx-mainline` | One tree, many devices and kernel forks |
