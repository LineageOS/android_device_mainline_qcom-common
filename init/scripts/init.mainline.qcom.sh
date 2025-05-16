#!/vendor/bin/sh
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Set SoC properties
for i in family machine revision soc_id
do
    setprop "vendor.qcom.soc.${i}" "$(cat /sys/devices/soc0/${i})"
done
