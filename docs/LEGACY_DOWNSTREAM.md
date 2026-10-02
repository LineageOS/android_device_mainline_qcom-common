# Legacy downstream support

Vendor blobs that were built for the pre-GKI downstream kernel expect
interfaces that mainline does not have (ION). `qcom-common` has a
switch for this. The GPU is unrelated: it runs on Mesa, see
[GRAPHICS.md](GRAPHICS.md).

**TL;DR:** the SoC family name decides. `msm*`, `sdm*` and several
`sm*` families get the legacy ION support.

## Flags

Set in `optional/options.mk` from `TARGET_QCOM_SOC_FAMILY`:

| Flag | Families | Effect |
|------|----------|--------|
| `TARGET_QCOM_SOC_FAMILY_DOWNSTREAM_IS_PRE_GKI` | `msm*`, `sdm*`, `sm61*`, `sm62*`, `sm71*`, `sm72*`, `sm81*`, `sm82*` | Legacy `libion` implementation, and the `libion` sepolicy from `device/lineage/sepolicy/libion` |
| `TARGET_QCOM_SOC_FAMILY_IS_LEGACY` | `apq*`, `msm*` | GPU related: see [GRAPHICS.md](GRAPHICS.md) |

## ION

Vendor blobs built for the downstream kernel call the ION interface,
which mainline does not have.

| Piece | What |
|-------|------|
| `libion` `legacy_impl` soong config | Set from the pre-GKI flag |
| `libion_dmaheap` (`hardware/mainline/qcom/libraries`) | A drop-in replacement for the legacy `libion.so`, backed by dma-buf heaps. Blobs are linked against it when extracted |
| `/dev/ion` | `0664 system system` in `ueventd.qcom.rc` |
| QSEECOM | Device nodes and service: see [QSEECOM.md](QSEECOM.md) |

## Adding a legacy SoC

[ADDING_A_SOC.md](ADDING_A_SOC.md) says where the family name is
mapped; the patterns above decide which flags it gets.
