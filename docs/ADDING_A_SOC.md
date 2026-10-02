# Adding a SoC

**TL;DR:** Add the SoC name to `optional/options.mk`, create
`soc/<family>/{board,product}.mk`, list it in `soc/README.md`.

Before you start: does an existing family fit? SoCs in one family share
a kernel base and most firmware. Add to a family if they do.

## Step 1: map the SoC name to a family

File: `optional/options.mk`, section `##### SoC #####`.

```
else ifneq ($(filter sm7150%,$(TARGET_QCOM_SOC)),)
    TARGET_QCOM_SOC_FAMILY := sm7150
```

| Flag | Set automatically for | Meaning |
|------|-----------------------|---------|
| `TARGET_QCOM_SOC_FAMILY_IS_LEGACY` | `apq*`, `msm*` | Adds `msm_drm_quirks`, no Vulkan from freedreno |
| `TARGET_QCOM_SOC_FAMILY_DOWNSTREAM_IS_PRE_GKI` | `msm*`, `sdm*`, `sm61/62/71/72/81/82*` | Legacy ION support |

Extend the patterns when the new family needs one of the flags.
What the flags do is in [LEGACY_DOWNSTREAM.md](LEGACY_DOWNSTREAM.md).

## Step 2: `soc/<family>/board.mk`

| Section | Set |
|---------|-----|
| Arch | `TARGET_ARCH*`, `TARGET_CPU_VARIANT*`, 32/64-bit switches |
| Boot | `MAINLINE_QCOM_SOC_ANDROIDBOOT_PARAMS` (`androidboot.boot_devices`) |
| Kernel params | `MAINLINE_QCOM_SOC_KERNEL_PARAMS` if needed |
| Flash | `BOARD_FLASH_BLOCK_SIZE` |
| SELinux | `BOARD_VENDOR_SEPOLICY_DIRS += $(MAINLINE_QCOM_COMMON_SOC_PATH)/sepolicy/vendor` if you have policy |

Copy the arch block from a family with the same CPU. `msm8998` is the
smallest example; `sm7150` shows more.

## Step 3: `soc/<family>/product.mk`

| Section | Set |
|---------|-----|
| Firmware | `PRODUCT_PACKAGES` for GPU and common firmware |
| Graphics | `ro.opengles.version` when `TARGET_GRAPHICS` is `mesa` |
| Daemons | `rmtfs`, `tqftpserv`, `qrtr-cfg`; `ro.vendor.qcom.soc.enable_modem_services` |
| Init | `init.mainline.qcom.<family>.rc` if the SoC needs its own |
| ADSP | `hexagonrpcd_*` packages for audio and sensors |

## Step 4: optional pieces

| Dir | Needed for |
|-----|------------|
| `soc/<family>/init/` | SoC specific init (see `sm7150`) |
| `soc/<family>/audio/primary_audio_policy_configuration.xml` | Audio policy for audio HALs that need one. The mainline audio HAL does not |
| `soc/<family>/sepolicy/vendor` | SoC specific policy |
| `soc/<family>/media/` | Media codec lists (`sm8550`) |
| `soc/<family>/thermal/` | Thermal config (`sm8550`) |

## Step 5: document it

Add the family and its marketing names to `soc/README.md`:

```
### sm7150
- Qualcomm Snapdragon 730 `sm7150-aa`
```

## Step 6: test with a device

Follow [NEW_DEVICE.md](NEW_DEVICE.md) with a real device. A SoC is not
done until one device boots. The kernel for the family is covered in
[KERNELS.md](KERNELS.md) and the DSP and modem setup in
[REMOTEPROCS.md](REMOTEPROCS.md), [MODEM_STACK.md](MODEM_STACK.md) and
[DSP_AND_SENSORS.md](DSP_AND_SENSORS.md).

## Check

- [ ] Every `TARGET_QCOM_SOC` value you add resolves to a family
- [ ] `soc/README.md` updated
- [ ] No device specific values in `soc/<family>/` (see
      `hardware/mainline/common/docs/SCOPE.md`)
