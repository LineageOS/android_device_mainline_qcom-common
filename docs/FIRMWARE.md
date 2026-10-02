# Firmware

Qualcomm SoCs need firmware for their DSPs, modem, GPU, IPA and Wi-Fi.
Getting each file to where the kernel looks for it is most of the work.

**TL;DR:** SoC-wide files come from `external/linux-firmware-mainline`,
device-specific files are borrowed from the downstream `vendor/` tree
and installed under `/odm/firmware/qcom/<soc>/<vendor>/<device>/`.
Never put files into `/vendor/firmware_mnt`.

## Where the kernel looks

| Item | Value |
|------|-------|
| Search path | `firmware_class.path=/vendor/firmware/` (in the common cmdline) |
| Name of a remoteproc image | From the DT `firmware-name`, for example `qcom/sm7150/xiaomi/davinci/adsp.mbn` |
| Layout | `qcom/<soc>/<vendor>/<device>/<file>` |

## Sources

| Kind | Source | Packaged as |
|------|--------|-------------|
| SoC-wide (Adreno `a630`, Wi-Fi) | `external/linux-firmware-mainline`, which only has the files pulled in so far; add more there when you need them | `PRODUCT_PACKAGES` such as `linux_firmware_qcom-a630`, `firmware_ath10k_*` (see `soc/<family>/product.mk`) |
| Device-specific | The downstream `vendor/` tree of the device, extracted with `tools/extract-utils` at the LineageOS root | The device `firmware/Android.bp`: `prebuilt_firmware` with `device_specific: true` |
| On a partition of the device | The firmware partition | Mount it ([below](#partitions)) |

## Install layout

A device-specific `prebuilt_firmware` is installed under `/odm`, and
the vendor path the kernel searches points to it with a symlink
(`davinci_mainline/firmware/Android.bp`):

```
/vendor/firmware/qcom/sm7150/xiaomi/davinci  ->  /odm/firmware/qcom/sm7150/xiaomi/davinci
```

| Module | Role |
|--------|------|
| `install_symlink` (`symlink_firmware_<device>`) | The link above |
| `prebuilt_firmware` with `sub_dir` | The file, under the `qcom/<soc>/<vendor>/<device>` subdirectory |
| `install_symlink` for each `device_specific` file | A workaround: Soong installs those in `/odm/etc/firmware`, so a symlink restores the expected path |
| `phony` (`all_symlink_firmware_<device>`) | One package name to pull in all of the above |

## Split images

Downstream firmware is often a split image: `x.mdt` plus `x.b00`,
`x.b01`, ... The kernel loader wants one `.mbn`.
`pil-squasher` (`hardware/mainline/qcom/pil-squasher`) joins them and
keeps the signature. Run it in a `genrule` (see `gen_firmware_*_ipa_fws.mbn`
in `davinci_mainline`).

## Partitions

| Mountpoint | Meaning |
|------------|---------|
| `/vendor/firmware_mnt` | Mountpoint of the device's **firmware partition** (modem and DSP images). Mount it; **never install files into it** |
| `/firmware` | Root symlink to `/vendor/firmware_mnt` (set by `qcom-common`) |
| `/vendor/dsp` | Mountpoint of the DSP partition |
| `/mnt/vendor/persist` | Calibration data. `qcom-common` overlays it with a writable layer at `post-fs` |

Tell ueventd where to find firmware that lives on such a partition
with `firmware_directories` in the device `ueventd.<name>.rc`.

## Persist symlinks

`firmware/persist` in this tree has two optional link modules, grouped
as `all_mainline_qcom-common_symlink_persist_firmware` (marked "not
recommended" in the source):

| Link | Target |
|------|--------|
| `firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin` | `/mnt/vendor/persist/WCNSS_qcom_wlan_nv.bin` |
| `firmware/qcom/sensors/sns.reg` | `/mnt/vendor/persist/sensors/sns.reg` |

## Redistribution

Do not commit firmware you may not redistribute. Keep it in the vendor
tree and in the device's own repositories.

## Check

- [ ] The kernel log shows no `Direct firmware load ... failed` for the
      files you installed
- [ ] The firmware partition is mounted at `/vendor/firmware_mnt`
