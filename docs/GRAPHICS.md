# Graphics

On mainline the GPU is driven by Mesa and the kernel `msm` DRM driver.
No downstream component takes part, except for one firmware file.

**TL;DR:** Mesa `freedreno` for OpenGL ES, Mesa Vulkan only for A6xx
and newer, firmware from `linux-firmware` plus the `*_zap` file from
the downstream vendor tree.

## Mesa

| Item | Value |
|------|-------|
| Gallium driver | `freedreno` (`BOARD_MESA3D_GALLIUM_DRIVERS`) |
| Vulkan | `freedreno` Vulkan (`BOARD_MESA3D_VULKAN_DRIVERS`), **not** for legacy families |
| minigbm platform | `msm` |
| `ro.opengles.version` | Set in `soc/<family>/product.mk` when `TARGET_GRAPHICS` is `mesa` |
| Display and allocator HALs | The common options; see the common [optional modules](../../common/docs/CHOOSING_OPTIONAL_MODULES.md) |

### Why no Vulkan on legacy families

Mesa has stated that it will never implement Vulkan for GPUs older
than A6xx. Some of the oldest GPUs did not get Vulkan in the downstream
stack either. So `qcom-common` adds the freedreno Vulkan driver only
when `TARGET_QCOM_SOC_FAMILY_IS_LEGACY` is not `true` (the `apq*` and
`msm*` families).

## GPU firmware

| File | Source | Packaged as |
|------|--------|-------------|
| Command processor and power management (`*_sqe`, `*_gmu`, ...) | `linux-firmware` (`external/linux-firmware-mainline`) | `linux_firmware_qcom-a530`, `linux_firmware_qcom-a630`, ... in `soc/<family>/product.mk` |
| `*_zap` (zap shader) | **The downstream vendor tree.** The only GPU part that has to be borrowed | Device `device.mk`, for example `a615_zap.elf` copied to `<firmware dir>/a615_zap.mbn` |

The zap file goes where the device DTS `firmware-name` says. See
[FIRMWARE.md](FIRMWARE.md).

## `msm_drm_quirks`

A small service for legacy families (`services/msm_drm_quirks`). It
reads the GPU id through `libdrm_freedreno` and sets the workaround
properties that Mesa and minigbm need.

| Step | What |
|------|------|
| 1 | At `init`, the graphics allocator services are stopped |
| 2 | At `early-boot`, wait for `/dev/dri/card0`, start `vendor.msm_drm_quirks` |
| 3 | It sets `vendor.qcom.soc.msm_drm.chip_id` and `.gpu_id` |
| 4 | Adreno 5xx (id 500 to 599): `vendor.mesa.fd.mesa.debug=sysmem` |
| 5 | Ids below 600: `vendor.minigbm.avoid_ubwc=true` |
| 6 | When it stops, the allocator services are enabled again, so the allocator starts with the properties already set |

## Troubleshooting

| Symptom | Check |
|---------|-------|
| No `/dev/dri/card0` | The `msm` and panel modules in `modules.load.basic`; [KERNELS.md](KERNELS.md) |
| GPU does not start | The `*_zap` file and the `linux-firmware` files in the kernel log |
| Graphics corruption on A5xx | `vendor.mesa.fd.mesa.debug` and `vendor.minigbm.avoid_ubwc` were set |
