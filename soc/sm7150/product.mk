#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# DSP
PRODUCT_PACKAGES += \
    hexagonrpcd_adsp_rootpd_phony \
    hexagonrpcd_adsp_sensorspd_phony

# Firmware
PRODUCT_PACKAGES += \
    firmware_qcom_a630_gmu.bin \
    firmware_qcom_a630_sqe.fw

# Init
PRODUCT_PACKAGES += \
    init.mainline.qcom.sm7150.rc
