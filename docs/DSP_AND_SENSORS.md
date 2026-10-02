# DSP, audio and sensors

On Qualcomm SoCs from 2018 on, sensors and much of the audio path live
on the ADSP. Linux reaches them through FastRPC.

**TL;DR:** run `hexagonrpcd` for the ADSP (two services), give it the
device's DSP data in `/vendor/etc/hexagonrpcd-root`, then the mainline
Sensors HAL uses the `libssc` backend and the mainline Audio HAL uses
ALSA UCM.

## FastRPC services

`hexagonrpcd` (`hardware/mainline/qcom/hexagonrpc`) serves files to the
DSP and implements the remote calls.

| Service | Command | For |
|---------|---------|-----|
| `vendor.hexagonrpcd-adsp-rootpd` | `hexagonrpcd -f /dev/fastrpc-adsp -d adsp -R /vendor/etc/hexagonrpcd-root` | Audio and the root protection domain |
| `vendor.hexagonrpcd-adsp-sensorspd` | `hexagonrpcd -f /dev/fastrpc-adsp -d adsp -s -R /vendor/etc/hexagonrpcd-root` | The sensors domain |
| SDSP service | `hexagonrpcd-sdsp.rc` | Devices with a separate sensors DSP |

Both run in class `core` as `system`. Add them to a SoC with the
packages `hexagonrpcd_adsp_rootpd_phony` and
`hexagonrpcd_adsp_sensorspd_phony` (see `soc/sm7150/product.mk`).

## Root directory (HexagonFS)

`hexagonrpcd` serves a file tree to the DSP, starting at the directory
given by `-R`. Here that is `/vendor/etc/hexagonrpcd-root`. The
`hexagonrpc` README ("HexagonFS") lists what each entry stands for in a
downstream Android system, and says to fill them from the device's
Android firmware:

| HexagonFS entry | Downstream Android location |
|-----------------|-----------------------------|
| `acdb` | `/vendor/etc/acdbdata` |
| `dsp` | `/vendor/dsp` |
| `sensors/config` | `/vendor/etc/sensors/config` |
| `sensors/registry` | `/mnt/vendor/persist/sensors/registry/registry` |
| `sensors/sns_reg.conf` | `/vendor/etc/sensors/sns_reg_config` |
| `socinfo` | `/sys/devices/soc0` (the **downstream kernel's** sysfs) |

`socinfo` is not a file of the vendor image: it is a copy of the
`soc0` attributes as exported by the downstream kernel, taken from a
device running it. The device tree keeps it (`socinfo/` of
`davinci_mainline`). The other entries are copied from the downstream
vendor tree, as `davinci_mainline`'s `device.mk` does.

The DSP firmware itself is installed as described in
[FIRMWARE.md](FIRMWARE.md), and started as in
[REMOTEPROCS.md](REMOTEPROCS.md).

## Sensors

The mainline Sensors HAL has a `libssc` backend for these DSP-managed
sensors (accelerometer, gyroscope, magnetometer, light, proximity,
compass). It uses `libssc` over QMI/QRTR.

| Item | Where |
|------|-------|
| Backend | `hardware/mainline/qcom/libraries/libsensors_libssc` |
| Backend README (configuration keys, soong config) | `libraries/libsensors_libssc/README.md` |
| Generic HAL | `hardware/mainline/common/interfaces/sensors/mainline/README.md` |
| Dependencies | `external/mainline-hw-deps/{libssc,libqmi,libqrtr-glib,glib,protobuf-c}` |

The HAL configuration is by properties and files; the backend README
lists the keys.

## Audio

The mainline Audio HAL is configuration-less and uses ALSA UCM, so the
Qualcomm part is choosing the UCM profile for the board:

| Item | Detail |
|------|--------|
| Profile | `TARGET_AUDIO_MAINLINE_UCM_PROFILES`, for example `sm8250` on SM7150 devices that share that DSP setup |
| Missing profiles | Some profiles in `ucm2/conf.d/sm8250` are not installed because of build system limits; the device README (`mi7150-mainline`) says what to install by hand |
| Warning | Wrong or missing profiles can crash the ADSP, which takes sensors down too |
| Audio policy | Only audio HALs that need one use `soc/<family>/audio/primary_audio_policy_configuration.xml`. The mainline HAL does not |

## Troubleshooting

| Symptom | Check |
|---------|-------|
| No `/dev/fastrpc-adsp` | The ADSP remoteproc and the FastRPC driver ([REMOTEPROCS.md](REMOTEPROCS.md)) |
| `hexagonrpcd` exits | The root directory exists and is readable; SELinux (`vendor_hexagonrpcd.te`) |
| No sensors | `libssc` backend loaded, and the `sensorspd` service is running |
| ADSP restarts on audio use | The UCM profile; `acdb/` data |
