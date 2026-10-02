# Legacy downstream support

Some Qualcomm SoCs are old enough that vendor blobs still expect the
pre-GKI downstream kernel (ION, QSEECOM) and that the GPU needs
workarounds. `qcom-common` has switches for these cases.

**TL;DR:** the SoC family name decides. `msm*` and `sdm*` families get
the legacy ION support, and `apq*`/`msm*` get the old Adreno
workarounds.

## Flags

Set in `optional/options.mk` from `TARGET_QCOM_SOC_FAMILY`:

| Flag | Families | Effect |
|------|----------|--------|
| `TARGET_QCOM_SOC_FAMILY_DOWNSTREAM_IS_PRE_GKI` | `msm*`, `sdm*`, `sm61*`, `sm62*`, `sm71*`, `sm72*`, `sm81*`, `sm82*` | Legacy `libion` implementation, and the `libion` sepolicy from `device/lineage/sepolicy/libion` |
| `TARGET_QCOM_SOC_FAMILY_IS_LEGACY` | `apq*`, `msm*` | `msm_drm_quirks`; no Vulkan from freedreno |

## ION

Vendor blobs built for the downstream kernel call the ION interface,
which mainline does not have.

| Piece | What |
|-------|------|
| `libion` `legacy_impl` soong config | Set from the pre-GKI flag |
| `libion_dmaheap` (`hardware/mainline/qcom/libraries`) | A drop-in replacement for the legacy `libion.so`, backed by dma-buf heaps. Blobs are linked against it when extracted |
| `/dev/ion` | `0664 system system` in `ueventd.qcom.rc` |
| `/dev/dma_heap/qseecom`, `/dev/qseecom` | Device nodes for QSEECOM, with permissions in `ueventd.qcom.rc` |

## Adreno 5xx workarounds: `msm_drm_quirks`

A service (`services/msm_drm_quirks`) that runs once at `early-boot` on
legacy families:

| Step | What |
|------|------|
| 1 | At `init`, the graphics allocator services are stopped |
| 2 | At `early-boot`, wait for `/dev/dri/card0`, start `vendor.msm_drm_quirks` |
| 3 | It reads the GPU id through `libdrm_freedreno` and sets `vendor.qcom.soc.msm_drm.chip_id` and `.gpu_id` |
| 4 | For Adreno 5xx (id 500 to 599): `vendor.mesa.fd.mesa.debug=sysmem` |
| 5 | For ids below 600: `vendor.minigbm.avoid_ubwc=true` |
| 6 | When the service stops, the allocator services are enabled again |

This way the allocator starts with the properties already set.

## Graphics on legacy families

| Item | Value |
|------|-------|
| Gallium | `freedreno` |
| Vulkan | Not built for legacy families |
| minigbm platform | `msm` |
| `ro.opengles.version` | Set per family in `soc/<family>/product.mk` when Mesa is used |

## Adding a legacy SoC

[ADDING_A_SOC.md](ADDING_A_SOC.md) says where the family name is
mapped; the patterns above decide which flags it gets.
