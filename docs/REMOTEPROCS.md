# Remote processors

Qualcomm SoCs run several firmware blobs on separate cores (ADSP,
CDSP, modem, ...), controlled by the kernel's `remoteproc` framework.
`qcom-common` starts them from userspace once the firmware is
reachable.

**TL;DR:** the device init triggers `start_all_remoteproc`. A script
walks `/sys/class/remoteproc` and starts each core, honoring a few
properties.

## Start

| Step | What |
|------|------|
| 1 | The device `init.<name>.rc` fires `trigger start_all_remoteproc`, after the modules and firmware mounts are ready |
| 2 | `qcom-common` runs `trigger firmware_mounts_complete`, then the start script as `u:r:vendor_start_remoteproc:s0` |
| 3 | The script handles each `/sys/class/remoteproc/*` entry |

To start one core later, set the property
`vendor.remoteproc.trigger_start=<name>`; the script is run for that
core only.

The script is `init.mainline.qcom.start_remoteproc.sh`. It always exits
`0` and logs to the kernel log with the tag `start_remoteproc.sh`.

## Names

The name of a core is its `name` attribute with `.` replaced by `_`
(a core named `x.remoteproc` is called `x_remoteproc`).

## Properties

`vendor.remoteproc.<name>.<key>`

| Key | Direction | Effect |
|-----|-----------|--------|
| `ignore` | You set | `1` skips the core when starting all (not when started singly) |
| `recovery` | You set | Written to the core's `recovery` attribute (for example `disabled`) |
| `firmware` | You set | Written to the core's `firmware` attribute before the start |
| `is_started` | Script sets | `1` if the start was accepted or the core was already running, `0` if it failed |

A core that is already `running` is left alone.

## Troubleshooting

| Symptom | Check |
|---------|-------|
| Core stays `offline` | `vendor.remoteproc.<name>.is_started`, and the kernel log for `Direct firmware load` |
| The core starts then crashes | The firmware of that core; for the ADSP, see [DSP_AND_SENSORS.md](DSP_AND_SENSORS.md) |
| Core should not run | `setprop vendor.remoteproc.<name>.ignore 1` at build time in `vendor.prop` |
| Firmware not found | [FIRMWARE.md](FIRMWARE.md) |
