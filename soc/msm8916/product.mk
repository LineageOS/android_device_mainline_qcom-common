#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Firmware
PRODUCT_PACKAGES += \
    linux_firmware_qcom-a300 \
    linux_firmware_qcom-a420 \
    linux_firmware_qcom-venus-1.8

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.msm8916.rc

# Modem
PRODUCT_PACKAGES += \
    rmtfs \
    rmtfs.rc
