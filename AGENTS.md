# AGENTS.md - device/mainline/qcom-common

Agents must read this file before touching anything in this repository.

Part of the mainline repository set. Map of all repos: `vendor/mainline/docs/REPOSITORIES.md`.

Qualcomm layer on top of `device/mainline/common`. SoC support lives
in `soc/<family>/`; Qualcomm HALs and daemons live in
`hardware/mainline/qcom`.

## Read first

| Task | Read |
|------|------|
| New device on a supported SoC | `docs/NEW_DEVICE.md` |
| New SoC | `docs/ADDING_A_SOC.md` |
| Anything generic | `device/mainline/common/AGENTS.md` and its `docs/` |

## Hard rules

- Do not build, flash or run tests; the human does.
- Do not search from the AOSP tree root.
- Keep device specific values out of `soc/<family>/`.
- Do not depend on `device/mainline/qcom-common-ext`.
- Add every new SoC to `soc/README.md` and to the mapping in
  `optional/options.mk`.
- Never add firmware blobs here.
- Never install files into `/vendor/firmware_mnt`; it is the mountpoint of
  the device's firmware partition.
